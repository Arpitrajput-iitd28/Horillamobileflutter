// lib/recruitment/interview.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date/time formatting

// Uncomment these imports when you are ready to use the API integration
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// =============================================================================
// SECTION 1: CENTRALIZED CONSTANTS AND DATA MODELS
// =============================================================================

// === Centralized Constants ===
const Color kMaroon = Color(0xFF800000);

// === Employee Model (for Interviewers) ===
class Employee {
  final String id;
  final String name;

  Employee({required this.id, required this.name});

  // // Uncomment for API integration
  // factory Employee.fromJson(Map<String, dynamic> json) {
  //   return Employee(
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //   );
  // }

  // // Uncomment for API integration
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //   };
  // }
}

// === Interview Model (UPDATED for multiple interviewers) ===
class Interview {
  final String id;
  final String candidateName;
  final List<String> interviewerIds; // CHANGED: Now a list of IDs
  final DateTime interviewDateTime;
  final String description;

  Interview({
    required this.id,
    required this.candidateName,
    required this.interviewerIds, // CHANGED
    required this.interviewDateTime,
    required this.description,
  });

  // // Uncomment for API integration
  // factory Interview.fromJson(Map<String, dynamic> json) {
  //   return Interview(
  //     id: json['id'] as String,
  //     candidateName: json['candidateName'] as String,
  //     interviewerIds: List<String>.from(json['interviewerIds'] as List<dynamic>), // CHANGED
  //     interviewDateTime: DateTime.parse(json['interviewDateTime'] as String),
  //     description: json['description'] as String,
  //   );
  // }

  // // Uncomment for API integration
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'candidateName': candidateName,
  //     'interviewerIds': interviewerIds, // CHANGED
  //     'interviewDateTime': interviewDateTime.toIso8601String(),
  //     'description': description,
  //   };
  // }
}


// =============================================================================
// SECTION 2: CREATE/EDIT INTERVIEW DIALOG
// =============================================================================

// Define callback types for clarity
typedef OnSaveInterviewCallback = void Function(Interview newInterview);

class CreateEditInterviewDialog extends StatefulWidget {
  final List<Employee> availableInterviewers;
  final OnSaveInterviewCallback onSave;

  const CreateEditInterviewDialog({
    Key? key,
    required this.availableInterviewers,
    required this.onSave,
  }) : super(key: key);

  @override
  _CreateEditInterviewDialogState createState() => _CreateEditInterviewDialogState();
}

class _CreateEditInterviewDialogState extends State<CreateEditInterviewDialog> {
  // --- Form Controllers ---
  late TextEditingController _candidateNameController;
  late TextEditingController _descriptionController;

  // --- Local State for Dialog Logic ---
  List<String> _selectedInterviewerIds = []; // CHANGED: Now a list
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _candidateNameController = TextEditingController();
    _descriptionController = TextEditingController();

