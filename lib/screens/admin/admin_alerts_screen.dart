import 'package:flutter/material.dart';

class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  String _filterSeverity = 'All';

  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 'A001',
      'type': 'Theft Alert',
      'severity': 'Critical',
      'user': 'Juan Dela Cruz',
      'userId': 'U001',
      'bike': 'Mountain Bike Pro',
      'location': 'Quezon City, Metro Manila',
      'coordinates': '14.6760° N, 121.0437° E',
      'time': '15 minutes ago',
      'timestamp': '2024-03-20 14:30',
      'status': 'Active',
      'description': 'Bike moved without authorization. GPS tracking active.',
    },
    {
      'id': 'A002',
      'type': 'Movement Alert',
      'severity': 'High',
      'user': 'Maria Santos',
      'userId': 'U002',
      'bike': 'Road Bike Elite',
      'location': 'Makati City, Metro Manila',
      'coordinates': '14.5547° N, 121.0244° E',
      'time': '1 hour ago',
      'timestamp': '2024-03-20 13:45',
      'status': 'Investigating',
      'description': 'Unusual movement pattern detected during non-business hours.',
    },
    {
      'id': 'A003',
      'type': 'Theft Alert',
      'severity': 'Critical',
      'user': 'Pedro Garcia',
      'userId': 'U005',
      'bike': 'City Cruiser',
      'location': 'Taguig City, Metro Manila',
      'coordinates': '14.5176° N, 121.0509° E',
      'time': '2 hours ago',
      'timestamp': '2024-03-20 12:45',
      'status': 'Resolved',
      'description': 'False alarm - User confirmed authorized movement.',
    },
    {
      'id': 'A004',
      'type': 'Low Battery',
      'severity': 'Medium',
      'user': 'Anna Lee',
      'userId': 'U004',
      'bike': 'Electric Bike',
      'location': 'Pasig City, Metro Manila',
      'coordinates': '14.5764° N, 121.0851° E',
      'time': '3 hours ago',
      'timestamp': '2024-03-20 11:30',
      'status': 'Acknowledged',
      'description': 'GPS tracker battery below 15%. Charging recommended.',
    },
    {
      'id': 'A005',
      'type': 'Geofence Breach',
      'severity': 'High',
      'user': 'John Doe',
      'userId': 'U003',
      'bike': 'Hybrid Bike',
      'location': 'Manila City, Metro Manila',
      'coordinates': '14.5995° N, 120.9842° E',
      'time': '5 hours ago',
      'timestamp': '2024-03-20 09:15',
      'status': 'Active',
      'description': 'Bike exceeded designated safe zone boundary.',
    },
    {
      'id': 'A006',
      'type': 'Tamper Alert',
      'severity': 'Critical',
      'user': 'Lisa Tan',
      'userId': 'U006',
      'bike': 'BMX Bike',
      'location': 'Caloocan City, Metro Manila',
      'coordinates': '14.6488° N, 120.9830° E',
      'time': '1 day ago',
      'timestamp': '2024-03-19 16:20',
      'status': 'Resolved',
      'description': 'GPS device tampering detected. Device secured by user.',
    },
  ];

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_filterSeverity == 'All') {
      return _alerts;
    }
    return _alerts
        .where((alert) => alert['severity'] == _filterSeverity)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = _filteredAlerts;
    final criticalCount =
        _alerts.where((a) => a['severity'] == 'Critical').length;
    final activeCount = _alerts.where((a) => a['status'] == 'Active').length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'Alert Monitoring',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Alert Summary
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.warning,
                    label: 'Critical',
                    value: '$criticalCount',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.notifications_active,
                    label: 'Active',
                    value: '$activeCount',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.check_circle,
                    label: 'Resolved',
                    value: '${_alerts.where((a) => a['status'] == 'Resolved').length}',
                    color: Colors.green,
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
                    isSelected: _filterSeverity == 'All',
                    onTap: () => setState(() => _filterSeverity = 'All'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Critical',
                    isSelected: _filterSeverity == 'Critical',
                    onTap: () => setState(() => _filterSeverity = 'Critical'),
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'High',
                    isSelected: _filterSeverity == 'High',
                    onTap: () => setState(() => _filterSeverity = 'High'),
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Medium',
                    isSelected: _filterSeverity == 'Medium',
                    onTap: () => setState(() => _filterSeverity = 'Medium'),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          // Alert Count
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredAlerts.length} alerts',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Refresh complete')),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),

          // Alerts List
          Expanded(
            child: filteredAlerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No alerts found',
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
                    itemCount: filteredAlerts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final alert = filteredAlerts[index];
                      return _AlertCard(alert: alert);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
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

class _AlertCard extends StatelessWidget {
  final Map<String, dynamic> alert;

  const _AlertCard({required this.alert});

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.blue;
      case 'Low':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.red;
      case 'Investigating':
        return Colors.orange;
      case 'Acknowledged':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'Theft Alert':
        return Icons.warning;
      case 'Movement Alert':
        return Icons.directions_bike;
      case 'Low Battery':
        return Icons.battery_alert;
      case 'Geofence Breach':
        return Icons.location_off;
      case 'Tamper Alert':
        return Icons.build;
      default:
        return Icons.notifications;
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
                    color: _getSeverityColor(alert['severity']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getAlertIcon(alert['type']),
                    color: _getSeverityColor(alert['severity']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert['type'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getSeverityColor(alert['severity'])
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alert['severity'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _getSeverityColor(alert['severity']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${alert['id']} • ${alert['time']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _InfoRow(
              icon: Icons.person,
              label: 'User',
              value: '${alert['user']} (${alert['userId']})',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.pedal_bike,
              label: 'Bike',
              value: alert['bike'],
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.location_on,
              label: 'Location',
              value: alert['location'],
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.info_outline,
              label: 'Details',
              value: alert['description'],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(alert['status']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: _getStatusColor(alert['status']),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        alert['status'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(alert['status']),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAlertDetails(context, alert);
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showAlertActions(context, alert);
                    },
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text('Actions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDetails(BuildContext context, Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
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
                'Alert Details',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _DetailRow(label: 'Alert ID', value: alert['id']),
              _DetailRow(label: 'Type', value: alert['type']),
              _DetailRow(label: 'Severity', value: alert['severity']),
              _DetailRow(label: 'Status', value: alert['status']),
              _DetailRow(label: 'User', value: alert['user']),
              _DetailRow(label: 'User ID', value: alert['userId']),
              _DetailRow(label: 'Bike', value: alert['bike']),
              _DetailRow(label: 'Location', value: alert['location']),
              _DetailRow(label: 'Coordinates', value: alert['coordinates']),
              _DetailRow(label: 'Timestamp', value: alert['timestamp']),
              _DetailRow(label: 'Time Ago', value: alert['time']),
              _DetailRow(label: 'Description', value: alert['description']),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertActions(BuildContext context, Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Alert Actions',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text('View on Map'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening map view...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Contact User'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling ${alert['user']}...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check, color: Colors.orange),
              title: const Text('Mark as Investigating'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Status updated to Investigating')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Resolve Alert'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alert marked as resolved')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Dismiss Alert'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alert dismissed')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
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
