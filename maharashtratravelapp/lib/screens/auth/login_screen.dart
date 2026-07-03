import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_button.dart';
import 'auth_layout.dart';
import '../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {

    return AuthLayout(
      title: "Welcome Back",
      subtitle: "Sign in to continue your journey",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: 90,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Welcome Back",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Sign in to continue your journey.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          CustomTextField(
            controller: emailController,
            hintText: "Email",
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 18),

          CustomTextField(
            controller: passwordController,
            hintText: "Password",
            prefixIcon: Icons.lock_outline,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              onPressed: (){
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: (){
                context.go("/forgot-password");
              },
              child: const Text("Forgot Password?"),
            ),
          ),

          PrimaryButton(
  text: "Login",
  icon: const Icon(Icons.login),
  onPressed: () async {

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
        ),
      );
      return;
    }

    final error = await authService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      context.go("/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  },
),

          const SizedBox(height: 25),

          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("OR"),
              ),
              Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 25),

          SocialButton(
  onPressed: () async {
    final error = await authService.signInWithGoogle();

    if (!mounted) return;

    if (error == null) {
      context.go("/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  },
),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.white70),
              ),

              TextButton(
                onPressed: (){
                  context.go("/register");
                },
                child: const Text("Create Account"),
              )
            ],
          )
        ],
      ),
    );
  }
}