import 'package:flutter/material.dart';

class PerformanceFeedback extends StatelessWidget {
  const PerformanceFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
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
