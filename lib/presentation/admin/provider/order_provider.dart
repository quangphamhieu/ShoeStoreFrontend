import 'package:flutter/material.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/usecases/order/get_all_orders_usecase.dart';
import '../../../domain/usecases/order/update_order_status_usecase.dart';

class OrderProvider extends ChangeNotifier {
  final GetAllOrdersUseCase getAllUseCase;
  final UpdateOrderStatusUseCase updateStatusUseCase;

  OrderProvider({
    required this.getAllUseCase,
    required this.updateStatusUseCase,
  });

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdatingStatus = false;
  bool get isUpdatingStatus => _isUpdatingStatus;

  String _search = '';
  String get search => _search;

  int? _typeFilter;
  int? get typeFilter => _typeFilter;

  final Set<int> _statusFilters = {};
  Set<int> get statusFilters => _statusFilters;

  int? _selectedOrderId;
  int? get selectedOrderId => _selectedOrderId;

  Set<int> get selectedOrderIds {
    if (_selectedOrderId == null) return {};
    return {_selectedOrderId!};
  }

  List<Order> get filteredOrders {
    Iterable<Order> result = _orders;

    if (_search.isNotEmpty) {
      final query = _search.toLowerCase();
      result = result.where((order) {
        final customer = (order.customerName ?? 'Khách #${order.customerId}').toLowerCase();
        final creator = (order.creatorName ?? (order.createdBy != null ? 'Nhân viên #${order.createdBy}' : '')).toLowerCase();
        final orderNumber = order.orderNumber.toLowerCase();
        final customerId = order.customerId.toString();
        final creatorId = order.createdBy?.toString() ?? '';

        return customer.contains(query) ||
            creator.contains(query) ||
            orderNumber.contains(query) ||
            customerId.contains(query) ||
            creatorId.contains(query);
      });
    }

    if (_statusFilters.isNotEmpty) {
      result = result.where((order) => _statusFilters.contains(order.statusId));
    }

    if (_typeFilter != null) {
      result = result.where((order) => order.orderType == _typeFilter);
    }

    return result.toList();
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await getAllUseCase.call();
      data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _orders = data;
    } catch (_) {
      _orders = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setTypeFilter(int? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void toggleStatusFilter(int statusId) {
    if (_statusFilters.contains(statusId)) {
      _statusFilters.remove(statusId);
    } else {
      _statusFilters.add(statusId);
    }
    notifyListeners();
  }

  void clearFilters() {
    _typeFilter = null;
    _statusFilters.clear();
    notifyListeners();
  }

  bool isSelected(int orderId) => _selectedOrderId == orderId;

  void selectOrder(int? orderId) {
    _selectedOrderId = orderId;
    notifyListeners();
  }

  void clearSelection() {
    _selectedOrderId = null;
    notifyListeners();
  }

  Future<bool> updateSelectedOrdersStatus(int statusId) async {
    if (_selectedOrderId == null) return false;

    _isUpdatingStatus = true;
    notifyListeners();

    final success = await updateStatusUseCase.call(orderId: _selectedOrderId!, statusId: statusId);

    _isUpdatingStatus = false;
    if (success) {
      await loadAll();
      _selectedOrderId = null;
    }
    notifyListeners();
    return success;
  }
}




