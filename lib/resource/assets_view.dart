import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Re-enabled import
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // === Asset View API Service ===
// class AssetViewService {
//   static const String baseUrl = 'https://yourapi.com/assets';

//   // Fetch all categories and assets
//   Future<List<Map<String, dynamic>>> fetchCategories() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return List<Map<String, dynamic>>.from(data);
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

//   // Add a new asset (to a category)
//   Future<void> addAsset(String category, Map<String, dynamic> asset) async {
//     final url = '$baseUrl/$category/assets';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(asset),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add asset');
//     }
//   }

//   // Add a new category
//   Future<void> addCategory(String categoryName, Map<String, dynamic> firstAsset) async {
//     final url = '$baseUrl';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': categoryName,
//         'assets': [firstAsset],
//       }),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add category');
//     }
//   }

//   // Edit asset
//   Future<void> editAsset(String category, String assetId, Map<String, dynamic> updatedAsset) async {
//     final url = '$baseUrl/$category/assets/$assetId';
//     final response = await http.put(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(updatedAsset),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to update asset');
//     }
//   }

//   // Archive asset
//   Future<void> archiveAsset(String category, String assetId) async {
//     final url = '$baseUrl/$category/assets/$assetId/archive';
//     final response = await http.post(Uri.parse(url));
//     if (response.statusCode != 200) {
//       throw Exception('Failed to archive asset');
//     }
//   }

//   // Delete asset
//   Future<void> deleteAsset(String category, String assetId) async {
//     final url = '$baseUrl/$category/assets/$assetId';
//     final response = await http.delete(Uri.parse(url));
//     if (response.statusCode != 200 && response.statusCode != 204) {
//       throw Exception('Failed to delete asset');
//     }
//   }
// }


// Define your primary color
const Color kMaroon = Color(0xFF800000);

class AssetsViewPage extends StatefulWidget {
  const AssetsViewPage({Key? key}) : super(key: key);

  @override
  State<AssetsViewPage> createState() => _AssetsViewPageState();
}

class _AssetsViewPageState extends State<AssetsViewPage> {
  // Initial data for categories and assets
  // final AssetViewService assetViewService = AssetViewService();
// List<Map<String, dynamic>> categories = []; // Will be loaded from API

// @override
// void initState() {
//   super.initState();
//   // _loadCategories();
// }

// Future<void> _loadCategories() async {
//   try {
//     final data = await assetViewService.fetchCategories();
//     setState(() {
//       categories = data;
//     });
//   } catch (e) {
//     // Handle error (show snackbar, etc.)
//   }
// }

  List<Map<String, dynamic>> categories = [
    {
      'name': 'Laptops',
      'assets': [
        {
          'asset': 'Google Pixelbook Go',
          'status': 'In use',
          'trackingId': 'LPT0039',
          'batchNo': 'LPB002',
        },
        {
          'asset': 'Microsoft Surface Laptop 4',
          'status': 'Not-Available',
          'trackingId': 'LPT0038',
          'batchNo': 'LPB002',
        },
        {
          'asset': 'Panasonic Toughbook 55',
          'status': 'Available',
          'trackingId': 'LPT0037',
          'batchNo': 'LPB002',
        },
      ],
    },
    {
      'name': 'Phones',
      'assets': [
        {
          'asset': 'iPhone 14',
          'status': 'Available',
          'trackingId': 'PHN0012',
          'batchNo': 'PHB001',
        },
      ],
    },
    {
      'name': 'Headphones',
      'assets': [],
    },
    {
      'name': 'Bags',
      'assets': [],
    },
    {
      'name': 'Camera',
      'assets': [],
    },
    {
      'name': 'Mouse',
      'assets': [],
    },
    {
      'name': 'Car',
      'assets': [],
    },
    {
      'name': 'Computers',
      'assets': [],
    },
  ];

  String searchQuery = ''; // Stores the current search query
  String filterStatus = 'All'; // Stores the current filter status

