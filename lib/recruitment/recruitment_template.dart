import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
// For simulating API calls (in a real app, you'd use packages like http or dio)
// import 'dart:convert'; // For json.decode/encode

// --- API Integration Placeholder (Commented Out) ---
// In a real application, you would interact with a backend API to persist data.
// This section demonstrates where API calls would typically be made.

/*
// This would be your API client or service
class ApiService {
  // Simulates fetching templates from a backend
  Future<List<Map<String, dynamic>>> fetchTemplates() async {
    // In a real app, this would be an http GET request to your backend
    // Example:
    // final response = await http.get(Uri.parse('YOUR_BACKEND_URL/templates'));
    // if (response.statusCode == 200) {
    //   return json.decode(response.body) as List<Map<String, dynamic>>;
    // } else {
    //   throw Exception('Failed to load templates');
    // }

    // Simulating network delay and returning mock data
    await Future.delayed(const Duration(seconds: 2));
    print("API: Fetching templates...");
    // This would ideally return fresh data from the server.
    // For this example, we'll return a copy of initial mock data to simulate success.
    return [
      {
        'title': 'Front-end Development (API Example)',
        'questions': [
          {'text': 'API Q1: What is a widget in Flutter?', 'priority': 'Common'},
          {'text': 'API Q2: Explain the widget lifecycle.', 'priority': 'Advanced'},
        ],
      },
      // You could add more mock templates here to simulate new data from server
    ];
  }

  // Simulates adding a new template to the backend
  Future<Map<String, dynamic>> addTemplate(Map<String, dynamic> newTemplate) async {
    // In a real app, this would be an http POST request
    // Example:
    // final response = await http.post(
    //   Uri.parse('YOUR_BACKEND_URL/templates'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(newTemplate),
    // );
    // if (response.statusCode == 201) {
    //   return json.decode(response.body); // Return the created template with ID from backend
    // } else {
    //   throw Exception('Failed to add template');
    // }

    await Future.delayed(const Duration(seconds: 1));
    print("API: Adding new template: ${newTemplate['title']}");
    // Simulate assigning an ID from the backend
    return {...newTemplate, 'id': 'temp_${DateTime.now().millisecondsSinceEpoch}'};
  }

  // Simulates adding a new question to an existing template on the backend
  Future<Map<String, dynamic>> addQuestionToTemplate(String templateId, Map<String, dynamic> newQuestion) async {
    // In a real app, this would be an http POST request to a specific template endpoint
    // Example:
    // final response = await http.post(
    //   Uri.parse('YOUR_BACKEND_URL/templates/$templateId/questions'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(newQuestion),
    // );
    // if (response.statusCode == 201) {
    //   return json.decode(response.body); // Return the created question with ID
    // } else {
    //   throw Exception('Failed to add question');
    // }

    await Future.delayed(const Duration(seconds: 1));
    print("API: Adding question '${newQuestion['text']}' to template '$templateId'");
    // Simulate assigning an ID from the backend
    return {...newQuestion, 'id': 'ques_${DateTime.now().millisecondsSinceEpoch}'};
  }

  // Simulates updating an existing template (e.g., questions within it)
  Future<void> updateTemplate(String templateId, Map<String, dynamic> updatedTemplate) async {
    // In a real app, this would be an http PUT/PATCH request
    // Example:
    // final response = await http.put(
    //   Uri.parse('YOUR_BACKEND_URL/templates/$templateId'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(updatedTemplate),
    // );
    await Future.delayed(const Duration(seconds: 1));
    print("API: Updating template with ID: $templateId");
  }

  // Simulates deleting a template
  Future<void> deleteTemplate(String templateId) async {
    // In a real app, this would be an http DELETE request
    // Example:
    // final response = await http.delete(Uri.parse('YOUR_BACKEND_URL/templates/$templateId'));
    await Future.delayed(const Duration(seconds: 1));
    print("API: Deleting template with ID: $templateId");
  }

  // Simulates uploading a PDF to a backend storage
  Future<String> uploadPdf(List<int> pdfBytes, String filename) async {
    // In a real app, this would be an http POST request for file upload
    // Example:
    // final request = http.MultipartRequest('POST', Uri.parse('YOUR_STORAGE_UPLOAD_URL'));
    // request.files.add(http.MultipartFile.fromBytes('file', pdfBytes, filename: filename));
    // final response = await request.send();
    await Future.delayed(const Duration(seconds: 2));
    final String url = 'YOUR_STORAGE_URL/$filename';
    print("API: Uploaded PDF to: $url");
    return url;
  }
}

// Initialize API service (this would be typically managed by a dependency injection system)
final ApiService apiService = ApiService();

*/
// --- End API Integration Placeholder ---

