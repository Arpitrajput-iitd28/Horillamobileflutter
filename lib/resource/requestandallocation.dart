import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // === Request & Allocation API Service ===
// class RequestService {
//   static const String baseUrl = 'https://yourapi.com/requests';

//   // Fetch all requests
//   Future<List<Map<String, dynamic>>> fetchRequests() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return List<Map<String, dynamic>>.from(data);
//     } else {
//       throw Exception('Failed to load requests');
//     }
//   }

//   // Add a new request
//   Future<void> addRequest(Map<String, dynamic> request) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(request),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add request');
//     }
//   }

//   // Update request status (approve/issue/cancel/return)
//   Future<void> updateRequestStatus(String requestId, String status) async {
//     final url = '$baseUrl/$requestId/status';
//     final response = await http.put(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'status': status}),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to update status');
//     }
//   }

//   // Delete a request
//   Future<void> deleteRequest(String requestId) async {
//     final url = '$baseUrl/$requestId';
//     final response = await http.delete(Uri.parse(url));
//     if (response.statusCode != 200 && response.statusCode != 204) {
//       throw Exception('Failed to delete request');
//     }
//   }
// }


const Color kBlack = Colors.black;

class RequestandAllocation  extends StatefulWidget {
  const RequestandAllocation({Key? key}) : super(key: key);

  @override
  State<RequestandAllocation> createState() => _AssetDashboardState();
}

class _AssetDashboardState extends State<RequestandAllocation> {
  // final RequestService requestService = RequestService();
// List<Map<String, dynamic>> requests = []; // Will be loaded from API

// @override
// void initState() {
//   super.initState();
//   // _loadRequests();
// }

// Future<void> _loadRequests() async {
//   try {
//     final data = await requestService.fetchRequests();
//     setState(() {
//       requests = data;
//     });
//   } catch (e) {
//     // Handle error (show snackbar, etc.)
//   }
// }

  // Mock data
  List<String> allItems = [
    'Laptop1',
    'Laptop2',
    'Monitor',
    'Projector',
    'Tablet',
    'Phone',
    'Printer',
  ];
  List<String> allEmployees = [
    'Adam Luis (001)',
    'Yash Yash (NFI0109)',
    'CH (16-252)',
    'Alice Smith (002)',
  ];

  // Requests: status = pending/approved/rejected/allocated/returned
  List<Map<String, dynamic>> requests = [
    {
      'item': 'Laptop1',
      'employee': 'Adam Luis (001)',
      'from': DateTime(2025, 6, 18),
      'to': DateTime(2025, 6, 25),
      'status': 'pending',
      'date': DateTime(2025, 6, 18),
    },
    {
      'item': 'Monitor',
      'employee': 'Yash Yash (NFI0109)',
      'from': DateTime(2025, 6, 16),
      'to': DateTime(2025, 6, 20),
      'status': 'allocated',
      'date': DateTime(2025, 6, 16),
    },
    {
      'item': 'Tablet',
      'employee': 'Alice Smith (002)',
      'from': DateTime(2025, 6, 15),
      'to': DateTime(2025, 6, 19),
      'status': 'returned',
      'date': DateTime(2025, 6, 15),
    },
  ];

  int tabIndex = 0; // 0 = Request, 1 = Allocation, 2 = Return
  String searchQuery = '';
  Map<String, dynamic> filter = {};

  // For file picking in return dialog
  List<PlatformFile> returnFiles = [];

