import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Make sure this is in your pubspec.yaml

// Ensure kMaroon is consistent across files, defined here for self-containment
const Color kMaroon = Color(0xFF800000);

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String searchQuery = '';
  // Mock data for existing question templates (copied from question_template.dart for now)
  final List<Map<String, dynamic>> availableTemplates = [
    {
      'title': 'Communication',
      'questions': [
        {'id': 'comm_q1', 'text': 'How would you describe the clarity level of this person?', 'priority': 'Common'},
        {'id': 'comm_q2', 'text': 'How would you describe the ambiguity in this persons presentation', 'priority': 'Advanced'},
      ],
    },
    {
      'title': 'Back-end Development',
      'questions': [
        {'id': 'be_q1', 'text': 'How did the APIs function ?', 'priority': 'High Priority'},
        {'id': 'be_q2', 'text': 'Was this person open to resolving issues that came up?', 'priority': 'Niche'},
      ],
    },
    // Add more templates as needed
  ];

  // Mock data for created questionnaires
  List<Map<String, dynamic>> createdQuestionnaires = [
    {
      'id': 'q_1',
      'title': 'Initial Team Feedback',
      'creatorName': 'Admin',
      'creationDate': DateTime(2025, 6, 20, 10, 0),
      'expiryDate': DateTime(2025, 12, 31), // Example: not expired
      'questions': [
        {'id': 'comm_q1', 'text': 'How would you describe the clarity level of this person?', 'priority': 'Common'},
        {'id': 'be_q1', 'text': 'How did the APIs function ?', 'priority': 'High Priority'},
      ],
    },
    {
      'id': 'q_2',
      'title': 'Mid-Year Performance Review',
      'creatorName': 'Manager',
      'creationDate': DateTime(2025, 5, 15, 14, 30),
      'expiryDate': DateTime(2025, 6, 1), // Example: expired
      'questions': [
        {'id': 'comm_q1', 'text': 'How would you describe the clarity level of this person?', 'priority': 'Common'},
        {'id': 'comm_q2', 'text': 'How would you describe the ambiguity in this persons presentation', 'priority': 'Advanced'},
        {'id': 'be_q1', 'text': 'How did the APIs function ?', 'priority': 'High Priority'},
        {'id': 'be_q2', 'text': 'Was this person open to resolving issues that came up?', 'priority': 'Niche'},
      ],
    },
     {
      'id': 'q_3',
      'title': 'Project X Post-Mortem',
      'creatorName': 'Lead Developer',
      'creationDate': DateTime(2025, 6, 25, 9, 0),
      'expiryDate': null, // No expiry
      'questions': [
        {'id': 'be_q1', 'text': 'How did the APIs function ?', 'priority': 'High Priority'},
        {'id': 'be_q2', 'text': 'Was this person open to resolving issues that came up?', 'priority': 'Niche'},
      ],
    },
  ];

  // Mock data for questionnaire responses
  List<Map<String, dynamic>> allResponses = [
    {
      'questionnaireId': 'q_1',
      'responderName': 'Alice',
      'submissionDate': DateTime(2025, 6, 21, 11, 0),
      'answers': [
        {'questionId': 'comm_q1', 'answer': 'Very clear and concise.'},
        {'questionId': 'be_q1', 'answer': 'APIs functioned flawlessly, very robust.'},
      ],
    },
    {
      'questionnaireId': 'q_1',
      'responderName': 'Bob',
      'submissionDate': DateTime(2025, 6, 22, 9, 30),
      'answers': [
        {'questionId': 'comm_q1', 'answer': 'Good clarity, some jargon used.'},
        {'questionId': 'be_q1', 'answer': 'APIs had minor latency issues, but overall good.'},
      ],
    },
    {
      'questionnaireId': 'q_2',
      'responderName': 'Charlie',
      'submissionDate': DateTime(2025, 5, 20, 16, 0),
      'answers': [
        {'questionId': 'comm_q1', 'answer': 'Excellent clarity, easy to follow.'},
        {'questionId': 'comm_q2', 'answer': 'No ambiguity observed.'},
        {'questionId': 'be_q1', 'answer': 'APIs were fast and reliable.'},
        {'questionId': 'be_q2', 'answer': 'Highly collaborative and open to feedback.'},
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredQuestionnaires {
    if (searchQuery.isEmpty) {
      return createdQuestionnaires;
    }
    return createdQuestionnaires.where((q) {
      return q['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
             q['creatorName'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void _addResponse(Map<String, dynamic> newResponse) {
    setState(() {
      allResponses.add(newResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Questionnaires'),
        backgroundColor: kMaroon,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0), // Increased height for two buttons and search
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search questionnaires...',
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    fillColor: Colors.white.withOpacity(0.2),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showCreateQuestionnaireDialog(context);
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Create', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMaroon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnswerFeedbacksPage(
                                createdQuestionnaires: createdQuestionnaires,
                                allResponses: allResponses,
                                addResponse: _addResponse, // Pass callback to add response
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.reply, color: Colors.white),
                        label: const Text('Answer', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey, // A different color for distinction
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredQuestionnaires.isEmpty
                ? Center(
                    child: Text(
                      searchQuery.isEmpty ? 'No questionnaires created yet.' : 'No matching questionnaires found.',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: filteredQuestionnaires.length,
                    itemBuilder: (context, index) {
                      final questionnaire = filteredQuestionnaires[index];
                      final responsesCount = allResponses
                          .where((r) => r['questionnaireId'] == questionnaire['id'])
                          .length;
                      
                      final bool isExpired = questionnaire['expiryDate'] != null &&
                                             (questionnaire['expiryDate'] as DateTime).isBefore(DateTime.now());

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      questionnaire['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: kMaroon,
                                      ),
                                    ),
                                  ),
                                  if (isExpired)
                                    Chip(
                                      label: const Text('Expired', style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.red.shade700,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _detailRow('Created By', questionnaire['creatorName'] ?? 'N/A'),
                              _detailRow(
                                  'Created On',
                                  DateFormat('MMM dd, yyyy - hh:mm a')
                                      .format(questionnaire['creationDate'])),
                              if (questionnaire['expiryDate'] != null)
                                _detailRow(
                                  'Expires On',
                                  DateFormat('MMM dd, yyyy - hh:mm a')
                                      .format(questionnaire['expiryDate']),
                                ),
                              _detailRow('Questions', '${questionnaire['questions'].length}'),
                              _detailRow('Responses', '$responsesCount'),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    tooltip: 'Edit Questionnaire',
                                    onPressed: () {
                                      _showCreateQuestionnaireDialog(
                                        context,
                                        questionnaire: questionnaire,
                                        isEditing: true,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share, color: Colors.green),
                                    tooltip: 'Share/Get Link',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Share link for "${questionnaire['title']}"')),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.visibility, color: Colors.purple),
                                    tooltip: 'View Answers',
                                    onPressed: () {
                                      _navigateToViewAnswersPage(context, questionnaire);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Delete Questionnaire',
                                    onPressed: () {
                                      _confirmDeleteQuestionnaire(context, questionnaire);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
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

  void _showCreateQuestionnaireDialog(BuildContext context, {Map<String, dynamic>? questionnaire, bool isEditing = false}) {
    final TextEditingController _titleController = TextEditingController(text: questionnaire?['title']);
    final TextEditingController _creatorNameController = TextEditingController(text: questionnaire?['creatorName']);
    List<Map<String, dynamic>> _selectedQuestions = List.from(questionnaire?['questions'] ?? []);
    String? _selectedTemplateTitle;
    DateTime? _selectedExpiryDate = questionnaire?['expiryDate'];

    if (isEditing && questionnaire != null && questionnaire['questions'] != null && questionnaire['questions'].isNotEmpty) {
      for (var template in availableTemplates) {
        if (template['questions']!.any((q) => _selectedQuestions.any((sq) => sq['id'] == q['id']))) {
          _selectedTemplateTitle = template['title'];
          break;
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState_dialog) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Questionnaire' : 'Create New Questionnaire', style: const TextStyle(color: kMaroon)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Questionnaire Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _creatorNameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name (Creator)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedExpiryDate ?? DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 years from now
                        );
                        if (pickedDate != null) {
                          setState_dialog(() {
                            // Keep existing time if any, otherwise set to end of day
                            _selectedExpiryDate = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date (Optional)',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        baseStyle: const TextStyle(fontSize: 16),
                        child: Text(
                          _selectedExpiryDate == null
                              ? 'No Expiry Set'
                              : DateFormat('MMM dd, yyyy').format(_selectedExpiryDate!),
                          style: _selectedExpiryDate == null ? TextStyle(color: Colors.grey[700]) : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownSearch<String>(
                      popupProps: const PopupProps.menu(
                        showSelectedItems: true,
                        showSearchBox: true, // Use showSearchBox instead of showSearchArt
                      ),
                      items: availableTemplates.map((e) => e['title'] as String).toList(),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Select Template',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      selectedItem: _selectedTemplateTitle,
                      onChanged: (String? newValue) {
                        setState_dialog(() {
                          _selectedTemplateTitle = newValue;
                          if (!isEditing || (newValue != null && availableTemplates.firstWhere((t) => t['title'] == newValue)['questions'] != null && !_selectedQuestions.every((sq) => availableTemplates.firstWhere((t) => t['title'] == newValue)['questions'].any((q) => q['id'] == sq['id'])))) {
                            _selectedQuestions.clear(); // Clear if template changed or not editing
                          }
                        });
                      },
                      clearButtonProps: const ClearButtonProps(isVisible: true),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedTemplateTitle != null)
                      Text('Questions from "${_selectedTemplateTitle!}":', style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (_selectedTemplateTitle != null)
                      ...availableTemplates
                          .firstWhere((t) => t['title'] == _selectedTemplateTitle)['questions']
                          .map<Widget>((q) {
                        bool isSelected = _selectedQuestions.any((sq) => sq['id'] == q['id']);
                        return CheckboxListTile(
                          title: Text(q['text']),
                          value: isSelected,
                          onChanged: (bool? newValue) {
                            setState_dialog(() {
                              if (newValue == true) {
                                _selectedQuestions.add(q);
                              } else {
                                _selectedQuestions.removeWhere((sq) => sq['id'] == q['id']);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: kMaroon)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty || _selectedQuestions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title and select at least one question.')),
                      );
                      return;
                    }

                    setState(() {
                      if (isEditing && questionnaire != null) {
                        // Update existing questionnaire
                        questionnaire['title'] = _titleController.text;
                        questionnaire['creatorName'] = _creatorNameController.text.isNotEmpty ? _creatorNameController.text : 'Anonymous';
                        questionnaire['expiryDate'] = _selectedExpiryDate;
                        questionnaire['questions'] = _selectedQuestions;
                      } else {
                        // Create new questionnaire
                        createdQuestionnaires.add({
                          'id': 'q_${DateTime.now().millisecondsSinceEpoch}', // Simple unique ID
                          'title': _titleController.text,
                          'creatorName': _creatorNameController.text.isNotEmpty ? _creatorNameController.text : 'Anonymous',
                          'creationDate': DateTime.now(),
                          'expiryDate': _selectedExpiryDate,
                          'questions': _selectedQuestions,
                        });
                      }
                    });
                    Navigator.of(dialogContext).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
                  child: Text(isEditing ? 'Save Changes' : 'Create', style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteQuestionnaire(BuildContext context, Map<String, dynamic> questionnaire) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Questionnaire', style: TextStyle(color: kMaroon)),
          content: Text('Are you sure you want to delete "${questionnaire['title']}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: kMaroon)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  createdQuestionnaires.removeWhere((q) => q['id'] == questionnaire['id']);
                  // Also remove associated responses
                  allResponses.removeWhere((r) => r['questionnaireId'] == questionnaire['id']);
                });
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${questionnaire['title']}" deleted.')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToViewAnswersPage(BuildContext context, Map<String, dynamic> questionnaire) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAnswersPage(
          questionnaire: questionnaire,
          allResponses: allResponses, // Pass all responses to filter later
        ),
      ),
    );
  }
}

// --- New Page for Viewing Answers ---
class ViewAnswersPage extends StatelessWidget {
  final Map<String, dynamic> questionnaire;
  final List<Map<String, dynamic>> allResponses;

  const ViewAnswersPage({
    Key? key,
    required this.questionnaire,
    required this.allResponses,
  }) : super(key: key);

  List<Map<String, dynamic>> get questionnaireResponses {
    return allResponses
        .where((r) => r['questionnaireId'] == questionnaire['id'])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${questionnaire['title']} - Answers'),
        backgroundColor: kMaroon,
      ),
      body: questionnaireResponses.isEmpty
          ? const Center(
              child: Text(
                'No responses for this questionnaire yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: questionnaireResponses.length,
              itemBuilder: (context, index) {
                final response = questionnaireResponses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Responder: ${response['responderName']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kMaroon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Submitted On: ${DateFormat('MMM dd, yyyy - hh:mm a').format(response['submissionDate'])}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const Divider(height: 20, thickness: 1),
                        // Display answers
                        ...response['answers'].map<Widget>((answer) {
                          // Find the full question text from the questionnaire's questions
                          final question = questionnaire['questions'].firstWhere(
                            (q) => q['id'] == answer['questionId'],
                            orElse: () => {'text': 'Unknown Question'}, // Fallback
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Q: ${question['text']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'A: ${answer['answer']}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// --- New Page for Answering Feedbacks ---
class AnswerFeedbacksPage extends StatefulWidget {
  final List<Map<String, dynamic>> createdQuestionnaires;
  final List<Map<String, dynamic>> allResponses;
  final Function(Map<String, dynamic>) addResponse;

  const AnswerFeedbacksPage({
    Key? key,
    required this.createdQuestionnaires,
    required this.allResponses,
    required this.addResponse,
  }) : super(key: key);

  @override
  State<AnswerFeedbacksPage> createState() => _AnswerFeedbacksPageState();
}

class _AnswerFeedbacksPageState extends State<AnswerFeedbacksPage> {
  String searchQuery = '';
  DateTime? selectedDateFilter;

  List<Map<String, dynamic>> get availableForAnswering {
    return widget.createdQuestionnaires.where((q) {
      final bool isExpired = q['expiryDate'] != null && (q['expiryDate'] as DateTime).isBefore(DateTime.now());
      if (isExpired) return false; // Don't show expired for answering

      // Filter by search query (creator name or title)
      final bool matchesSearch = searchQuery.isEmpty ||
                                 q['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                                 (q['creatorName']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      // Filter by date posted
      final bool matchesDate = selectedDateFilter == null ||
                               (q['creationDate'] as DateTime).year == selectedDateFilter!.year &&
                               (q['creationDate'] as DateTime).month == selectedDateFilter!.month &&
                               (q['creationDate'] as DateTime).day == selectedDateFilter!.day;
      return matchesSearch && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Answer Feedbacks'),
        backgroundColor: kMaroon,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by title or creator...',
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    fillColor: Colors.white.withOpacity(0.2),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateFilter ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    setState(() {
                      selectedDateFilter = pickedDate;
                    });
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: selectedDateFilter == null ? 'Filter by Date Posted' : DateFormat('MMM dd, yyyy').format(selectedDateFilter!),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: selectedDateFilter != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white70),
                              onPressed: () {
                                setState(() {
                                  selectedDateFilter = null;
                                });
                              },
                            )
                          : const Icon(Icons.calendar_today, color: Colors.white70),
                    ),
                    baseStyle: const TextStyle(color: Colors.white),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: availableForAnswering.isEmpty
          ? Center(
              child: Text(
                searchQuery.isEmpty && selectedDateFilter == null
                    ? 'No active questionnaires available for answering.'
                    : 'No matching active questionnaires found.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: availableForAnswering.length,
              itemBuilder: (context, index) {
                final questionnaire = availableForAnswering[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionnaire['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kMaroon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created By: ${questionnaire['creatorName']}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          'Posted On: ${DateFormat('MMM dd, yyyy').format(questionnaire['creationDate'])}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        if (questionnaire['expiryDate'] != null)
                          Text(
                            'Expires On: ${DateFormat('MMM dd, yyyy').format(questionnaire['expiryDate'])}',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubmitFeedbackPage(
                                    questionnaire: questionnaire,
                                    addResponse: widget.addResponse,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                            child: const Text('Answer', style: TextStyle(color: Colors.white)),
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

// --- New Page for Submitting Answers ---
class SubmitFeedbackPage extends StatefulWidget {
  final Map<String, dynamic> questionnaire;
  final Function(Map<String, dynamic>) addResponse;

  const SubmitFeedbackPage({
    Key? key,
    required this.questionnaire,
    required this.addResponse,
  }) : super(key: key);

  @override
  State<SubmitFeedbackPage> createState() => _SubmitFeedbackPageState();
}

class _SubmitFeedbackPageState extends State<SubmitFeedbackPage> {
  late Map<String, TextEditingController> _answerControllers;
  final TextEditingController _responderNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _answerControllers = {};
    for (var q in widget.questionnaire['questions']) {
      _answerControllers[q['id']] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _responderNameController.dispose();
    _answerControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _submitAnswers() {
    if (_responderNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to submit feedback.')),
      );
      return;
    }

    final List<Map<String, dynamic>> answers = [];
    bool allAnswered = true;
    for (var q in widget.questionnaire['questions']) {
      final answerText = _answerControllers[q['id']]?.text;
      if (answerText == null || answerText.isEmpty) {
        allAnswered = false;
        break;
      }
      answers.add({
        'questionId': q['id'],
        'answer': answerText,
      });
    }

    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions before submitting.')),
      );
      return;
    }

    final newResponse = {
      'questionnaireId': widget.questionnaire['id'],
      'responderName': _responderNameController.text,
      'submissionDate': DateTime.now(),
      'answers': answers,
    };

    widget.addResponse(newResponse); // Call the callback to update parent state
    Navigator.pop(context); // Go back to AnswerFeedbacksPage
    Navigator.pop(context); // Go back to FeedbackPage (might need to adjust based on your flow)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer: "${widget.questionnaire['title']}"'),
        backgroundColor: kMaroon,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Questionnaire by: ${widget.questionnaire['creatorName']}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Posted On: ${DateFormat('MMM dd, yyyy - hh:mm a').format(widget.questionnaire['creationDate'])}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
             if (widget.questionnaire['expiryDate'] != null)
              Text(
                'Expires On: ${DateFormat('MMM dd, yyyy - hh:mm a').format(widget.questionnaire['expiryDate'])}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            const Divider(height: 32, thickness: 1),
            TextField(
              controller: _responderNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name (Responder)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ...widget.questionnaire['questions'].asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              Map<String, dynamic> question = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}: ${question['text']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kMaroon,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _answerControllers[question['id']],
                      maxLines: null, // Allow multiple lines for answers
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Type your answer here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitAnswers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMaroon,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}