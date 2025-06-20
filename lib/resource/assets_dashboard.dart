import 'package:flutter/material.dart';

class AssetsDashboard extends StatelessWidget {
  const AssetsDashboard({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> summaryStats = [
    {
      'label': 'Assets',
      'value': 126,
      'color': const Color.fromARGB(255, 18, 18, 18),
    },
    {
      'label': 'Assets Request',
      'value': 8,
      'color': const Color.fromARGB(255, 0, 74, 111),
    },
    {
      'label': 'Assets in Use',
      'value': 21,
      'color': const Color.fromARGB(255,139,45,20),
    },
  ];

// Uncomment this method for API integration and comment out the mock data above
  /*
  Future<void> fetchPerformanceSummary() async {
    final serverAddress = 'YOUR_API_BASE_URL'; // Replace with your server URL
    final url = Uri.parse('$serverAddress/api/performance/summary/');
    // Optionally add authentication headers if needed
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer YOUR_TOKEN', // Replace with actual token
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        totalAssets = data['total_assets'];
        totalAssetsrequest = data['total_assets_request'];
        totalAssetsinuse = data['total_assets_in_use'];
      });
    } else {
      // Handle error, show a snackbar or fallback to mock data
      print('Failed to fetch performance summary: ${response.statusCode}');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Horizontally scrollable summary cards
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: summaryStats.length + 1,
                itemBuilder: (context, index) {
                  if (index < summaryStats.length) {
                    final stat = summaryStats[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF8B2D14),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border(
                          top: BorderSide(
                            color: stat['color'],
                            width: 4,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stat['label'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${stat['value']}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Arrow button at the end
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 40, color: Colors.black54),
                        onPressed: () {
                          Navigator.pushNamed(context, '/extended_asset_dashboard');
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            const Divider(height: 32, thickness: 1),

            // Consistent navigation cards for features
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _NavigationCard(
                    icon: Icons.inventory_2,
                    title: "Assets View",
                    subtitle: "Track and manage assets according to the category",
                    route: '/assets_view',
                  ),
                  _NavigationCard(
                    icon: Icons.widgets,
                    title: "Assets Batches",
                    subtitle: "Update asset information with a unique batch number",
                    route: '/assets_batches',
                  ),
                  _NavigationCard(
                    icon: Icons.assignment,
                    title: "Requests and Allocations",
                    subtitle: "Track and manage asset requests and their allocations",
                    route: '/requests_allocations',
                  ),
                  _NavigationCard(
                    icon: Icons.work_history_rounded,
                    title: "Assets History",
                    subtitle: "Review the history of asset usage and changes",
                    route: '/assets_history',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Reusable navigation card widget
class _NavigationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _NavigationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Color.fromARGB(255, 100, 7, 0)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
