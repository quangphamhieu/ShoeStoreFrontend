import 'package:flutter/material.dart';
import '../../widgets/side_menu.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          SideMenu(),
          Expanded(
            child: Center(child: Text('Dashboard content here')),
          ),
        ],
      ),
    );
  }
}
