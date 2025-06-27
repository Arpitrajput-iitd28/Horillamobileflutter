import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import necessary packages for API operations.
// You would need to add 'http' to your pubspec.yaml:
// dependencies:
//   http: ^0.13.3 // Or the latest compatible version
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For encoding/decoding JSON

const Color kMaroon = Color(0xFF800000);

class Meetings extends StatefulWidget {
  const Meetings({Key? key}) : super(key: key);

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  List<Map<String, dynamic>> allMeetings = [
    {
      'id': 'm001', // Example ID for API interaction
      'title': 'Q2 Planning',
      'manager': 'Adam',
      'employee': 'John',
      'dateTime': DateTime(2025, 6, 19, 10, 30),
      'minutes': 60,
      'comments': 'Discussed quarterly targets.',
      'isArchived': false,
    },
    {
      'id': 'm002', // Example ID for API interaction
      'title': 'Client Review',
      'manager': 'Eve',
      'employee': 'Alice',
      'dateTime': DateTime(2025, 6, 20, 14, 0),
      'minutes': 30,
      'comments': 'Feedback on deliverables.',
      'isArchived': false,
    },
  ];

  List<Map<String, dynamic>> filteredMeetings = [];
  String searchQuery = '';
  Map<String, dynamic> filter = {};
  Set<int> expandedIndices = {};

  @override
  void initState() {
    super.initState();
    // Uncomment this for API integration:
    // _fetchMeetingsFromApi();
    filteredMeetings = List.from(allMeetings);
  }

  // Example function to fetch meetings from a REST API
  /*
  Future<void> _fetchMeetingsFromApi() async {
    // final serverAddress = 'YOUR_API_BASE_URL'; // Replace with your server URL
    // final url = Uri.parse('$serverAddress/api/meetings/');
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
      //       'id': 'api_m001',
      //       'title': 'API Fetched Meeting 1',
      //       'manager': 'API Manager',
      //       'employee': 'API Employee',
      //       'dateTime': '2025-07-01T09:00:00Z', // ISO 8601 string
      //       'minutes': 45,
      //       'comments': 'Fetched from API.',
      //       'isArchived': false,
      //     },
      //     {
      //       'id': 'api_m002',
      //       'title': 'API Fetched Meeting 2',
      //       'manager': 'Another API Manager',
      //       'employee': 'Another API Employee',
      //       'dateTime': '2025-07-02T11:30:00Z',
      //       'minutes': 60,
      //       'comments': 'Another meeting from API.',
      //       'isArchived': false,
      //     },
      //   ]),
      //   200,
      // );


      // if (response.statusCode == 200) {
      //   final List<dynamic> fetchedData = json.decode(response.body);
      //   setState(() {
      //     allMeetings = fetchedData.map((item) => {
      //       'id': item['id'],
      //       'title': item['title'],
      //       'manager': item['manager'],
      //       'employee': item['employee'],
      //       'dateTime': DateTime.parse(item['dateTime']), // Parse ISO 8601 string
      //       'minutes': item['minutes'],
      //       'comments': item['comments'],
      //       'isArchived': item['isArchived'],
      //     }).toList();
      //     _applyFilters(); // Re-apply filters after data refresh
      //   });
      // } else {
      //   print('Failed to fetch meetings: ${response.statusCode}');
      //   // Optionally show a user-friendly message
      // }
    } catch (e) {
      print('Error fetching meetings: $e');
      // Optionally show a user-friendly message
    }
  }
  */

  // Example function to add a meeting to a REST API
  /*
  Future<void> _addMeetingToApi(Map<String, dynamic> meetingData) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/meetings/');
    try {
      // final response = await http.post(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     ...meetingData,
      //     'dateTime': meetingData['dateTime'].toIso8601String(), // Convert DateTime to ISO 8601 string
      //   }),
      // );
      // if (response.statusCode == 201) { // 201 Created
      //   print('Meeting added successfully to API');
      //   // Optionally, re-fetch meetings to update UI
      //   // _fetchMeetingsFromApi();
      // } else {
      //   print('Failed to add meeting: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error adding meeting: $e');
    }
  }
  */

  // Example function to update a meeting on a REST API
  /*
  Future<void> _updateMeetingOnApi(String meetingId, Map<String, dynamic> meetingData) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/meetings/$meetingId/'); // Assuming ID in URL
    try {
      // final response = await http.put( // Or PATCH for partial updates
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     ...meetingData,
      //     'dateTime': meetingData['dateTime'].toIso8601String(),
      //   }),
      // );
      // if (response.statusCode == 200) {
      //   print('Meeting updated successfully on API');
      //   // Optionally, re-fetch meetings to update UI
      //   // _fetchMeetingsFromApi();
      // } else {
      //   print('Failed to update meeting: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error updating meeting: $e');
    }
  }
  */

  // Example function to delete a meeting from a REST API
  /*
  Future<void> _deleteMeetingFromApi(String meetingId) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/meetings/$meetingId/');
    try {
      // final response = await http.delete(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //   },
      // );
      // if (response.statusCode == 204) { // 204 No Content for successful deletion
      //   print('Meeting deleted successfully from API');
      //   // Optionally, re-fetch meetings to update UI
      //   // _fetchMeetingsFromApi();
      // } else {
      //   print('Failed to delete meeting: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error deleting meeting: $e');
    }
  }
  */


