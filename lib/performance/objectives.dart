import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kMaroon = Color(0xFF800000);

class PerformanceObjectives extends StatefulWidget {
  const PerformanceObjectives({Key? key}) : super(key: key);

  @override
  State<PerformanceObjectives> createState() => _PerformanceObjectivesState();
}

class _PerformanceObjectivesState extends State<PerformanceObjectives> {
  List<Map<String, dynamic>> allObjectives = [
    {
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
      'isArchived': false,
      'assignees': [
        {
          'name': 'John',
          'progressHistory': [
            {'date': DateTime(2024, 1, 15, 9, 0), 'progress': 10},
            {'date': DateTime(2024, 2, 15, 9, 0), 'progress': 30},
            {'date': DateTime(2024, 3, 15, 9, 0), 'progress': 50},
          ]
        },
        {
          'name': 'Jane',
          'progressHistory': [
            {'date': DateTime(2024, 1, 10, 11, 0), 'progress': 80},
          ]
        }
      ],
    },
    {
      'title': 'Customer Satisfaction',
      'manager': 'Eve',
      'managerProgressHistory': [
        {'date': DateTime(2024, 1, 1, 10, 0), 'progress': 40},
      ],
      'keyResult': '0 Key results',
      'duration': '1',
      'description': 'Measure client satisfaction',
      'isArchived': false,
      'assignees': [
        {
          'name': 'Alice',
          'progressHistory': [
            {'date': DateTime(2024, 1, 15, 9, 0), 'progress': 70},
          ]
        }
      ],
    },
  ];

  List<Map<String, dynamic>> filteredObjectives = [];
  String searchQuery = '';
  bool showSelfObjectives = true;
  Map<String, dynamic> filter = {};
  Set<int> expandedIndices = {};

