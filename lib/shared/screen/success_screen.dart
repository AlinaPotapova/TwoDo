import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  const SuccessScreen(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Success')),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 24, color: Colors.green),
        ),
      ),
    );
  }
}
