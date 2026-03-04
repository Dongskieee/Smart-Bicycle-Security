import 'package:flutter/material.dart';

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

