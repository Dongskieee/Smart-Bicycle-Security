import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const PedalPatrolApp());
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _isLoading = false;

  Future<void> _createAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_email', email);
    await prefs.setString('registered_password', password);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully')),
    );

    // Navigate to home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PedalPatrolHome()),
    );
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_add, size: 64, color: Colors.blue),
                      const SizedBox(height: 12),
                      const Text('Create Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.email), labelText: 'Email', border: OutlineInputBorder()),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
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
                          suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Password is required';
                          if (v.length < 4) return 'Password too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: confirmController,
                        obscureText: _obscure,
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_outline), labelText: 'Confirm Password', border: OutlineInputBorder()),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please confirm your password';
                          if (v != passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createAccount,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: _isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Create Account'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Login')),
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

class PedalPatrolApp extends StatelessWidget {
  const PedalPatrolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(elevation: 2, backgroundColor: Colors.white, foregroundColor: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const LoginScreen(), // 👈 Start with login
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _isLoading = false;

  void loginUser() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    _attemptLogin().whenComplete(() {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Future<void> _attemptLogin() async {
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('registered_email');
    final storedPassword = prefs.getString('registered_password');

    if (storedEmail == null || storedPassword == null) {
      // No account exists yet — force the user to create one first.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No account found. Please create one.")),
      );
      // Navigate to signup screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
      return;
    }

    if (email == storedEmail && password == storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PedalPatrolHome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // logo / title
                      const Icon(Icons.directions_bike, size: 64, color: Colors.blue),
                      const SizedBox(height: 12),
                      const Text(
                        'Cyclist Login',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          if (v == null || v.trim().isEmpty) return 'Email is required';
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
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Password is required';
                          if (v.length < 4) return 'Password too short';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : loginUser,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: _isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Login'),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (c) => const SignupScreen()));
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


class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String _name = '';
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('registered_name') ?? '';
      _avatarPath = prefs.getString('registered_avatar');
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        _avatarPath != null && _avatarPath!.isNotEmpty
            ? CircleAvatar(radius: 20, backgroundImage: FileImage(File(_avatarPath!)))
            : Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.directions_bike, color: primary, size: 28),
              ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _name.isNotEmpty ? _name : 'PedalPatrol',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary),
            ),
            const SizedBox(height: 2),
            Text("Theft Alert System", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

/// Account menu shown as a person icon with dropdown options (Settings, Logout)
class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.person),
      onSelected: (value) async {
        if (value == 'logout') {
          // On logout, return to login and clear navigation stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        } else if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (value == 'settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'profile', child: Text('Profile')),
        PopupMenuItem(value: 'settings', child: Text('Settings')),
        PopupMenuItem(value: 'logout', child: Text('Logout')),
      ],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _email = '';
  String? _avatarPath;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('registered_email') ?? '';
      _nameController.text = prefs.getString('registered_name') ?? '';
      _phoneController.text = prefs.getString('registered_phone') ?? '';
      _bioController.text = prefs.getString('registered_bio') ?? '';
      _avatarPath = prefs.getString('registered_avatar');
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 800, imageQuality: 85);
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final ext = picked.path.contains('.') ? picked.path.split('.').last : 'jpg';
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.$ext';
    final saved = await File(picked.path).copy('${appDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_avatar', saved.path);

    setState(() {
      _avatarPath = saved.path;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_name', _nameController.text.trim());
    await prefs.setString('registered_phone', _phoneController.text.trim());
    await prefs.setString('registered_bio', _bioController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Email', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  Text(_email, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _avatarPath != null && _avatarPath!.isNotEmpty
                            ? CircleAvatar(radius: 48, backgroundImage: FileImage(File(_avatarPath!)))
                            : const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 40)),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Display name', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextField(controller: _nameController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Your name')),
                  const SizedBox(height: 12),
                  const Text('Phone', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextField(controller: _phoneController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Phone number'), keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  const Text('Bio', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextField(controller: _bioController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'A short bio'), maxLines: 3),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(onPressed: _saveProfile, child: const Text('Save')),
                      const SizedBox(width: 12),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('registered_email');
    await prefs.remove('registered_password');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted.')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete account'),
              subtitle: const Text('Remove stored credentials from this device'),
              onTap: () async {
                // confirm
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Delete account?'),
                    content: const Text('This will remove the stored account from this device.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete')),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _deleteAccount(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  const AlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "THEFT ALERT!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text("Unauthorized movement detected"),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.circle, color: Theme.of(context).colorScheme.error, size: 14),
                const Text("LED", style: TextStyle(fontSize: 12))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Current Location",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.telegram, size: 16),
                  label: const Text("Track"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 150, // fixed height to avoid unbounded height error
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.location_pin, color: Colors.red, size: 60),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Current Location"),
            const Text("14.599500, 120.984200",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Latitude\n14.599500"),
                Text("Longitude\n120.984200"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PedalPatrolHome extends StatefulWidget {
  const PedalPatrolHome({super.key});

  @override
  State<PedalPatrolHome> createState() => _PedalPatrolHomeState();
}

class _PedalPatrolHomeState extends State<PedalPatrolHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    GpsScreen(),
    AlertsScreen(),
    HistoryScreen(),
    RidesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: "GPS"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bike), label: "Rides"),
        ],
      ),
    );
  }
}

