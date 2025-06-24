import 'package:flutter/material.dart';

class RecruitmentDashboard extends StatelessWidget {
  const RecruitmentDashboard({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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
                          Navigator.pushNamed(context, '/extended_recruitment_dashboard');
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
                    icon: Icons.face_4,
                    title: "Candidates",
                    subtitle: "Track and manage candidates.",
                    route: '/candidate',
                  ),
                  _NavigationCard(
                    icon: Icons.art_track_sharp,
                    title: "Pipeline",
                    subtitle: "Create recruitment ,add the stage to manage candidates and assign managers at any stage in the hiring process.",
                    route: '/pipeline',
                  ),
                  _NavigationCard(
                    icon: Icons.supervisor_account_outlined,
                    title: "Interview",
                    subtitle: "Track and manage interviews and their allocations.",
                    route: '/interview',
                  ),
                  _NavigationCard(
                    icon: Icons.work_history_rounded,
                    title: "Recruitment History",
                    subtitle: "Review the history of individuals hired , their position and all the associated data.",
                    route: '/recruitment_history',
                  ),
                  _NavigationCard(
                    icon: Icons.quiz_rounded,
                    title: "Recruitment Template",
                    subtitle: "Add and Use set of questions that can assist the interviewer during the process. ",
                    route: '/recruitment_template',
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
