import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// Import necessary packages for API operations.
// You would need to add 'http' to your pubspec.yaml:
// dependencies:
//   http: ^0.13.3 // Or the latest compatible version
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For encoding/decoding JSON

const Color kMaroon = Color(0xFF800000);

class BonusPoint extends StatefulWidget {
  const BonusPoint({Key? key}) : super(key: key);

  @override
  State<BonusPoint> createState() => _BonusPointState();
}

class _BonusPointState extends State<BonusPoint> {
  List<Map<String, dynamic>> allBonusPoints = [
    {
      'id': 'bp001', // Example ID for API interaction
      'employee_name': 'John Doe',
      'bonus_points': 50,
      'based_on': 'Project Completion',
      'position': 'Developer',
      'date': DateTime(2025, 6, 10),
      'isArchived': false,
    },
    {
      'id': 'bp002', // Example ID for API interaction
      'employee_name': 'Jane Smith',
      'bonus_points': 30,
      'based_on': 'Teamwork',
      'position': 'Designer',
      'date': DateTime(2025, 6, 12),
      'isArchived': false,
    },
    {
      'id': 'bp003', // Example ID for API interaction
      'employee_name': 'Alice Johnson',
      'bonus_points': 40,
      'based_on': 'Innovation',
      'position': 'Product Manager',
      'date': DateTime(2025, 6, 15),
      'isArchived': false,
    },
  ];

  List<Map<String, dynamic>> filteredBonusPoints = [];
  String searchQuery = '';
  Map<String, dynamic> filter = {};
  Set<int> expandedIndices = {};

  @override
  void initState() {
    super.initState();
    // Uncomment this for API integration:
    // _fetchBonusPointsFromApi();
    filteredBonusPoints = List.from(allBonusPoints);
  }

  // Example function to fetch bonus points from a REST API
  /*
  Future<void> _fetchBonusPointsFromApi() async {
    // final serverAddress = 'YOUR_API_BASE_URL'; // Replace with your server URL
    // final url = Uri.parse('$serverAddress/api/bonus_points/');
    try {
      // final response = await http.get(url, headers: {
      //   'Authorization': 'Bearer YOUR_TOKEN', // Replace with actual token
      //   'Content-Type': 'application/json',
      // });

      // // Simulate a network request and response for demonstration
      // await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      // final response = http.Response(
      //   json.encode([
      //     {
      //       'id': 'api_bp001',
      //       'employee_name': 'API John',
      //       'bonus_points': 60,
      //       'based_on': 'API Project',
      //       'position': 'API Dev',
      //       'date': '2025-07-05T00:00:00Z', // ISO 8601 string
      //       'isArchived': false,
      //     },
      //     {
      //       'id': 'api_bp002',
      //       'employee_name': 'API Jane',
      //       'bonus_points': 35,
      //       'based_on': 'API Teamwork',
      //       'position': 'API Designer',
      //       'date': '2025-07-06T00:00:00Z',
      //       'isArchived': false,
      //     },
      //   ]),
      //   200,
      // );

      // if (response.statusCode == 200) {
      //   final List<dynamic> fetchedData = json.decode(response.body);
      //   setState(() {
      //     allBonusPoints = fetchedData.map((item) => {
      //       'id': item['id'],
      //       'employee_name': item['employee_name'],
      //       'bonus_points': item['bonus_points'],
      //       'based_on': item['based_on'],
      //       'position': item['position'],
      //       'date': DateTime.parse(item['date']), // Parse ISO 8601 string
      //       'isArchived': item['isArchived'],
      //     }).toList();
      //     _applyFilters(); // Re-apply filters after data refresh
      //   });
      // } else {
      //   print('Failed to fetch bonus points: ${response.statusCode}');
      //   // Optionally show a user-friendly message
      // }
    } catch (e) {
      print('Error fetching bonus points: $e');
      // Optionally show a user-friendly message
    }
  }
  */

