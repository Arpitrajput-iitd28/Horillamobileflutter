import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
// Import necessary packages for API operations.
// You would need to add 'http' to your pubspec.yaml:
// dependencies:
//   http: ^0.13.3 // Or the latest compatible version
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For encoding/decoding JSON

const Color kMaroon = Color(0xFF800000);

class ExtendedDashboard extends StatefulWidget {
  const ExtendedDashboard({Key? key}) : super(key: key);

  @override
  State<ExtendedDashboard> createState() => _ExtendedDashboardState();
}

class _ExtendedDashboardState extends State<ExtendedDashboard> {
  // Chart type states: 0 = Bar, 1 = Pie, 2 = Line
  int bonusChartType = 0;
  int meetingsChartType = 0;
  int objectivesChartType = 0;

  // Data to be fetched from API
  int totalObjectives = 28;
  int totalKeyResults = 8;
  int totalFeedbacks = 21;

  List<Map<String, dynamic>> bonusPoints = [
    {'employee': 'John', 'points': 50},
    {'employee': 'Jane', 'points': 30},
    {'employee': 'Alice', 'points': 40},
    {'employee': 'Bob', 'points': 25},
  ];

  Map<String, int> meetingsData = {
    'Completed': 12,
    'Rescheduled': 3,
    'Cancelled': 2,
  };

  int totalProjects = 10;
  int projectsCompleted = 7;

  @override
  void initState() {
    super.initState();
    // Uncomment these methods for API integration:
    // _fetchObjectivesSummary();
    // _fetchBonusPointsData();
    // _fetchMeetingsData();
    // _fetchProjectData();
  }

  // Example function to fetch overall objectives summary from a REST API
  /*
  Future<void> _fetchObjectivesSummary() async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/dashboard/objectives_summary/');
    try {
      // final response = await http.get(url, headers: {
      //   'Authorization': 'Bearer YOUR_TOKEN',
      //   'Content-Type': 'application/json',
      // });

      // // Simulate a network request
      // await Future.delayed(Duration(milliseconds: 500));
      // final response = http.Response(
      //   json.encode({
      //     'total_objectives': 35,
      //     'total_key_results': 12,
      //     'total_feedbacks': 28,
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
      //   print('Failed to fetch objectives summary: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error fetching objectives summary: $e');
    }
  }
  */

  // Example function to fetch bonus points data from a REST API
  /*
  Future<void> _fetchBonusPointsData() async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/dashboard/bonus_points_data/');
    try {
      // final response = await http.get(url, headers: {
      //   'Authorization': 'Bearer YOUR_TOKEN',
      //   'Content-Type': 'application/json',
      // });

      // // Simulate a network request
      // await Future.delayed(Duration(milliseconds: 500));
      // final response = http.Response(
      //   json.encode([
      //     {'employee': 'Michael', 'points': 70},
      //     {'employee': 'Sarah', 'points': 45},
      //     {'employee': 'David', 'points': 60},
      //     {'employee': 'Emily', 'points': 35},
      //   ]),
      //   200,
      // );

      // if (response.statusCode == 200) {
      //   final List<dynamic> fetchedData = json.decode(response.body);
      //   setState(() {
      //     bonusPoints = fetchedData.map((item) => {
      //       'employee': item['employee'],
      //       'points': item['points'],
      //     }).toList();
      //   });
      // } else {
      //   print('Failed to fetch bonus points data: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error fetching bonus points data: $e');
    }
  }
  */

  // Example function to fetch meetings data from a REST API
  /*
  Future<void> _fetchMeetingsData() async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/dashboard/meetings_data/');
    try {
      // final response = await http.get(url, headers: {
      //   'Authorization': 'Bearer YOUR_TOKEN',
      //   'Content-Type': 'application/json',
      // });

      // // Simulate a network request
      // await Future.delayed(Duration(milliseconds: 500));
      // final response = http.Response(
      //   json.encode({
      //     'Completed': 15,
      //     'Rescheduled': 5,
      //     'Cancelled': 1,
      //   }),
      //   200,
      // );

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> fetchedData = json.decode(response.body);
      //   setState(() {
      //     meetingsData = fetchedData.cast<String, int>();
      //   });
      // } else {
      //   print('Failed to fetch meetings data: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error fetching meetings data: $e');
    }
  }
  */

