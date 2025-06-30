import 'package:flutter/material.dart';
// For simulating API calls (in a real app, you'd use packages like http or dio)
// import 'dart:convert'; // For json.decode/encode
// import 'package:http/http.dart' as http; // Uncomment and add to pubspec.yaml if using http client

// --- API Integration Placeholder (Commented Out) ---
// In a real application, you would interact with a backend API to persist data.
// This section demonstrates where API calls would typically be made for recruitment data.

/*
// This would be your API client or service specifically for recruitment data
class RecruitmentApiService {
  // Simulates fetching recruitment summary data from a backend
  Future<List<Map<String, dynamic>>> fetchRecruitmentSummary() async {
    // In a real app, this would be an http GET request to your backend
    // Example:
    // final response = await http.get(Uri.parse('YOUR_BACKEND_URL/recruitment/summary'));
    // if (response.statusCode == 200) {
    //   // If your API returns data like:
    //   // [{"label": "Individuals in Pipeline", "value": 56, "color": "#121212"}, ...]
    //   return (json.decode(response.body) as List)
    //       .map((e) => {
    //             'label': e['label'],
    //             'value': e['value'],
    //             // You might need to parse colors from hex string to Color object
    //             'color': Color(int.parse(e['color'].substring(1, 7), radix: 16) + 0xFF000000),
    //           })
    //       .toList();
    // } else {
    //   throw Exception('Failed to load recruitment summary: ${response.statusCode}');
    // }

    // Simulating network delay and returning mock data
    await Future.delayed(const Duration(seconds: 1));
    print("API: Fetching recruitment summary...");
    return [
      {
        'label': 'Individuals in Pipeline (API)',
        'value': 60, // Example of updated value from API
        'color': const Color.fromARGB(255, 18, 18, 18),
      },
      {
        'label': 'Individuals interviewed (API)',
        'value': 15, // Example of updated value from API
        'color': const Color.fromARGB(255, 2, 146, 218),
      },
      {
        'label': 'Individual hired (API)',
        'value': 12, // Example of updated value from API
        'color': const Color.fromARGB(255, 227, 0, 106),
      },
      // You could add more mock stats here to simulate new data from server
    ];
  }

  // Add other recruitment-related API methods here, e.g.:
  // Future<void> addRecruitmentRecord(Map<String, dynamic> record) async {
  //   // POST /recruitment/records
  // }
  // Future<void> updateRecruitmentRecord(String id, Map<String, dynamic> record) async {
  //   // PUT /recruitment/records/{id}
  // }
  // Future<void> deleteRecruitmentRecord(String id) async {
  //   // DELETE /recruitment/records/{id}
  // }
}

// Initialize API service (this would be typically managed by a dependency injection system)
final RecruitmentApiService recruitmentApiService = RecruitmentApiService();
*/
// --- End API Integration Placeholder ---


class RecruitmentDashboard extends StatelessWidget {
  const RecruitmentDashboard({Key? key}) : super(key: key);

  // This data is currently static. If it were to be fetched from an API
  // dynamically, this widget would typically need to be converted to a
  // StatefulWidget, and the data fetched in its initState or via a FutureBuilder.
  static final List<Map<String, dynamic>> summaryStats = [
    {
      'label': 'Individuals in Pipeline',
      'value': 56,
      'color': const Color.fromARGB(255, 18, 18, 18),
    },
    {
      'label': 'Individuals interviewed',
      'value': 12,
      'color': const Color.fromARGB(255, 2, 146, 218),
    },
    {
      'label': 'Individual hired',
      'value': 11,
      'color': const Color.fromARGB(255, 227, 0, 106),
    },
  ];

  // --- API Call Placeholder (Commented Out) ---
  // Example of how you would fetch data if this were a StatefulWidget:
  /*
  // In a StatefulWidget, you would have a state class like _RecruitmentDashboardState
  // and fetch data in its initState:
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchSummaryStats();
  // }

  // List<Map<String, dynamic>> _dynamicSummaryStats = []; // To hold API fetched data

  // Future<void> _fetchSummaryStats() async {
  //   try {
  //     final fetchedStats = await recruitmentApiService.fetchRecruitmentSummary();
  //     setState(() {
  //       _dynamicSummaryStats = fetchedStats;
  //     });
  //     // You might show a success message
  //   } catch (e) {
  //     print('Error fetching recruitment summary: $e');
  //     // You might show an error message to the user
  //   }
  // }

  // And then in your build method, you would use _dynamicSummaryStats instead of summaryStats.
  // Alternatively, for a StatelessWidget, you could use a FutureBuilder:
  // body: FutureBuilder<List<Map<String, dynamic>>>(
  //   future: recruitmentApiService.fetchRecruitmentSummary(),
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return const Center(child: CircularProgressIndicator());
  //     } else if (snapshot.hasError) {
  //       return Center(child: Text('Error: ${snapshot.error}'));
  //     } else if (snapshot.hasData) {
  //       final apiSummaryStats = snapshot.data!;
  //       // Use apiSummaryStats for your ListView.builder
  //       return _buildDashboardContent(apiSummaryStats);
  //     } else {
  //       return const Center(child: Text('No data available.'));
  //     }
  //   },
  // ),
  */
  // --- End API Call Placeholder ---


  @override
  Widget build(BuildContext context) {
    // If using FutureBuilder as suggested in the commented section above,
    // this build method might receive `apiSummaryStats` as an argument
    // or access it from `snapshot.data`.
    // For now, it uses the static `summaryStats`.
    final currentSummaryStats = summaryStats; // Or _dynamicSummaryStats if fetching from API

    return Scaffold(
      appBar: AppBar(title: const Text('Recruitment Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Horizontally scrollable summary cards
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: currentSummaryStats.length + 1, // Use currentSummaryStats
                itemBuilder: (context, index) {
                  if (index < currentSummaryStats.length) { // Use currentSummaryStats
                    final stat = currentSummaryStats[index]; // Use currentSummaryStats
                    return _SummaryCard(
                      label: stat['label'] as String,
                      value: stat['value'] as int,
                      color: stat['color'] as Color,
                    );
                  } else {
                    return _AddCard(
                      onTap: () {
                        // Implement navigation or dialog to add new recruitment data
                        // This might also trigger an API call to add data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add New Recruitment Data functionality (API integration would go here)')),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _NavigationCard(
                    icon: Icons.person_add,
                    title: "Add Individual",
                    subtitle: "Add new individuals to the recruitment pipeline",
                    route: '/add_individual', // Placeholder route, API call for adding
                  ),
                  _NavigationCard(
                    icon: Icons.history,
                    title: "Recruitment History",
                    subtitle: "Review the history of individuals hired , their position and all the associated data.",
                    route: '/recruitment_history', // This page might fetch history from API
                  ),
                  _NavigationCard(
                    icon: Icons.quiz_rounded,
                    title: "Recruitment Template",
                    subtitle: "Add and Use set of questions that can assist the interviewer during the process. ",
                    route: '/recruitment_template', // This page already has API placeholders
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

// Reusable summary card widget
class _SummaryCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: color,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable add card widget
class _AddCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCard({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Add New',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
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
        onTap: () {
          // In a real app, this navigation would trigger relevant API calls
          // to fetch data for the destination page.
          if (route == '/add_individual') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Add Individual (API integration for adding data)')),
            );
          } else {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}