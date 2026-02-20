import 'package:flutter/material.dart';

void main() {
  runApp(const PedalPatrolApp());
}

class PedalPatrolApp extends StatelessWidget {
  const PedalPatrolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // 👈 Start with login
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

  void loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    if (email == "cyclist@gmail.com" && password == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PedalPatrolHome(),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Cyclist Login",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loginUser,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "PedalPatrol",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text("Theft Alert System", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class AlertCard extends StatelessWidget {
  const AlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "THEFT ALERT!",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text("Unauthorized movement detected"),
              ],
            ),
          ),
          Column(
            children: const [
              Icon(Icons.circle, color: Colors.red, size: 14),
              Text("LED", style: TextStyle(fontSize: 12))
            ],
          )
        ],
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Current Location",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: "GPS"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike), label: "Rides"),
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
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
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


void loginUser(BuildContext context, String email, String password) {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter email and password")),
    );
    return;
  }

  // Dummy user validation (replace with API/Firebase later)
  if (email == "cyclist@gmail.com" && password == "123456") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Successful")),
    );

    Navigator.pushReplacementNamed(context, "/home");
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid email or password")),
    );
  }
}


