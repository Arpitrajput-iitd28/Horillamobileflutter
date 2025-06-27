import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import necessary packages for API operations.
// You would need to add 'http' to your pubspec.yaml:
// dependencies:
//   http: ^0.13.3 // Or the latest compatible version
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For encoding/decoding JSON

const Color kMaroon = Color(0xFF800000);
const Color kGreenCompleted = Color.fromARGB(255, 34, 139, 34); // A nice green for completion

class PerformanceObjectives extends StatefulWidget {
  const PerformanceObjectives({Key? key}) : super(key: key);

  @override
  State<PerformanceObjectives> createState() => _PerformanceObjectivesState();
}

class _PerformanceObjectivesState extends State<PerformanceObjectives> {
  List<Map<String, dynamic>> allObjectives = [
    {
      'id': 'obj001', // Added ID for API interaction
      'title': 'Operation Efficiency',
      'manager': 'Adam',
      'managerProgressHistory': [
        {'date': DateTime(2024, 1, 1, 10, 0), 'progress': 20},
        {'date': DateTime(2024, 2, 1, 10, 0), 'progress': 40},
        {'date': DateTime(2024, 3, 1, 10, 0), 'progress': 60},
      ],
      'keyResult': '1 Key result',
      'duration': '3',
      'description': 'Increase it by 20%',
      'assignees': [
        {
          'id': 'assignee001', // Added ID for API interaction
          'name': 'John',
          'progressHistory': [
            {'date': DateTime(2024, 1, 15, 9, 0), 'progress': 10},
            {'date': DateTime(2024, 2, 15, 9, 0), 'progress': 30},
            {'date': DateTime(2024, 3, 15, 9, 0), 'progress': 50},
          ]
        },
        {
          'id': 'assignee002', // Added ID for API interaction
          'name': 'Jane',
          'progressHistory': [
            {'date': DateTime(2024, 1, 10, 11, 0), 'progress': 80},
          ]
        }
      ],
    },
    {
      'id': 'obj002', // Added ID for API interaction
      'title': 'Customer Satisfaction',
      'manager': 'Eve',
      'managerProgressHistory': [
        {'date': DateTime(2024, 1, 1, 10, 0), 'progress': 40},
        {'date': DateTime(2024, 4, 1, 10, 0), 'progress': 100}, // Example for 100% completion
      ],
      'keyResult': '0 Key results',
      'duration': '1',
      'description': 'Measure client satisfaction',
      'assignees': [
        {
          'id': 'assignee003', // Added ID for API interaction
          'name': 'Alice',
          'progressHistory': [
            {'date': DateTime(2024, 1, 15, 9, 0), 'progress': 70},
            {'date': DateTime(2024, 4, 1, 10, 0), 'progress': 100}, // Example for 100% completion
          ]
        }
      ],
    },
     {
      'id': 'obj003', // Another example
      'title': 'Product Launch',
      'manager': 'Bob',
      'managerProgressHistory': [
        {'date': DateTime(2024, 5, 1, 9, 0), 'progress': 20},
      ],
      'keyResult': 'Launch new feature',
      'duration': '2',
      'description': 'Release new product version by Q3',
      'assignees': [
        {
          'id': 'assignee004',
          'name': 'Charlie',
          'progressHistory': [
            {'date': DateTime(2024, 5, 5, 10, 0), 'progress': 15},
          ]
        },
        {
          'id': 'assignee005',
          'name': 'Diana',
          'progressHistory': [
            {'date': DateTime(2024, 5, 10, 11, 0), 'progress': 25},
          ]
        }
      ],
    },
  ];

  List<Map<String, dynamic>> filteredObjectives = [];
  String searchQuery = '';
  bool showSelfObjectives = true; // Assuming a 'self' filter based on current user
  Map<String, dynamic> filter = {};
  Set<String> expandedObjectiveIds = {}; // Using Objective ID for expansion

  @override
  void initState() {
    super.initState();
    // Uncomment this for API integration:
    // _fetchObjectivesFromApi();
    _applyFilters();
  }

  // Example function to fetch objectives from a REST API
  /*
  Future<void> _fetchObjectivesFromApi() async {
    // final serverAddress = 'YOUR_API_BASE_URL'; // Replace with your server URL
    // final url = Uri.parse('$serverAddress/api/objectives/');
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
      //       'id': 'api_obj001',
      //       'title': 'API Efficiency',
      //       'manager': 'API Manager',
      //       'managerProgressHistory': [
      //         {'date': '2024-04-01T10:00:00Z', 'progress': 25},
      //         {'date': '2024-05-01T10:00:00Z', 'progress': 50},
      //       ],
      //       'keyResult': 'API Key Result',
      //       'duration': '4',
      //       'description': 'API Description',
      //       'assignees': [
      //         {
      //           'id': 'api_assignee001',
      //           'name': 'API User 1',
      //           'progressHistory': [
      //             {'date': '2024-04-15T09:00:00Z', 'progress': 15},
      //           ]
      //         }
      //       ],
      //     },
      //   ]),
      //   200,
      // );

      // if (response.statusCode == 200) {
      //   final List<dynamic> fetchedData = json.decode(response.body);
      //   setState(() {
      //     allObjectives = fetchedData.map((item) {
      //       // Convert date strings to DateTime objects
      //       List<Map<String, dynamic>> managerHistory = (item['managerProgressHistory'] as List)
      //           .map((entry) => {'date': DateTime.parse(entry['date']), 'progress': entry['progress']})
      //           .toList();
      //       List<Map<String, dynamic>> assignees = (item['assignees'] as List)
      //           .map((assignee) => {
      //                 'id': assignee['id'],
      //                 'name': assignee['name'],
      //                 'progressHistory': (assignee['progressHistory'] as List)
      //                     .map((entry) => {'date': DateTime.parse(entry['date']), 'progress': entry['progress']})
      //                     .toList(),
      //               })
      //           .toList();

      //       return {
      //         'id': item['id'],
      //         'title': item['title'],
      //         'manager': item['manager'],
      //         'managerProgressHistory': managerHistory,
      //         'keyResult': item['keyResult'],
      //         'duration': item['duration'],
      //         'description': item['description'],
      //         'assignees': assignees,
      //       };
      //     }).toList();
      //     _applyFilters(); // Re-apply filters after data refresh
      //   });
      // } else {
      //   print('Failed to fetch objectives: ${response.statusCode}');
      //   // Optionally show a user-friendly message
      // }
    } catch (e) {
      print('Error fetching objectives: $e');
      // Optionally show a user-friendly message
    }
  }
  */

