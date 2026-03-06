import 'package:flutter/material.dart';

class AdminGpsScreen extends StatefulWidget {
  const AdminGpsScreen({super.key});

  @override
  State<AdminGpsScreen> createState() => _AdminGpsScreenState();
}

class _AdminGpsScreenState extends State<AdminGpsScreen> {
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _bikes = [
    {
      'id': 'B001',
      'name': 'Mountain Bike Pro',
      'user': 'Juan Dela Cruz',
      'userId': 'U001',
      'location': 'Quezon City, Metro Manila',
      'coordinates': '14.6760° N, 121.0437° E',
      'status': 'Moving',
      'speed': '15 km/h',
      'battery': '85%',
      'lastUpdate': '2 minutes ago',
      'signal': 'Strong',
    },
    {
      'id': 'B002',
      'name': 'Road Bike Elite',
      'user': 'Maria Santos',
      'userId': 'U002',
      'location': 'Makati City, Metro Manila',
      'coordinates': '14.5547° N, 121.0244° E',
      'status': 'Parked',
      'speed': '0 km/h',
      'battery': '92%',
      'lastUpdate': 'Just now',
      'signal': 'Strong',
    },
    {
      'id': 'B003',
      'name': 'Hybrid Bike',
      'user': 'John Doe',
      'userId': 'U003',
      'location': 'Manila City, Metro Manila',
      'coordinates': '14.5995° N, 120.9842° E',
      'status': 'Moving',
      'speed': '22 km/h',
      'battery': '78%',
      'lastUpdate': '1 minute ago',
      'signal': 'Medium',
    },
    {
      'id': 'B004',
      'name': 'Electric Bike',
      'user': 'Anna Lee',
      'userId': 'U004',
      'location': 'Pasig City, Metro Manila',
      'coordinates': '14.5764° N, 121.0851° E',
      'status': 'Offline',
      'speed': '0 km/h',
      'battery': '12%',
      'lastUpdate': '2 hours ago',
      'signal': 'None',
    },
    {
      'id': 'B005',
      'name': 'City Cruiser',
      'user': 'Pedro Garcia',
      'userId': 'U005',
      'location': 'Taguig City, Metro Manila',
      'coordinates': '14.5176° N, 121.0509° E',
      'status': 'Parked',
      'speed': '0 km/h',
      'battery': '68%',
      'lastUpdate': '10 minutes ago',
      'signal': 'Strong',
    },
    {
      'id': 'B006',
      'name': 'BMX Bike',
      'user': 'Lisa Tan',
      'userId': 'U006',
      'location': 'Caloocan City, Metro Manila',
      'coordinates': '14.6488° N, 120.9830° E',
      'status': 'Moving',
      'speed': '18 km/h',
      'battery': '55%',
      'lastUpdate': '5 minutes ago',
      'signal': 'Medium',
    },
  ];

  List<Map<String, dynamic>> get _filteredBikes {
    if (_filterStatus == 'All') {
      return _bikes;
    }
    return _bikes.where((bike) => bike['status'] == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBikes = _filteredBikes;
    final movingCount = _bikes.where((b) => b['status'] == 'Moving').length;
    final parkedCount = _bikes.where((b) => b['status'] == 'Parked').length;
    final offlineCount = _bikes.where((b) => b['status'] == 'Offline').length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'GPS Tracking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map view coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Summary
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _StatusCard(
                    icon: Icons.directions_bike,
                    label: 'Moving',
                    value: '$movingCount',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatusCard(
                    icon: Icons.local_parking,
                    label: 'Parked',
                    value: '$parkedCount',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatusCard(
                    icon: Icons.signal_wifi_off,
                    label: 'Offline',
                    value: '$offlineCount',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _filterStatus == 'All',
                    onTap: () => setState(() => _filterStatus = 'All'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Moving',
                    isSelected: _filterStatus == 'Moving',
                    onTap: () => setState(() => _filterStatus = 'Moving'),
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Parked',
                    isSelected: _filterStatus == 'Parked',
                    onTap: () => setState(() => _filterStatus = 'Parked'),
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Offline',
                    isSelected: _filterStatus == 'Offline',
                    onTap: () => setState(() => _filterStatus = 'Offline'),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // Bike Count
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredBikes.length} bikes tracked',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Live tracking updated')),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),

          // Bikes List
          Expanded(
            child: filteredBikes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pedal_bike,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bikes found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredBikes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final bike = filteredBikes[index];
                      return _BikeTrackingCard(bike: bike);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _BikeTrackingCard extends StatelessWidget {
  final Map<String, dynamic> bike;

  const _BikeTrackingCard({required this.bike});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Moving':
        return Colors.green;
      case 'Parked':
        return Colors.blue;
      case 'Offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Moving':
        return Icons.directions_bike;
      case 'Parked':
        return Icons.local_parking;
      case 'Offline':
        return Icons.signal_wifi_off;
      default:
        return Icons.help_outline;
    }
  }

  Color _getBatteryColor(String battery) {
    final percent = int.tryParse(battery.replaceAll('%', '')) ?? 0;
    if (percent > 50) return Colors.green;
    if (percent > 20) return Colors.orange;
    return Colors.red;
  }

  Color _getSignalColor(String signal) {
    switch (signal) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Weak':
        return Colors.red;
      case 'None':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.pedal_bike,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${bike['user']} (${bike['userId']})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${bike['id']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(bike['status']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(bike['status']),
                        size: 14,
                        color: _getStatusColor(bike['status']),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bike['status'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(bike['status']),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        bike['coordinates'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.speed,
                  label: bike['speed'],
                  color: bike['status'] == 'Moving'
                      ? Colors.green
                      : Colors.grey,
                ),
                _InfoChip(
                  icon: Icons.battery_charging_full,
                  label: bike['battery'],
                  color: _getBatteryColor(bike['battery']),
                ),
                _InfoChip(
                  icon: Icons.signal_cellular_alt,
                  label: bike['signal'],
                  color: _getSignalColor(bike['signal']),
                ),
                _InfoChip(
                  icon: Icons.access_time,
                  label: bike['lastUpdate'],
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showBikeOnMap(context, bike);
                    },
                    icon: const Icon(Icons.map, size: 18),
                    label: const Text('View on Map'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showTrackingDetails(context, bike);
                    },
                    icon: const Icon(Icons.info, size: 18),
                    label: const Text('Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBikeOnMap(BuildContext context, Map<String, dynamic> bike) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map View'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 64,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Map integration coming soon',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bike['coordinates'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTrackingDetails(BuildContext context, Map<String, dynamic> bike) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tracking Details',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _DetailRow(label: 'Bike ID', value: bike['id']),
            _DetailRow(label: 'Bike Name', value: bike['name']),
            _DetailRow(label: 'Owner', value: bike['user']),
            _DetailRow(label: 'Owner ID', value: bike['userId']),
            _DetailRow(label: 'Status', value: bike['status']),
            _DetailRow(label: 'Current Speed', value: bike['speed']),
            _DetailRow(label: 'Location', value: bike['location']),
            _DetailRow(label: 'Coordinates', value: bike['coordinates']),
            _DetailRow(label: 'Battery Level', value: bike['battery']),
            _DetailRow(label: 'Signal Strength', value: bike['signal']),
            _DetailRow(label: 'Last Update', value: bike['lastUpdate']),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting live tracking...')),
                  );
                },
                icon: const Icon(Icons.my_location),
                label: const Text('Track Live'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
