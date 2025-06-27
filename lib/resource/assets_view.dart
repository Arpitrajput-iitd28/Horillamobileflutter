// lib/assets_view_single_file.dart (or replace content of your main.dart)
import 'package:flutter/material.dart';
// Uncomment these imports when you are ready to use the API integration
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// =============================================================================
// SECTION 1: CENTRALIZED CONSTANTS AND DATA MODELS
// =============================================================================

// === Centralized Constants ===
const Color kMaroon = Color(0xFF800000);

// === Centralized AssetBatch Model (Represents a Category) ===
class AssetBatch {
  final String? id; // For API interaction, optional for mock data
  final String batchNo; // Unique identifier for the batch/category
  final String title; // The display name for the category

  AssetBatch({
    this.id,
    required this.batchNo,
    required this.title,
  });

  // // Uncomment this section when ready for API integration
  // // Factory constructor to create an AssetBatch instance from a JSON map.
  // factory AssetBatch.fromJson(Map<String, dynamic> json) {
  //   return AssetBatch(
  //     id: json['id'] as String?,
  //     batchNo: json['batchNo'] as String,
  //     title: json['title'] as String,
  //   );
  // }

  // // Uncomment this section when ready for API integration
  // // Converts an AssetBatch instance to a JSON map, typically for sending to an API.
  // Map<String, dynamic> toJson() {
  //   return {
  //     'batchNo': batchNo,
  //     'title': title,
  //   };
  // }
}

// === Centralized Asset Model (Represents an Individual Asset Item) ===
class Asset {
  final String? id; // For API interaction, optional for mock data
  final String name; // Name of the asset (e.g., "ASUS Zenbook")
  final String trackingId; // Unique tracking ID for the asset
  final String batchNo; // Links this asset to its parent AssetBatch (category)
  final String status; // 'Available', 'Borrowed'

  Asset({
    this.id,
    required this.name,
    required this.trackingId,
    required this.batchNo,
    required this.status,
  });

  // // Uncomment this section when ready for API integration
  // // Factory constructor to create an Asset instance from a JSON map.
  // factory Asset.fromJson(Map<String, dynamic> json) {
  //   return Asset(
  //     id: json['id'] as String?,
  //     name: json['name'] as String,
  //     trackingId: json['trackingId'] as String,
  //     batchNo: json['batchNo'] as String,
  //     status: json['status'] as String,
  //   );
  // }

  // // Uncomment this section when ready for API integration
  // // Converts an Asset instance to a JSON map.
  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'trackingId': trackingId,
  //     'batchNo': batchNo,
  //     'status': status,
  //   };
  // }
}


// =============================================================================
// SECTION 2: CREATE/EDIT ASSET DIALOG
// =============================================================================

// Define callback types for clarity
typedef OnSaveAssetCallback = void Function(AssetBatch? newCategory, Asset newAsset);

class CreateEditAssetDialog extends StatefulWidget {
  final List<AssetBatch> existingCategories; // List of categories for selection
  final OnSaveAssetCallback onSave; // Callback to return the new/updated asset

  const CreateEditAssetDialog({
    Key? key,
    required this.existingCategories,
    required this.onSave,
  }) : super(key: key);

  @override
  _CreateEditAssetDialogState createState() => _CreateEditAssetDialogState();
}

class _CreateEditAssetDialogState extends State<CreateEditAssetDialog> {
  // --- Form Controllers ---
  late TextEditingController _newBatchNoController;
  late TextEditingController _newCategoryTitleController;
  late TextEditingController _assetNameController;
  late TextEditingController _trackingIdController;

  // --- Local State for Dialog Logic ---
  String? _selectedCategoryBatchNo; // Holds batchNo of selected existing category
  String _currentStatus = 'Available'; // Default asset status
  bool _isNewCategoryMode = true; // True for creating new category, false for adding to existing

  // Focus node for asset name for better UX
  late FocusNode _assetNameFocusNode;

  @override
  void initState() {
    super.initState();
    _newBatchNoController = TextEditingController();
    _newCategoryTitleController = TextEditingController();
    _assetNameController = TextEditingController();
    _trackingIdController = TextEditingController();
    _assetNameFocusNode = FocusNode();

    // If there are no existing categories, force new category mode
    if (widget.existingCategories.isEmpty) {
      _isNewCategoryMode = true;
    } else {
      // If there are existing categories, default to adding to existing
      _isNewCategoryMode = false;
      _selectedCategoryBatchNo = widget.existingCategories.first.batchNo;
    }
  }

