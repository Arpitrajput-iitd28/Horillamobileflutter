// lib/asset_batches.dart
import 'package:flutter/material.dart';
// Import the centralized AssetBatch model and kMaroon constant
import 'asset_batch.dart'; 
import 'create_batch_dialog.dart'; 
import 'edit_batch_dialog.dart';   

// Uncomment these imports when you are ready to use the API integration
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// (Note: kMaroon and AssetBatch class definition are now removed from here, as they are imported)


class AssetBatches extends StatefulWidget {
  const AssetBatches({Key? key}) : super(key: key);

  @override
  State<AssetBatches> createState() => _AssetBatchesPageState();
}

class _AssetBatchesPageState extends State<AssetBatches> {
  List<AssetBatch> batches = [];
  String searchQuery = '';

  // // Uncomment these variables when you are ready to use the API integration
  // bool isLoading = false;
  // String? errorMessage;

  // // Uncomment and replace with your actual API Base URL when ready for API integration
  // final String _apiBaseUrl = 'https://your-api-endpoint.com/api/v1';

  // // --- Internet Connectivity Check (Uncomment when ready for API integration) ---
  // Future<bool> _checkInternetConnectivity() async { /* ... same as before ... */ }
  // // --- API Calls (Uncomment and implement when ready for API integration) ---
  // // Future<void> _fetchBatchesFromApi() async { /* ... same as before ... */ }
  // // Future<void> _createBatchViaApi(AssetBatch newBatch) async { /* ... same as before ... */ }
  // // Future<void> _updateBatchViaApi(AssetBatch updatedBatch) async { /* ... same as before ... */ }
  // // Future<void> _deleteBatchViaApi(String batchId) async { /* ... same as before ... */ }
  // // void _showApiErrorSnackBar(String message) { /* ... same as before ... */ }