  @override
  void initState() {
    super.initState();
    filteredObjectives = List.from(allObjectives);
  }

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
                  .map((e) => e['name'].toString().toLowerCase())
                  .contains(filter['assignee'].toString().toLowerCase());
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
        // Archive filter: show only archived if filter['isArchived']=='true', else only non-archived
        if (filter['isArchived'] == 'true') {
          matchesFilter = matchesFilter && obj['isArchived'] == true;
        } else if (filter['isArchived'] == 'false' || filter['isArchived'] == null || filter['isArchived'] == 'Unknown') {
          matchesFilter = matchesFilter && obj['isArchived'] == false;
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
    String isArchived = filter['isArchived'] ?? 'Unknown';

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
                    'assignee': assignee,
                    'keyResult': keyResult,
                    'duration': duration,
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

  // Progress edit dialog for manager/assignee
  Future<void> _editProgressDialog({
  required String name,
  required List<Map<String, dynamic>> progressHistory,
  required Function(int) onSaved,
}) async {
  int localProgress = progressHistory.isNotEmpty ? progressHistory.last['progress'] : 0;
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
                          value: localProgress.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey,
                          label: '$localProgress',
                          onChanged: (val) {
                            setLocalState(() {
                              localProgress = val.round();
                              print('Slider value: $localProgress');                              
                            });
                          },
                        ),
                      ),
                      Text('$localProgress%')
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Progress History:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      children: progressHistory.reversed.map((entry) {
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
                  setState(() {
                    progressHistory.add({
                      'date': DateTime.now(),
                      'progress': localProgress,
                    });
                  });
                  onSaved(localProgress);
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
    bool isArchived = objective?['isArchived'] ?? false;
    List<Map<String, dynamic>> assignees = objective?['assignees'] != null
        ? List<Map<String, dynamic>>.from(objective!['assignees'])
        : [];
    List<Map<String, dynamic>> managerProgressHistory =
        objective?['managerProgressHistory'] != null
            ? List<Map<String, dynamic>>.from(objective!['managerProgressHistory'])
            : [
                {
                  'date': DateTime.now(),
                  'progress': 0,
                }
              ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          int managerCurrentProgress = managerProgressHistory.isNotEmpty
              ? managerProgressHistory.last['progress']
              : 0;
          return AlertDialog(
            title: Text(editIndex == null ? 'Create Objective' : 'Edit Objective'),
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
                  Row(
                    children: [
                      const Text('Manager Progress:'),
                      Expanded(
                        child: Slider(
                          value: managerCurrentProgress.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: '$managerCurrentProgress',
                          onChanged: (val) {
                            setLocalState(() {
                              managerCurrentProgress = val.round();
                            });
                          },
                        ),
                      ),
                      Text('$managerCurrentProgress%')
                    ],
                  ),
                  TextField(
                    controller: keyResultController,
                    decoration: const InputDecoration(labelText: 'Key Result'),
                  ),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(labelText: 'Duration'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    children: [
                      const Text('Assignees:'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setLocalState(() {
                            assignees.add({
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
                  ...assignees.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var assignee = entry.value;
                    int assigneeCurrentProgress = (assignee['progressHistory'] as List).isNotEmpty
                        ? assignee['progressHistory'].last['progress']
                        : 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Name'),
                            controller: TextEditingController(text: assignee['name']),
                            onChanged: (val) => assignees[idx]['name'] = val,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: assigneeCurrentProgress.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  label: '$assigneeCurrentProgress',
                                  onChanged: (val) {
                                    setLocalState(() {
                                      assigneeCurrentProgress = val.round();
                                    });
                                  },
                                ),
                              ),
                              Text('$assigneeCurrentProgress%'),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setLocalState(() => assignees.removeAt(idx));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
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
                  final newObj = {
                    'title': titleController.text,
                    'manager': managerController.text,
                    'managerProgressHistory': [
                      ...managerProgressHistory,
                      {
                        'date': DateTime.now(),
                        'progress': managerCurrentProgress,
                      }
                    ],
                    'keyResult': keyResultController.text,
                    'duration': durationController.text,
                    'description': descriptionController.text,
                    'isArchived': isArchived,
                    'assignees': assignees.map((a) {
                      List<Map<String, dynamic>> ph = a['progressHistory'] ?? [];
                      int latestProgress = ph.isNotEmpty ? ph.last['progress'] : 0;
                      return {
                        'name': a['name'],
                        'progressHistory': [
                          ...ph,
                          {
                            'date': DateTime.now(),
                            'progress': latestProgress,
                          }
                        ]
                      };
                    }).toList(),
                  };
                  setState(() {
                    if (editIndex == null) {
                      allObjectives.add(newObj);
                    } else {
                      allObjectives[editIndex] = newObj;
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
        title: const Text('Performance Objectives'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Horizontal bar: Search, Filter, Create
            Container(
              // ignore: deprecated_member_use
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
                final isExpanded = expandedIndices.contains(idx);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(obj['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            const Text('Manager: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            GestureDetector(
                              onTap: () {
                                _editProgressDialog(
                                  name: obj['manager'],
                                  progressHistory: obj['managerProgressHistory'],
                                  onSaved: (newProgress) {setState(() {

                                  });},
                                );
                              },
                              child: Text(
                                obj['manager'],
                                style: const TextStyle(
                                  color: kMaroon,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${obj['managerProgressHistory'].isNotEmpty ? obj['managerProgressHistory'].last['progress'] : 0}%',
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
                              _detailRow('Title', obj['title']),
                              Row(
                                children: [
                                  const Text('Assignees: ', style: TextStyle(fontWeight: FontWeight.w600)),
                                  ...((obj['assignees'] as List).asMap().entries.map((entry) {
                                    final assignee = entry.value;
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _editProgressDialog(
                                              name: assignee['name'],
                                              progressHistory: assignee['progressHistory'],
                                              onSaved: (newProgress) {setState(() {
                                                
                                              });},
                                            );
                                          },
                                          child: Text(
                                            assignee['name'],
                                            style: const TextStyle(
                                              color: kMaroon,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${assignee['progressHistory'].isNotEmpty ? assignee['progressHistory'].last['progress'] : 0}%',
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                    );
                                  })),
                                ],
                              ),
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
                                )),
                              _detailRow('Key Result', obj['keyResult']),
                              _detailRow('Duration', obj['duration']),
                              _detailRow('Description', obj['description']),
                              _detailRow('Is Archived', obj['isArchived'].toString()),
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
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.archive, color: kMaroon),
                                    onPressed: () {
                                      setState(() {
                                        obj['isArchived'] = true;
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
}

