import 'package:flutter/material.dart';

class ProjectDashboard extends StatelessWidget {
  const ProjectDashboard({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> summaryStats = [
    {
      'label': 'Total Projects',
      'value': 126,
      'color': Color(0xFFFFE4C4), // Bisque color
    },
    {
      'label': 'New Projects',
      'value': 8,
      'color':  Color(0xFFFFE4C4),
    },
    {
      'label': 'Projects in Progress',
      'value': 21,
      'color':  Color(0xFFFFE4C4),
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
        totalProjects = data['total_projects'];
        totalNewProjects = data['total_new_projects'];
        totalProjectsinProgress = data['total_projects_in_progress'];
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
      appBar: AppBar(title: const Text('Project Dashboard')),
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
                          Navigator.pushNamed(context, '/extended_project_dashboard');
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            const Divider(height: 32, thickness: 2.5),

            // Consistent navigation cards for features
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _NavigationCard(
                    icon: Icons.article_rounded,
                    title: "Projects",
                    subtitle: "Track and manage projects according to the category",
                    route: '/projects',
                  ),
                  _NavigationCard(
                    icon: Icons.task,
                    title: "Task",
                    subtitle: "Assign and keep a record of tasks that need to be completed",
                    route: '/task',
                  ),
                  _NavigationCard(
                    icon: Icons.calendar_month_rounded,
                    title: "Timesheet",
                    subtitle: "Record the time an employee spend on a designated task",
                    route: '/timesheet',
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