// ===== Screens =====

class GpsScreen extends StatelessWidget {
  const GpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedalPatrol'),
        actions: const [AccountMenu()],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Header(),
              SizedBox(height: 20),
              AlertCard(),
              SizedBox(height: 20),
              LocationCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedalPatrol'),
        actions: const [AccountMenu()],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.green, size: 30),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bicycle Safe",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text("No unauthorized movement detected"),
                        ],
                      ),
                    ),
                    Column(
                      children: const [
                        Icon(Icons.circle, color: Colors.green, size: 14),
                        Text("LED", style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView(
                    children: const [
                      AlertItem(time: "8:54:48 PM"),
                      AlertItem(time: "8:54:24 PM"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AlertItem extends StatelessWidget {
  final String time;
  const AlertItem({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Unauthorized movement detected!",
              style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.red),
              const SizedBox(width: 6),
              Text(time),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.red),
              SizedBox(width: 6),
              Text("14.5995, 120.9842"),
            ],
          )
        ],
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedalPatrol'),
        actions: const [AccountMenu()],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.green, size: 30),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bicycle Safe",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text("No unauthorized movement detected"),
                        ],
                      ),
                    ),
                    Column(
                      children: const [
                        Icon(Icons.circle, color: Colors.green, size: 14),
                        Text("LED", style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Row(
      children: [
        Icon(Icons.show_chart),
        SizedBox(width: 8),
        Text("Movement History",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
    const SizedBox(height: 10),
    Expanded(
      child: ListView(
        children: const [
          HistoryItem(title: "Bike parked", time: "10:24 AM", safe: true),
          HistoryItem(title: "Movement detected", time: "9:45 AM", safe: false),
          HistoryItem(title: "Bike parked", time: "9:15 AM", safe: true),
          HistoryItem(title: "Movement detected", time: "8:30 AM", safe: false),
          HistoryItem(title: "System activated", time: "8:00 AM", safe: true),
        ],
      ),
    )
  ],
),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String title;
  final String time;
  final bool safe;

  const HistoryItem({
    super.key,
    required this.title,
    required this.time,
    required this.safe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            safe ? Icons.check_circle : Icons.warning,
            color: safe ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedalPatrol'),
        actions: const [AccountMenu()],
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),

              // 🚴 Current Ride Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Current Ride",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: const Text("Start Ride"),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Start a ride to track your\ncycling metrics",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📊 Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  RideStatCard(title: "Total Distance", value: "77.7 km"),
                  RideStatCard(title: "Total Time", value: "3h 53m"),
                  RideStatCard(title: "Total Rides", value: "4"),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Recent Activities",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView(
                  children: const [
                    RideActivityItem(),
                    RideActivityItem(),
                    RideActivityItem(),
                    RideActivityItem(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RideStatCard extends StatelessWidget {
  final String title;
  final String value;

  const RideStatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class RideActivityItem extends StatelessWidget {
  const RideActivityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.show_chart, color: Colors.blue),
          ),
          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Feb 5, 2026"),
                SizedBox(height: 4),
                Text(
                  "15.3 km",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Duration"),
              SizedBox(height: 4),
              Text(
                "42m 0s",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}


void loginUser(BuildContext context, String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter email and password")),
    );
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('registered_email');
  final storedPassword = prefs.getString('registered_password');

  if (storedEmail == null || storedPassword == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No account found. Please create one.")),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
    return;
  }

  final emailNorm = email.trim().toLowerCase();
  final passwordNorm = password.trim();

  if (emailNorm == storedEmail && passwordNorm == storedPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Successful")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PedalPatrolHome()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid email or password")),
    );
  }
}