  // Example function to add a bonus point to a REST API
  /*
  Future<void> _addBonusPointToApi(Map<String, dynamic> pointData) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/bonus_points/');
    try {
      // final response = await http.post(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     ...pointData,
      //     'date': pointData['date'].toIso8601String(), // Convert DateTime to ISO 8601 string
      //   }),
      // );
      // if (response.statusCode == 201) { // 201 Created
      //   print('Bonus point added successfully to API');
      //   // Optionally, re-fetch bonus points to update UI
      //   // _fetchBonusPointsFromApi();
      // } else {
      //   print('Failed to add bonus point: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error adding bonus point: $e');
    }
  }
  */

  // Example function to update a bonus point on a REST API
  /*
  Future<void> _updateBonusPointOnApi(String pointId, Map<String, dynamic> pointData) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/bonus_points/$pointId/'); // Assuming ID in URL
    try {
      // final response = await http.put( // Or PATCH for partial updates
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     ...pointData,
      //     'date': pointData['date'].toIso8601String(),
      //   }),
      // );
      // if (response.statusCode == 200) {
      //   print('Bonus point updated successfully on API');
      //   // Optionally, re-fetch bonus points to update UI
      //   // _fetchBonusPointsFromApi();
      // } else {
      //   print('Failed to update bonus point: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error updating bonus point: $e');
    }
  }
  */

  // Example function to delete a bonus point from a REST API
  /*
  Future<void> _deleteBonusPointFromApi(String pointId) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/bonus_points/$pointId/');
    try {
      // final response = await http.delete(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //   },
      // );
      // if (response.statusCode == 204) { // 204 No Content for successful deletion
      //   print('Bonus point deleted successfully from API');
      //   // Optionally, re-fetch bonus points to update UI
      //   // _fetchBonusPointsFromApi();
      // } else {
      //   print('Failed to delete bonus point: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error deleting bonus point: $e');
    }
  }
  */

