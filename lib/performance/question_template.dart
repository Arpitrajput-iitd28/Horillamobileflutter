import 'package:flutter/material.dart';

class QuestionTemplate extends StatelessWidget {
  const QuestionTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('extended Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Features under development',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
