import 'package:flutter/material.dart';

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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

