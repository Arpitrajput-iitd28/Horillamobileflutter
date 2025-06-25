import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // === Asset API Service ===
// class AssetService {
//   static const String baseUrl = 'https://yourapi.com/assets';

//   // Fetch all assets
//   Future<List<Map<String, dynamic>>> fetchAssets() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return List<Map<String, dynamic>>.from(data);
//     } else {
//       throw Exception('Failed to load assets');
//     }
//   }

//   // Add a new asset
//   Future<void> addAsset(Map<String, dynamic> asset) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(asset),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add asset');
//     }
//   }

//   // Update asset history (add new history point)
//   Future<void> updateAssetHistory(String assetId, Map<String, dynamic> historyPoint) async {
//     final url = '$baseUrl/$assetId/history';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(historyPoint),
//     );
//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception('Failed to update asset history');
//     }
//   }

//   // Archive or delete asset
//   Future<void> archiveAsset(String assetId) async {
//     final url = '$baseUrl/$assetId/archive';
//     final response = await http.post(Uri.parse(url));
//     if (response.statusCode != 200) {
//       throw Exception('Failed to archive asset');
//     }
//   }

//   Future<void> deleteAsset(String assetId) async {
//     final url = '$baseUrl/$assetId';
//     final response = await http.delete(Uri.parse(url));
//     if (response.statusCode != 200 && response.statusCode != 204) {
//       throw Exception('Failed to delete asset');
//     }
//   }
// }


const Color kMaroon = Color(0xFF800000);

void main() => runApp(const MaterialApp(
  home: AssetHistory(),
  debugShowCheckedModeBanner: false,
));

class AssetHistory extends StatefulWidget {
  const AssetHistory({Key? key}) : super(key: key);

  @override
  State<AssetHistory> createState() => _AssetHistoryPageState();
}

class _AssetHistoryPageState extends State<AssetHistory> {
  // final AssetService assetService = AssetService();
// List<Map<String, dynamic>> items = []; // Will be loaded from API

// @override
// void initState() {
//   super.initState();
//   // _loadAssets();
// }

// Future<void> _loadAssets() async {
//   try {
//     final data = await assetService.fetchAssets();
//     setState(() {
//       items = data;
//     });
//   } catch (e) {
//     // Handle error (show snackbar, etc.)
//   }
// }

  
  List<Map<String, dynamic>> items = [
    {
      'title': 'Laptop1',
      'trackingId': 'LPT0039',
      'batchNo': 'LPB002',
      'imagePath': null,
      'history': [
        {
          'borrower': 'John Doe',
          'borrowedOn': DateTime(2025, 6, 1),
          'condition': 'Good',
          'borrowerImage': null,
          'notes': [
            {'author': 'Admin', 'text': 'Returned on time', 'timestamp': DateTime(2025, 6, 10)},
            {'author': 'John Doe', 'text': 'No issues', 'timestamp': DateTime(2025, 6, 10)},
          ]
        },
        {
          'borrower': 'Alice Smith',
          'borrowedOn': DateTime(2025, 5, 15),
          'condition': 'Moderate',
          'borrowerImage': null,
          'notes': [],
        },
      ],
      'archived': false,
    },
    {
      'title': 'Phone1',
      'trackingId': 'PHN0012',
      'batchNo': 'PHB001',
      'imagePath': null,
      'history': [],
      'archived': false,
    },
  ];

  String searchQuery = '';

