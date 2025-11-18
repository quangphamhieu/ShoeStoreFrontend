import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoestorefe/presentation/admin/provider/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Nhập số điện thoại và mật khẩu để đăng nhập"),
                      const SizedBox(height: 24),
                      TextField(
                        controller: provider.phoneOrEmailController,
                        decoration: const InputDecoration(
                          labelText: "nhập số điện thoại hoặc email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: provider.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Mật khẩu",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (_) {}),
                          const Text("Lưu đăng nhập"),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Quên mật khẩu?"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              provider.isLoading
                                  ? null
                                  : () async {
                                    await provider.login();
                                    if (provider.user != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("đăng nhập thành công"),
                                        ),
                                      );
                                      context.go('/dashboard');
                                    }
                                  },
                          child:
                              provider.isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text("Đăng nhập"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () => context.go('/signup'),
                          child: const Text(
                            "Chưa có tài khoản? Tạo tài khoản mới",
                          ),
                        ),
                      ),
                      if (provider.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            provider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (screenWidth > 600)
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/banner.png'),
                      fit: BoxFit.contain, // đảm bảo ảnh cover toàn bộ container
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
