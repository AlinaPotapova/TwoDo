import 'package:flutter/material.dart';

class LoginErrorContent extends StatelessWidget {
  final String message;

  const LoginErrorContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Retry"),
            )
          ],
        ),
      ),
    );
  }
}
