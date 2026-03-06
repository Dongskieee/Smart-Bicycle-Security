import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'home_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String otp;
  final DateTime otpGeneratedTime;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.otp,
    required this.otpGeneratedTime,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool _canResend = false;
  int _resendCountdown = 30;
  Timer? _resendTimer;
  late String _currentOtp;
  late DateTime _currentOtpGeneratedTime;

  @override
  void initState() {
    super.initState();
    _currentOtp = widget.otp;
    _currentOtpGeneratedTime = widget.otpGeneratedTime;
    startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 30;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  void verifyOTP() {
    final now = DateTime.now();
    if (now.difference(_currentOtpGeneratedTime).inSeconds >= 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP expired. Please resend OTP.")),
      );
      return;
    }

    if (otpController.text.trim() == _currentOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP verified! Logging in...")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

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

  Future<void> resendOTP() async {
    String newOTP = (100000 + Random().nextInt(900000)).toString();
    await sendOTPEmail(widget.email, newOTP);

    setState(() {
      _currentOtp = newOTP;
      _currentOtpGeneratedTime = DateTime.now();
    });

    startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter OTP sent to ${widget.email}"),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: verifyOTP,
              child: const Text("Verify OTP"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _canResend ? resendOTP : null,
              child: Text(
                _canResend ? "Resend OTP" : "Resend OTP in $_resendCountdown s",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