  List<Map<String, dynamic>> get filteredItems {
    return items.where((item) {
      if (item['archived'] == true) return false;
      return item['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['trackingId'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['batchNo'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void _showCreateDialog() {
    String title = '';
    String trackingId = '';
    String batchNo = '';
    String? imagePath;

    final titleController = TextEditingController();
    final trackingController = TextEditingController();
    final batchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          Future<void> pickImage() async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );
            if (result != null && result.files.isNotEmpty) {
              setLocalState(() => imagePath = result.files.first.path);
            }
          }

          return AlertDialog(
            title: const Text('Add New Item', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (val) => title = val,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: trackingController,
                    decoration: const InputDecoration(labelText: 'Tracking Number'),
                    onChanged: (val) => trackingId = val,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: batchController,
                    decoration: const InputDecoration(labelText: 'Batch Number'),
                    onChanged: (val) => batchNo = val,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: kMaroon.withOpacity(0.1),
                        backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
                        radius: 24,
                        child: imagePath == null
                            ? const Icon(Icons.image, color: kMaroon, size: 28)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: const Text('Upload Image', style: TextStyle(color: Colors.white)),
                        onPressed: pickImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: kMaroon)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
                onPressed: () {
                  if (title.trim().isEmpty || trackingId.trim().isEmpty || batchNo.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  setState(() {
                    items.add({
                      'title': title,
                      'trackingId': trackingId,
                      'batchNo': batchNo,
                      'imagePath': imagePath,
                      'history': [],
                      'archived': false,
                    });
                  });
                  // await assetService.addAsset({
//   'title': title,
//   'trackingId': trackingId,
//   'batchNo': batchNo,
//   'imagePath': imagePath, // Upload and use URL in production
//   'history': [],
//   'archived': false,
// });
// await _loadAssets();

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

  void _showAddHistoryPointDialog(int itemIndex) {
    String borrower = '';
    DateTime? borrowedOn;
    String condition = 'Good';
    String? borrowerImagePath;

    final borrowerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          Future<void> pickBorrowerImage() async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );
            if (result != null && result.files.isNotEmpty) {
              setLocalState(() => borrowerImagePath = result.files.first.path);
            }
          }

          return AlertDialog(
            title: const Text('Add History Point', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: borrowerController,
                    decoration: const InputDecoration(labelText: 'Borrower Name'),
                    onChanged: (val) => borrower = val,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Borrowed On:', style: TextStyle(color: kMaroon)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: borrowedOn ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setLocalState(() => borrowedOn = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: kMaroon),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              borrowedOn != null
                                  ? DateFormat('yyyy-MM-dd').format(borrowedOn!)
                                  : 'Select Date',
                              style: const TextStyle(color: kMaroon),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: kMaroon.withOpacity(0.1),
                        backgroundImage: borrowerImagePath != null ? FileImage(File(borrowerImagePath!)) : null,
                        radius: 24,
                        child: borrowerImagePath == null
                            ? const Icon(Icons.person, color: kMaroon, size: 28)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: const Text('Upload Image', style: TextStyle(color: Colors.white)),
                        onPressed: pickBorrowerImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: condition,
                    items: ['Good', 'Moderate', 'Damaged']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => condition = val ?? 'Good'),
                    decoration: const InputDecoration(labelText: 'Condition'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: kMaroon)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
                onPressed: () {
                  if (borrower.trim().isEmpty || borrowedOn == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  setState(() {
                    items[itemIndex]['history'].add({
                      'borrower': borrower,
                      'borrowedOn': borrowedOn,
                      'condition': condition,
                      'borrowerImage': borrowerImagePath,
                      'notes': [],
                    });
                  });
                  // final assetId = items[itemIndex]['trackingId']; // Or use a real unique ID from your backend
// await assetService.updateAssetHistory(assetId, {
//   'borrower': borrower,
//   'borrowedOn': borrowedOn.toIso8601String(),
//   'condition': condition,
//   'borrowerImage': borrowerImagePath, // Upload and use URL in production
//   'notes': [],
// });
// await _loadAssets();

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

  void _showNotesDialog(Map<String, dynamic> point) {
    String note = '';
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setLocalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Notes/Discussion', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      children: (point['notes'] as List)
                          .map<Widget>((n) => ListTile(
                                title: Text(n['text']),
                                subtitle: Text(
                                    '${n['author']} • ${DateFormat('yyyy-MM-dd – kk:mm').format(n['timestamp'])}'),
                              ))
                          .toList(),
                    ),
                  ),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'Add a note...'),
                    onChanged: (val) => note = val,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                    onPressed: () {
                      if (note.trim().isEmpty) return;
                      setState(() {
                        point['notes'].add({
                          'author': 'You',
                          'text': note,
                          'timestamp': DateTime.now(),
                        });
                      });
                      noteController.clear();
                      setLocalState(() {});
                    },
                    child: const Text('Add Note'),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void _archiveItem(int idx) {
    setState(() {
      items[idx]['archived'] = true;
    });
    // final assetId = items[idx]['trackingId'];
// await assetService.archiveAsset(assetId);
// await _loadAssets();

// await assetService.deleteAsset(assetId);
// await _loadAssets();

  }

  void _deleteItem(int idx) {
    setState(() {
      items.removeAt(idx);
    });
    // final assetId = items[idx]['trackingId'];
// await assetService.archiveAsset(assetId);
// await _loadAssets();

// await assetService.deleteAsset(assetId);
// await _loadAssets();

  }

  void _updateItem(int idx) {
    _showAddHistoryPointDialog(idx);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset History'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kMaroon),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search, Create
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
                    style: const TextStyle(color: kMaroon),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: kMaroon),
                  label: const Text('Create', style: TextStyle(color: kMaroon)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kMaroon,
                    side: const BorderSide(color: kMaroon),
                  ),
                  onPressed: () => _showCreateDialog(),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 10),
          // Cards
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final item = filtered[idx];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(14),
                    leading: CircleAvatar(
                      backgroundColor: kMaroon.withOpacity(0.1),
                      backgroundImage: item['imagePath'] != null
                          ? FileImage(File(item['imagePath']))
                          : null,
                      radius: 28,
                      child: item['imagePath'] == null
                          ? const Icon(Icons.image, color: kMaroon, size: 32)
                          : null,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            color: kMaroon,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tracking ID: ${item['trackingId']}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('History:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 8),
                              if ((item['history'] as List).isEmpty)
                                Text('No history available.', style: TextStyle(color: kMaroon)),
                              ...List.generate((item['history'] as List).length, (hIdx) {
                                final point = item['history'][hIdx];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Borrower: ${point['borrower']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, color: kMaroon),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Borrowed On: ${DateFormat('yyyy-MM-dd').format(point['borrowedOn'])}',
                                          style: const TextStyle(color: Colors.black87),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Condition: ${point['condition']}',
                                          style: const TextStyle(color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),
                                        if (point['borrowerImage'] != null)
                                          Image.file(
                                            File(point['borrowerImage']),
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        Row(
                                          children: [
                                            const Icon(Icons.comment, size: 18),
                                            TextButton(
                                              onPressed: () => _showNotesDialog(point),
                                              child: const Text('View/Add Notes' , style: TextStyle(color: Color.fromARGB(255, 150, 10, 0)),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 12),
                              // Action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.update, color: kMaroon),
                                    onPressed: () => _updateItem(idx),
                                    tooltip: 'Update',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.archive, color: kMaroon),
                                    onPressed: () => _archiveItem(idx),
                                    tooltip: 'Archive',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: kMaroon),
                                    onPressed: () => _deleteItem(idx),
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                            ],
                          ),
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
}
