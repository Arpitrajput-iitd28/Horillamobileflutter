import 'package:flutter/material.dart';
// Import necessary packages for API operations.
// You would need to add 'http' to your pubspec.yaml:
// dependencies:
//   http: ^0.13.3 // Or the latest compatible version
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For encoding/decoding JSON

class PerformanceDashboard extends StatefulWidget {
  const PerformanceDashboard({Key? key}) : super(key: key);

  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  // Mock data - will be replaced by API data if integration is uncommented
  int totalObjectives = 26;
  int totalKeyResults = 8;
  int totalFeedbacks = 21;

  // This list will be populated dynamically from the state variables
  List<Map<String, dynamic>> get summaryStats {
    return [
      {
        'label': 'Total employee objectives',
        'value': totalObjectives,
        'color': const Color.fromARGB(255, 18, 18, 18),
      },
      {
        'label': 'Total key results',
        'value': totalKeyResults,
        'color': const Color.fromARGB(255, 0, 74, 111),
      },
      {
        'label': 'Total feedbacks',
        'value': totalFeedbacks,
        'color': const Color.fromARGB(255,139,45,20),
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    // Uncomment this method call for API integration
    // fetchPerformanceSummary();
  }

  // Uncomment this method for API integration and comment out the mock data above
  /*
  Future<void> fetchPerformanceSummary() async {
    // Ensure you add http package to your pubspec.yaml:
    // dependencies:
    //   http: ^latest_version
    // final serverAddress = 'YOUR_API_BASE_URL'; // Replace with your server URL
    // final url = Uri.parse('$serverAddress/api/performance/summary/');
    try {
      // Optionally add authentication headers if needed
      // final response = await http.get(url, headers: {
      //   'Authorization': 'Bearer YOUR_TOKEN', // Replace with actual token
      //   'Content-Type': 'application/json',
      // });

      // // Simulating a network request for demonstration
      // await Future.delayed(Duration(seconds: 2));
      // final response = http.Response(
      //   json.encode({
      //     'total_objectives': 30,
      //     'total_key_results': 10,
      //     'total_feedbacks': 25,
      //   }),
      //   200,
      // );

      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   setState(() {
      //     totalObjectives = data['total_objectives'];
      //     totalKeyResults = data['total_key_results'];
      //     totalFeedbacks = data['total_feedbacks'];
      //   });
      // } else {
      //   // Handle error, show a snackbar or fallback to mock data
      //   print('Failed to fetch performance summary: ${response.statusCode}');
      //   // Optionally, show a user-friendly message
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Failed to load dashboard data. Showing mock data.')),
      //   );
      // }
    } catch (e) {
      // Handle network errors (e.g., no internet connection)
      print('Error fetching performance summary: $e');
      // Optionally, show a user-friendly message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Network error. Please check your connection.')),
      // );
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Dashboard')),
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
                        color: const Color(0xFF8B2D14),
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
                          Navigator.pushNamed(context, '/extended_dashboard');
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
                    icon: Icons.flag,
                    title: "Objectives",
                    subtitle: "Set and track employee objectives",
                    route: '/objectives',
                  ),
                  _NavigationCard(
                    icon: Icons.star,
                    title: "Bonus Points",
                    subtitle: "Reward employee achievements",
                    route: '/bonus_points',
                  ),
                  _NavigationCard(
                    icon: Icons.feedback,
                    title: "Feedback",
                    subtitle: "Give and receive feedback",
                    route: '/feedback',
                  ),
                  _NavigationCard(
                    icon: Icons.people,
                    title: "Meetings",
                    subtitle: "Schedule and manage meetings",
                    route: '/meetings',
                  ),
                  _NavigationCard(
                    icon: Icons.quiz,
                    title: "Question Template",
                    subtitle: "Manage feedback templates",
                    route: '/question_template',
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
        leading: Icon(icon, size: 32, color: const Color.fromARGB(255, 100, 7, 0)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}