  // --- Filtering ---
  List<Map<String, dynamic>> get filteredRequests {
    final filtered = requests.where((req) {
      if (tabIndex == 0 && req['status'] == 'pending') return true;
      if (tabIndex == 1 && req['status'] == 'allocated') return true;
      if (tabIndex == 2 && req['status'] == 'issued') return true;
      return false;
    }).toList();
    if (searchQuery.isNotEmpty) {
      return filtered
          .where((req) =>
              req['item'].toLowerCase().contains(searchQuery.toLowerCase()) ||
              req['employee'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request and Allocations', style: TextStyle(color: kBlack)),
        iconTheme: const IconThemeData(color: kBlack),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search, Filter, Create
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search, color: kBlack),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kBlack),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kBlack, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: kBlack),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: kBlack),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter',
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: kBlack),
                  label: const Text('Create', style: TextStyle(color: kBlack)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kBlack,
                    side: const BorderSide(color: kBlack),
                  ),
                  onPressed: _showCreateDialog,
                ),
              ],
            ),
          ),
          // Toggle Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _toggleButton('Request', 0),
                _toggleButton('Allocation', 1),
                _toggleButton('Return', 2),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 10),
          // Cards List
          Expanded(
            child: ListView.builder(
              itemCount: filteredRequests.length,
              itemBuilder: (context, idx) {
                final req = filteredRequests[idx];
                if (tabIndex == 0) return _requestCard(req);
                if (tabIndex == 1) return _allocationCard(req);
                return _returnCard(req);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, int idx) {
    final isActive = tabIndex == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tabIndex = idx),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Request Card ---
  Widget _requestCard(Map<String, dynamic> req) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: ListTile(
        title: Text(req['item'], style: const TextStyle(color: kBlack, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For: ${req['employee']}', style: const TextStyle(color: kBlack)),
            Text(
              'Duration: ${DateFormat('yyyy-MM-dd').format(req['from'])} to ${DateFormat('yyyy-MM-dd').format(req['to'])}',
              style: const TextStyle(color: kBlack),
            ),
            Text('Requested on: ${DateFormat('yyyy-MM-dd').format(req['date'])}', style: const TextStyle(color: kBlack)),
          ],
        ),
        trailing: Icon(Icons.hourglass_top, color: Colors.orange[800]),
      ),
    );
  }

  // --- Allocation Card ---
  Widget _allocationCard(Map<String, dynamic> req) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: ListTile(
        title: Text(req['item'], style: const TextStyle(color: kBlack, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For: ${req['employee']}', style: const TextStyle(color: kBlack)),
            Text(
              'Duration: ${DateFormat('yyyy-MM-dd').format(req['from'])} to ${DateFormat('yyyy-MM-dd').format(req['to'])}',
              style: const TextStyle(color: kBlack),
            ),
            Text('Requested on: ${DateFormat('yyyy-MM-dd').format(req['date'])}', style: const TextStyle(color: kBlack)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => _showAllocationPrompt(req, true),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _showAllocationPrompt(req, false),
            ),
          ],
        ),
      ),
    );
  }

  // --- Return Card ---
  Widget _returnCard(Map<String, dynamic> req) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: ListTile(
        title: Text(req['item'], style: const TextStyle(color: kBlack, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For: ${req['employee']}', style: const TextStyle(color: kBlack)),
            Text(
              'Duration: ${DateFormat('yyyy-MM-dd').format(req['from'])} to ${DateFormat('yyyy-MM-dd').format(req['to'])}',
              style: const TextStyle(color: kBlack),
            ),
            Text('Issued on: ${DateFormat('yyyy-MM-dd').format(req['date'])}', style: const TextStyle(color: kBlack)),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _showReturnDialog(req),
          child: const Text('Return'),
        ),
      ),
    );
  }

  // --- Filter Dialog ---
  void _showFilterDialog() {
    // Simple placeholder (expand as needed)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter (Coming Soon)', style: TextStyle(color: kBlack)),
        content: const Text('Advanced filtering will be available here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: kBlack)),
          ),
        ],
      ),
    );
  }

  // --- Create Request Dialog ---
  void _showCreateDialog() {
    String? selectedItem;
    String? selectedEmployee;
    DateTime? fromDate;
    DateTime? toDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          return AlertDialog(
            title: const Text('Create Asset Request', style: TextStyle(color: kBlack)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownSearch<String>(
                    items: allItems,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Item",
                        labelStyle: TextStyle(color: kBlack),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    onChanged: (val) => setLocalState(() => selectedItem = val),
                    selectedItem: selectedItem,
                  ),
                  const SizedBox(height: 10),
                  DropdownSearch<String>(
                    items: allEmployees,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Employee",
                        labelStyle: TextStyle(color: kBlack),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    onChanged: (val) => setLocalState(() => selectedEmployee = val),
                    selectedItem: selectedEmployee,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fromDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setLocalState(() => fromDate = picked);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              fromDate != null ? DateFormat('yyyy-MM-dd').format(fromDate!) : 'Select Date',
                              style: const TextStyle(color: kBlack),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: toDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setLocalState(() => toDate = picked);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              toDate != null ? DateFormat('yyyy-MM-dd').format(toDate!) : 'Select Date',
                              style: const TextStyle(color: kBlack),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: kBlack)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (selectedItem == null || selectedEmployee == null || fromDate == null || toDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields.')),
                    );
                    return;
                  }
                  setState(() {
                    requests.add({
                      'item': selectedItem!,
                      'employee': selectedEmployee!,
                      'from': fromDate!,
                      'to': toDate!,
                      'status': 'pending',
                      'date': DateTime.now(),
                    });
                  });
                  // await requestService.addRequest({
//   'item': selectedItem!,
//   'employee': selectedEmployee!,
//   'from': fromDate!,
//   'to': toDate!,
//   'status': 'pending',
//   'date': DateTime.now(),
// });
// await _loadRequests();

                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        });
      },
    );
  }

  // --- Allocation Prompt ---
  void _showAllocationPrompt(Map<String, dynamic> req, bool approve) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          approve ? 'Approve Request' : 'Cancel Request',
          style: const TextStyle(color: kBlack),
        ),
        content: Text(
          approve
              ? 'Do you want to issue the item?'
              : 'Are you sure you want to cancel the request?',
          style: const TextStyle(color: kBlack),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: kBlack)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: approve ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (approve) {
                  req['status'] = 'issued';
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item has been allocated.')),
                  );
                } else {
                  req['status'] = 'rejected';
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request has been cancelled.')),
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // --- Return Dialog ---
  void _showReturnDialog(Map<String, dynamic> req) {
    String? condition;
    List<PlatformFile> files = [];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          Future<void> pickFiles() async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['jpg', 'jpeg', 'png'],
            );
            if (result != null) {
              setLocalState(() {
                files = result.files;
              });
              // final requestId = req['id'];
// await requestService.updateRequestStatus(requestId, 'returned');
// await _loadRequests();

            }
          }

          Widget filePreview(PlatformFile file) {
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Image.file(
                File(file.path!),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            );
          }

          return AlertDialog(
            title: const Text('Return Asset', style: TextStyle(color: kBlack)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: condition,
                    items: ['Good', 'Moderate', 'Damaged']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setLocalState(() => condition = val),
                    decoration: const InputDecoration(labelText: 'Condition'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: kBlack),
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Photo(s)'),
                    onPressed: pickFiles,
                  ),
                  if (files.isNotEmpty)
                    Wrap(
                      children: files.map(filePreview).toList(),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: kBlack)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (condition == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select condition.')),
                    );
                    return;
                  }
                  setState(() {
                    req['status'] = 'returned';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item has been returned.')),
                  );
                },
                child: const Text('Done'),
              ),
            ],
          );
        });
      },
    );
  }
}

