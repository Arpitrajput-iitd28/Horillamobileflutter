// lib/edit_batch_dialog.dart
import 'package:flutter/material.dart';
import 'asset_batch.dart'; // Import centralized model and constants

class EditBatchDialog extends StatefulWidget {
  final AssetBatch initialBatch;
  final Function(AssetBatch updatedBatch) onSave;

  const EditBatchDialog({
    Key? key,
    required this.initialBatch,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditBatchDialogState createState() => _EditBatchDialogState();
}

class _EditBatchDialogState extends State<EditBatchDialog> {
  late TextEditingController _titleController;
  late TextEditingController _assetNameController;
  late FocusNode _assetNameFocusNode;

  late List<String> _currentAssets;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialBatch.title);
    _assetNameController = TextEditingController();
    _assetNameFocusNode = FocusNode();
    _currentAssets = List.from(widget.initialBatch.assets);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _assetNameController.dispose();
    _assetNameFocusNode.dispose();
    super.dispose();
  }

  void _addAsset() {
    final asset = _assetNameController.text.trim();
    if (asset.isNotEmpty) {
      if (!_currentAssets.contains(asset)) {
        setState(() {
          _currentAssets.add(asset);
          _assetNameController.text = '';
        });
        _assetNameFocusNode.requestFocus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset already exists in this list!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset name cannot be empty!')),
      );
    }
  }

  void _removeAsset(String assetToRemove) {
    setState(() {
      _currentAssets.remove(assetToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog( // Changed from AlertDialog to Dialog
      backgroundColor: Colors.transparent, // Make Dialog background transparent
      child: Material( // Wrap content in Material for proper styling and elevation
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        elevation: 24, // Add some elevation for shadow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Essential for Column inside SingleChildScrollView
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Batch: ${widget.initialBatch.batchNo}',
                    style: TextStyle(color: kMaroon, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Batch Title',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: TextStyle(color: kMaroon),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _assetNameController,
                        focusNode: _assetNameFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Add New Asset',
                          labelStyle: TextStyle(color: kMaroon),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                        ),
                        style: TextStyle(color: kMaroon),
                        onSubmitted: (_) => _addAsset(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: kMaroon),
                      onPressed: _addAsset,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_currentAssets.isNotEmpty)
                  SizedBox(
                    height: 120, // Fixed height for assets list
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _currentAssets.length,
                      itemBuilder: (context, idx) {
                        final asset = _currentAssets[idx];
                        return ListTile(
                          title: Text(asset, style: TextStyle(color: kMaroon)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeAsset(asset),
                          ),
                        );
                      },
                    ),
                  ),
                if (_currentAssets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('No assets in this batch.', style: TextStyle(color: Colors.grey)),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: kMaroon)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kMaroon, foregroundColor: Colors.white),
                      onPressed: () {
                        final updatedTitle = _titleController.text.trim();
                        if (updatedTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Batch Title cannot be empty.')),
                          );
                          return;
                        }

                        final updatedBatch = AssetBatch(
                          id: widget.initialBatch.id,
                          batchNo: widget.initialBatch.batchNo,
                          title: updatedTitle,
                          assets: List<String>.from(_currentAssets),
                        );

                        widget.onSave(updatedBatch);
                        Navigator.pop(context);
                      },
                      child: const Text('Save Changes'),
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