  @override
  void dispose() {
    _newBatchNoController.dispose();
    _newCategoryTitleController.dispose();
    _assetNameController.dispose();
    _trackingIdController.dispose();
    _assetNameFocusNode.dispose();
    super.dispose();
  }

  // --- Utility Functions ---
  void _clearAssetFields() {
    _assetNameController.clear();
    _trackingIdController.clear();
    _currentStatus = 'Available'; // Reset to default status
  }

  void _onSavePressed() {
    // --- Validate Category (Batch) Information ---
    AssetBatch? newCategory;
    String finalBatchNo;

    if (_isNewCategoryMode) {
      // New category creation logic
      final batchNo = _newBatchNoController.text.trim();
      final categoryTitle = _newCategoryTitleController.text.trim();

      if (batchNo.isEmpty || categoryTitle.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New Category Batch Number and Title are required.')),
        );
        return;
      }
      if (widget.existingCategories.any((cat) => cat.batchNo.toLowerCase() == batchNo.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Batch Number already exists as a category.')),
        );
        return;
      }
      newCategory = AssetBatch(id: DateTime.now().millisecondsSinceEpoch.toString() + 'cat', batchNo: batchNo, title: categoryTitle);
      finalBatchNo = batchNo;
    } else {
      // Adding to existing category
      if (_selectedCategoryBatchNo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an existing category.')),
        );
        return;
      }
      finalBatchNo = _selectedCategoryBatchNo!;
    }

    // --- Validate Asset Information ---
    final assetName = _assetNameController.text.trim();
    final trackingId = _trackingIdController.text.trim();

    if (assetName.isEmpty || trackingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset Name and Tracking ID are required.')),
      );
      return;
    }

    // Create the new Asset object
    final newAsset = Asset(
      id: DateTime.now().millisecondsSinceEpoch.toString() + 'asset', // Unique ID for mock data
      name: assetName,
      trackingId: trackingId,
      batchNo: finalBatchNo, // Link to the chosen/new category
      status: _currentStatus,
    );

    // Call the parent's onSave callback
    widget.onSave(newCategory, newAsset);
    Navigator.pop(context); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Make Dialog background transparent
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
                    'Add Asset Item',
                    style: TextStyle(color: kMaroon, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Category Selection/Creation Toggle ---
                if (widget.existingCategories.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(
                        label: Text('New', style: TextStyle(color: _isNewCategoryMode ? Colors.white : kMaroon)),
                        selected: _isNewCategoryMode,
                        selectedColor: kMaroon,
                        onSelected: (bool selected) {
                          setState(() {
                            _isNewCategoryMode = selected;
                            if (_isNewCategoryMode) {
                              _selectedCategoryBatchNo = null; // Clear selection if switching to new category
                            }
                            _clearAssetFields(); // Clear asset fields on mode switch
                          });
                        },
                      ),
                      ChoiceChip(
                        label: Text('Existing', style: TextStyle(color: !_isNewCategoryMode ? Colors.white : kMaroon)),
                        selected: !_isNewCategoryMode,
                        selectedColor: kMaroon,
                        onSelected: (bool selected) {
                          setState(() {
                            _isNewCategoryMode = !selected;
                            if (!_isNewCategoryMode && widget.existingCategories.isNotEmpty) {
                              _selectedCategoryBatchNo = widget.existingCategories.first.batchNo; // Auto-select first
                            }
                            _clearAssetFields(); // Clear asset fields on mode switch
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 10),

                // --- New Category Fields (Conditional) ---
                if (_isNewCategoryMode) ...[
                  TextField(
                    controller: _newBatchNoController,
                    decoration: InputDecoration(
                      labelText: 'New Category Batch Number',
                      labelStyle: TextStyle(color: kMaroon),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                    ),
                    style: TextStyle(color: kMaroon),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _newCategoryTitleController,
                    decoration: InputDecoration(
                      labelText: 'New Category Title',
                      labelStyle: TextStyle(color: kMaroon),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                    ),
                    style: TextStyle(color: kMaroon),
                  ),
                  const SizedBox(height: 20),
                ],

                // --- Existing Category Dropdown (Conditional) ---
                if (!_isNewCategoryMode && widget.existingCategories.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryBatchNo,
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: TextStyle(color: kMaroon),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                    ),
                    items: widget.existingCategories.map((category) {
                      return DropdownMenuItem(
                        value: category.batchNo,
                        child: Text('${category.title} (${category.batchNo})', style: TextStyle(color: kMaroon)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryBatchNo = value;
                        // No need to clear asset fields here as we are staying within the same "Add asset to existing category" mode
                      });
                    },
                    dropdownColor: Colors.white,
                    style: TextStyle(color: kMaroon),
                  ),
                  const SizedBox(height: 20),
                ],
                if (!_isNewCategoryMode && widget.existingCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'No existing categories. Please create a new one.',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),

                // --- Asset Details Fields ---
                TextField(
                  controller: _assetNameController,
                  focusNode: _assetNameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Asset Name',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: TextStyle(color: kMaroon),
                  textInputAction: TextInputAction.next, // Go to next field on Enter
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _trackingIdController,
                  decoration: InputDecoration(
                    labelText: 'Tracking ID',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: TextStyle(color: kMaroon),
                  textInputAction: TextInputAction.done, // Done on Enter
                  onSubmitted: (_) => _onSavePressed(), // Trigger save on Enter if last field
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _currentStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: kMaroon),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Available', child: Text('Available', style: TextStyle(color: kMaroon))),
                    DropdownMenuItem(value: 'Borrowed', child: Text('Borrowed', style: TextStyle(color: kMaroon))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _currentStatus = value!;
                    });
                  },
                  dropdownColor: Colors.white,
                  style: TextStyle(color: kMaroon),
                ),
                const SizedBox(height: 20),

                // --- Action Buttons ---
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
                      child: const Text('Done'),
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
// SECTION 3: ASSETS VIEW PAGE
// =============================================================================

class AssetsViewPage extends StatefulWidget {
  const AssetsViewPage({Key? key}) : super(key: key);

  @override
  State<AssetsViewPage> createState() => _AssetsViewPageState();
}

class _AssetsViewPageState extends State<AssetsViewPage> {
  // State for the main page
  List<AssetBatch> _assetCategories = []; // Stores our categories/batches
  List<Asset> _allAssets = []; // Stores all individual asset items
  String _searchQuery = '';
  String _selectedFilterStatus = 'All'; // 'All', 'Available', 'Borrowed'

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
    _assetCategories = [
      AssetBatch(id: 'cat_1', batchNo: 'GS-TAP-2025-012', title: 'Android Tablets'),
      AssetBatch(id: 'cat_2', batchNo: 'GS-LAP-MI-007', title: 'Mi Laptops'),
      AssetBatch(id: 'cat_3', batchNo: 'GS-LAP-ASUS-003', title: 'ASUS Laptops'),
    ];

    _allAssets = [
      Asset(id: 'asset_1', name: 'Samsung Tab S8', trackingId: 'TABS8-001', batchNo: 'GS-TAP-2025-012', status: 'Available'),
      Asset(id: 'asset_2', name: 'Lenovo P11', trackingId: 'LENP11-001', batchNo: 'GS-TAP-2025-012', status: 'Borrowed'),
      Asset(id: 'asset_3', name: 'Mi Notebook Pro', trackingId: 'MINBP-001', batchNo: 'GS-LAP-MI-007', status: 'Available'),
      Asset(id: 'asset_4', name: 'Mi Gaming Laptop', trackingId: 'MIGL-001', batchNo: 'GS-LAP-MI-007', status: 'Available'),
      Asset(id: 'asset_5', name: 'ASUS Zenbook 14', trackingId: 'ASZ14-001', batchNo: 'GS-LAP-ASUS-003', status: 'Borrowed'),
      Asset(id: 'asset_6', name: 'ASUS ROG Strix', trackingId: 'ASROG-001', batchNo: 'GS-LAP-ASUS-003', status: 'Available'),
    ];
  }

  // --- Filtered and Searched Categories ---
  List<AssetBatch> get _filteredCategories {
    List<AssetBatch> filteredBySearch = _assetCategories.where((category) {
      final titleLower = category.title.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();

    // If a filter is applied to assets, we still show all matching categories,
    // but the assets shown *within* the expanded category will be filtered.
    return filteredBySearch;
  }

  // --- Show Create/Edit Asset Dialog ---
  void _showCreateEditAssetDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CreateEditAssetDialog(
          existingCategories: _assetCategories, // Pass existing categories for dropdown
          onSave: (newCategory, newAsset) {
            setState(() {
              if (newCategory != null) {
                // Add the new category to our list of categories
                _assetCategories.add(newCategory);
                // // Uncomment for API create category
                // // _createCategoryApi(newCategory);
              }
              // Add the new asset to our list of all assets
              _allAssets.add(newAsset);
              // // Uncomment for API create asset
              // // _createAssetApi(newAsset);
            });
          },
        );
      },
    );
  }

  // --- Delete Asset Function (Individual Asset) ---
  void _deleteAsset(String assetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Asset', style: TextStyle(color: kMaroon)),
        content: const Text('Do you really want to delete this asset?', style: TextStyle(color: kMaroon)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                _allAssets.removeWhere((asset) => asset.id == assetId);
              });
              // // Uncomment for API delete asset
              // // _deleteAssetApi(assetId);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // --- API Calls (Commented Out) ---
  // // Future<void> _fetchInitialDataFromApi() async { /* ... implementation for fetching categories and assets ... */ }
  // // Future<void> _createCategoryApi(AssetBatch newCategory) async { /* ... implementation ... */ }
  // // Future<void> _createAssetApi(Asset newAsset) async { /* ... implementation ... */ }
  // // Future<void> _deleteAssetApi(String assetId) async { /* ... implementation ... */ }
  // // Future<void> _updateAssetApi(Asset updatedAsset) async { /* ... implementation ... */ }
  // // void _showApiErrorSnackBar(String message) { /* ... implementation ... */ }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Assets View', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // --- Search and Filter Bar ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: kMaroon),
                    decoration: InputDecoration(
                      hintText: 'Search by Category Title',
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
                // Filter Button (Dropdown)
                DropdownButton<String>(
                  value: _selectedFilterStatus,
                  icon: const Icon(Icons.filter_list, color: kMaroon),
                  style: const TextStyle(color: kMaroon),
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilterStatus = newValue!;
                    });
                  },
                  items: <String>['All', 'Available', 'Borrowed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Asset', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _showCreateEditAssetDialog, // Opens the unified dialog
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black26),

          // --- Asset Categories List ---
          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty ? 'No asset categories available.' : 'No matching categories found.',
                      style: const TextStyle(color: kMaroon, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, idx) {
                      final category = _filteredCategories[idx];
                      // Get assets belonging to this category and apply status filter
                      final assetsInThisCategory = _allAssets.where(
                        (asset) => asset.batchNo == category.batchNo &&
                                    (_selectedFilterStatus == 'All' || asset.status == _selectedFilterStatus)
                      ).toList();

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
                                  category.title, // Display category title
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
                                  color: kMaroon.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${assetsInThisCategory.length} assets', // Show count of filtered assets
                                  style: const TextStyle(color: kMaroon),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            // Display assets within this expanded category
                            if (assetsInThisCategory.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _selectedFilterStatus == 'All'
                                      ? 'No assets in this category.'
                                      : 'No ${_selectedFilterStatus.toLowerCase()} assets in this category.',
                                  style: TextStyle(color: kMaroon.withOpacity(0.7)),
                                ),
                              ),
                            ...assetsInThisCategory.map((asset) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.label, color: kMaroon, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Name: ${asset.name}',
                                            style: const TextStyle(color: kMaroon, fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.qr_code, color: kMaroon, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Tracking ID: ${asset.trackingId}',
                                            style: const TextStyle(color: kMaroon, fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.category, color: kMaroon, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Batch No: ${asset.batchNo}',
                                            style: const TextStyle(color: kMaroon, fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          asset.status == 'Available' ? Icons.check_circle : Icons.timer_off,
                                          color: asset.status == 'Available' ? Colors.green : Colors.orange,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Status: ${asset.status}',
                                            style: TextStyle(
                                              color: asset.status == 'Available' ? Colors.green : Colors.orange,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // Delete individual asset button
                                        IconButton(
                                          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                                          onPressed: () => _deleteAsset(asset.id!),
                                          tooltip: 'Remove this asset',
                                        ),
                                      ],
                                    ),
                                    const Divider(color: Colors.black12, height: 20), // Separator for assets
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 10), // Space after last asset
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

// =============================================================================
// MAIN ENTRY POINT (example for demonstration, adjust as needed)
// =============================================================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AssetsViewPage(), // Your Assets View Page is the home screen
    );
  }
}