  // Example function to add an objective to a REST API
  /*
  Future<void> _addObjectiveToApi(Map<String, dynamic> objectiveData) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/objectives/');
    try {
      // Convert DateTime objects to ISO 8601 strings for API
      final Map<String, dynamic> dataToSend = {
        ...objectiveData,
        'managerProgressHistory': (objectiveData['managerProgressHistory'] as List)
            .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
            .toList(),
        'assignees': (objectiveData['assignees'] as List)
            .map((assignee) => {
                  'id': assignee['id'],
                  'name': assignee['name'],
                  'progressHistory': (assignee['progressHistory'] as List)
                      .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
                      .toList(),
                })
            .toList(),
      };

      // final response = await http.post(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode(dataToSend),
      // );
      // if (response.statusCode == 201) { // 201 Created
      //   print('Objective added successfully to API');
      //   // Optionally, re-fetch objectives to update UI
      //   // _fetchObjectivesFromApi();
      // } else {
      //   print('Failed to add objective: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error adding objective: $e');
    }
  }
  */

  // Example function to update an objective on a REST API
  /*
  Future<void> _updateObjectiveOnApi(String objectiveId, Map<String, dynamic> objectiveData) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/objectives/$objectiveId/'); // Assuming ID in URL
    try {
      // Convert DateTime objects to ISO 8601 strings for API
      final Map<String, dynamic> dataToSend = {
        ...objectiveData,
        'managerProgressHistory': (objectiveData['managerProgressHistory'] as List)
            .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
            .toList(),
        'assignees': (objectiveData['assignees'] as List)
            .map((assignee) => {
                  'id': assignee['id'],
                  'name': assignee['name'],
                  'progressHistory': (assignee['progressHistory'] as List)
                      .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
                      .toList(),
                })
            .toList(),
      };

      // final response = await http.put( // Or PATCH for partial updates
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode(dataToSend),
      // );
      // if (response.statusCode == 200) {
      //   print('Objective updated successfully on API');
      //   // Optionally, re-fetch objectives to update UI
      //   // _fetchObjectivesFromApi();
      // } else {
      //   print('Failed to update objective: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error updating objective: $e');
    }
  }
  */

  // Example function to delete an objective from a REST API
  /*
  Future<void> _deleteObjectiveFromApi(String objectiveId) async {
    // final serverAddress = 'YOUR_API_BASE_URL';
    // final url = Uri.parse('$serverAddress/api/objectives/$objectiveId/');
    try {
      // final response = await http.delete(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer YOUR_TOKEN',
      //   },
      // );
      // if (response.statusCode == 204) { // 204 No Content for successful deletion
      //   print('Objective deleted successfully from API');
      //   // Optionally, re-fetch objectives to update UI
      //   // _fetchObjectivesFromApi();
      // } else {
      //   print('Failed to delete objective: ${response.statusCode}');
      // }
    } catch (e) {
      print('Error deleting objective: $e');
    }
  }
  */

