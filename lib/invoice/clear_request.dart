import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

const Color kMaroon = Color(0xFF800000);

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // === Clear Request API Service ===
// class ClearRequestService { ... }

class ClearRequestPage extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const ClearRequestPage({Key? key, required this.history}) : super(key: key);

  @override
  State<ClearRequestPage> createState() => _ClearRequestPageState();
}

class _ClearRequestPageState extends State<ClearRequestPage> {
  // final ClearRequestService clearRequestService = ClearRequestService();
  // List<Map<String, dynamic>> _requests = []; // For API
  List<Map<String, dynamic>> _requests = [];

  String filterName = '';
  DateTime? filterDate;

  @override
  void initState() {
    super.initState();
    // _loadRequests();
    _requests = List<Map<String, dynamic>>.from(widget.history);
  }

  // Future<void> _loadRequests() async {
  //   try {
  //     final data = await clearRequestService.fetchAllRequests();
  //     setState(() {
  //       _requests = data;
  //     });
  //   } catch (e) {
  //     // Handle error
  //   }
  // }

  List<Map<String, dynamic>> get filteredRequests {
    return _requests.where((item) {
      final matchesName = filterName.isEmpty ||
          (item['applicant'] ?? '').toLowerCase().contains(filterName.toLowerCase());
      final matchesDate = filterDate == null ||
          DateFormat('yyyy-MM-dd').format(item['dateTime']) ==
              DateFormat('yyyy-MM-dd').format(filterDate!);
      return matchesName && matchesDate;
    }).toList();
  }

  void _showDetailsDialog(Map<String, dynamic> item) {
    final dateStr = DateFormat('yyyy-MM-dd – kk:mm').format(item['dateTime']);

    Widget filePreview(Map<String, dynamic> file) {
      final ext = (file['extension'] ?? '').toLowerCase();
      final filePath = file['path'];
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
                    url: 'file://$filePath',
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Details', style: TextStyle(color: kMaroon)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Applicant: ${item['applicant'] ?? "N/A"}', style: const TextStyle(color: kMaroon)),
              const SizedBox(height: 6),
              Text('Date & Time: $dateStr', style: const TextStyle(color: kMaroon)),
              const SizedBox(height: 6),
              Text('Comments:', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(item['comments'] ?? ''),
              const SizedBox(height: 8),
              if (item['files'] != null && (item['files'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Attached Files:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      children: (item['files'] as List).map<Widget>((f) => filePreview(f)).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Flexible(
                    child: Chip(
                      label: Text(
                        item['status'] == 'approved'
                            ? 'Approved'
                            : item['status'] == 'rejected'
                                ? 'Rejected'
                                : 'Pending',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: item['status'] == 'approved'
                          ? Colors.green
                          : item['status'] == 'rejected'
                              ? Colors.red
                              : Colors.orange,
                    ),
                  ),
                ],
              ),
              if (item['status'] == 'rejected' && (item['rejectionComment'] ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Rejection Reason: ${item['rejectionComment']}',
                    style: const TextStyle(color: Colors.red),
                  ),
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
      ),
    );
  }

  void _showActionMenu(BuildContext context, Map<String, dynamic> item, int idx) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Approve'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmApprove(item, idx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Reject'),
                onTap: () {
                  Navigator.pop(context);
                  _promptReject(item, idx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmApprove(Map<String, dynamic> item, int idx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request', style: TextStyle(color: kMaroon)),
        content: const Text('Do you really want to approve this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              // === API version: ===
              // await clearRequestService.approveRequest(item['id']);
              setState(() {
                _requests[idx]['status'] = 'approved';
                _requests[idx]['rejectionComment'] = '';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request approved!')),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _promptReject(Map<String, dynamic> item, int idx) {
    String comment = '';
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setLocalState) {
        return AlertDialog(
          title: const Text('Reject Request', style: TextStyle(color: kMaroon)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide a reason for rejection:'),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Rejection Reason',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => comment = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: kMaroon)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                if (comment.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a reason.')),
                  );
                  return;
                }
                Navigator.pop(context);
                _confirmReject(item, idx, comment);
              },
              child: const Text('Send'),
            ),
          ],
        );
      }),
    );
  }

  void _confirmReject(Map<String, dynamic> item, int idx, String comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request', style: TextStyle(color: kMaroon)),
        content: const Text('Do you really want to reject this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // === API version: ===
              // await clearRequestService.rejectRequest(item['id'], comment);
              setState(() {
                _requests[idx]['status'] = 'rejected';
                _requests[idx]['rejectionComment'] = comment;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request rejected!')),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    String tempName = filterName;
    DateTime? tempDate = filterDate;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Requests', style: TextStyle(color: kMaroon)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Applicant Name'),
              onChanged: (val) => tempName = val,
              controller: TextEditingController(text: tempName),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Date:', style: TextStyle(color: kMaroon)),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => tempDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: kMaroon),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tempDate != null
                            ? DateFormat('yyyy-MM-dd').format(tempDate!)
                            : 'Select Date',
                        style: const TextStyle(color: kMaroon),
                      ),
                    ),
                  ),
                ),
                if (tempDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, color: kMaroon),
                    onPressed: () => setState(() => tempDate = null),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: kMaroon)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
            onPressed: () {
              setState(() {
                filterName = tempName;
                filterDate = tempDate;
              });
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshRequests() async {
    // === API version: ===
    // await _loadRequests();
    // For now, just simulate refresh
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredRequests;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Requests', style: TextStyle(color: kMaroon)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kMaroon),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kMaroon),
            tooltip: 'Refresh',
            onPressed: _refreshRequests,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: kMaroon),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: filtered.isEmpty
          ? const Center(child: Text('No requests found.'))
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final item = filtered[idx];
                final dateStr = DateFormat('yyyy-MM-dd – kk:mm').format(item['dateTime']);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    onTap: () => _showDetailsDialog(item),
                    title: Text(
                      'Request by ${item['applicant'] ?? "N/A"}',
                      style: const TextStyle(
                          color: kMaroon, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Date: $dateStr',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: kMaroon),
                          onPressed: () => _showActionMenu(context, item, idx),
                        ),
                        const SizedBox(height: 2),
                        Flexible(
                          child: Chip(
                            label: Text(
                              item['status'] == 'approved'
                                  ? 'Approved'
                                  : item['status'] == 'rejected'
                                      ? 'Rejected'
                                      : 'Pending',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: item['status'] == 'approved'
                                ? Colors.green
                                : item['status'] == 'rejected'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
