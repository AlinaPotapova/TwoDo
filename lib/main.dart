import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_do/core/dependency_injection.dart';
import 'package:two_do/features/authentication/presentation/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:two_do/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // TODO: Firebase App Check — enable after proper configuration in Firebase Console
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );
  if (kIsWeb) {}
  DependenciesRoot.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ValueNotifier<ThemeMode>>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Two Do',
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
          ),

          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 115, 146, 195),
              brightness: Brightness.dark,
            ),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
