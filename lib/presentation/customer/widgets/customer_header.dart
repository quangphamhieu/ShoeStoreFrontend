import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/customer_provider.dart';
import 'package:shoestorefe/core/network/token_handler.dart';
import 'package:shoestorefe/core/utils/auth_utils.dart';

class CustomerHeader extends StatelessWidget {
  const CustomerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final isLoggedIn = TokenHandler().hasToken();
    final userName = isLoggedIn ? TokenHandler().getUserName() : null;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.store, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              const Text(
                'VỀ SHOP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Navigation Menu - Made flexible to prevent overflow
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem('HOME'),
                  _buildNavItem('MOBILE'),
                  _buildNavItem('TENIS'),
                  _buildNavItem('PLANA'),
                  _buildNavItem('NEW BALANCE'),
                  _buildNavItem('CONVERSE', hasDropdown: true),
                  _buildNavItem('CHỦ ĐỀ', hasDropdown: true),
                  _buildNavItem('GIẢM GIÁ'),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Search Bar
          Container(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 38),
            width: 200,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (value) => provider.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Header Actions
          _buildHeaderIcon(Icons.account_circle_outlined),
          const SizedBox(width: 8),
          _buildHeaderIcon(Icons.favorite_border),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildHeaderIcon(Icons.shopping_bag_outlined),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Hiển thị user info và đăng xuất nếu đã đăng nhập
          if (isLoggedIn && userName != null) ...[
            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => AuthUtils.logout(context),
              child: _buildHeaderButton('Đăng xuất'),
            ),
          ] else ...[
            // Hiển thị đăng nhập/đăng ký nếu chưa đăng nhập
            GestureDetector(
              onTap: () => context.go('/'),
              child: _buildHeaderButton('Đăng Nhập'),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => context.go('/signup'),
              child: _buildHeaderButton('Đăng ký', isPrimary: true),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, {bool hasDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 3),
            const Icon(Icons.keyboard_arrow_down, size: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }

  Widget _buildHeaderButton(String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? Colors.red : Colors.transparent,
        border: Border.all(color: isPrimary ? Colors.red : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isPrimary ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