  void _searchObjectives(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredObjectives = allObjectives.where((obj) {
        final matchesTitle = obj['title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        bool matchesFilter = true;
        if (filter['manager'] != null && filter['manager'] != '') {
          matchesFilter = matchesFilter &&
              obj['manager'].toString().toLowerCase() ==
                  filter['manager'].toString().toLowerCase();
        }
        if (filter['assignee'] != null && filter['assignee'] != '') {
          matchesFilter = matchesFilter &&
              (obj['assignees'] as List)
                  .any((e) => e['name'].toString().toLowerCase() == filter['assignee'].toString().toLowerCase());
        }
        if (filter['keyResult'] != null && filter['keyResult'] != '') {
          matchesFilter = matchesFilter &&
              obj['keyResult']
                  .toString()
                  .toLowerCase()
                  .contains(filter['keyResult'].toString().toLowerCase());
        }
        if (filter['duration'] != null && filter['duration'] != '') {
          matchesFilter = matchesFilter &&
              obj['duration'].toString() == filter['duration'].toString();
        }
        return matchesTitle && matchesFilter;
      }).toList();
    });
  }

  void _showFilterDialog() {
    String manager = filter['manager'] ?? '';
    String assignee = filter['assignee'] ?? '';
    String keyResult = filter['keyResult'] ?? '';
    String duration = filter['duration'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Objectives'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Manager', manager, (val) => manager = val),
                _buildTextField('Assignee', assignee, (val) => assignee = val),
                _buildTextField('Key Result', keyResult, (val) => keyResult = val),
                _buildTextField('Duration', duration, (val) => duration = val),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filter = {
                    'manager': manager,
                    'assignee': assignee,
                    'keyResult': keyResult,
                    'duration': duration,
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

  // Helper to calculate total progress
  double _calculateTotalProgress(Map<String, dynamic> objective) {
    double totalProgressSum = 0;
    int participantsCount = 0;

    // Manager's progress
    if (objective['managerProgressHistory'] != null && (objective['managerProgressHistory'] as List).isNotEmpty) {
      totalProgressSum += (objective['managerProgressHistory'].last['progress'] as int).toDouble();
      participantsCount++;
    }

    // Assignees' progress
    if (objective['assignees'] != null && (objective['assignees'] as List).isNotEmpty) {
      for (var assignee in (objective['assignees'] as List)) {
        if (assignee['progressHistory'] != null && (assignee['progressHistory'] as List).isNotEmpty) {
          totalProgressSum += (assignee['progressHistory'].last['progress'] as int).toDouble();
          participantsCount++;
        }
      }
    }

    if (participantsCount == 0) {
      return 0.0;
    }
    return (totalProgressSum / participantsCount).roundToDouble();
  }

  // Progress edit dialog for manager/assignee
  Future<void> _editProgressDialog({
    required String name,
    required List<Map<String, dynamic>> progressHistory,
    required Function() onSavedCallback, // Changed to a simple callback
  }) async {
    // Ensure we are working with a *copy* of the progress history for local updates
    List<Map<String, dynamic>> localProgressHistory = List.from(progressHistory);
    int currentProgress = localProgressHistory.isNotEmpty ? localProgressHistory.last['progress'] : 0;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text('Edit Progress for $name'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: currentProgress.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 100,
                            activeColor: Colors.red,
                            inactiveColor: Colors.grey,
                            label: '$currentProgress%',
                            onChanged: (val) {
                              setLocalState(() {
                                currentProgress = val.round();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('$currentProgress%')
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        children: localProgressHistory.reversed.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              '${DateFormat('yyyy-MM-dd HH:mm').format(entry['date'])}: ${entry['progress']}%',
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Only add if progress has actually changed or if it's the first entry
                    if (localProgressHistory.isEmpty || localProgressHistory.last['progress'] != currentProgress) {
                      localProgressHistory.add({
                        'date': DateTime.now(),
                        'progress': currentProgress,
                      });
                    }

                    // Update the original list via reference
                    // This is where we ensure the original list passed to the dialog is updated
                    // We clear the original and add elements from the local copy
                    progressHistory.clear();
                    progressHistory.addAll(localProgressHistory);

                    onSavedCallback(); // Trigger a setState in the parent
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _progressHistoryList(List<Map<String, dynamic>> history) {
    return SizedBox(
      height: 80,
      child: ListView(
        children: history.reversed.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              '${DateFormat('yyyy-MM-dd HH:mm').format(entry['date'])}: ${entry['progress']}%',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          );
        }).toList(),
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

  void _showCreateOrEditDialog({Map<String, dynamic>? objective, int? editIndex}) {
    final titleController = TextEditingController(text: objective?['title'] ?? '');
    final managerController = TextEditingController(text: objective?['manager'] ?? '');
    final keyResultController = TextEditingController(text: objective?['keyResult'] ?? '');
    final durationController = TextEditingController(text: objective?['duration'] ?? '');
    final descriptionController = TextEditingController(text: objective?['description'] ?? '');

    // Deep copy of assignees and managerProgressHistory to avoid direct modification
    List<Map<String, dynamic>> tempAssignees = objective?['assignees'] != null
        ? (objective!['assignees'] as List).map((a) => Map<String, dynamic>.from(a)).toList()
        : [];
    List<Map<String, dynamic>> tempManagerProgressHistory =
        objective?['managerProgressHistory'] != null
            ? (objective!['managerProgressHistory'] as List).map((h) => Map<String, dynamic>.from(h)).toList()
            : []; // Initialize empty if no history

    // If creating a new objective, ensure manager has a starting progress entry
    if (editIndex == null && tempManagerProgressHistory.isEmpty) {
      tempManagerProgressHistory.add({
        'date': DateTime.now(),
        'progress': 0,
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        // Use a local variable to hold manager's current progress in the dialog
        // This is crucial for the slider to work inside StatefulBuilder
        int dialogManagerCurrentProgress = tempManagerProgressHistory.isNotEmpty
            ? tempManagerProgressHistory.last['progress']
            : 0;

        return AlertDialog( // Changed to AlertDialog
          title: Text(editIndex == null ? 'Create Objective' : 'Edit Objective'),
          content: StatefulBuilder( // StatefulBuilder for content to allow local state changes
            builder: (BuildContext context, StateSetter setLocalState) {
              return SingleChildScrollView(
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
                    Row(
                      children: [
                        const Text('Manager Progress:'),
                        Expanded(
                          child: Slider(
                            value: dialogManagerCurrentProgress.toDouble(), // Use dialog's local state
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: '$dialogManagerCurrentProgress%',
                            onChanged: (val) {
                              setLocalState(() {
                                dialogManagerCurrentProgress = val.round(); // Update local state
                              });
                            },
                          ),
                        ),
                        Text('$dialogManagerCurrentProgress%')
                      ],
                    ),
                    TextField(
                      controller: keyResultController,
                      decoration: const InputDecoration(labelText: 'Key Result'),
                    ),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(labelText: 'Duration (in months)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Assignees:', style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setLocalState(() {
                              tempAssignees.add({
                                'id': UniqueKey().toString(), // Generate a unique ID for new assignees
                                'name': '',
                                'progressHistory': [
                                  {'date': DateTime.now(), 'progress': 0}
                                ]
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    ...tempAssignees.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var assignee = entry.value;
                      // Use a local variable for assignee's current progress in the dialog
                      int assigneeCurrentProgress = (assignee['progressHistory'] as List).isNotEmpty
                          ? assignee['progressHistory'].last['progress']
                          : 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Assignee ${idx + 1} Name'),
                              controller: TextEditingController(text: assignee['name']),
                              onChanged: (val) {
                                assignee['name'] = val; // Update the assignee map directly
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: assigneeCurrentProgress.toDouble(),
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    label: '$assigneeCurrentProgress%',
                                    onChanged: (val) {
                                      setLocalState(() {
                                        assigneeCurrentProgress = val.round();
                                        // Ensure progress history is updated with new value
                                        if (assignee['progressHistory'].isEmpty ||
                                            assignee['progressHistory'].last['progress'] != assigneeCurrentProgress) {
                                          assignee['progressHistory'].add({
                                            'date': DateTime.now(),
                                            'progress': assigneeCurrentProgress,
                                          });
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Text('$assigneeCurrentProgress%'),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setLocalState(() => tempAssignees.removeAt(idx));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
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
                // Only add new progress entry if value has actually changed
                if (tempManagerProgressHistory.isEmpty || tempManagerProgressHistory.last['progress'] != dialogManagerCurrentProgress) {
                   tempManagerProgressHistory.add({
                     'date': DateTime.now(),
                     'progress': dialogManagerCurrentProgress,
                   });
                 }

                final newObjective = {
                  'id': objective?['id'] ?? UniqueKey().toString(), // Keep existing ID or generate new
                  'title': titleController.text,
                  'manager': managerController.text,
                  'managerProgressHistory': tempManagerProgressHistory, // Use the updated history
                  'keyResult': keyResultController.text,
                  'duration': durationController.text,
                  'description': descriptionController.text,
                  'assignees': tempAssignees.map((a) {
                    // Ensure assignees' progress histories are correctly updated from the dialog's local state
                    // The `onChanged` for assignee slider directly updates `assignee['progressHistory']`
                    // so we just pass the `tempAssignees` list.
                    return a;
                  }).toList(),
                };

                setState(() {
                  if (editIndex == null) {
                    allObjectives.add(newObjective);
                    // Example: Add to API
                    // _addObjectiveToApi(newObjective);
                  } else {
                    allObjectives[editIndex] = newObjective;
                    // Example: Update on API
                    // _updateObjectiveOnApi(newObjective['id'], newObjective);
                  }
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: Text(editIndex == null ? 'Create' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Objectives'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Horizontal bar: Search, Filter, Create
            Container(
              color: kMaroon.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  // Search
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by title',
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
                      onChanged: _searchObjectives,
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

            // Self/All Objective toggle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.white,
                fillColor: kMaroon,
                color: kMaroon,
                isSelected: [showSelfObjectives, !showSelfObjectives],
                onPressed: (index) {
                  setState(() {
                    showSelfObjectives = index == 0;
                    // You might want to re-apply filters based on this toggle
                    // _applyFilters();
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Self Objective'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('All Objective'),
                  ),
                ],
              ),
            ),

            // Objectives List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredObjectives.length,
              itemBuilder: (context, idx) {
                final obj = filteredObjectives[idx];
                final String objectiveId = obj['id']; // Use the ID for expansion
                final bool isExpanded = expandedObjectiveIds.contains(objectiveId);
                final double totalProgress = _calculateTotalProgress(obj);
                final bool isCompleted = totalProgress == 100.0;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(obj['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Manager: ${obj['manager']}'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text('Total Progress: ', style: TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  isCompleted ? 'Objective Completed' : '${totalProgress.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted ? kGreenCompleted : kMaroon,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                          color: kMaroon,
                        ),
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedObjectiveIds.remove(objectiveId);
                            } else {
                              expandedObjectiveIds.add(objectiveId);
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
                              _detailRow('Title', obj['title']),
                              _detailRow('Manager', obj['manager']),
                              const SizedBox(height: 8),
                              const Text('Assignees:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ...((obj['assignees'] as List).map((assignee) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        assignee['name'],
                                        style: const TextStyle(
                                          color: Colors.black, // No underline, not tappable
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${assignee['progressHistory'].isNotEmpty ? assignee['progressHistory'].last['progress'] : 0}%',
                                      ),
                                    ],
                                  ),
                                );
                              })).toList(), // Convert iterable to list
                              const SizedBox(height: 8),
                              const Text('Manager Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
                              _progressHistoryList(obj['managerProgressHistory']),
                              const SizedBox(height: 8),
                              const Text('Assignee Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ...((obj['assignees'] as List).map((assignee) =>
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${assignee['name']}:', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      _progressHistoryList(assignee['progressHistory']),
                                    ],
                                  ),
                                )).toList(), // Convert iterable to list
                              _detailRow('Key Result', obj['keyResult']),
                              _detailRow('Duration', '${obj['duration']} months'),
                              _detailRow('Description', obj['description']),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: kMaroon),
                                    onPressed: () => _showCreateOrEditDialog(objective: obj, editIndex: allObjectives.indexOf(obj)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        allObjectives.removeAt(allObjectives.indexOf(obj));
                                        _applyFilters();
                                        // Example: Delete from API
                                        // _deleteObjectiveFromApi(obj['id']);
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
}


// code with permission for self /all objective 


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// // Import necessary packages for API operations.
// // You would need to add 'http' to your pubspec.yaml:
// // dependencies:
// //   http: ^0.13.3 // Or the latest compatible version
// // import 'package:http/http.dart' as http;
// // import 'dart:convert'; // For encoding/decoding JSON

// const Color kMaroon = Color(0xFF800000);
// const Color kGreenCompleted = Color.fromARGB(255, 34, 139, 34); // A nice green for completion

// class PerformanceObjectives extends StatefulWidget {
//   const PerformanceObjectives({Key? key}) : super(key: key);

//   @override
//   State<PerformanceObjectives> createState() => _PerformanceObjectivesState();
// }

// class _PerformanceObjectivesState extends State<PerformanceObjectives> {
//   // Simulating the current logged-in user and their role
//   String currentUserName = 'Adam'; // Change to 'Alice' to test HR role
//   String currentUserRole = 'admin'; // 'admin', 'hr', or 'employee'

//   List<Map<String, dynamic>> allObjectives = [
//     {
//       'id': 'obj001', // Added ID for API interaction
//       'title': 'Operation Efficiency',
//       'manager': 'Adam', // This objective is for 'Adam' (manager)
//       'managerProgressHistory': [
//         {'date': DateTime(2024, 1, 1, 10, 0), 'progress': 20},
//         {'date': DateTime(2024, 2, 1, 10, 0), 'progress': 40},
//         {'date': DateTime(2024, 3, 1, 10, 0), 'progress': 60},
//       ],
//       'keyResult': '1 Key result',
//       'duration': '3',
//       'description': 'Increase it by 20%',
//       'assignees': [
//         {
//           'id': 'assignee001', // Added ID for API interaction
//           'name': 'John',
//           'progressHistory': [
//             {'date': DateTime(2024, 1, 15, 9, 0), 'progress': 10},
//             {'date': DateTime(2024, 2, 15, 9, 0), 'progress': 30},
//             {'date': DateTime(2024, 3, 15, 9, 0), 'progress': 50},
//           ]
//         },
//         {
//           'id': 'assignee002', // Added ID for API interaction
//           'name': 'Jane',
//           'progressHistory': [
//             {'date': DateTime(2024, 1, 10, 11, 0), 'progress': 80},
//           ]
//         }
//       ],
//     },
//     {
//       'id': 'obj002', // Added ID for API interaction
//       'title': 'Customer Satisfaction',
//       'manager': 'Eve',
//       'managerProgressHistory': [
//         {'date': DateTime(2024, 1, 1, 10, 0), 'progress': 40},
//         {'date': DateTime(2024, 4, 1, 10, 0), 'progress': 100}, // Example for 100% completion
//       ],
//       'keyResult': '0 Key results',
//       'duration': '1',
//       'description': 'Measure client satisfaction',
//       'assignees': [
//         {
//           'id': 'assignee003', // Added ID for API interaction
//           'name': 'Alice', // Alice is an assignee here (useful for HR test)
//           'progressHistory': [
//             {'date': DateTime(2024, 1, 15, 9, 0), 'progress': 70},
//             {'date': DateTime(2024, 4, 1, 10, 0), 'progress': 100}, // Example for 100% completion
//           ]
//         }
//       ],
//     },
//      {
//       'id': 'obj003', // Another example
//       'title': 'Product Launch',
//       'manager': 'Bob',
//       'managerProgressHistory': [
//         {'date': DateTime(2024, 5, 1, 9, 0), 'progress': 20},
//       ],
//       'keyResult': 'Launch new feature',
//       'duration': '2',
//       'description': 'Release new product version by Q3',
//       'assignees': [
//         {
//           'id': 'assignee004',
//           'name': 'Charlie',
//           'progressHistory': [
//             {'date': DateTime(2024, 5, 5, 10, 0), 'progress': 15},
//           ]
//         },
//         {
//           'id': 'assignee005',
//           'name': 'Diana',
//           'progressHistory': [
//             {'date': DateTime(2024, 5, 10, 11, 0), 'progress': 25},
//           ]
//         }
//       ],
//     },
//   ];

//   List<Map<String, dynamic>> filteredObjectives = [];
//   String searchQuery = '';
//   Map<String, dynamic> filter = {};
//   Set<String> expandedObjectiveIds = {}; // Using Objective ID for expansion

//   @override
//   void initState() {
//     super.initState();
//     // Uncomment this for API integration:
//     // _fetchObjectivesFromApi();
//     _applyFilters();
//   }

//   // Example function to fetch objectives from a REST API
//   /*
//   Future<void> _fetchObjectivesFromApi() async {
//     // final serverAddress = 'YOUR_API_BASE_URL'; // Replace with your server URL
//     // final url = Uri.parse('$serverAddress/api/objectives/');
//     try {
//       // final response = await http.get(url, headers: {
//       //   'Authorization': 'Bearer YOUR_TOKEN', // Replace with actual token
//       //   'Content-Type': 'application/json',
//       // });

//       // // Simulate a network request and response for demonstration
//       // await Future.delayed(Duration(seconds: 1)); // Simulate network delay
//       // final response = http.Response(
//       //   json.encode([
//       //     {
//       //       'id': 'api_obj001',
//       //       'title': 'API Efficiency',
//       //       'manager': 'API Manager',
//       //       'managerProgressHistory': [
//       //         {'date': '2024-04-01T10:00:00Z', 'progress': 25},
//       //         {'date': '2024-05-01T10:00:00Z', 'progress': 50},
//       //       ],
//       //       'keyResult': 'API Key Result',
//       //       'duration': '4',
//       //       'description': 'API Description',
//       //       'assignees': [
//       //         {
//       //           'id': 'api_assignee001',
//       //           'name': 'API User 1',
//       //           'progressHistory': [
//       //             {'date': '2024-04-15T09:00:00Z', 'progress': 15},
//       //           ]
//       //         }
//       //       ],
//       //     },
//       //   ]),
//       //   200,
//       // );

//       // if (response.statusCode == 200) {
//       //   final List<dynamic> fetchedData = json.decode(response.body);
//       //   setState(() {
//       //     allObjectives = fetchedData.map((item) {
//       //       // Convert date strings to DateTime objects
//       //       List<Map<String, dynamic>> managerHistory = (item['managerProgressHistory'] as List)
//       //           .map((entry) => {'date': DateTime.parse(entry['date']), 'progress': entry['progress']})
//       //           .toList();
//       //       List<Map<String, dynamic>> assignees = (item['assignees'] as List)
//       //           .map((assignee) => {
//       //                 'id': assignee['id'],
//       //                 'name': assignee['name'],
//       //                 'progressHistory': (assignee['progressHistory'] as List)
//       //                     .map((entry) => {'date': DateTime.parse(entry['date']), 'progress': entry['progress']})
//       //                     .toList(),
//       //               })
//       //           .toList();

//       //       return {
//       //         'id': item['id'],
//       //         'title': item['title'],
//       //         'manager': item['manager'],
//       //         'managerProgressHistory': managerHistory,
//       //         'keyResult': item['keyResult'],
//       //         'duration': item['duration'],
//       //         'description': item['description'],
//       //         'assignees': assignees,
//       //       };
//       //     }).toList();
//       //     _applyFilters(); // Re-apply filters after data refresh
//       //   });
//       // } else {
//       //   print('Failed to fetch objectives: ${response.statusCode}');
//       //   // Optionally show a user-friendly message
//       // }
//     } catch (e) {
//       print('Error fetching objectives: $e');
//       // Optionally show a user-friendly message
//     }
//   }
//   */

//   // Example function to add an objective to a REST API
//   /*
//   Future<void> _addObjectiveToApi(Map<String, dynamic> objectiveData) async {
//     // final serverAddress = 'YOUR_API_BASE_URL';
//     // final url = Uri.parse('$serverAddress/api/objectives/');
//     try {
//       // Convert DateTime objects to ISO 8601 strings for API
//       final Map<String, dynamic> dataToSend = {
//         ...objectiveData,
//         'managerProgressHistory': (objectiveData['managerProgressHistory'] as List)
//             .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
//             .toList(),
//         'assignees': (objectiveData['assignees'] as List)
//             .map((assignee) => {
//                   'id': assignee['id'],
//                   'name': assignee['name'],
//                   'progressHistory': (assignee['progressHistory'] as List)
//                       .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
//                       .toList(),
//                 })
//             .toList(),
//       };

//       // final response = await http.post(
//       //   url,
//       //   headers: {
//       //     'Authorization': 'Bearer YOUR_TOKEN',
//       //     'Content-Type': 'application/json',
//       //   },
//       //   body: json.encode(dataToSend),
//       // );
//       // if (response.statusCode == 201) { // 201 Created
//       //   print('Objective added successfully to API');
//       //   // Optionally, re-fetch objectives to update UI
//       //   // _fetchObjectivesFromApi();
//       // } else {
//       //   print('Failed to add objective: ${response.statusCode}');
//       // }
//     } catch (e) {
//       print('Error adding objective: $e');
//     }
//   }
//   */

//   // Example function to update an objective on a REST API
//   /*
//   Future<void> _updateObjectiveOnApi(String objectiveId, Map<String, dynamic> objectiveData) async {
//     // final serverAddress = 'YOUR_API_BASE_URL';
//     // final url = Uri.parse('$serverAddress/api/objectives/$objectiveId/'); // Assuming ID in URL
//     try {
//       // Convert DateTime objects to ISO 8601 strings for API
//       final Map<String, dynamic> dataToSend = {
//         ...objectiveData,
//         'managerProgressHistory': (objectiveData['managerProgressHistory'] as List)
//             .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
//             .toList(),
//         'assignees': (objectiveData['assignees'] as List)
//             .map((assignee) => {
//                   'id': assignee['id'],
//                   'name': assignee['name'],
//                   'progressHistory': (assignee['progressHistory'] as List)
//                       .map((e) => {'date': (e['date'] as DateTime).toIso8601String(), 'progress': e['progress']})
//                       .toList(),
//                 })
//             .toList(),
//       };

//       // final response = await http.put( // Or PATCH for partial updates
//       //   url,
//       //   headers: {
//       //     'Authorization': 'Bearer YOUR_TOKEN',
//       //     'Content-Type': 'application/json',
//       //   },
//       //   body: json.encode(dataToSend),
//       // );
//       // if (response.statusCode == 200) {
//       //   print('Objective updated successfully on API');
//       //   // Optionally, re-fetch objectives to update UI
//       //   // _fetchObjectivesFromApi();
//       // } else {
//       //   print('Failed to update objective: ${response.statusCode}');
//       // }
//     } catch (e) {
//       print('Error updating objective: $e');
//     }
//   }
//   */

//   // Example function to delete an objective from a REST API
//   /*
//   Future<void> _deleteObjectiveFromApi(String objectiveId) async {
//     // final serverAddress = 'YOUR_API_BASE_URL';
//     // final url = Uri.parse('$serverAddress/api/objectives/$objectiveId/');
//     try {
//       // final response = await http.delete(
//       //   url,
//       //   headers: {
//       //     'Authorization': 'Bearer YOUR_TOKEN',
//       //   },
//       // );
//       // if (response.statusCode == 204) { // 204 No Content for successful deletion
//       //   print('Objective deleted successfully from API');
//       //   // Optionally, re-fetch objectives to update UI
//       //   // _fetchObjectivesFromApi();
//       // } else {
//       //   print('Failed to delete objective: ${response.statusCode}');
//       // }
//     } catch (e) {
//       print('Error deleting objective: $e');
//     }
//   }
//   */

//   void _searchObjectives(String query) {
//     setState(() {
//       searchQuery = query;
//       _applyFilters();
//     });
//   }

//   void _applyFilters() {
//     setState(() {
//       List<Map<String, dynamic>> tempFiltered = allObjectives.where((obj) {
//         final matchesTitle = obj['title']
//             .toString()
//             .toLowerCase()
//             .contains(searchQuery.toLowerCase());
//         bool matchesRoleVisibility = false;

//         if (currentUserRole == 'admin') {
//           matchesRoleVisibility = true; // Admins see all objectives
//         } else {
//           // HR and regular employees see objectives they manage or are assigned to.
//           // This covers "Self Objectives" for any role, and objectives HR creates for others if HR is the manager.
//           final isManager = obj['manager'] == currentUserName;
//           final isAssignee = (obj['assignees'] as List).any((a) => a['name'] == currentUserName);
//           matchesRoleVisibility = isManager || isAssignee;
//         }

//         bool matchesUserFilter = true;
//         // Apply existing filters
//         if (filter['manager'] != null && filter['manager'] != '') {
//           matchesUserFilter = matchesUserFilter &&
//               obj['manager'].toString().toLowerCase() ==
//                   filter['manager'].toString().toLowerCase();
//         }
//         if (filter['assignee'] != null && filter['assignee'] != '') {
//           matchesUserFilter = matchesUserFilter &&
//               (obj['assignees'] as List)
//                   .any((e) => e['name'].toString().toLowerCase() == filter['assignee'].toString().toLowerCase());
//         }
//         if (filter['keyResult'] != null && filter['keyResult'] != '') {
//           matchesUserFilter = matchesUserFilter &&
//               obj['keyResult']
//                   .toString()
//                   .toLowerCase()
//                   .contains(filter['keyResult'].toString().toLowerCase());
//         }
//         if (filter['duration'] != null && filter['duration'] != '') {
//           matchesUserFilter = matchesUserFilter &&
//               obj['duration'].toString() == filter['duration'].toString();
//         }

//         return matchesTitle && matchesRoleVisibility && matchesUserFilter;
//       }).toList();
//       filteredObjectives = tempFiltered;
//     });
//   }

//   void _showFilterDialog() {
//     String manager = filter['manager'] ?? '';
//     String assignee = filter['assignee'] ?? '';
//     String keyResult = filter['keyResult'] ?? '';
//     String duration = filter['duration'] ?? '';

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Filter Objectives'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _buildTextField('Manager', manager, (val) => manager = val),
//                 _buildTextField('Assignee', assignee, (val) => assignee = val),
//                 _buildTextField('Key Result', keyResult, (val) => keyResult = val),
//                 _buildTextField('Duration', duration, (val) => duration = val),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   filter = {
//                     'manager': manager,
//                     'assignee': assignee,
//                     'keyResult': keyResult,
//                     'duration': duration,
//                   };
//                   _applyFilters();
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text('Filter'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   filter = {};
//                   _applyFilters();
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text('Clear'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTextField(String label, String initial, Function(String) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: TextFormField(
//         initialValue: initial,
//         decoration: InputDecoration(labelText: label),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   // Helper to calculate total progress
//   double _calculateTotalProgress(Map<String, dynamic> objective) {
//     double totalProgressSum = 0;
//     int participantsCount = 0;

//     // Manager's progress
//     if (objective['managerProgressHistory'] != null && (objective['managerProgressHistory'] as List).isNotEmpty) {
//       totalProgressSum += (objective['managerProgressHistory'].last['progress'] as int).toDouble();
//       participantsCount++;
//     }

//     // Assignees' progress
//     if (objective['assignees'] != null && (objective['assignees'] as List).isNotEmpty) {
//       for (var assignee in (objective['assignees'] as List)) {
//         if (assignee['progressHistory'] != null && (assignee['progressHistory'] as List).isNotEmpty) {
//           totalProgressSum += (assignee['progressHistory'].last['progress'] as int).toDouble();
//           participantsCount++;
//         }
//       }
//     }

//     if (participantsCount == 0) {
//       return 0.0;
//     }
//     return (totalProgressSum / participantsCount).roundToDouble();
//   }

//   // Progress edit dialog for manager/assignee
//   Future<void> _editProgressDialog({
//     required String name,
//     required List<Map<String, dynamic>> progressHistory,
//     required Function() onSavedCallback, // Changed to a simple callback
//   }) async {
//     // Ensure we are working with a *copy* of the progress history for local updates
//     List<Map<String, dynamic>> localProgressHistory = List.from(progressHistory);
//     int currentProgress = localProgressHistory.isNotEmpty ? localProgressHistory.last['progress'] : 0;

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setLocalState) {
//             return AlertDialog(
//               title: Text('Edit Progress for $name'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Slider(
//                             value: currentProgress.toDouble(),
//                             min: 0,
//                             max: 100,
//                             divisions: 100,
//                             activeColor: Colors.red,
//                             inactiveColor: Colors.grey,
//                             label: '$currentProgress%',
//                             onChanged: (val) {
//                               setLocalState(() {
//                                 currentProgress = val.round();
//                               });
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Text('$currentProgress%')
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(
//                       height: 80,
//                       child: ListView(
//                         children: localProgressHistory.reversed.map((entry) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 2),
//                             child: Text(
//                               '${DateFormat('yyyy-MM-dd HH:mm').format(entry['date'])}: ${entry['progress']}%',
//                               style: const TextStyle(fontSize: 13, color: Colors.grey),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Only add if progress has actually changed or if it's the first entry
//                     if (localProgressHistory.isEmpty || localProgressHistory.last['progress'] != currentProgress) {
//                       localProgressHistory.add({
//                         'date': DateTime.now(),
//                         'progress': currentProgress,
//                       });
//                     }

//                     // Update the original list via reference
//                     // We clear the original and add elements from the local copy
//                     progressHistory.clear();
//                     progressHistory.addAll(localProgressHistory);

//                     onSavedCallback(); // Trigger a setState in the parent
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Save'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _progressHistoryList(List<Map<String, dynamic>> history) {
//     return SizedBox(
//       height: 80,
//       child: ListView(
//         children: history.reversed.map((entry) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: Text(
//               '${DateFormat('yyyy-MM-dd HH:mm').format(entry['date'])}: ${entry['progress']}%',
//               style: const TextStyle(fontSize: 13, color: Colors.grey),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _detailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   void _showCreateOrEditDialog({Map<String, dynamic>? objective, int? editIndex}) {
//     final titleController = TextEditingController(text: objective?['title'] ?? '');
//     final managerController = TextEditingController(text: objective?['manager'] ?? '');
//     final keyResultController = TextEditingController(text: objective?['keyResult'] ?? '');
//     final durationController = TextEditingController(text: objective?['duration'] ?? '');
//     final descriptionController = TextEditingController(text: objective?['description'] ?? '');

//     // Determine initial state of 'isSelfObjective' for editing
//     bool initialIsSelfObjective = (objective != null && objective['manager'] == currentUserName) ||
//                                   (objective == null && currentUserRole != 'admin' && currentUserRole != 'hr'); // Default new for non-admin/hr is self

//     // If editing, and manager is current user, make it self objective. Otherwise, it's for others.
//     // If creating, and current user is Admin/HR, default to 'Others'. Otherwise, default to 'Self'.
//     if (objective != null) {
//       initialIsSelfObjective = objective['manager'] == currentUserName;
//     } else { // Creating a new objective
//       initialIsSelfObjective = !(currentUserRole == 'admin' || currentUserRole == 'hr'); // Default to self for non-admin/hr
//       if (initialIsSelfObjective) {
//         managerController.text = currentUserName; // Pre-fill for self-objective
//       }
//     }


//     // Deep copy of assignees and managerProgressHistory to avoid direct modification
//     List<Map<String, dynamic>> tempAssignees = objective?['assignees'] != null
//         ? (objective!['assignees'] as List).map((a) => Map<String, dynamic>.from(a)).toList()
//         : [];
//     List<Map<String, dynamic>> tempManagerProgressHistory =
//         objective?['managerProgressHistory'] != null
//             ? (objective!['managerProgressHistory'] as List).map((h) => Map<String, dynamic>.from(h)).toList()
//             : []; // Initialize empty if no history

//     // If creating a new objective, ensure manager has a starting progress entry
//     if (editIndex == null && tempManagerProgressHistory.isEmpty) {
//       tempManagerProgressHistory.add({
//         'date': DateTime.now(),
//         'progress': 0,
//       });
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         bool _isSelfObjective = initialIsSelfObjective;

//         // Use a local variable to hold manager's current progress in the dialog
//         int dialogManagerCurrentProgress = tempManagerProgressHistory.isNotEmpty
//             ? tempManagerProgressHistory.last['progress']
//             : 0;

//         return AlertDialog(
//           title: Text(editIndex == null ? 'Create Objective' : 'Edit Objective'),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setLocalState) {
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: titleController,
//                       decoration: const InputDecoration(labelText: 'Title'),
//                     ),
//                     if (currentUserRole == 'admin' || currentUserRole == 'hr')
//                       Column(
//                         children: [
//                           RadioListTile<bool>(
//                             title: const Text('Self Objective'),
//                             value: true,
//                             groupValue: _isSelfObjective,
//                             onChanged: (bool? value) {
//                               setLocalState(() {
//                                 _isSelfObjective = value!;
//                                 if (_isSelfObjective) {
//                                   managerController.text = currentUserName;
//                                 } else {
//                                   managerController.clear();
//                                 }
//                               });
//                             },
//                           ),
//                           RadioListTile<bool>(
//                             title: const Text('For Someone Else (All Objective)'),
//                             value: false,
//                             groupValue: _isSelfObjective,
//                             onChanged: (bool? value) {
//                               setLocalState(() {
//                                 _isSelfObjective = value!;
//                                 if (_isSelfObjective) {
//                                   managerController.text = currentUserName;
//                                 } else {
//                                   managerController.clear();
//                                 }
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     TextField(
//                       controller: managerController,
//                       decoration: const InputDecoration(labelText: 'Manager'),
//                       readOnly: _isSelfObjective && (currentUserRole != 'admin' && currentUserRole != 'hr'), // Only read-only for self-objective if not admin/hr
//                     ),
//                     Row(
//                       children: [
//                         const Text('Manager Progress:'),
//                         Expanded(
//                           child: Slider(
//                             value: dialogManagerCurrentProgress.toDouble(), // Use dialog's local state
//                             min: 0,
//                             max: 100,
//                             divisions: 100,
//                             label: '$dialogManagerCurrentProgress%',
//                             onChanged: (val) {
//                               setLocalState(() {
//                                 dialogManagerCurrentProgress = val.round(); // Update local state
//                               });
//                             },
//                           ),
//                         ),
//                         Text('$dialogManagerCurrentProgress%')
//                       ],
//                     ),
//                     TextField(
//                       controller: keyResultController,
//                       decoration: const InputDecoration(labelText: 'Key Result'),
//                     ),
//                     TextField(
//                       controller: durationController,
//                       decoration: const InputDecoration(labelText: 'Duration (in months)'),
//                       keyboardType: TextInputType.number,
//                     ),
//                     TextField(
//                       controller: descriptionController,
//                       decoration: const InputDecoration(labelText: 'Description'),
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const Text('Assignees:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         IconButton(
//                           icon: const Icon(Icons.add),
//                           onPressed: () {
//                             setLocalState(() {
//                               tempAssignees.add({
//                                 'id': UniqueKey().toString(), // Generate a unique ID for new assignees
//                                 'name': '',
//                                 'progressHistory': [
//                                   {'date': DateTime.now(), 'progress': 0}
//                                 ]
//                               });
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     ...tempAssignees.asMap().entries.map((entry) {
//                       int idx = entry.key;
//                       var assignee = entry.value;
//                       // Use a local variable for assignee's current progress in the dialog
//                       int assigneeCurrentProgress = (assignee['progressHistory'] as List).isNotEmpty
//                           ? assignee['progressHistory'].last['progress']
//                           : 0;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextField(
//                               decoration: InputDecoration(labelText: 'Assignee ${idx + 1} Name'),
//                               controller: TextEditingController(text: assignee['name']),
//                               onChanged: (val) {
//                                 assignee['name'] = val; // Update the assignee map directly
//                               },
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Slider(
//                                     value: assigneeCurrentProgress.toDouble(),
//                                     min: 0,
//                                     max: 100,
//                                     divisions: 100,
//                                     label: '$assigneeCurrentProgress%',
//                                     onChanged: (val) {
//                                       setLocalState(() {
//                                         assigneeCurrentProgress = val.round();
//                                         // Ensure progress history is updated with new value
//                                         if (assignee['progressHistory'].isEmpty ||
//                                             assignee['progressHistory'].last['progress'] != assigneeCurrentProgress) {
//                                           assignee['progressHistory'].add({
//                                             'date': DateTime.now(),
//                                             'progress': assigneeCurrentProgress,
//                                           });
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 Text('$assigneeCurrentProgress%'),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () {
//                                     setLocalState(() => tempAssignees.removeAt(idx));
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Only add new progress entry if value has actually changed
//                 if (tempManagerProgressHistory.isEmpty || tempManagerProgressHistory.last['progress'] != dialogManagerCurrentProgress) {
//                    tempManagerProgressHistory.add({
//                      'date': DateTime.now(),
//                      'progress': dialogManagerCurrentProgress,
//                    });
//                  }

//                 final newObjective = {
//                   'id': objective?['id'] ?? UniqueKey().toString(), // Keep existing ID or generate new
//                   'title': titleController.text,
//                   'manager': managerController.text,
//                   'managerProgressHistory': tempManagerProgressHistory, // Use the updated history
//                   'keyResult': keyResultController.text,
//                   'duration': durationController.text,
//                   'description': descriptionController.text,
//                   'assignees': tempAssignees.map((a) {
//                     // Ensure assignees' progress histories are correctly updated from the dialog's local state
//                     // The `onChanged` for assignee slider directly updates `assignee['progressHistory']`
//                     // so we just pass the `tempAssignees` list.
//                     return a;
//                   }).toList(),
//                 };

//                 setState(() {
//                   if (editIndex == null) {
//                     allObjectives.add(newObjective);
//                     // Example: Add to API
//                     // _addObjectiveToApi(newObjective);
//                   } else {
//                     allObjectives[editIndex] = newObjective;
//                     // Example: Update on API
//                     // _updateObjectiveOnApi(newObjective['id'], newObjective);
//                   }
//                   _applyFilters();
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text(editIndex == null ? 'Create' : 'Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Performance Objectives'),
//         backgroundColor: kMaroon,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Horizontal bar: Search, Filter, Create
//             Container(
//               color: kMaroon.withOpacity(0.08),
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Row(
//                 children: [
//                   // Search
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search by title',
//                         prefixIcon: const Icon(Icons.search, color: kMaroon),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: kMaroon),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: kMaroon, width: 2),
//                         ),
//                       ),
//                       onChanged: _searchObjectives,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Filter
//                   IconButton(
//                     icon: const Icon(Icons.filter_list, color: kMaroon),
//                     onPressed: _showFilterDialog,
//                     tooltip: 'Filter',
//                   ),
//                   const SizedBox(width: 8),
//                   // Create
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.add),
//                     label: const Text('Create'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kMaroon,
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () => _showCreateOrEditDialog(),
//                   ),
//                 ],
//               ),
//             ),

//             // Removed the "Self Objective / All Objective" toggle here

//             // Objectives List
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: filteredObjectives.length,
//               itemBuilder: (context, idx) {
//                 final obj = filteredObjectives[idx];
//                 final String objectiveId = obj['id']; // Use the ID for expansion
//                 final bool isExpanded = expandedObjectiveIds.contains(objectiveId);
//                 final double totalProgress = _calculateTotalProgress(obj);
//                 final bool isCompleted = totalProgress == 100.0;

//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text(obj['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Manager: ${obj['manager']}'),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Text('Total Progress: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                                 Text(
//                                   isCompleted ? 'Objective Completed' : '${totalProgress.toStringAsFixed(0)}%',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: isCompleted ? kGreenCompleted : kMaroon,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         trailing: Icon(
//                           isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
//                           color: kMaroon,
//                         ),
//                         onTap: () {
//                           setState(() {
//                             if (isExpanded) {
//                               expandedObjectiveIds.remove(objectiveId);
//                             } else {
//                               expandedObjectiveIds.add(objectiveId);
//                             }
//                           });
//                         },
//                       ),
//                       if (isExpanded)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _detailRow('Title', obj['title']),
//                               _detailRow('Manager', obj['manager']),
//                               const SizedBox(height: 8),
//                               const Text('Assignees:', style: TextStyle(fontWeight: FontWeight.bold)),
//                               ...((obj['assignees'] as List).map((assignee) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 4.0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         assignee['name'],
//                                         style: const TextStyle(
//                                           color: Colors.black, // Not tappable
//                                         ),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         '${assignee['progressHistory'].isNotEmpty ? assignee['progressHistory'].last['progress'] : 0}%',
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               })).toList(), // Convert iterable to list
//                               const SizedBox(height: 8),
//                               const Text('Manager Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
//                               _progressHistoryList(obj['managerProgressHistory']),
//                               const SizedBox(height: 8),
//                               const Text('Assignee Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
//                               ...((obj['assignees'] as List).map((assignee) =>
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('${assignee['name']}:', style: const TextStyle(fontWeight: FontWeight.w600)),
//                                       _progressHistoryList(assignee['progressHistory']),
//                                     ],
//                                   ),
//                                 )).toList(), // Convert iterable to list
//                               _detailRow('Key Result', obj['keyResult']),
//                               _detailRow('Duration', '${obj['duration']} months'),
//                               _detailRow('Description', obj['description']),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit, color: kMaroon),
//                                     onPressed: () => _showCreateOrEditDialog(objective: obj, editIndex: allObjectives.indexOf(obj)),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: kMaroon),
//                                     onPressed: () {
//                                       setState(() {
//                                         allObjectives.removeAt(allObjectives.indexOf(obj));
//                                         _applyFilters();
//                                         // Example: Delete from API
//                                         // _deleteObjectiveFromApi(obj['id']);
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 