const Color kMaroon = Color(0xFF800000);

class RecruitmentTemplatePage extends StatefulWidget {
  const RecruitmentTemplatePage({Key? key}) : super(key: key);

  @override
  State<RecruitmentTemplatePage> createState() => _RecruitmentTemplatePageState();
}

class _RecruitmentTemplatePageState extends State<RecruitmentTemplatePage> {
  List<Map<String, dynamic>> templates = [
    {
      'title': 'Front-end Development',
      'questions': [
        {'text': 'What is a widget in Flutter?', 'priority': 'Common'},
        {'text': 'Explain the widget lifecycle.', 'priority': 'Advanced'},
      ],
    },
    {
      'title': 'Back-end Development',
      'questions': [
        {'text': 'Explain RESTful APIs.', 'priority': 'High Priority'},
        {'text': 'What is JWT authentication?', 'priority': 'Niche'},
      ],
    },
  ];

  String searchQuery = '';
  List<bool> selectedTemplates = [];
  Map<int, Set<int>> selectedQuestions = {}; // templateIndex -> set of question indices

  @override
  void initState() {
    super.initState();
    selectedTemplates = List.filled(templates.length, false);
    for (int i = 0; i < templates.length; i++) {
      selectedQuestions[i] = {};
    }

    // --- API Call Placeholder (Commented Out) ---
    // Call API to fetch templates when the page initializes
    /*
    _fetchTemplatesFromApi();
    */
    // --- End API Call Placeholder ---
  }

  // --- API Integration Placeholder (Commented Out) ---
  /*
  Future<void> _fetchTemplatesFromApi() async {
    try {
      final fetchedTemplates = await apiService.fetchTemplates();
      setState(() {
        templates = fetchedTemplates;
        // Re-initialize selection states for new templates
        selectedTemplates = List.filled(templates.length, false);
        selectedQuestions = {};
        for (int i = 0; i < templates.length; i++) {
          selectedQuestions[i] = {};
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Templates loaded from API (simulated)!')),
      );
    } catch (e) {
      print('Error fetching templates: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load templates: $e')),
      );
    }
  }
  */
  // --- End API Integration Placeholder ---


