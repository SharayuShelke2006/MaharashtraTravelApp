import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_button.dart';
import 'auth_layout.dart';
import '../../core/services/auth_service.dart';

final authService = AuthService();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {

    return AuthLayout(
      title: "Create Account",
      subtitle: "Join the Vatruhi community",
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
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Start exploring Maharashtra today.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          CustomTextField(
            controller: nameController,
            hintText: "Full Name",
            prefixIcon: Icons.person_outline,
          ),

          const SizedBox(height: 18),

          CustomTextField(
            controller: emailController,
            hintText: "Email Address",
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
              onPressed: () {
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

          const SizedBox(height: 18),

          CustomTextField(
            controller: confirmPasswordController,
            hintText: "Confirm Password",
            prefixIcon: Icons.lock_outline,
            obscureText: obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword =
                      !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),

          const SizedBox(height: 28),

          PrimaryButton(
            text: "Create Account",
            icon: const Icon(Icons.person_add_alt_1),
           onPressed: () async {

  if(passwordController.text !=
      confirmPasswordController.text){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match"),
      ),
    );

    return;
  }

  final error = await authService.signUp(
    name: nameController.text,
    email: emailController.text,
    password: passwordController.text,
  );

  if(error == null){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account Created Successfully"),
      ),
    );

    context.go("/login");

  }else{

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );

  }

},
          ),

          const SizedBox(height: 25),

          const Row(
            children: [
              Expanded(child: Divider(color: Colors.white30)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "OR",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Expanded(child: Divider(color: Colors.white30)),
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
                "Already have an account?",
                style: TextStyle(color: Colors.white70),
              ),

              TextButton(
                onPressed: () {
                  context.go("/login");
                },
                child: const Text("Login"),
              )
            ],
          )
        ],
      ),
    );
  }
}