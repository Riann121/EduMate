import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // EduMate Color Palette (Same as Login/Routine)
  static const Color eduBlack = Color(0xFF111827);
  static const Color eduGrey = Color(0xFFF3F4F6);
  static const Color eduAccent = Color(0xFF3B82F6);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: eduBlack),
          onPressed: () => {
            Navigator.pop(context), // Go back to Login
            Navigator.pushNamed(context, '/login'),
          }
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Create Account",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: eduBlack)),
              const Text("Start organizing your studies today",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 40),

              _inputLabel("Full Name"),
              _inputField(_nameController, "e.g. John Doe", Icons.person_outline),

              _inputLabel("Email Address"),
              _inputField(_emailController, "example@email.com", Icons.email_outlined),

              _inputLabel("Password"),
              _inputField(_passwordController, "••••••••", Icons.lock_outline, isPassword: true),

              _inputLabel("Confirm Password"),
              _inputField(_confirmPasswordController, "••••••••", Icons.lock_reset_outlined, isPassword: true),

              const SizedBox(height: 40),
              //firebase auth register
              _actionButton("Register", () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  // Success: Go to home
                  Navigator.pushReplacementNamed(context, '/home');
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? "Registration Failed"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }, eduBlack, Colors.white),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to Login
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Login",
                        style: TextStyle(color: eduAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Input Label
  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(label, style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
    );
  }

  // Helper: Input Field
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

  // Helper: Action Button
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