  List<Map<String, dynamic>> get filteredTemplates {
    if (searchQuery.isEmpty) return templates;
    return templates
        .map((template) {
          final filteredQuestions = (template['questions'] as List)
              .where((q) => (q['text'] as String).toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
          if (template['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
              filteredQuestions.isNotEmpty) {
            return {
              'title': template['title'],
              'questions': filteredQuestions,
            };
          }
          return null;
        })
        .where((t) => t != null)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  void _showCreateDialog() {
    String? selectedTemplate;
    bool isNewTemplate = false;
    String newTemplateTitle = '';
    String questionText = '';
    String priority = 'Common';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          return AlertDialog(
            title: const Text('Add Template or Question', style: TextStyle(color: kMaroon)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isNewTemplate,
                        onChanged: (val) => setLocalState(() => isNewTemplate = val ?? false),
                        activeColor: kMaroon,
                      ),
                      const Text('Add New Template', style: TextStyle(color: kMaroon)),
                    ],
                  ),
                  if (isNewTemplate)
                    TextField(
                      decoration: const InputDecoration(labelText: 'Template Title'),
                      onChanged: (val) => newTemplateTitle = val,
                    )
                  else
                    DropdownSearch<String>(
                      items: templates.map((t) => t['title'] as String).toList(),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select Template",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      onChanged: (val) => setLocalState(() => selectedTemplate = val),
                      selectedItem: selectedTemplate,
                    ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Question'),
                    onChanged: (val) => questionText = val,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: [
                      'Niche',
                      'Common',
                      'Low Priority',
                      'High Priority',
                      'Advanced'
                    ]
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setLocalState(() => priority = val ?? 'Common'),
                    decoration: const InputDecoration(labelText: 'Priority'),
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
                onPressed: () async { // Made async to await API calls
                  if ((isNewTemplate && newTemplateTitle.trim().isEmpty) ||
                      questionText.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }

                  // --- API Call Placeholder (Commented Out) ---
                  // Simulate API call to add template/question
                  /*
                  try {
                    if (isNewTemplate) {
                      final newTempData = {
                        'title': newTemplateTitle,
                        'questions': [
                          {'text': questionText, 'priority': priority}
                        ],
                      };
                      final createdTemplate = await apiService.addTemplate(newTempData);
                      // On success, update local state
                      setState(() {
                        templates.add(createdTemplate);
                        selectedTemplates.add(false);
                        selectedQuestions[templates.length - 1] = {};
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Template "${createdTemplate['title']}" added (simulated API)!')),
                      );
                    } else {
                      final idx = templates.indexWhere((t) => t['title'] == selectedTemplate);
                      if (idx != -1) {
                        final questionData = {'text': questionText, 'priority': priority};
                        // In a real app, you'd use the template's actual ID from the backend
                        final templateId = templates[idx]['id'] ?? templates[idx]['title']; // Use ID if available
                        final createdQuestion = await apiService.addQuestionToTemplate(templateId, questionData);
                        // On success, update local state
                        setState(() {
                          (templates[idx]['questions'] as List).add(createdQuestion);
                        });
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Question added to "${templates[idx]['title']}" (simulated API)!')),
                        );
                      }
                    }
                  } catch (e) {
                    print('Error adding template/question: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add: $e')),
                    );
                  }
                  */
                  // --- End API Call Placeholder ---

                  // Original local state update (kept for current functionality)
                  setState(() {
                    if (isNewTemplate) {
                      templates.add({
                        'title': newTemplateTitle,
                        'questions': [
                          {'text': questionText, 'priority': priority}
                        ],
                      });
                      selectedTemplates.add(false);
                      selectedQuestions[templates.length - 1] = {};
                    } else {
                      final idx = templates.indexWhere((t) => t['title'] == selectedTemplate);
                      if (idx != -1) {
                        (templates[idx]['questions'] as List)
                            .add({'text': questionText, 'priority': priority});
                      }
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

  void _showPdfDialog() async {
    List<bool> localSelectedTemplates = List.from(selectedTemplates);
    Map<int, Set<int>> localSelectedQuestions = {
      for (int i = 0; i < templates.length; i++)
        i: Set<int>.from(selectedQuestions[i] ?? {})
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocalState) {
          return AlertDialog(
            title: const Text('Select Templates/Questions', style: TextStyle(color: kMaroon)),
            content: SizedBox(
              width: 370,
              height: 400,
              child: ListView.builder(
                itemCount: templates.length,
                itemBuilder: (context, tIdx) {
                  final template = templates[tIdx];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          Checkbox(
                            value: localSelectedTemplates[tIdx],
                            onChanged: (val) {
                              setLocalState(() {
                                localSelectedTemplates[tIdx] = val ?? false;
                                if (val == true) {
                                  localSelectedQuestions[tIdx] =
                                      Set<int>.from(List.generate(
                                          (template['questions'] as List).length, (i) => i));
                                } else {
                                  localSelectedQuestions[tIdx] = {};
                                }
                              });
                            },
                            activeColor: kMaroon,
                          ),
                          Expanded(
                            child : Text(
                              template['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: kMaroon , fontSize: 12),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                        )],
                      
                      ),
                      children: [
                        ...List.generate(
                          (template['questions'] as List).length,
                          (qIdx) {
                            final question = template['questions'][qIdx];
                            return ListTile(
                              leading: Checkbox(
                                value: localSelectedQuestions[tIdx]?.contains(qIdx) ?? false,
                                onChanged: (val) {
                                  setLocalState(() {
                                    if (val == true) {
                                      localSelectedQuestions[tIdx]?.add(qIdx);
                                    } else {
                                      localSelectedQuestions[tIdx]?.remove(qIdx);
                                    }
                                    localSelectedTemplates[tIdx] =
                                        (localSelectedQuestions[tIdx]?.length ?? 0) ==
                                            (template['questions'] as List).length;
                                  });
                                },
                                activeColor: kMaroon,
                              ),
                              title: Text(question['text'],
                                  style: const TextStyle(color: kMaroon)),
                              subtitle: Text(question['priority'],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 10)),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
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
                  setState(() {
                    selectedTemplates = List.from(localSelectedTemplates);
                    selectedQuestions = {
                      for (int i = 0; i < templates.length; i++)
                        i: Set<int>.from(localSelectedQuestions[i] ?? {})
                    };
                  });
                  Navigator.pop(context);
                  _generatePdf();
                },
                child: const Text('Download PDF'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    for (int tIdx = 0; tIdx < templates.length; tIdx++) {
      if (!selectedTemplates[tIdx] &&
          (selectedQuestions[tIdx]?.isEmpty ?? true)) continue;

      final template = templates[tIdx];
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(template['title'],
                    style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(kMaroon.value))),
                pw.SizedBox(height: 10),
                pw.ListView.builder(
                  itemCount: (template['questions'] as List).length,
                  itemBuilder: (context, qIdx) {
                    if (selectedTemplates[tIdx] ||
                        (selectedQuestions[tIdx]?.contains(qIdx) ?? false)) {
                      final question = template['questions'][qIdx];
                      return pw.Container(
                        margin: const pw.EdgeInsets.symmetric(vertical: 4),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('• ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(kMaroon.value))),
                            pw.Expanded(
                              child: pw.Text('${question['text']} '
                                  '(${question['priority']})',
                                  style: const pw.TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      );
                    }
                    return pw.SizedBox();
                  },
                ),
              ],
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // --- API Call Placeholder (Commented Out) ---
    // After PDF is generated, you might want to upload it to a backend storage
    /*
    try {
      final pdfBytes = await pdf.save();
      final filename = 'recruitment_template_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final uploadedUrl = await apiService.uploadPdf(pdfBytes, filename);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF uploaded to: $uploadedUrl (simulated API)!')),
      );
    } catch (e) {
      print('Error uploading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload PDF: $e')),
      );
    }
    */
    // --- End API Call Placeholder ---
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruitment Template', style: TextStyle(color: kMaroon)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kMaroon),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search, Create, PDF Download
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
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: kMaroon),
                  onPressed: _showPdfDialog,
                  tooltip: 'Download PDF',
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
                  onPressed: _showCreateDialog,
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 10),
          // Template Cards
          Expanded(
            child: ListView(
              children: filteredTemplates.map((template) {
                final questions = template['questions'] as List;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(template['title'],
                            style: const TextStyle(
                                color: kMaroon,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        const SizedBox(height: 8),
                        ...questions.map<Widget>((q) => ListTile(
                              dense: true,
                              leading: _priorityChip(q['priority']),
                              title: Text(q['text'], style: const TextStyle(color: kMaroon)),
                            )),
                        if (questions.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No questions in this template.',
                                style: TextStyle(color: kMaroon)),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityChip(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'niche':
        color = Colors.deepPurple;
        break;
      case 'common':
        color = const Color.fromARGB(255, 0, 99, 3);
        break;
      case 'low priority':
        color = const Color.fromARGB(255, 238, 170, 68);
        break;
      case 'high priority':
        color = const Color.fromARGB(255, 113, 19, 13);
        break;
      case 'advanced':
        color = const Color.fromARGB(255, 7, 73, 127);
        break;
      default:
        color = kMaroon;
    }
    return Chip(
      label: Text(priority, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}
