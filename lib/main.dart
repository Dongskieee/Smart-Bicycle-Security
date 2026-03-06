import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PedalPatrolApp());
}

class PedalPatrolApp extends StatelessWidget {
  const PedalPatrolApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PedalPatrol Theme Colors - Orange & Blue
    const primaryBlue = Color(0xFF1976D2); // Main blue
    const accentOrange = Color(0xFFFF6F00); // Vibrant orange
    const lightOrange = Color(0xFFFFB74D);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.light(
          primary: primaryBlue,
          secondary: accentOrange,
          tertiary: lightOrange,
          surface: Colors.white,
          error: Colors.red.shade700,
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        
        // AppBar Theme
        appBarTheme: AppBarTheme(
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: primaryBlue,
          iconTheme: const IconThemeData(color: primaryBlue),
          titleTextStyle: const TextStyle(
            color: primaryBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Button Themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 2,
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
          ),
        ),
        
        // Card Theme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        
        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: Colors.grey.shade600,
          selectedIconTheme: const IconThemeData(size: 28),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        
        // Icon Theme
        iconTheme: const IconThemeData(color: primaryBlue),
        
        // Text Theme
        textTheme: TextTheme(
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
        ),
        
        // FloatingActionButton Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
