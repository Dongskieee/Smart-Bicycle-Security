import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

