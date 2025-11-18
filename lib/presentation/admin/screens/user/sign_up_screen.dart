import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoestorefe/presentation/admin/provider/sign_up_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignUpProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: provider.nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // use provider.gender to set initial shown value instead of hard-coded string
                value: provider.gender == 0 ? "Nam" : "Nữ",
                items: const [
                  DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                  DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    provider.setGender(value);
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: provider.emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: provider.phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: provider.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (provider.error != null)
                Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          await provider.signUp();
                          if (provider.user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Sign up thành công!")),
                            );
                            context.go('/'); // quay về LoginScreen
                          }
                        },
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'), // quay về Login
                child: const Text("Bạn đã có tài khoản? Đăng nhập"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
