import 'package:flutter/material.dart';
import 'package:focus_app/core/dependency_injection.dart';
import 'package:focus_app/features/authentication/presentation/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focus_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DependenciesRoot.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    );
  }
}