  void _searchBonusPoints(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredBonusPoints = allBonusPoints.where((point) {
        final matchesEmployee = point['employee_name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        bool matchesFilter = true;
        if (filter['position'] != null && filter['position'] != '') {
          matchesFilter = matchesFilter &&
              point['position'].toString().toLowerCase() ==
                  filter['position'].toString().toLowerCase();
        }
        if (filter['date'] != null && filter['date'] != '') {
          matchesFilter = matchesFilter &&
              DateFormat('yyyy-MM-dd').format(point['date']) == filter['date'];
        }
        if (filter['isArchived'] == 'true') {
          matchesFilter = matchesFilter && point['isArchived'] == true;
        } else if (filter['isArchived'] == 'false' || filter['isArchived'] == null || filter['isArchived'] == 'Unknown') {
          matchesFilter = matchesFilter && point['isArchived'] == false;
        }
        return matchesEmployee && matchesFilter;
      }).toList();
    });
  }

  void _showFilterDialog() {
    String position = filter['position'] ?? '';
    String date = filter['date'] ?? '';
    String isArchived = filter['isArchived'] ?? 'Unknown';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Bonus Points'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Position', position, (val) => position = val),
                _buildTextField('Date (yyyy-MM-dd)', date, (val) => date = val),
                DropdownButtonFormField<String>(
                  value: isArchived,
                  items: ['Unknown', 'true', 'false']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (val) => isArchived = val ?? 'Unknown',
                  decoration: const InputDecoration(labelText: 'Is Archived'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filter = {
                    'position': position,
                    'date': date,
                    'isArchived': isArchived,
                  };
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: const Text('Filter'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  filter = {};
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, String initial, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
      ),
    );
  }

  void _showCreateOrEditDialog({Map<String, dynamic>? point, int? editIndex}) {
    final employeeController = TextEditingController(text: point?['employee_name'] ?? '');
    final pointsController = TextEditingController(text: point?['bonus_points']?.toString() ?? '');
    final basedOnController = TextEditingController(text: point?['based_on'] ?? '');
    final positionController = TextEditingController(text: point?['position'] ?? '');
    DateTime selectedDate = point?['date'] ?? DateTime.now();
    bool isArchived = point?['isArchived'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          return AlertDialog(
            title: Text(editIndex == null ? 'Create Bonus Point' : 'Edit Bonus Point'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: employeeController,
                    decoration: const InputDecoration(labelText: 'Employee Name'),
                  ),
                  TextField(
                    controller: pointsController,
                    decoration: const InputDecoration(labelText: 'Bonus Points'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: basedOnController,
                    decoration: const InputDecoration(labelText: 'Based On'),
                  ),
                  TextField(
                    controller: positionController,
                    decoration: const InputDecoration(labelText: 'Position'),
                  ),
                  Row(
                    children: [
                      const Text('Date:'),
                      const SizedBox(width: 8),
                      Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setLocalState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Is Archived:'),
                      Checkbox(
                        value: isArchived,
                        onChanged: (val) => setLocalState(() => isArchived = val ?? false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newPoint = {
                    // 'id': editIndex == null ? null : point?['id'], // Include ID for updates
                    'employee_name': employeeController.text,
                    'bonus_points': int.tryParse(pointsController.text) ?? 0,
                    'based_on': basedOnController.text,
                    'position': positionController.text,
                    'date': selectedDate,
                    'isArchived': isArchived,
                  };
                  setState(() {
                    if (editIndex == null) {
                      allBonusPoints.add(newPoint);
                      // Example: Add to API
                      // _addBonusPointToApi(newPoint);
                    } else {
                      // Example: Update on API
                      // _updateBonusPointOnApi(point!['id'], newPoint);
                      allBonusPoints[editIndex] = newPoint;
                    }
                    _applyFilters();
                  });
                  Navigator.pop(context);
                },
                child: Text(editIndex == null ? 'Create' : 'Save'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    
    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, text: 'Bonus Points Report'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Employee', 'Points', 'Based On', 'Position', 'Date'],
                data: filteredBonusPoints.map((point) {
                  return [
                    point['employee_name'],
                    point['bonus_points'].toString(),
                    point['based_on'],
                    point['position'],
                    DateFormat('yyyy-MM-dd').format(point['date']),
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF and prompt the user to save it
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonus Points'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar: Search, Filter, Create, Download
            Container(
              color: kMaroon.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  // Search
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search, color: kMaroon),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: kMaroon),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: kMaroon, width: 2),
                        ),
                      ),
                      onChanged: _searchBonusPoints,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Filter
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: kMaroon),
                    onPressed: _showFilterDialog,
                    tooltip: 'Filter',
                  ),
                  const SizedBox(width: 8),
                  // Download PDF
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf, color: kMaroon),
                    onPressed: _generatePdf,
                    tooltip: 'Download PDF',
                  ),
                  const SizedBox(width: 8),
                  // Create
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMaroon,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showCreateOrEditDialog(),
                  ),
                ],
              ),
            ),
            const Divider(height: 18, thickness: 1),
            // Bonus Points List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredBonusPoints.length,
              itemBuilder: (context, idx) {
                final point = filteredBonusPoints[idx];
                final isExpanded = expandedIndices.contains(idx);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(point['employee_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${point['bonus_points']} points'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(DateFormat('MMM d').format(point['date'])),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                              color: kMaroon,
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedIndices.remove(idx);
                            } else {
                              expandedIndices.add(idx);
                            }
                          });
                        },
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailRow('Employee', point['employee_name']),
                              _detailRow('Bonus Points', point['bonus_points'].toString()),
                              _detailRow('Based On', point['based_on']),
                              _detailRow('Position', point['position']),
                              _detailRow('Date', DateFormat('yyyy-MM-dd').format(point['date'])),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: kMaroon),
                                    onPressed: () => _showCreateOrEditDialog(point: point, editIndex: allBonusPoints.indexOf(point)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        // Example: Delete from API
                                        // _deleteBonusPointFromApi(point['id']);
                                        allBonusPoints.removeAt(allBonusPoints.indexOf(point));
                                        _applyFilters();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.archive, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        point['isArchived'] = true;
                                        // Example: Archive on API (update isArchived status)
                                        // _updateBonusPointOnApi(point['id'], {'isArchived': true});
                                        _applyFilters();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}