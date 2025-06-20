import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kMaroon = Color(0xFF800000);

class Meetings extends StatefulWidget {
  const Meetings({Key? key}) : super(key: key);

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  List<Map<String, dynamic>> allMeetings = [
    {
      'title': 'Q2 Planning',
      'manager': 'Adam',
      'employee': 'John',
      'dateTime': DateTime(2025, 6, 19, 10, 30),
      'minutes': 60,
      'comments': 'Discussed quarterly targets.',
      'isArchived': false,
    },
    {
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
    filteredMeetings = List.from(allMeetings);
  }

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
                    } else {
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
                        prefixIcon: Icon(Icons.search, color: kMaroon),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kMaroon),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kMaroon, width: 2),
                        ),
                      ),
                      onChanged: _searchMeetings,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: kMaroon),
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
                                    icon: Icon(Icons.edit, color: kMaroon),
                                    onPressed: () => _showCreateOrEditDialog(meeting: meeting, editIndex: allMeetings.indexOf(meeting)),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        allMeetings.removeAt(allMeetings.indexOf(meeting));
                                        _applyFilters();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.archive, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        meeting['isArchived'] = true;
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
