import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

const Color kMaroon = Color(0xFF800000);

class RecruitmentHistoryPage extends StatefulWidget {
  const RecruitmentHistoryPage({Key? key}) : super(key: key);

  @override
  State<RecruitmentHistoryPage> createState() => _RecruitmentHistoryPageState();
}

class _RecruitmentHistoryPageState extends State<RecruitmentHistoryPage> {
  List<Map<String, dynamic>> history = [
    {
      'title': 'Front-end Developer',
      'name': 'Alice Smith',
      'dateJoined': DateTime(2025, 6, 10),
      'imagePath': null,
      'linkedin': 'https://linkedin.com/in/alicesmith',
      'resume': null,
      'description': 'Skilled in Flutter and React.',
      'archived': false,
    },
    {
      'title': 'Back-end Developer',
      'name': 'John Doe',
      'dateJoined': DateTime(2025, 6, 5),
      'imagePath': null,
      'linkedin': '',
      'resume': null,
      'description': '',
      'archived': false,
    },
  ];

  String searchQuery = '';

  List<Map<String, dynamic>> get filteredHistory {
    return history.where((item) {
      if (item['archived'] == true) return false;
      return item['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['name'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void _showCreateDialog({Map<String, dynamic>? editItem, int? editIdx}) {
    String? selectedTitle = editItem?['title'];
    String name = editItem?['name'] ?? '';
    DateTime? dateJoined = editItem?['dateJoined'];
    String? imagePath = editItem?['imagePath'];
    String linkedin = editItem?['linkedin'] ?? '';
    String? resumePath = editItem?['resume'];
    String description = editItem?['description'] ?? '';

    final titleController = TextEditingController(text: selectedTitle);
    final nameController = TextEditingController(text: name);
    final linkedinController = TextEditingController(text: linkedin);
    final descriptionController = TextEditingController(text: description);

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

          Future<void> pickResume() async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx'],
            );
            if (result != null && result.files.isNotEmpty) {
              setLocalState(() => resumePath = result.files.first.path);
            }
          }

          return AlertDialog(
            title: const Text('Add Recruitment Entry', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Position Title'),
                    onChanged: (val) => selectedTitle = val,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Date Joined:', style: TextStyle(color: kMaroon)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: dateJoined ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setLocalState(() => dateJoined = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: kMaroon),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dateJoined != null
                                  ? DateFormat('yyyy-MM-dd').format(dateJoined!)
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
                        backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
                        radius: 24,
                        child: imagePath == null
                            ? const Icon(Icons.person, color: kMaroon, size: 28)
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: linkedinController,
                    decoration: const InputDecoration(labelText: 'LinkedIn URL'),
                    onChanged: (val) => linkedin = val,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          resumePath != null
                              ? 'Resume: ${resumePath?.split('/').last}'
                              : 'No resume selected',
                          style: const TextStyle(color: kMaroon),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                        icon: const Icon(Icons.attach_file, color: Colors.white),
                        label: const Text('Upload Resume', style: TextStyle(color: Colors.white)),
                        onPressed: pickResume,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description/Comment'),
                    maxLines: 2,
                    onChanged: (val) => description = val,
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
                  if ((selectedTitle ?? '').trim().isEmpty ||
                      name.trim().isEmpty ||
                      dateJoined == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
                  setState(() {
                    final newEntry = {
                      'title': selectedTitle,
                      'name': name,
                      'dateJoined': dateJoined,
                      'imagePath': imagePath,
                      'linkedin': linkedin,
                      'resume': resumePath,
                      'description': description,
                      'archived': false,
                    };
                    if (editIdx != null) {
                      history[editIdx] = newEntry;
                    } else {
                      history.insert(0, newEntry);
                    }
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

  void _showShareDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Link', style: TextStyle(color: kMaroon)),
        content: SelectableText(
          'https://company.com/profile/${item['name'].toString().replaceAll(' ', '').toLowerCase()}',
          style: const TextStyle(color: kMaroon),
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

  void _archiveItem(int idx) {
    setState(() {
      history[idx]['archived'] = true;
    });
  }

  void _deleteItem(int idx) {
    setState(() {
      history.removeAt(idx);
    });
  }

  Future<void> _launchLinkedIn(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch LinkedIn profile.')),
      );
    }
  }

  Future<void> _openResume(String path) async {
    if (path.isNotEmpty) {
      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open resume file.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredHistory;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruitment History', style: TextStyle(color: kMaroon)),
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
                          ? const Icon(Icons.person, color: kMaroon, size: 32)
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
                          item['name'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Joined: ${DateFormat('yyyy-MM-dd').format(item['dateJoined'])}',
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
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
                              // Action icons row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: kMaroon),
                                    onPressed: () => _showCreateDialog(editItem: item, editIdx: idx),
                                    tooltip: 'Edit',
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
                                  IconButton(
                                    icon: const Icon(Icons.share, color: kMaroon),
                                    onPressed: () => _showShareDialog(item),
                                    tooltip: 'Share',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // LinkedIn (tappable, wrapped)
                              if ((item['linkedin'] as String).isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.link, color: kMaroon, size: 18),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _launchLinkedIn(item['linkedin']),
                                        child: Text(
                                          item['linkedin'],
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 13,
                                            decoration: TextDecoration.underline,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              // Resume (tappable, wrapped)
                              if ((item['resume'] as String?)?.isNotEmpty == true)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.picture_as_pdf, color: kMaroon, size: 18),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _openResume(item['resume']),
                                        child: Text(
                                          item['resume'].toString().split('/').last,
                                          style: const TextStyle(
                                            color: kMaroon,
                                            fontSize: 13,
                                            decoration: TextDecoration.underline,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('(Tap to open)', style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                              // Description (wrapped)
                              if ((item['description'] as String).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    item['description'],
                                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                                    softWrap: true,
                                  ),
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
