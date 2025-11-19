// ...existing code...
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/side_menu.dart';
import '../../widgets/app_header.dart';
import '../../provider/user_provider.dart';
import '../../provider/store_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _storeName(StoreProvider provider, int? storeId) {
    if (storeId == null) return '-';
    for (final store in provider.stores) {
      if (store.id == storeId) return store.name;
    }
    return '-';
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserProvider>().loadAll();
      context.read<StoreProvider>().loadAll();
    });
  }

  Future<void> _openForm({required bool editMode}) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => UserFormDialog(editMode: editMode),
    );
    if (res == true) {
      await context.read<UserProvider>().loadAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final storeProvider = context.watch<StoreProvider>();

    // disable interactions while any operation is running
    final busy =
        provider.isLoading ||
        provider.isCreating ||
        provider.isUpdating ||
        provider.isDeleting;

    return Scaffold(
      body: Row(
        children: [
          const SideMenu(),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA),
              child: Column(
                children: [
                  const AppHeader(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Toolbar
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (v) => provider.setFilter(v),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Tìm kiếm tên, điện thoại, email, vai trò',
                                    prefixIcon: const Icon(Icons.search),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                icon:
                                    provider.isCreating
                                        ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Icon(Icons.add),
                                label: const Text(
                                  'Thêm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed:
                                    busy
                                        ? null
                                        : () => _openForm(editMode: false),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon:
                                    provider.isUpdating
                                        ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Icon(Icons.edit),
                                label: const Text(
                                  'Sửa',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF87CEEB),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed:
                                    (provider.selectedUserId != null && !busy)
                                        ? () => _openForm(editMode: true)
                                        : null,
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon:
                                    provider.isDeleting
                                        ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Icon(Icons.delete_outline),
                                label: const Text(
                                  'Xóa',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed:
                                    (provider.selectedUserId != null && !busy)
                                        ? () async {
                                          final ok = await showDialog<bool>(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  title: const Text('Xác nhận'),
                                                  content: const Text(
                                                    'Bạn có chắc muốn xóa người dùng này?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.of(
                                                            context,
                                                          ).pop(false),
                                                      child: const Text('Hủy'),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.of(
                                                            context,
                                                          ).pop(true),
                                                      child: const Text('Xóa'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                          if (ok == true) {
                                            final id = provider.selectedUserId!;
                                            final success = await provider
                                                .deleteUser(id);
                                            if (!success && mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Xóa thất bại'),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                        : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 25,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child:
                                  provider.isLoading
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth:
                                                      constraints.maxWidth,
                                                ),
                                                child: DataTable(
                                                  showCheckboxColumn: false,
                                                  columnSpacing: 20,
                                                  headingTextStyle:
                                                      const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF1F2933,
                                                        ),
                                                      ),
                                                  dataTextStyle:
                                                      const TextStyle(
                                                        fontSize: 14,
                                                        color: Color(
                                                          0xFF334155,
                                                        ),
                                                      ),
                                                  dividerThickness: 0.3,
                                                  headingRowColor:
                                                      MaterialStateProperty.all(
                                                        const Color(0xFFF1F5F9),
                                                      ),
                                                  columns: const [
                                                    DataColumn(
                                                      label: SizedBox(
                                                        width: 32,
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text('ID'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Tên'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Điện thoại'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Email'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Giới tính'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Vai trò'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Cửa hàng'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Trạng thái'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Tạo lúc'),
                                                    ),
                                                  ],
                                                  rows:
                                                      provider.filteredUsers.map((
                                                        u,
                                                      ) {
                                                        final selected =
                                                            provider
                                                                .selectedUserId ==
                                                            u.id;
                                                        return DataRow(
                                                          selected: selected,
                                                          onSelectChanged:
                                                              (v) => provider
                                                                  .selectUser(
                                                                    v == true
                                                                        ? u.id
                                                                        : null,
                                                                  ),
                                                          cells: [
                                                            DataCell(
                                                              Center(
                                                                child: Checkbox(
                                                                  value:
                                                                      selected,
                                                                  onChanged:
                                                                      (
                                                                        v,
                                                                      ) => provider.selectUser(
                                                                        v == true
                                                                            ? u.id
                                                                            : null,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                u.id.toString(),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              ConstrainedBox(
                                                                constraints:
                                                                    BoxConstraints(
                                                                      maxWidth:
                                                                          200,
                                                                    ),
                                                                child: Text(
                                                                  u.fullName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(u.phone),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                u.email ?? '-',
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                u.gender == 0
                                                                    ? 'Male'
                                                                    : 'Female',
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(u.roleName),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                _storeName(
                                                                  storeProvider,
                                                                  u.storeId,
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      u.statusName.toLowerCase().contains(
                                                                            'active',
                                                                          )
                                                                          ? const Color(
                                                                            0xFFEFFAF3,
                                                                          )
                                                                          : const Color(
                                                                            0xFFFFF1F2,
                                                                          ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  u.statusName,
                                                                  style: TextStyle(
                                                                    color:
                                                                        u.statusName.toLowerCase().contains(
                                                                              'active',
                                                                            )
                                                                            ? const Color(
                                                                              0xFF0F9D58,
                                                                            )
                                                                            : const Color(
                                                                              0xFFDC2626,
                                                                            ),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                u.createdAt
                                                                    .toLocal()
                                                                    .toString()
                                                                    .split('.')
                                                                    .first,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple form dialog for create/edit user
class UserFormDialog extends StatefulWidget {
  final bool editMode;
  const UserFormDialog({super.key, required this.editMode});

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _phoneC;
  late TextEditingController _emailC;
  late TextEditingController _passwordC;
  int _gender = 0;
  int _roleId = 2;
  int? _storeId;
  int _statusId = 1;
  bool _loading = false;
  bool _prefillLoading = false;

  int _mapRoleNameToId(String roleName) {
    final lower = roleName.toLowerCase();
    if (lower.contains('admin')) return 2;
    if (lower.contains('staff')) return 3;
    return 3;
  }

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController();
    _phoneC = TextEditingController();
    _emailC = TextEditingController();
    _passwordC = TextEditingController();

    Future.microtask(() {
      context.read<StoreProvider>().loadAll();
    });

    if (widget.editMode) {
      _prefillLoading = true;
      final provider = context.read<UserProvider>();
      provider.getSelectedUserDetail().then((u) {
        if (!mounted) return;
        if (u != null) {
          _nameC.text = u.fullName;
          _phoneC.text = u.phone;
          _emailC.text = u.email ?? '';
          _gender = u.gender;
          _roleId = _mapRoleNameToId(u.roleName);
          // no roleId in entity so attempt parse from roleName if numeric, else keep default
          _statusId = u.statusName.toLowerCase().contains('active') ? 1 : 2;
          _storeId = u.storeId;
        }
        setState(() => _prefillLoading = false);
      });
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final provider = context.read<UserProvider>();
    final name = _nameC.text.trim();
    final phone = _phoneC.text.trim();
    final email = _emailC.text.trim().isEmpty ? null : _emailC.text.trim();

    bool success = false;
    if (widget.editMode) {
      final id = provider.selectedUserId;
      if (id != null) {
        success = await provider.updateUser(
          id: id,
          fullName: name,
          phone: phone,
          email: email,
          gender: _gender,
          roleId: _roleId,
          storeId: _storeId,
          statusId: _statusId,
        );
      }
    } else {
      success = await provider.createUser(
        fullName: name,
        phone: phone,
        email: email,
        password: _passwordC.text.trim(),
        gender: _gender,
        roleId: _roleId,
        storeId: _storeId,
      );
    }

    if (!mounted) return;
    setState(() => _loading = false);
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.editMode ? 'Cập nhật thất bại' : 'Tạo thất bại'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final storeProvider = context.watch<StoreProvider>();
    final submitting = _loading || provider.isCreating || provider.isUpdating;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  _prefillLoading
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
                                  widget.editMode
                                      ? 'Sửa người dùng'
                                      : 'Thêm người dùng',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _nameC,
                              decoration: InputDecoration(
                                labelText: 'Họ & tên *',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'Vui lòng nhập tên'
                                          : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneC,
                              decoration: InputDecoration(
                                labelText: 'Số điện thoại *',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'Vui lòng nhập số điện thoại'
                                          : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailC,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (!widget.editMode)
                              TextFormField(
                                controller: _passwordC,
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu *',
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator:
                                    (v) =>
                                        v == null || v.trim().isEmpty
                                            ? 'Vui lòng nhập mật khẩu'
                                            : null,
                              ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: _gender,
                                    decoration: InputDecoration(
                                      labelText: 'Giới tính',
                                      filled: true,
                                      fillColor: const Color(0xFFF8FAFC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Text('Male'),
                                      ),
                                      DropdownMenuItem(
                                        value: 1,
                                        child: Text('Female'),
                                      ),
                                    ],
                                    onChanged:
                                        (v) => setState(() => _gender = v ?? 0),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: _roleId,
                                    decoration: InputDecoration(
                                      labelText: 'Vai trò *',
                                      filled: true,
                                      fillColor: const Color(0xFFF8FAFC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Text('Admin'),
                                      ),
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text('Staff'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() => _roleId = value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<int?>(
                              value: _storeId,
                              decoration: InputDecoration(
                                labelText: 'Cửa hàng',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('Chọn cửa hàng'),
                                ),
                                ...storeProvider.stores.map(
                                  (store) => DropdownMenuItem<int?>(
                                    value: store.id,
                                    child: Text(store.name),
                                  ),
                                ),
                              ],
                              onChanged:
                                  (value) => setState(() {
                                    _storeId = value;
                                  }),
                            ),
                            const SizedBox(height: 12),
                            if (widget.editMode)
                              DropdownButtonFormField<int>(
                                value: _statusId,
                                decoration: InputDecoration(
                                  labelText: 'Trạng thái',
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Inactive'),
                                  ),
                                ],
                                onChanged:
                                    (v) => setState(() => _statusId = v ?? 1),
                              ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('Hủy'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: submitting ? null : _submit,
                                  child:
                                      submitting
                                          ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Text(
                                            widget.editMode ? 'Lưu' : 'Tạo',
                                          ),
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

// ...existing code...