  // Example function to fetch project data from a REST API
  /*
  Future<void> _fetchProjectData() async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/dashboard/project_data/');
    try {
      // final response = await http.get(url, headers: {
      //   'Authorization': 'Bearer YOUR_TOKEN',
      //   'Content-Type': 'application/json',
      // });

      // // Simulate a network request
      // await Future.delayed(Duration(milliseconds: 500));
      // final response = http.Response(
      //   json.encode({
      //     'total_projects': 15,
      //     'projects_completed': 10,
      //   }),
      //   200,
      // );

      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   setState(() {
      //     totalProjects = data['total_projects'];
      //     projectsCompleted = data['projects_completed'];
      //   });
      // } else {
      //   print('Failed to fetch project data: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error fetching project data: $e');
    }
  }
  */

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extended Dashboard'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Objectives Summary
              const Text(
                'Objectives Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kMaroon,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: summaryStats.length,
                  itemBuilder: (context, index) {
                    final stat = summaryStats[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
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
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Bonus Points Chart Section
              _buildChartSection(
                title: 'Bonus Points Distribution',
                chartType: bonusChartType,
                onChartTypeChanged: (type) => setState(() => bonusChartType = type),
                chart: _buildDynamicChart(
                  bonusPoints.map((e) => e['employee'].toString()).toList(),
                  bonusPoints.map((e) => e['points'] as double).toList(),
                  bonusChartType,
                  'Employee',
                  'Points',
                ),
              ),
              const SizedBox(height: 32),

              // Meetings Chart Section
              _buildChartSection(
                title: 'Meetings Summary',
                chartType: meetingsChartType,
                onChartTypeChanged: (type) => setState(() => meetingsChartType = type),
                chart: _buildDynamicChart(
                  meetingsData.keys.toList(),
                  meetingsData.values.map((e) => e.toDouble()).toList(),
                  meetingsChartType,
                  'Category',
                  'Count',
                ),
              ),
              const SizedBox(height: 32),

              // Projects Progress Section
              const Text(
                'Projects Progress',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kMaroon,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Projects: $totalProjects',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Projects Completed: $projectsCompleted',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: totalProjects > 0 ? projectsCompleted / totalProjects : 0,
                        backgroundColor: Colors.grey[300],
                        color: kMaroon,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${((projectsCompleted / totalProjects) * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required int chartType,
    required ValueChanged<int> onChartTypeChanged,
    required Widget chart,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kMaroon,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildChartTypeButton('Bar', 0, chartType, onChartTypeChanged),
            _buildChartTypeButton('Pie', 1, chartType, onChartTypeChanged),
            _buildChartTypeButton('Line', 2, chartType, onChartTypeChanged),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 250,
              child: chart,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartTypeButton(String label, int type, int currentType, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () => onChanged(type),
        style: ElevatedButton.styleFrom(
          backgroundColor: currentType == type ? kMaroon : Colors.grey[200],
          foregroundColor: currentType == type ? Colors.white : kMaroon,
          side: BorderSide(color: kMaroon.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 30),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildDynamicChart(List<String> labels, List<double> values, int chartType, String xAxisTitle, String yAxisTitle) {
    if (values.isEmpty) {
      return const Center(child: Text('No data available for this chart.'));
    }

    if (chartType == 0) {
      // Bar Chart
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: values.reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  return index >= 0 && index < labels.length
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(labels[index], style: const TextStyle(fontSize: 10)),
                        )
                      : const SizedBox.shrink();
                },
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                reservedSize: 28,
                interval: (values.reduce((a, b) => a > b ? a : b) / 3).roundToDouble().clamp(1.0, double.infinity),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          barGroups: List.generate(
            values.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: kMaroon.withOpacity(0.7 + 0.3 * (i % 2)),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (chartType == 1) {
      // Pie Chart
      return PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: List.generate(
            values.length,
            (i) => PieChartSectionData(
              value: values[i],
              title: '${((values[i] / values.reduce((a, b) => a + b)) * 100).toStringAsFixed(1)}%',
              color: kMaroon.withOpacity(0.7 + 0.3 * (i % 2)),
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      );
    } else {
      // Line Chart
      return LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                reservedSize: 28,
                interval: (values.reduce((a, b) => a > b ? a : b) / 3).roundToDouble().clamp(1.0, double.infinity),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < labels.length
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(labels[idx], style: const TextStyle(fontSize: 10)),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(labels.length, (i) => FlSpot(i.toDouble(), values[i])),
              isCurved: true,
              color: kMaroon,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      );
    }
  }
}