  // --- Computed Property for Filtered Categories ---
  List<Map<String, dynamic>> get filteredCategories {
    return categories.map((category) {
      final assets = (category['assets'] as List<dynamic>).where((asset) {
        final assetMap = asset as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
        final matchesSearch = searchQuery.isEmpty ||
            assetMap['asset'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            assetMap['trackingId'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            assetMap['batchNo'].toLowerCase().contains(searchQuery.toLowerCase());
        final matchesStatus = filterStatus == 'All' || assetMap['status'] == filterStatus;
        return matchesSearch && matchesStatus;
      }).toList();
      return {
        'name': category['name'],
        'assets': assets,
      };
    }).where((category) => (category['assets'] as List).isNotEmpty || searchQuery.isNotEmpty || filterStatus != 'All').toList();
    // Only show categories that have assets after filtering, or if search/filter is active
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets View', style: TextStyle(color: kMaroon)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kMaroon),
        elevation: 1, // Adds a subtle shadow to the app bar
      ),
      body: Column(
        children: [
          // --- Search, Filter, Create Section ---
          Container(
            color: kMaroon.withOpacity(0.08), // Light maroon background
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search assets...',
                      prefixIcon: const Icon(Icons.search, color: kMaroon),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                // Filter Button
                IconButton(
                  icon: const Icon(Icons.filter_list, color: kMaroon, size: 28),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter by Status',
                ),
                const SizedBox(width: 8),
                // Create Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Create', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMaroon, // Button background color
                    foregroundColor: Colors.white, // Text and icon color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _showCreateDialog,
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 10), // Separator line

          // --- Expandable Category List ---
          Expanded(
            child: ListView(
              // Check if any category has assets after filtering
              children: filteredCategories.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            'No assets or categories match your search/filter criteria.',
                            style: TextStyle(color: kMaroon, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ]
                  : filteredCategories.map((category) {
                      final assets = category['assets'] as List<dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: kMaroon.withOpacity(0.1), width: 1),
                        ),
                        child: ExpansionTile(
                          key: PageStorageKey<String>(category['name']),
                          title: Row(
                            children: [
                              Text(
                                category['name'],
                                style: const TextStyle(color: kMaroon, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade700,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  '${assets.length}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            // Display message if no assets in this category after filtering
                            if (assets.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No assets in this category match the current filter/search.',
                                  style: TextStyle(color: kMaroon),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                            // Table of assets with horizontal scrolling
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: DataTable(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kMaroon.withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    columnSpacing: 25.0, // Space between columns
                                    dataRowMinHeight: 48.0,
                                    dataRowMaxHeight: 60.0,
                                    columns: const [
                                      DataColumn(label: Text('Asset', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Status', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Tracking ID', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Batch No', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Actions', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold))),
                                    ],
                                    rows: assets.map<DataRow>((asset) {
                                      final currentAsset = asset as Map<String, dynamic>;
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(currentAsset['asset'], style: const TextStyle(color: kMaroon))),
                                          DataCell(Text(currentAsset['status'], style: const TextStyle(color: kMaroon))),
                                          DataCell(Text(currentAsset['trackingId'], style: const TextStyle(color: kMaroon))),
                                          DataCell(Text(currentAsset['batchNo'], style: const TextStyle(color: kMaroon))),
                                          DataCell(Row(
                                            mainAxisSize: MainAxisSize.min, // Prevents row from expanding too much
                                            children: [
                                              // Edit Button
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                                onPressed: () {
                                                  _showEditAssetDialog(category['name'], currentAsset);
                                                },
                                                tooltip: 'Edit Asset',
                                              ),
                                              // Archive Button
                                              IconButton(
                                                icon: const Icon(Icons.archive, color: Colors.orange),
                                                onPressed: () {
                                                  _archiveAsset(category['name'], currentAsset);
                                                },
                                                tooltip: 'Archive Asset',
                                              ),
                                              // Delete Button
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () {
                                                  _deleteAsset(category['name'], currentAsset);
                                                },
                                                tooltip: 'Delete Asset',
                                              ),
                                            ],
                                          )),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Dialog Function ---
  void _showFilterDialog() {
    String localStatus = filterStatus; // Local state for the dialog

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Assets by Status', style: TextStyle(color: kMaroon)),
          content: DropdownButtonFormField<String>(
            value: localStatus,
            items: ['All', 'Available', 'In use', 'Not-Available']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (val) {
              setState(() { // Using setState here to update localStatus within the dialog
                localStatus = val ?? 'All';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filterStatus = localStatus; // Update global filter status
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Apply', style: TextStyle(color: kMaroon)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  filterStatus = 'All'; // Clear filter
                });
                Navigator.pop(context);
              },
              child: const Text('Clear', style: TextStyle(color: kMaroon)),
            ),
          ],
        );
      },
    );
  }

  // --- Create Dialog Function ---
  void _showCreateDialog() {
    String? selectedCategory;
    bool isNewCategory = false;
    String newCategoryName = '';
    String assetName = '';
    String trackingId = '';
    String batchNo = '';
    String status = 'Available';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          // StatefulBuilder allows updating UI within the dialog
          return AlertDialog(
            title: const Text('Add Asset or Category', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures column takes minimum space
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isNewCategory,
                        onChanged: (val) => setLocalState(() => isNewCategory = val ?? false),
                        activeColor: kMaroon,
                      ),
                      const Text('Add New Category', style: TextStyle(color: kMaroon)),
                    ],
                  ),
                  if (isNewCategory)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'New Category Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => newCategoryName = val,
                      ),
                    )
                  else
                    // Reverted to DropdownSearch for category selection
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: DropdownSearch<String>(
                        items: categories.map((c) => c['name'] as String).toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Existing Category",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          // Added menuProps for more explicit styling, though unlikely to fix the bool-double error directly
                          menuProps: MenuProps(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        onChanged: (val) => setLocalState(() => selectedCategory = val),
                        selectedItem: selectedCategory, // Use selectedCategory as is
                      ),
                    ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Asset Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => assetName = val,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Tracking ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => trackingId = val,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Batch No',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => batchNo = val,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: status,
                    items: ['Available', 'In use', 'Not-Available']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setLocalState(() => status = val ?? 'Available'),
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMaroon,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // --- Validation ---
                  if (assetName.trim().isEmpty || trackingId.trim().isEmpty || batchNo.trim().isEmpty) {
                    _showSnackBar('Please fill all asset fields.', Colors.red);
                    return;
                  }
                  if (isNewCategory && newCategoryName.trim().isEmpty) {
                    _showSnackBar('Please enter a new category name.', Colors.red);
                    return;
                  }
                  if (!isNewCategory && selectedCategory == null) {
                    _showSnackBar('Please select an existing category.', Colors.red);
                    return;
                  }

                  setState(() {
                    if (isNewCategory) {
                      // Add new category and its first asset
                      categories.add({
                        'name': newCategoryName.trim(),
                        'assets': [
                          {
                            'asset': assetName.trim(),
                            'status': status,
                            'trackingId': trackingId.trim(),
                            'batchNo': batchNo.trim(),
                          }
                        ],
                      });
                      _showSnackBar('New category "${newCategoryName.trim()}" and asset added!', Colors.green);
                    } else {
                      // Add asset to existing category
                      final catIndex = categories.indexWhere((c) => c['name'] == selectedCategory);
                      if (catIndex != -1) {
                        (categories[catIndex]['assets'] as List).add({
                          'asset': assetName.trim(),
                          'status': status,
                          'trackingId': trackingId.trim(),
                          'batchNo': batchNo.trim(),
                        });
                        _showSnackBar('Asset added to "$selectedCategory"!', Colors.green);
                      }
                    }
                  });
                  // if (isNewCategory) {
//   await assetViewService.addCategory(newCategoryName.trim(), {
//     'asset': assetName.trim(),
//     'status': status,
//     'trackingId': trackingId.trim(),
//     'batchNo': batchNo.trim(),
//   });
// } else {
//   await assetViewService.addAsset(selectedCategory, {
//     'asset': assetName.trim(),
//     'status': status,
//     'trackingId': trackingId.trim(),
//     'batchNo': batchNo.trim(),
//   });
// }
// await _loadCategories();

                  Navigator.pop(context); // Close dialog
                },
                child: const Text('Done'),
              ),
            ],
          );
        });
      },
    );
  }

  // --- Edit Asset Dialog Function ---
  void _showEditAssetDialog(String categoryName, Map<String, dynamic> assetToEdit) {
    // Create copies to allow editing without directly modifying the original asset until confirmed
    String newAssetName = assetToEdit['asset'];
    String newTrackingId = assetToEdit['trackingId'];
    String newBatchNo = assetToEdit['batchNo'];
    String newStatus = assetToEdit['status'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          return AlertDialog(
            title: const Text('Edit Asset', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(text: newAssetName),
                    decoration: const InputDecoration(labelText: 'Asset Name', border: OutlineInputBorder()),
                    onChanged: (val) => newAssetName = val,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: TextEditingController(text: newTrackingId),
                    decoration: const InputDecoration(labelText: 'Tracking ID', border: OutlineInputBorder()),
                    onChanged: (val) => newTrackingId = val,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: TextEditingController(text: newBatchNo),
                    decoration: const InputDecoration(labelText: 'Batch No', border: OutlineInputBorder()),
                    onChanged: (val) => newBatchNo = val,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: newStatus,
                    items: ['Available', 'In use', 'Not-Available']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setLocalState(() => newStatus = val ?? 'Available'),
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMaroon,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (newAssetName.trim().isEmpty || newTrackingId.trim().isEmpty || newBatchNo.trim().isEmpty) {
                    _showSnackBar('Please fill all fields.', Colors.red);
                    return;
                  }

                  setState(() {
                    final cat = categories.firstWhere((c) => c['name'] == categoryName);
                    final assetList = cat['assets'] as List;
                    final index = assetList.indexOf(assetToEdit); // Find the original asset reference

                    if (index != -1) {
                      assetList[index] = { // Update the asset directly in the list
                        'asset': newAssetName.trim(),
                        'status': newStatus,
                        'trackingId': newTrackingId.trim(),
                        'batchNo': newBatchNo.trim(),
                      };
                      _showSnackBar('Asset updated successfully!', Colors.green);
                    }
                  });
                  // await assetViewService.editAsset(
//   categoryName,
//   assetToEdit['trackingId'], // Or use a real unique ID from your backend
//   {
//     'asset': newAssetName.trim(),
//     'status': newStatus,
//     'trackingId': newTrackingId.trim(),
//     'batchNo': newBatchNo.trim(),
//   },
// );
// await _loadCategories();

                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }


  // --- Delete Asset Function ---
  void _deleteAsset(String categoryName, Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset', style: TextStyle(color: kMaroon)),
        content: Text('Are you sure you want to delete "${asset['asset']}"?', style: const TextStyle(color: kMaroon)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                final cat = categories.firstWhere((c) => c['name'] == categoryName);
                (cat['assets'] as List).remove(asset);
                _showSnackBar('Asset deleted.', Colors.green);
              });
              // await assetViewService.deleteAsset(categoryName, asset['trackingId']);
// await _loadCategories();

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // --- Archive Asset Function ---
  void _archiveAsset(String categoryName, Map<String, dynamic> asset) {
    setState(() {
      final cat = categories.firstWhere((c) => c['name'] == categoryName);
      (cat['assets'] as List).remove(asset);
    });
    // await assetViewService.archiveAsset(categoryName, asset['trackingId']);
// await _loadCategories();

    _showSnackBar('Asset "${asset['asset']}" archived.', Colors.blue);
  }

  // --- Helper function to show Snackbars ---
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
