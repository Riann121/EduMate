import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color eduBlack = Color(0xFF111827);
  static const Color eduGrey = Color(0xFFF3F4F6);
  static const Color eduAccent = Color(0xFF3B82F6);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text("Welcome Back",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: eduBlack)),
              const Text("Login to manage your studies",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 50),

              _inputLabel("Email Address"),
              _inputField(_emailController, "Enter your email", Icons.email_outlined),

              _inputLabel("Password"),
              _inputField(_passwordController, "Enter your password", Icons.lock_outline, isPassword: true),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text("Forgot Password?", style: TextStyle(color: eduAccent)),
              //   ),
              // ),

              const SizedBox(height: 30),
              //login via firebase auth
              _actionButton("Login", () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  // Success: Go to home
                  Navigator.pushReplacementNamed(context, '/home');
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? "Login Failed"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }, eduBlack, Colors.white),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to RegisterPage
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Register", style: TextStyle(color: eduAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(color: eduGrey, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: ctrl,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback action, Color bg, Color txt) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: txt,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: action,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}