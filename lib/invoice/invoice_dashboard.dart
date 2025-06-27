import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'clear_request.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // === Invoice API Service ===
// class InvoiceService { ... }

const Color kMaroon = Color(0xFF800000);

class InvoiceDashboard extends StatefulWidget {
  const InvoiceDashboard({Key? key}) : super(key: key);

  @override
  State<InvoiceDashboard> createState() => _InvoiceDashboardState();
}

class _InvoiceDashboardState extends State<InvoiceDashboard> {
  final bool isAdmin = true; // Set to false for regular users

  // final InvoiceService invoiceService = InvoiceService();

  List<Map<String, dynamic>> _history = [
    {
      'files': [],
      'comments': 'Taxi fare for client meeting',
      'dateTime': DateTime(2025, 6, 20, 10, 30),
      'status': 'pending',
      'applicant': 'John Doe',
    },
    {
      'files': [],
      'comments': 'Lunch with team',
      'dateTime': DateTime(2025, 6, 19, 9, 0),
      'status': 'cleared',
      'applicant': 'Alice Smith',
    },
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   // _loadHistory();
  // }
  // Future<void> _loadHistory() async { ... }

  void _showApplyDialog() {
    List<PlatformFile> attachedFiles = [];
    String comments = '';
    List<Map<String, dynamic>> cameraFiles = [];

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

          Future<void> takePhoto() async {
            final picker = ImagePicker();
            final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
            if (photo != null) {
              setLocalState(() {
                cameraFiles.add({
                  'name': photo.name,
                  'path': photo.path,
                  'extension': photo.path.split('.').last,
                  'source': 'camera',
                });
              });
            }
          }

          Widget filePreview(dynamic file) {
            String ext;
            String filePath;
            String? name;
            if (file is PlatformFile) {
              ext = (file.extension ?? '').toLowerCase();
              filePath = file.path!;
              name = file.name;
            } else if (file is Map<String, dynamic>) {
              ext = (file['extension'] ?? '').toLowerCase();
              filePath = file['path'];
              name = file['name'];
            } else {
              return const SizedBox.shrink();
            }

            if (['jpg', 'jpeg', 'png'].contains(ext)) {
              return Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FullscreenImageViewer.open(
                          context: context,
                          child: Image.file(File(filePath)),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(filePath),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: kMaroon, size: 20),
                      tooltip: 'Download',
                      onPressed: () async {
                        final dir = await getExternalStorageDirectory();
                        await FlutterDownloader.enqueue(
                          url: 'file://$filePath',
                          savedDir: dir!.path,
                          fileName: name,
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Download started!')),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (ext == 'pdf') {
              return Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 90,
                      child: Text(
                        name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: kMaroon, size: 20),
                      tooltip: 'Download',
                      onPressed: () async {
                        final dir = await getExternalStorageDirectory();
                        await FlutterDownloader.enqueue(
                          url: 'file://$filePath',
                          savedDir: dir!.path,
                          fileName: name,
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Download started!')),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          return AlertDialog(
            title: const Text('Apply for Reimbursement', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Attach Files'),
                          onPressed: pickFiles,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                          onPressed: takePhoto,
                        ),
                      ),
                    ],
                  ),
                  if (attachedFiles.isNotEmpty || cameraFiles.isNotEmpty)
                    Wrap(
                      children: [
                        ...attachedFiles.map(filePreview),
                        ...cameraFiles.map(filePreview),
                      ],
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
                child: const Text('Cancel', style: TextStyle(color: kMaroon)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                onPressed: () async {
                  // === API version: ===
                  // await invoiceService.submitRequest(
                  //   [...attachedFiles.map((f) => File(f.path!)), ...cameraFiles.map((f) => File(f['path']))],
                  //   comments,
                  // );
                  // await _loadHistory();

                  setState(() {
                    _history.insert(0, {
                      'files': [
                        ...attachedFiles.map((f) => {
                              'name': f.name,
                              'path': f.path,
                              'extension': f.extension,
                            }),
                        ...cameraFiles
                      ],
                      'comments': comments,
                      'dateTime': DateTime.now(),
                      'status': 'pending',
                      'applicant': 'Current User', // Replace with actual user in real app
                    });
                  });
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

  void _navigateToClearRequestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClearRequestPage(history: _history),
      ),
    );
  }

  void _showHistoryDetailDialog(Map<String, dynamic> item) {
    final dateStr = DateFormat('yyyy-MM-dd – kk:mm').format(item['dateTime']);
    showDialog(
      context: context,
      builder: (context) {
        Widget filePreview(Map<String, dynamic> file) {
          final ext = (file['extension'] ?? '').toLowerCase();
          if (['jpg', 'jpeg', 'png'].contains(ext)) {
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: GestureDetector(
                onTap: () {
                  FullscreenImageViewer.open(
                    context: context,
                    child: Image.file(File(file['path'])),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(file['path']),
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          } else if (ext == 'pdf') {
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 90,
                    child: Text(
                      file['name'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: kMaroon, size: 20),
                    tooltip: 'Download',
                    onPressed: () async {
                      final dir = await getExternalStorageDirectory();
                      await FlutterDownloader.enqueue(
                        url: 'file://${file['path']}',
                        savedDir: dir!.path,
                        fileName: file['name'],
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Download started!')),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        return AlertDialog(
          title: const Text('Reimbursement Details', style: TextStyle(color: kMaroon)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date & Time: $dateStr', style: const TextStyle(color: kMaroon)),
                const SizedBox(height: 8),
                Text('Comments:', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item['comments'] ?? ''),
                const SizedBox(height: 8),
                if (item['files'] != null && (item['files'] as List).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Attached Files:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        children: (item['files'] as List).map<Widget>((f) => filePreview(Map<String, dynamic>.from(f))).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Chip(
                      label: Text(
                        item['status'] == 'cleared' ? 'Cleared' : 'Pending',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: item['status'] == 'cleared' ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: kMaroon)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reimbursements', style: TextStyle(color: kMaroon)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kMaroon),
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
                  if (isAdmin)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: kMaroon,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _navigateToClearRequestPage,
                        child: const Text('Approve', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1, height: 32),
            // History List with Refresh Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kMaroon)),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: kMaroon),
                        tooltip: 'Refresh',
                        onPressed: () async {
                          // === API version: ===
                          // await _loadHistory();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
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

    return GestureDetector(
      onTap: () => _showHistoryDetailDialog(item),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    label: Text(
                      item['status'] == 'cleared' ? 'Cleared' : 'Pending',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: item['status'] == 'cleared' ? Colors.green : Colors.red,
                  ),
                  const Spacer(),
                  Text(dateStr, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              if (item['files'] != null && (item['files'] as List).isNotEmpty)
                Wrap(
                  children: (item['files'] as List).map<Widget>((file) {
                    final ext = (file['extension'] ?? '').toLowerCase();
                    if (['jpg', 'jpeg', 'png'].contains(ext)) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: Image.file(
                          File(file['path']),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (ext == 'pdf') {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 22),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 40,
                              child: Text(
                                file['name'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }).toList(),
                ),
              const SizedBox(height: 6),
              Text('Comments: $commentPreview', style: const TextStyle(color: kMaroon)),
            ],
          ),
        ),
      ),
    );
  }
}
