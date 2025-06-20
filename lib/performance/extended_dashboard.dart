import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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

  // Mock data
  final int totalObjectives = 28;
  final int totalKeyResults = 8;
  final int totalFeedbacks = 21;

  final List<Map<String, dynamic>> bonusPoints = [
    {'employee': 'John', 'points': 50},
    {'employee': 'Jane', 'points': 30},
    {'employee': 'Alice', 'points': 40},
    {'employee': 'Bob', 'points': 25},
  ];

  final Map<String, int> meetingsData = {
    'Completed': 12,
    'Rescheduled': 3,
    'Cancelled': 2,
  };

  final int totalProjects = 10;
  final Map<String, int> objectivesData = {
    '>50%': 4,
    '>75%': 3,
    '>90%': 2,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extended Dashboard'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KPIs
              _kpiCard('Total employee objectives', totalObjectives),
              _kpiCard('Total key results', totalKeyResults),
              _kpiCard('Total feedbacks', totalFeedbacks),
              const SizedBox(height: 12),
              const Divider(thickness: 3),
              const SizedBox(height: 12),

              // Chart 1: Bonus Points by Employee
              _chartSection(
                title: 'Employee Bonus Points',
                chartType: bonusChartType,
                onSwitch: () => setState(() => bonusChartType = (bonusChartType + 1) % 3),
                chartWidget: _bonusPointsChart(),
              ),

              const SizedBox(height: 24),

              // Chart 2: Meetings Data
              _chartSection(
                title: 'Meetings Status',
                chartType: meetingsChartType,
                onSwitch: () => setState(() => meetingsChartType = (meetingsChartType + 1) % 3),
                chartWidget: _meetingsChart(),
              ),

              const SizedBox(height: 24),

              // Chart 3: Objectives Progress
              _chartSection(
                title: 'Objectives Progress',
                chartType: objectivesChartType,
                onSwitch: () => setState(() => objectivesChartType = (objectivesChartType + 1) % 3),
                chartWidget: _objectivesChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // KPI Card
  Widget _kpiCard(String label, int value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kMaroon.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Chart Section with Switch Button
  Widget _chartSection({
    required String title,
    required int chartType,
    required VoidCallback onSwitch,
    required Widget chartWidget,
  }) {
    final chartNames = ['Bar', 'Pie', 'Line'];
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: kMaroon)),
                const Spacer(),
                ElevatedButton(
                  onPressed: onSwitch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Switch: ${chartNames[chartType]}'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(height: 250, child: chartWidget),
          ],
        ),
      ),
    );
  }

  // Bonus Points Chart
  Widget _bonusPointsChart() {
    final chartType = bonusChartType;
    final employees = bonusPoints.map((e) => e['employee'] as String).toList();
    final points = bonusPoints.map((e) => (e['points'] as num).toDouble()).toList();


    if (chartType == 0) {
      // Bar Chart
      return BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < employees.length
                      ? Text(employees[idx], style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(
            employees.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: points[i] ,
                  color: kMaroon,
                  width: 18,
                  borderRadius: BorderRadius.circular(8),
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
          sections: List.generate(
            employees.length,
            (i) => PieChartSectionData(
              value: points[i],
              title: employees[i],
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
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < employees.length
                      ? Text(employees[idx], style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(employees.length, (i) => FlSpot(i.toDouble(), points[i])),
              color: kMaroon,
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      );
    }
  }

  // Meetings Chart
  Widget _meetingsChart() {
    final chartType = meetingsChartType;
    final categories = meetingsData.keys.toList();
    final values = meetingsData.values.map((e) => e.toDouble()).toList();


    if (chartType == 0) {
      // Bar Chart
      return BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < categories.length
                      ? Text(categories[idx], style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(
            categories.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i] ,
                  color: kMaroon,
                  width: 22,
                  borderRadius: BorderRadius.circular(8),
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
          sections: List.generate(
            categories.length,
            (i) => PieChartSectionData(
              value: values[i] ,
              title: categories[i],
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
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < categories.length
                      ? Text(categories[idx], style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(categories.length, (i) => FlSpot(i.toDouble(), values[i])),
              isCurved: true,
              color: kMaroon,
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      );
    }
  }

  // Objectives Chart
  Widget _objectivesChart() {
    final chartType = objectivesChartType;
    final labels = objectivesData.keys.toList();
    final values = objectivesData.values.map((e) => e.toDouble()).toList();


    if (chartType == 0) {
      // Bar Chart
      return BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < labels.length
                      ? Text(labels[idx], style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(
            labels.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i] ,
                  color: kMaroon,
                  width: 22,
                  borderRadius: BorderRadius.circular(8),
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
          sections: List.generate(
            labels.length,
            (i) => PieChartSectionData(
              value: values[i],
              title: labels[i],
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
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  return idx >= 0 && idx < labels.length
                      ? Text(labels[idx], style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(labels.length, (i) => FlSpot(i.toDouble(), values[i])),
              isCurved: true,
              color: kMaroon,
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      );
    }
  }
}