  // --- Initial Mock Data (Default Behavior) ---
  void _loadInitialMockData() {
    batches = [
      AssetBatch(id: 'mock_1', batchNo: 'GS-TAP-2025-012', title: 'Android Tablets', assets: []),
      AssetBatch(id: 'mock_2', batchNo: 'GS-LAP-MI-007', title: 'None', assets: ['Mi Notebook']),
      AssetBatch(
        id: 'mock_3',
        batchNo: 'GS-LAP-ASUS-003',
        title: 'None',
        assets: [
          'ASUS Zenbook',
          'ASUS Vivobook',
          'ASUS ROG',
          'ASUS TUF',
          'ASUS ExpertBook',
          'ASUS Chromebook'
        ],
      ),
      AssetBatch(
        id: 'mock_4',
        batchNo: 'GS-LAP-AVT-002',
        title: 'None',
        assets: ['AVITA LIBER', 'AVITA PURA', 'AVITA ESSENTIAL', 'AVITA ADMIROR', 'AVITA MAGUS'],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadInitialMockData(); // Default: Load mock data
    // // Uncomment the line below and comment the above line to switch to API fetching
    // // _fetchBatchesFromApi();
  }

  // Get filtered batches based on search query
  List<AssetBatch> get filteredBatches {
    return batches.where((batch) {
      final batchNoLower = batch.batchNo.toLowerCase();
      final titleLower = batch.title.toLowerCase();
      final queryLower = searchQuery.toLowerCase();
      return batchNoLower.contains(queryLower) || titleLower.contains(queryLower);
    }).toList();
  }

  // --- Show Create Dialog ---
  void _showCreateBatchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateBatchDialog(
          currentBatches: batches, // Pass existing batches for validation
          onSave: (newBatch) {
            setState(() {
              batches.add(newBatch); // Add the new batch to the main state
            });
            // // Uncomment and use API create when ready
            // // _createBatchViaApi(newBatch);
          },
        );
      },
    );
  }

  // --- Show Edit Dialog ---
  void _showEditBatchDialog(AssetBatch batchToEdit) {
    showDialog(
      context: context,
      builder: (context) {
        return EditBatchDialog(
          initialBatch: batchToEdit, // Pass the specific batch to be edited
          onSave: (updatedBatch) {
            setState(() {
              // Find the index of the batch to update and replace it
              final index = batches.indexWhere((b) => b.batchNo == updatedBatch.batchNo);
              if (index != -1) {
                batches[index] = updatedBatch;
              }
            });
            // // Uncomment and use API update when ready
            // // _updateBatchViaApi(updatedBatch);
          },
        );
      },
    );
  }

  // --- Delete Batch Function ---
  void _deleteBatch(AssetBatch batchToDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Batch', style: TextStyle(color: kMaroon)),
        content: Text('Do you really want to delete batch "${batchToDelete.batchNo}"?',
            style: const TextStyle(color: kMaroon)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
            onPressed: () {
              // --- Local (Mock) Data Update ---
              setState(() {
                batches.removeWhere((batch) => batch.batchNo == batchToDelete.batchNo);
              });
              // // --- Uncomment and use _deleteBatchViaApi when ready for API ---
              // // if (batchToDelete.id == null) {
              // //   // This scenario should be handled if IDs are strictly from API
              // //   // _showApiErrorSnackBar('Cannot delete: Batch ID is missing.');
              // //   Navigator.pop(context);
              // //   return;
              // // }
              // // await _deleteBatchViaApi(batchToDelete.id!);
              // // -------------------------------------------------------------

              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // --- Function to remove an individual asset from a batch ---
  void _removeAssetFromBatch(AssetBatch batch, String assetToRemove) {
    setState(() {
      final index = batches.indexWhere((b) => b.batchNo == batch.batchNo);
      if (index != -1) {
        // Create a new list for assets to ensure Flutter detects the change and rebuilds.
        final updatedAssets = List<String>.from(batches[index].assets)..remove(assetToRemove);
        // Replace the old batch object with a new one containing updated assets.
        batches[index] = AssetBatch(
          id: batches[index].id,
          batchNo: batches[index].batchNo,
          title: batches[index].title,
          assets: updatedAssets,
        );

        // // --- Uncomment and use API update when ready ---
        // // final updatedBatch = batches[index];
        // // _updateBatchViaApi(updatedBatch);
        // // --------------------------------------------------
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredBatches; // Get the list of batches filtered by search query

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Asset Batches', style: TextStyle(color: kMaroon, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: kMaroon),
                    decoration: InputDecoration(
                      hintText: 'Search',
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
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Create Batch', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _showCreateBatchDialog, // Calls the dedicated create dialog
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black26),
          // --- Conditional UI for Loading/Error (Uncomment only when using API integration) ---
          // isLoading
          //     ? const Expanded(
          //         child: Center(
          //           child: CircularProgressIndicator(color: kMaroon),
          //         ),
          //       )
          //     : errorMessage != null
          //         ? Expanded(
          //             child: Center(
          //               child: Padding(
          //                 padding: const EdgeInsets.all(16.0),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     const Icon(Icons.error_outline, color: Colors.red, size: 40),
          //                     const SizedBox(height: 10),
          //                     Text(
          //                       errorMessage!,
          //                       textAlign: TextAlign.center,
          //                       style: const TextStyle(color: Colors.red, fontSize: 16),
          //                     ),
          //                     const SizedBox(height: 10),
          //                     ElevatedButton(
          //                       onPressed: _fetchBatchesFromApi, // Retry API call
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor: kMaroon,
          //                         foregroundColor: Colors.white,
          //                       ),
          //                       child: const Text('Retry'),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           )
          //         : // This is the default branch when not loading or error
          Expanded(
            child: filtered.isEmpty // Display message if no batches or no search results
                ? Center(
                    child: Text(
                      searchQuery.isEmpty ? 'No asset batches available.' : 'No matching batches found.',
                      style: const TextStyle(color: kMaroon, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final batch = filtered[idx];
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
                                  batch.batchNo,
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
                                  batch.title,
                                  style: const TextStyle(color: kMaroon),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (batch.assets.isEmpty)
                                    const Text('No assets in this batch.',
                                        style: TextStyle(color: kMaroon)),
                                  ...List.generate(batch.assets.length, (assetIdx) {
                                    final asset = batch.assets[assetIdx];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.devices_other, color: kMaroon, size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              asset,
                                              style: const TextStyle(color: kMaroon, fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                                            onPressed: () => _removeAssetFromBatch(batch, asset),
                                            tooltip: 'Remove asset',
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                  // --- Action Buttons for Each Batch ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                                        label: const Text('Edit Batch', style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kMaroon,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () => _showEditBatchDialog(batch), // Call the dedicated edit dialog
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                                        label: const Text('Delete Batch', style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () => _deleteBatch(batch),
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
          ),
        ],
      ),
    );
  }
}