  void _searchMeetings(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredMeetings = allMeetings.where((meeting) {
        final matchesTitle = meeting['title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        bool matchesFilter = true;
        if (filter['manager'] != null && filter['manager'] != '') {
          matchesFilter = matchesFilter &&
              meeting['manager'].toString().toLowerCase() ==
                  filter['manager'].toString().toLowerCase();
        }
        if (filter['employee'] != null && filter['employee'] != '') {
          matchesFilter = matchesFilter &&
              meeting['employee'].toString().toLowerCase() ==
                  filter['employee'].toString().toLowerCase();
        }
        if (filter['date'] != null && filter['date'] != '') {
          matchesFilter = matchesFilter &&
              DateFormat('yyyy-MM-dd').format(meeting['dateTime']) == filter['date'];
        }
        if (filter['isArchived'] == 'true') {
          matchesFilter = matchesFilter && meeting['isArchived'] == true;
        } else if (filter['isArchived'] == 'false' || filter['isArchived'] == null || filter['isArchived'] == 'Unknown') {
          matchesFilter = matchesFilter && meeting['isArchived'] == false;
        }
        return matchesTitle && matchesFilter;
      }).toList();
    });
  }

  void _showFilterDialog() {
    String manager = filter['manager'] ?? '';
    String employee = filter['employee'] ?? '';
    String date = filter['date'] ?? '';
    String isArchived = filter['isArchived'] ?? 'Unknown';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Meetings'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Manager', manager, (val) => manager = val),
                _buildTextField('Employee', employee, (val) => employee = val),
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
                    'manager': manager,
                    'employee': employee,
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

  void _showCreateOrEditDialog({Map<String, dynamic>? meeting, int? editIndex}) {
    final titleController = TextEditingController(text: meeting?['title'] ?? '');
    final managerController = TextEditingController(text: meeting?['manager'] ?? '');
    final employeeController = TextEditingController(text: meeting?['employee'] ?? '');
    DateTime selectedDateTime = meeting?['dateTime'] ?? DateTime.now();
    int minutes = meeting?['minutes'] ?? 15;
    final commentsController = TextEditingController(text: meeting?['comments'] ?? '');
    bool isArchived = meeting?['isArchived'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          return AlertDialog(
            title: Text(editIndex == null ? 'Create Meeting' : 'Edit Meeting'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: managerController,
                    decoration: const InputDecoration(labelText: 'Manager'),
                  ),
                  TextField(
                    controller: employeeController,
                    decoration: const InputDecoration(labelText: 'Employee'),
                  ),
                  Row(
                    children: [
                      const Text('Date & Time:'),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                            );
                            if (pickedTime != null) {
                              setLocalState(() {
                                selectedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Minutes:'),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: minutes,
                        items: List.generate(16, (i) => (i + 1) * 15)
                            .map((val) => DropdownMenuItem(
                                  value: val,
                                  child: Text('$val mins'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setLocalState(() {
                            minutes = val ?? 15;
                          });
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: commentsController,
                    decoration: const InputDecoration(labelText: 'Comments'),
                    maxLines: 2,
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
                  final newMeeting = {
                    // 'id': editIndex == null ? null : meeting?['id'], // Include ID for updates
                    'title': titleController.text,
                    'manager': managerController.text,
                    'employee': employeeController.text,
                    'dateTime': selectedDateTime,
                    'minutes': minutes,
                    'comments': commentsController.text,
                    'isArchived': isArchived,
                  };
                  setState(() {
                    if (editIndex == null) {
                      allMeetings.add(newMeeting);
                      // Example: Add to API
                      // _addMeetingToApi(newMeeting);
                    } else {
                      // Example: Update on API
                      // _updateMeetingOnApi(meeting!['id'], newMeeting);
                      allMeetings[editIndex] = newMeeting;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar: Search, Filter, Create
            Container(
              color: kMaroon.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
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
                      onChanged: _searchMeetings,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: kMaroon),
                    onPressed: _showFilterDialog,
                    tooltip: 'Filter',
                  ),
                  const SizedBox(width: 8),
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
            // Meetings List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMeetings.length,
              itemBuilder: (context, idx) {
                final meeting = filteredMeetings[idx];
                final isExpanded = expandedIndices.contains(idx);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(meeting['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(meeting['dateTime'])),
                        trailing: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                          color: kMaroon,
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
                              _detailRow('Title', meeting['title']),
                              _detailRow('Manager', meeting['manager']),
                              _detailRow('Employee', meeting['employee']),
                              _detailRow('Date & Time', DateFormat('yyyy-MM-dd – kk:mm').format(meeting['dateTime'])),
                              Row(
                                children: [
                                  const Text('Minutes of Meeting: ', style: TextStyle(fontWeight: FontWeight.w600)),
                                  DropdownButton<int>(
                                    value: meeting['minutes'],
                                    items: List.generate(16, (i) => (i + 1) * 15)
                                        .map((val) => DropdownMenuItem(
                                              value: val,
                                              child: Text('$val mins'),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        meeting['minutes'] = val ?? 15;
                                        // Example: Update minutes on API
                                        // _updateMeetingOnApi(meeting['id'], {'minutes': val ?? 15});
                                      });
                                    },
                                  ),
                                ],
                              ),
                              _detailRow('Comments', meeting['comments']),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: kMaroon),
                                    onPressed: () => _showCreateOrEditDialog(meeting: meeting, editIndex: allMeetings.indexOf(meeting)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        // Example: Delete from API
                                        // _deleteMeetingFromApi(meeting['id']);
                                        allMeetings.removeAt(allMeetings.indexOf(meeting));
                                        _applyFilters();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.archive, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        meeting['isArchived'] = true;
                                        // Example: Archive on API (update isArchived status)
                                        // _updateMeetingOnApi(meeting['id'], {'isArchived': true});
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