// lib/create_batch_dialog.dart
import 'package:flutter/material.dart';
import 'asset_batch.dart'; // Import centralized model and constants

class CreateBatchDialog extends StatefulWidget {
  final List<AssetBatch> currentBatches;
  final Function(AssetBatch newBatch) onSave;

  const CreateBatchDialog({
    Key? key,
    required this.currentBatches,
    required this.onSave,
  }) : super(key: key);

  @override
  _CreateBatchDialogState createState() => _CreateBatchDialogState();
}

class _CreateBatchDialogState extends State<CreateBatchDialog> {
  late TextEditingController _batchNoController;
  late TextEditingController _titleController;
  late TextEditingController _firstAssetController;

  @override
  void initState() {
    super.initState();
    _batchNoController = TextEditingController();
    _titleController = TextEditingController();
    _firstAssetController = TextEditingController();
  }

  @override
  void dispose() {
    _batchNoController.dispose();
    _titleController.dispose();
    _firstAssetController.dispose();
    super.dispose();
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
                    'Create New Asset Batch',
                    style: TextStyle(color: kMaroon, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _batchNoController,
                  decoration: InputDecoration(
                    labelText: 'Batch Number (e.g., GS-XYZ-001)',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: TextStyle(color: kMaroon),
                ),
                const SizedBox(height: 10),
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
                TextField(
                  controller: _firstAssetController,
                  decoration: InputDecoration(
                    labelText: 'First Asset (Optional)',
                    labelStyle: TextStyle(color: kMaroon),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kMaroon)),
                  ),
                  style: TextStyle(color: kMaroon),
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
                        final newBatchNo = _batchNoController.text.trim();
                        final newTitle = _titleController.text.trim();
                        final firstAsset = _firstAssetController.text.trim();

                        if (newBatchNo.isEmpty || newTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Batch Number and Title are required.')),
                          );
                          return;
                        }

                        if (widget.currentBatches.any((b) => b.batchNo.toLowerCase() == newBatchNo.toLowerCase())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Batch Number already exists!')),
                          );
                          return;
                        }

                        final newBatch = AssetBatch(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          batchNo: newBatchNo,
                          title: newTitle,
                          assets: firstAsset.isNotEmpty ? [firstAsset] : [],
                        );

                        widget.onSave(newBatch);
                        Navigator.pop(context);
                      },
                      child: const Text('Create'),
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