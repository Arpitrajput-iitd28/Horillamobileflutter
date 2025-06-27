import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

// Import necessary packages for API/database operations.
// These would need to be added to your pubspec.yaml.
// import 'package:http/http.dart' as http; // For making HTTP requests
// import 'dart:convert'; // For encoding/decoding JSON
// import 'package:sqflite/sqflite.dart'; // For local SQLite database
// import 'package:path/path.dart'; // For joining paths (used with sqflite)
// import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
// import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database

const Color kMaroon = Color(0xFF800000);

class QuestionTemplate extends StatefulWidget {
  const QuestionTemplate({Key? key}) : super(key: key);

  @override
  State<QuestionTemplate> createState() => _RecruitmentTemplatePageState();
}

class _RecruitmentTemplatePageState extends State<QuestionTemplate> {
  List<Map<String, dynamic>> templates = [
    {
      'title': 'Communication',
      'questions': [
        {'text': 'How would you describe the clarity level of this person?', 'priority': 'Common'},
        {'text': 'How would you describe the ambiguity in this persons presentation', 'priority': 'Advanced'},
      ],
    },
    {
      'title': 'Back-end Development',
      'questions': [
        {'text': 'How did the APIs function ?', 'priority': 'High Priority'},
        {'text': 'Was this person open to resolving issues that came up?', 'priority': 'Niche'},
      ],
    },
  ];

  String searchQuery = '';
  List<bool> selectedTemplates = [];
  Map<int, Set<int>> selectedQuestions = {}; // templateIndex -> set of question indices

  // Example for a local SQLite database instance
  // late Database _database;

  @override
  void initState() {
    super.initState();
    selectedTemplates = List.filled(templates.length, false);
    for (int i = 0; i < templates.length; i++) {
      selectedQuestions[i] = {};
    }
    // Initialize API/Database operations here
    // _fetchTemplatesFromApi(); // Example API call on initialization
    // _initDatabase(); // Example database initialization
    // _initializeFirebase(); // Example Firebase initialization
  }

  // Example function to initialize a local SQLite database
  /*
  Future<void> _initDatabase() async {
    // Open the database and store the reference.
    _database = await openDatabase(
      join(await getDatabasesPath(), 'templates_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE templates(id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
      version: 1,
    );
    // You might also create a 'questions' table here and link them.
    // await db.execute(
    //   'CREATE TABLE questions(id INTEGER PRIMARY KEY, templateId INTEGER, text TEXT, priority TEXT, FOREIGN KEY (templateId) REFERENCES templates(id))',
    // );
  }
  */

  // Example function to initialize Firebase
  /*
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform, // You would need firebase_options.dart
    );
    // You can now access Firestore:
    // FirebaseFirestore.instance.collection('templates').snapshots().listen((data) {
    //   // Update your templates list here based on Firestore data
    // });
  }
  */

  // Example function to fetch data from a REST API
  /*
  Future<void> _fetchTemplatesFromApi() async {
    try {
      final response = await http.get(Uri.parse('https://api.example.com/templates'));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          templates = fetchedData.map((item) => {
            'title': item['title'],
            'questions': (item['questions'] as List).map((q) => {
              'text': q['text'],
              'priority': q['priority'],
            }).toList(),
          }).toList();
          selectedTemplates = List.filled(templates.length, false);
          selectedQuestions = {};
          for (int i = 0; i < templates.length; i++) {
            selectedQuestions[i] = {};
          }
        });
      } else {
        // Handle server errors
        print('Failed to load templates: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching templates: $e');
    }
  }
  */

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
                onPressed: () {
                  if ((isNewTemplate && newTemplateTitle.trim().isEmpty) ||
                      questionText.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields.')),
                    );
                    return;
                  }
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

                      // Example: Add new template to a REST API
                      /*
                      _addTemplateToApi({
                        'title': newTemplateTitle,
                        'questions': [
                          {'text': questionText, 'priority': priority}
                        ],
                      });
                      */

                      // Example: Add new template to SQLite database
                      /*
                      _database.insert(
                        'templates',
                        {'title': newTemplateTitle},
                        conflictAlgorithm: ConflictAlgorithm.replace,
                      ).then((templateId) {
                        // If you have a questions table, insert the question
                        // _database.insert(
                        //   'questions',
                        //   {'templateId': templateId, 'text': questionText, 'priority': priority},
                        // );
                      });
                      */

                      // Example: Add new template to Firestore
                      /*
                      FirebaseFirestore.instance.collection('templates').add({
                        'title': newTemplateTitle,
                        'questions': [
                          {'text': questionText, 'priority': priority}
                        ],
                      });
                      */

                    } else {
                      final idx = templates.indexWhere((t) => t['title'] == selectedTemplate);
                      if (idx != -1) {
                        (templates[idx]['questions'] as List)
                            .add({'text': questionText, 'priority': priority});

                        // Example: Update existing template on a REST API
                        /*
                        _updateTemplateOnApi(
                          templates[idx]['id'], // Assuming an 'id' field for the template
                          {'text': questionText, 'priority': priority},
                        );
                        */

                        // Example: Update existing template in SQLite (add question)
                        /*
                        // You'd need to fetch the template ID first, then insert the question
                        // into the 'questions' table with the correct templateId.
                        */

                        // Example: Update existing template in Firestore (add question)
                        /*
                        // You would need to get the document ID for the selected template
                        // and then update its 'questions' array.
                        // FirebaseFirestore.instance.collection('templates').doc(templateDocId).update({
                        //   'questions': FieldValue.arrayUnion([{'text': questionText, 'priority': priority}])
                        // });
                        */
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

  // Example function to add a template to a REST API
  /*
  Future<void> _addTemplateToApi(Map<String, dynamic> templateData) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/templates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(templateData),
      );
      if (response.statusCode == 201) { // 201 Created
        print('Template added successfully to API');
      } else {
        print('Failed to add template to API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding template to API: $e');
    }
  }
  */

  // Example function to update a template on a REST API (e.g., adding a question)
  /*
  Future<void> _updateTemplateOnApi(int templateId, Map<String, dynamic> questionData) async {
    try {
      final response = await http.put(
        Uri.parse('https://api.example.com/templates/$templateId/questions'), // Adjust endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(questionData),
      );
      if (response.statusCode == 200) {
        print('Question added/updated successfully on API');
      } else {
        print('Failed to update template on API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating template on API: $e');
    }
  }
  */

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
                            child: Text(
                              template['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: kMaroon, fontSize: 12),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Template', style: TextStyle(color: kMaroon)),
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