import 'dart:io';

import 'package:chat_app/text_compose.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessage({String? text, XFile? imgFile}) async {
    Map<String, dynamic> data = {};

    if (imgFile != null) {
      final File file = File(imgFile.path);
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().microsecondsSinceEpoch.toString());
      final TaskSnapshot snapshot = await storageRef.putFile(file);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      data['imgUrl'] = downloadUrl;
    }
    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFce4257),
        elevation: 0,
        title: const Text(
          'Olá',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: TextComposer(_sendMessage),
      ),
    );
  }
}
