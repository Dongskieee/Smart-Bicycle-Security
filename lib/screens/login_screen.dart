import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pedalpatrol/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'otp_verification_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? email;

  const LoginScreen({super.key, this.email});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
  }

  /// Generate a 6-digit OTP
  String generateOTP() {
    Random random = Random();
    int otp = 100000 + random.nextInt(900000);
    return otp.toString();
  }

  /// Send OTP via EmailJS
  Future<void> sendOTPEmail(String email, String otp) async {
    try {
      try {
        var response = await emailjs.send(
          'service_zktw00d',
          'template_803x1br',
          {
            'email': email,
            'user_email': email,
            'user_otp': otp,
            'time': "30 seconds",
          },
          emailjs.Options(publicKey: 'PhvthuVJS0mXCpxG_'),
        );

        print(response.status);
        print(response.text);
      } catch (error) {
        print("EmailJS ERROR:");
        print(error);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP sent to $email")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send OTP: $e")));
    }
  }

  /// Handle login form submission
  Future<void> loginUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      String email = emailController.text.trim().toLowerCase();
      String password = passwordController.text.trim();

      final loginSuccess = await _attemptLogin(email, password);
      if (!loginSuccess) return;

      // Generate OTP
      String otp = generateOTP();

      // Send OTP
      await sendOTPEmail(email, otp);

      if (!mounted) return;

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            // email: email,
            //otp: otp,
            //otpGeneratedTime: DateTime.now(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Simulate credential verification
  Future<bool> _attemptLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('registered_email');
    final storedPassword = prefs.getString('registered_password');

    if (storedEmail == null || storedPassword == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No account found. Please create one.")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      }
      return false;
    }

    if (email == storedEmail && password == storedPassword) {
      return true;
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF50C9CE)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.directions_bike,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Cyclist Login',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 4) return 'Password too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : loginUser,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text('Create account'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
