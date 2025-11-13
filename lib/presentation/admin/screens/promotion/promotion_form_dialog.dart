import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/promotion_product.dart';
import '../../provider/promotion_provider.dart';
import '../../provider/product_provider.dart';

class PromotionFormDialog extends StatefulWidget {
  final bool editMode;
  const PromotionFormDialog({super.key, required this.editMode});

  @override
  State<PromotionFormDialog> createState() => _PromotionFormDialogState();
}

class _PromotionFormDialogState extends State<PromotionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _searchController;
  late final Map<int, TextEditingController> _discountControllers;
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  int _statusId = 1;
  bool _loading = false;
  bool _prefillLoading = false;
  
  List<Product> _availableProducts = [];
  List<Map<String, dynamic>> _selectedProducts = []; // [{productId, productName, discountPercent}]
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _searchController = TextEditingController();
    _discountControllers = {};

    Future.microtask(() {
      context.read<ProductProvider>().loadAll();
    });

    if (widget.editMode) {
      _prefillLoading = true;
      final provider = context.read<PromotionProvider>();
      provider.getSelectedPromotionDetail().then((p) {
        if (!mounted || p == null) {
          setState(() => _prefillLoading = false);
          return;
        }
        setState(() {
          _nameController.text = p.name;
          _startDate = p.startDate;
          _endDate = p.endDate;
          _statusId = p.statusId;
          _selectedProducts = p.products.map((pp) => {
            'productId': pp.productId,
            'productName': pp.productName,
            'discountPercent': pp.discountPercent,
          }).toList();
          for (var product in _selectedProducts) {
            _discountControllers[product['productId']] = TextEditingController(
              text: product['discountPercent'].toString(),
            );
          }
          _prefillLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    for (var controller in _discountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final productProvider = context.read<ProductProvider>();
    final q = query.toLowerCase();
    setState(() {
      _searchResults = productProvider.products.where((p) {
        final name = p.name.toLowerCase();
        final sku = (p.sku ?? '').toLowerCase();
        return name.contains(q) || sku.contains(q);
      }).where((p) => !_selectedProducts.any((sp) => sp['productId'] == p.id)).toList();
    });
  }

  void _addProduct(Product product) {
    if (_selectedProducts.any((p) => p['productId'] == product.id)) return;
    
    setState(() {
      _selectedProducts.add({
        'productId': product.id,
        'productName': product.name,
        'discountPercent': 0.0,
      });
      _discountControllers[product.id] = TextEditingController(text: '0');
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _removeProduct(int productId) {
    setState(() {
      _selectedProducts.removeWhere((p) => p['productId'] == productId);
      _discountControllers[productId]?.dispose();
      _discountControllers.remove(productId);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  InputDecoration _decoration(String label, {String? hint, bool required = false}) {
    final suffix = required ? ' *' : '';
    return InputDecoration(
      labelText: '$label$suffix',
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    );
  }

  Future<void> _handleSubmit() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất một sản phẩm')),
      );
      return;
    }

    final provider = context.read<PromotionProvider>();
    final products = _selectedProducts.map((p) => {
      'productId': p['productId'],
      'discountPercent': double.parse(_discountControllers[p['productId']]!.text),
    }).toList();

    setState(() => _loading = true);

    bool success = false;
    if (widget.editMode) {
      final id = provider.selectedPromotionId;
      if (id != null) {
        success = await provider.updatePromotion(
          id,
          name: _nameController.text.trim(),
          startDate: _startDate,
          endDate: _endDate,
          statusId: _statusId,
          products: products,
          storeIds: [], // TODO: Add store selection if needed
        );
      }
    } else {
      success = await provider.createPromotion(
        name: _nameController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        statusId: _statusId,
        products: products,
        storeIds: [], // TODO: Add store selection if needed
      );
    }

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.editMode ? 'Cập nhật thất bại' : 'Tạo mới thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 900),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: _prefillLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.editMode ? 'Sửa khuyến mãi' : 'Thêm khuyến mãi',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            decoration: _decoration('Tên khuyến mãi', hint: 'Nhập tên khuyến mãi', required: true),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Vui lòng nhập tên khuyến mãi';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, true),
                                  child: InputDecorator(
                                    decoration: _decoration('Ngày bắt đầu', required: true),
                                    child: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, false),
                                  child: InputDecorator(
                                    decoration: _decoration('Ngày kết thúc', required: true),
                                    child: Text('${_endDate.day}/${_endDate.month}/${_endDate.year}'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          if (widget.editMode)
                            DropdownButtonFormField<int>(
                              value: _statusId == 1 || _statusId == 2 ? _statusId : 1,
                              decoration: _decoration('Trạng thái', required: true),
                              items: const [
                                DropdownMenuItem(value: 1, child: Text('Active')),
                                DropdownMenuItem(value: 2, child: Text('Inactive')),
                              ],
                              onChanged: (v) => setState(() => _statusId = v ?? 1),
                            ),
                          const SizedBox(height: 20),
                          // Search and add products section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.search, color: Color(0xFF64748B)),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Tìm kiếm và thêm sản phẩm',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => _ProductSearchDialog(
                                            products: context.read<ProductProvider>().products
                                                .where((p) => !_selectedProducts.any((sp) => sp['productId'] == p.id))
                                                .toList(),
                                            onSelect: _addProduct,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2563EB)),
                                      tooltip: 'Thêm sản phẩm',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _searchController,
                                  onChanged: _searchProducts,
                                  decoration: InputDecoration(
                                    hintText: 'Tìm kiếm sản phẩm...',
                                    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  ),
                                ),
                                if (_searchResults.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _searchResults.length,
                                      itemBuilder: (context, index) {
                                        final product = _searchResults[index];
                                        return ListTile(
                                          title: Text(product.name),
                                          subtitle: Text(product.sku ?? ''),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.add, color: Color(0xFF2563EB)),
                                            onPressed: () => _addProduct(product),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Selected products list
                          if (_selectedProducts.isNotEmpty) ...[
                            const Text(
                              'Sản phẩm đã thêm',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              constraints: const BoxConstraints(maxHeight: 300),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _selectedProducts.length,
                                itemBuilder: (context, index) {
                                  final product = _selectedProducts[index];
                                  final productId = product['productId'];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product['productName'],
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            controller: _discountControllers[productId],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Giảm %',
                                              isDense: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) return 'Nhập %';
                                              final percent = double.tryParse(value);
                                              if (percent == null || percent < 0 || percent > 100) {
                                                return '0-100';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
                                          onPressed: () => _removeProduct(productId),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _loading ? null : () => Navigator.of(context).pop(false),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  foregroundColor: const Color(0xFF64748B),
                                ),
                                child: const Text('Hủy'),
                              ),
                              const SizedBox(width: 14),
                              ElevatedButton(
                                onPressed: _prefillLoading ? null : () => _handleSubmit(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.editMode ? const Color(0xFF87CEEB) : const Color(0xFF2563EB),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 0,
                                ),
                                child: _loading
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : Text(widget.editMode ? 'Lưu thay đổi' : 'Tạo khuyến mãi'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductSearchDialog extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onSelect;

  const _ProductSearchDialog({required this.products, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Chọn sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.sku ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF2563EB)),
                      onPressed: () {
                        onSelect(product);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

