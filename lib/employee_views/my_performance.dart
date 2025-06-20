import 'package:flutter/material.dart';

class MyPerformance extends StatelessWidget {
  const MyPerformance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Performance'),
      ),
      body: const Center(
        child: Text(
          'This is the My Performance page.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
