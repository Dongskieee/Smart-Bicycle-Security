import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';

void loginUser(BuildContext context, String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
    });
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('registered_email');
  final storedPassword = prefs.getString('registered_password');

  if (storedEmail == null || storedPassword == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No account found. Please create one.")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    });
    return;
  }

  final emailNorm = email.trim().toLowerCase();
  final passwordNorm = password.trim();

  if (emailNorm == storedEmail && passwordNorm == storedPassword) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    });
  }
}
