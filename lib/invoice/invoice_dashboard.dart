import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

const Color kMaroon = Color(0xFF800000);

class InvoiceDashboard extends StatefulWidget {
  const InvoiceDashboard({Key? key}) : super(key: key);

  @override
  State<InvoiceDashboard> createState() => _InvoiceDashboardState();
}

class _InvoiceDashboardState extends State<InvoiceDashboard> {
  final List<Map<String, dynamic>> _history = [
    {
      'name': 'John Doe',
      'attachedFiles': [],
      'comments': 'Taxi fare for client meeting',
      'dateTime': DateTime(2025, 6, 20, 10, 30),
      'status': 'pending',
    },
    {
      'name': 'Alice Smith',
      'attachedFiles': [],
      'comments': 'Lunch with team',
      'dateTime': DateTime(2025, 6, 19, 9, 0),
      'status': 'cleared',
    },
  ];

  void _showApplyDialog() {
    String name = '';
    String comments = '';
    List<PlatformFile> attachedFiles = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          Future<void> pickFiles() async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
            );
            if (result != null) {
              setLocalState(() {
                attachedFiles = result.files;
              });
            }
          }

          Widget filePreview(PlatformFile file) {
            if (['jpg', 'jpeg', 'png'].contains(file.extension?.toLowerCase())) {
              return Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Image.file(
                  File(file.path!),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              );
            } else if (file.extension?.toLowerCase() == 'pdf') {
              return Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 60,
                      child: Text(
                        file.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          return AlertDialog(
            title: const Text('Apply for Reimbursement'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                    icon: const Icon(Icons.attach_file , color: Colors.black87,),
                    label: const Text('Attach Files', style: TextStyle(color: Colors.black)),
                    onPressed: pickFiles,
                  ),
                  if (attachedFiles.isNotEmpty)
                    Wrap(
                      children: attachedFiles.map(filePreview).toList(),
                    ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Comments'),
                    maxLines: 2,
                    onChanged: (val) => comments = val,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                onPressed: () {
                  if (name.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  setState(() {
                    _history.insert(0, {
                      'name': name,
                      'attachedFiles': attachedFiles.map((f) => {
                        'name': f.name,
                        'path': f.path,
                        'extension': f.extension,
                      }).toList(),
                      'comments': comments,
                      'dateTime': DateTime.now(),
                      'status': 'pending',
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Done', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        });
      },
    );
  }

  void _navigateToClearRequestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClearRequestPage(history: _history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reimbursements/Invoice'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 18),
            // Stacked Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kMaroon,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _showApplyDialog,
                      child: const Text('Apply', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: kMaroon,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _navigateToClearRequestPage,
                      child: const Text('Clear Request', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1, height: 32),
            // History List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ..._history.map((item) => _historyCard(item)).toList(),
                  if (_history.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text("No reimbursement requests yet.")),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item) {
    final dateStr = DateFormat('yyyy-MM-dd – kk:mm').format(item['dateTime']);
    String commentPreview = item['comments'] ?? '';
    if (commentPreview.length > 50) {
      commentPreview = commentPreview.substring(0, 50) + '...';
    }

    Widget fileSection;
    final files = item['attachedFiles'] as List?;
    if (files != null && files.isNotEmpty) {
      fileSection = Wrap(
        children: files.map<Widget>((fileMap) {
          final file = fileMap as Map<String, dynamic>;
          final ext = (file['extension'] ?? '').toLowerCase();
          if (['jpg', 'jpeg', 'png'].contains(ext)) {
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Image.file(
                File(file['path']),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            );
          } else if (ext == 'pdf') {
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.picture_as_pdf, color: Color.fromARGB(255, 164, 15, 4), size: 32),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 60,
                    child: Text(
                      file['name'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList(),
      );
    } else {
      fileSection = const Row(
        children: [
          Icon(Icons.receipt_long, color: kMaroon, size: 32),
          SizedBox(width: 8),
          Text("No files attached", style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Chip(
                  label: Text(
                    item['status'] == 'cleared' ? 'Cleared' : 'Pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: item['status'] == 'cleared' ? const Color.fromARGB(255, 5, 92, 8) : const Color.fromARGB(255, 120, 14, 7),
                ),
              ],
            ),
            const SizedBox(height: 6),
            fileSection,
            const SizedBox(height: 6),
            _infoRow('Comments', commentPreview),
            _infoRow('Date & Time', dateStr),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
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

// HR's Clear Request Page (to be designed later)
class ClearRequestPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  const ClearRequestPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for future HR functionality
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear Requests'),
        backgroundColor: kMaroon,
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, idx) {
          final item = history[idx];
          final dateStr = DateFormat('yyyy-MM-dd – kk:mm').format(item['dateTime']);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text('Requested on $dateStr'),
              trailing: Text(
                item['status'] == 'cleared' ? "Cleared" : "Pending",
                style: TextStyle(
                  color: item['status'] == 'cleared' ? const Color.fromARGB(255, 0, 75, 3) : const Color.fromARGB(255, 201, 23, 10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
