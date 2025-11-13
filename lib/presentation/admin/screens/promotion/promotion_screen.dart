import 'package:flutter/material.dart';
import '../../widgets/side_menu.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          SideMenu(),
          Expanded(
            child: Center(child: Text('Promotion content here')),
          ),
        ],
      ),
    );
  }
}
