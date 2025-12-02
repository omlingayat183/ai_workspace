import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 5,
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome Back",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),

              const SizedBox(height: 20),

              TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
              const SizedBox(height: 12),
              TextField(controller: password, obscureText: true, decoration: InputDecoration(labelText: "Password")),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: loading
                    ? null
                    : () async {
                        bool success = await ref
                            .read(authControllerProvider.notifier)
                            .login(email.text.trim(), password.text.trim());

                        if (success) {
                          context.go("/notes");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login failed")),
                          );
                        }
                      },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),

              TextButton(
                  onPressed: () => context.go("/register"),
                  child: const Text("Create an account")),
            ],
          ),
        ),
      ),
    );
  }
}