    // Initialize with no interviewers selected by default, user will pick
  }

  @override
  void dispose() {
    _candidateNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- Date Picker ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kMaroon,
              onPrimary: Colors.white,
              onSurface: kMaroon,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kMaroon,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- Time Picker ---
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kMaroon,
              onPrimary: Colors.white,
              onSurface: kMaroon,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kMaroon,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // --- Multi-Select Interviewer Dialog (FIXED) ---
  Future<void> _showMultiSelectInterviewerDialog() async {
    final List<String>? results = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) { // Use dialogContext to refer to the context of the dialog
        // Create a temporary list to manage selections within this specific dialog
        List<String> tempSelectedInterviewerIds = List.from(_selectedInterviewerIds);

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select Interviewers', style: TextStyle(color: kMaroon)),
          content: StatefulBuilder( // <--- FIX: Use StatefulBuilder to manage inner dialog state
            builder: (BuildContext context, StateSetter setStateInDialog) { // setStateInDialog to update checkboxes
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.availableInterviewers.map((employee) {
                    return CheckboxListTile(
                      title: Text(employee.name, style: const TextStyle(color: kMaroon)),
                      value: tempSelectedInterviewerIds.contains(employee.id),
                      onChanged: (bool? selected) {
                        setStateInDialog(() { // <--- FIX: Call setStateInDialog to update checkbox visuals
                          if (selected == true) {
                            tempSelectedInterviewerIds.add(employee.id);
                          } else {
                            tempSelectedInterviewerIds.remove(employee.id);
                          }
                        });
                      },
                      activeColor: kMaroon,
                      checkColor: Colors.white,
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Cancel button uses dialogContext
              child: const Text('Cancel', style: TextStyle(color: kMaroon)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(dialogContext, tempSelectedInterviewerIds), // Done button returns selected IDs
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    if (results != null) {
      setState(() { // This setState updates the parent CreateEditInterviewDialog's state
        _selectedInterviewerIds = results;
      });
    }
  }

  // --- Save Interview ---
  void _onSavePressed() {
    final candidateName = _candidateNameController.text.trim();
    final description = _descriptionController.text.trim();

    if (candidateName.isEmpty || _selectedInterviewerIds.isEmpty) { // Check if at least one interviewer is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Candidate Name and at least one Interviewer are required.')),
      );
      return;
    }

    // Combine date and time
    final interviewDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newInterview = Interview(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      candidateName: candidateName,
      interviewerIds: _selectedInterviewerIds, // Use the list of IDs
      interviewDateTime: interviewDateTime,
      description: description,
    );

    widget.onSave(newInterview);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Helper to get interviewer names for display in the dialog
    String getSelectedInterviewerNames() {
      if (_selectedInterviewerIds.isEmpty) {
        return 'No interviewers selected';
      }
      final names = _selectedInterviewerIds.map((id) {
        return widget.availableInterviewers.firstWhere((emp) => emp.id == id, orElse: () => Employee(id: '', name: 'Unknown')).name;
      }).toList();
      return names.join(', ');
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        elevation: 24,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Schedule New Interview',
                    style: TextStyle(color: kMaroon, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _candidateNameController,
                  decoration: InputDecoration(
                    labelText: 'Candidate Name',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: const TextStyle(color: kMaroon),
                ),
                const SizedBox(height: 10),

                // Interviewer Multi-Select Input
                InkWell(
                  onTap: widget.availableInterviewers.isNotEmpty ? _showMultiSelectInterviewerDialog : null,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Interviewers',
                      labelStyle: TextStyle(color: kMaroon),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                      suffixIcon: const Icon(Icons.arrow_drop_down, color: kMaroon),
                    ),
                    child: Text(
                      getSelectedInterviewerNames(),
                      style: const TextStyle(color: kMaroon),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Ensure it stays on one line
                    ),
                  ),
                ),
                if (widget.availableInterviewers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                    child: Text(
                      'No interviewers available. Please add employees first.',
                      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 10),

                // Date and Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(color: kMaroon),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDate),
                            style: const TextStyle(color: kMaroon),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Time',
                            labelStyle: TextStyle(color: kMaroon),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: const TextStyle(color: kMaroon),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: const TextStyle(color: kMaroon),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: kMaroon)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
                      onPressed: _onSavePressed,
                      child: const Text('Schedule'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// =============================================================================
// SECTION 3: SCHEDULED INTERVIEWS PAGE (MAIN PAGE)
// =============================================================================

class ScheduledInterviews extends StatefulWidget {
  const ScheduledInterviews({Key? key}) : super(key: key);

  @override
  State<ScheduledInterviews> createState() => _ScheduledInterviewsPageState();
}

class _ScheduledInterviewsPageState extends State<ScheduledInterviews> {
  // --- Main Page State ---
  List<Interview> _interviews = [];
  List<Employee> _employees = []; // Our mock database of employees/interviewers
  String _searchQuery = '';
  String _selectedFilterTag = 'All'; // 'All', 'Incoming', 'Ongoing', 'Expired'

  // // Uncomment these variables for API integration
  // bool _isLoading = false;
  // String? _errorMessage;
  // final String _apiBaseUrl = 'https://your-api-endpoint.com/api/v1'; // Placeholder

  @override
  void initState() {
    super.initState();
    _loadInitialMockData(); // Load mock data on start
    // // Uncomment this line to try fetching from API on start
    // // _fetchInitialDataFromApi();
  }

  // --- Initial Mock Data (Default Behavior) ---
  void _loadInitialMockData() {
    _employees = [
      Employee(id: 'emp_1', name: 'Alice Smith'),
      Employee(id: 'emp_2', name: 'Bob Johnson'),
      Employee(id: 'emp_3', name: 'Charlie Brown'),
    ];

    // Current time for reference: Friday, June 27, 2025 at 12:16:28 PM IST. (As per context)
    // Adjusting mock data to match a plausible scenario based on provided current time
    final now = DateTime(2025, 6, 27, 12, 16, 28); // Fixed 'now' for consistent mock status

    _interviews = [
      Interview(
        id: 'int_1',
        candidateName: 'Aswathy',
        interviewerIds: ['emp_1'],
        interviewDateTime: now.add(const Duration(hours: 1)), // Incoming (starts in 1 hr)
        description: 'First round technical interview.',
      ),
      Interview(
        id: 'int_2',
        candidateName: 'Grace Price',
        interviewerIds: ['emp_2', 'emp_3'],
        interviewDateTime: now.subtract(const Duration(days: 1, hours: 2)), // Expired (yesterday)
        description: 'HR screening for senior role.',
      ),
      Interview(
        id: 'int_3',
        candidateName: 'James Perry',
        interviewerIds: ['emp_1', 'emp_2'],
        interviewDateTime: now.subtract(const Duration(minutes: 30)), // Ongoing (started 30 min ago)
        description: 'Final round with department head.',
      ),
      Interview(
        id: 'int_4',
        candidateName: 'KUSHI',
        interviewerIds: ['emp_3'],
        interviewDateTime: now.add(const Duration(minutes: 5)), // Incoming (starts in 5 min, "Starts Soon!")
        description: 'Cultural fit interview.',
      ),
      Interview(
        id: 'int_5',
        candidateName: 'Amelia Hayes',
        interviewerIds: ['emp_2'],
        interviewDateTime: now.subtract(const Duration(days: 5, hours: 10)), // Expired (5 days ago)
        description: 'Initial phone screen.',
      ),
      Interview(
        id: 'int_6',
        candidateName: 'Deepak Sharma',
        interviewerIds: ['emp_1', 'emp_3'],
        interviewDateTime: now.add(const Duration(days: 3, hours: 1)), // Incoming (3 days later)
        description: 'Managerial round for product lead.',
      ),
    ];
  }

  // --- Helper to get interviewer names from IDs ---
  String _getInterviewerNames(List<String> interviewerIds) {
    if (interviewerIds.isEmpty) return 'No Interviewer';
    final names = interviewerIds.map((id) {
      return _employees.firstWhere((emp) => emp.id == id, orElse: () => Employee(id: '', name: 'Unknown')).name;
    }).toList();
    return names.join(', ');
  }

  // --- Interview Status Tag Logic ---
  String _getInterviewStatusTag(DateTime interviewDateTime) {
    final now = DateTime.now(); // Use real current time for status calculation
    final interviewStart = interviewDateTime;
    final interviewEnd = interviewDateTime.add(const Duration(hours: 1)); // Assume 1 hour duration for 'Ongoing'

    if (now.isAfter(interviewEnd)) {
      return 'Expired';
    } else if (now.isBefore(interviewStart)) {
      return 'Incoming';
    } else {
      return 'Ongoing';
    }
  }

  // --- Time Left Calculation ---
  String _calculateTimeLeft(DateTime interviewDateTime) {
    final now = DateTime.now(); // Use real current time for time left
    if (interviewDateTime.isBefore(now)) {
      return ''; // No time left if in past or ongoing
    }

    final difference = interviewDateTime.difference(now);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours.remainder(24)}h left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m left';
    } else {
      return 'Starts Soon!';
    }
  }

  // --- Filtered and Searched Interviews ---
  List<Interview> get _filteredInterviews {
    return _interviews.where((interview) {
      final candidateNameLower = interview.candidateName.toLowerCase();
      final interviewerNamesLower = _getInterviewerNames(interview.interviewerIds).toLowerCase();
      final queryLower = _searchQuery.toLowerCase();

      // Apply search filter
      bool matchesSearch = candidateNameLower.contains(queryLower) || interviewerNamesLower.contains(queryLower);

      // Apply tag filter
      bool matchesTag = _selectedFilterTag == 'All' || _getInterviewStatusTag(interview.interviewDateTime) == _selectedFilterTag;

      return matchesSearch && matchesTag;
    }).toList();
  }

  // --- Show Create Interview Dialog ---
  void _showCreateInterviewDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CreateEditInterviewDialog(
          availableInterviewers: _employees,
          onSave: (newInterview) {
            setState(() {
              _interviews.add(newInterview);
              // Sort the interviews to keep "Incoming" first, then "Ongoing", then "Expired"
              _interviews.sort((a, b) {
                final statusA = _getInterviewStatusTag(a.interviewDateTime);
                final statusB = _getInterviewStatusTag(b.interviewDateTime);

                // Define a custom order for statuses
                final statusOrder = {'Incoming': 0, 'Ongoing': 1, 'Expired': 2, 'All': 3};
                final orderA = statusOrder[statusA] ?? 99;
                final orderB = statusOrder[statusB] ?? 99;

                if (orderA != orderB) {
                  return orderA.compareTo(orderB);
                }

                // Secondary sort: chronological order
                return a.interviewDateTime.compareTo(b.interviewDateTime);
              });
            });
            // Call the notification function here (commented out API logic inside)
            _sendInterviewerNotifications(newInterview.interviewerIds, newInterview);
            // // Uncomment for API create interview
            // // _createInterviewApi(newInterview);
          },
        );
      },
    );
  }

  // --- Delete Interview Function ---
  void _deleteInterview(String interviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Interview', style: TextStyle(color: kMaroon)),
        content: const Text('Are you sure you want to delete this interview?', style: TextStyle(color: kMaroon)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                _interviews.removeWhere((interview) => interview.id == interviewId);
              });
              // // Uncomment for API delete interview
              // // _deleteInterviewApi(interviewId);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // --- Notification Placeholder (Commented Out) ---
  void _sendInterviewerNotifications(List<String> interviewerIds, Interview interview) {
    print('Notification Placeholder: Sending notification for interview ${interview.id}');
    print('To interviewers: ${interviewerIds.join(', ')}');
    print('Interview Details: Candidate ${interview.candidateName} on ${DateFormat('yyyy-MM-dd hh:mm a').format(interview.interviewDateTime)}');

    // // --- API Integration for Notifications (Commented Out) ---
    // // This is where you would integrate with a push notification service
    // // (e.g., Firebase Cloud Messaging, a custom API endpoint).
    // // You would typically send the interviewerIds and interview details to your backend,
    // // and the backend would handle sending the actual push notifications.
    //
    // /*
    // if (!await _checkInternetConnectivity()) {
    //   print('Cannot send notification: No internet connection.');
    //   return;
    // }
    // try {
    //   final notificationPayload = {
    //     'interviewer_ids': interviewerIds,
    //     'interview_id': interview.id,
    //     'candidate_name': interview.candidateName,
    //     'interview_time': interview.interviewDateTime.toIso8601String(),
    //     'description': interview.description,
    //     'message': 'New interview scheduled with ${interview.candidateName} on ${DateFormat('MMM dd, hh:mm a').format(interview.interviewDateTime)}',
    //   };
    //
    //   final response = await http.post(
    //     Uri.parse('$_apiBaseUrl/send-interview-notification'), // Replace with your notification API endpoint
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode(notificationPayload),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     print('Notification request sent successfully.');
    //   } else {
    //     print('Failed to send notification request: HTTP ${response.statusCode}');
    //     // Optionally show a snackbar to the user about notification failure
    //   }
    // } catch (e) {
    //   print('Error sending notification: $e');
    //   // Optionally show a snackbar
    // }
    // */
  }


  // --- API Calls (Commented Out Stubs) ---
  // // Future<void> _fetchInitialDataFromApi() async { /* ... implementation for fetching employees and interviews ... */ }
  // // Future<void> _createInterviewApi(Interview newInterview) async { /* ... implementation ... */ }
  // // Future<void> _deleteInterviewApi(String interviewId) async { /* ... implementation ... */ }
  // // Future<void> _updateInterviewApi(Interview updatedInterview) async { /* ... implementation ... */ }


  @override
  Widget build(BuildContext context) {
    final filtered = _filteredInterviews;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Scheduled Interviews', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // --- Search, Filter, and Create Bar ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: kMaroon),
                    decoration: InputDecoration(
                      hintText: 'Search by Candidate or Interviewer',
                      hintStyle: TextStyle(color: kMaroon.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kMaroon.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kMaroon, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.search, color: kMaroon),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Dropdown
                DropdownButton<String>(
                  value: _selectedFilterTag,
                  icon: const Icon(Icons.filter_list, color: kMaroon),
                  style: const TextStyle(color: kMaroon),
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilterTag = newValue!;
                    });
                  },
                  items: <String>['All', 'Incoming', 'Ongoing', 'Expired']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 12),
                // Create Interview Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Schedule', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _showCreateInterviewDialog,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black26),

          // --- Interviews List ---
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty && _selectedFilterTag == 'All'
                          ? 'No interviews scheduled.'
                          : 'No matching interviews found.',
                      style: const TextStyle(color: kMaroon, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final interview = filtered[idx];
                      final statusTag = _getInterviewStatusTag(interview.interviewDateTime);
                      final timeLeft = _calculateTimeLeft(interview.interviewDateTime);

                      Color statusColor;
                      switch (statusTag) {
                        case 'Incoming':
                          statusColor = const Color.fromARGB(255, 9, 105, 2);
                          break;
                        case 'Ongoing':
                          statusColor = Colors.orange;
                          break;
                        case 'Expired':
                          statusColor = Colors.red;
                          break;
                        default:
                          statusColor = Colors.grey;
                      }

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          collapsedIconColor: kMaroon,
                          iconColor: kMaroon,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  interview.candidateName,
                                  style: const TextStyle(
                                    color: kMaroon,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusTag,
                                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Display time left only for Incoming interviews
                              if (timeLeft.isNotEmpty && statusTag == 'Incoming') ...[
                                const SizedBox(width: 8),
                                Text(
                                  timeLeft,
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(Icons.person, 'Candidate:', interview.candidateName),
                                  _buildDetailRow(Icons.groups, 'Interviewers:', _getInterviewerNames(interview.interviewerIds)),
                                  _buildDetailRow(Icons.calendar_today, 'Date:', DateFormat('yyyy-MM-dd').format(interview.interviewDateTime)),
                                  _buildDetailRow(Icons.access_time, 'Time:', DateFormat('hh:mm a').format(interview.interviewDateTime)),
                                  _buildDetailRow(Icons.description, 'Description:', interview.description.isNotEmpty ? interview.description : 'None'),
                                  _buildDetailRow(
                                    statusTag == 'Incoming' ? Icons.schedule : (statusTag == 'Ongoing' ? Icons.hourglass_empty : Icons.cancel),
                                    'Status:',
                                    statusTag,
                                    textColor: statusColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                                      label: const Text('Delete Interview', style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () => _deleteInterview(interview.id),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build consistent detail rows
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kMaroon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: kMaroon, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor ?? kMaroon, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Allow description to wrap if needed
            ),
        ),
        ],
    ),
    );
}
}

