import 'package:chat_app/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFce4257)),
        iconTheme: const IconThemeData(
          color: Color(0xFFce4257),
        ),
        useMaterial3: true,
      ),
      color: Colors.red.shade100,
      home: const ChatScreen(),
    );
  }
}
