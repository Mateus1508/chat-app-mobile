import 'dart:io';

import 'package:chat_app/text_compose.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User? _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user;
    });
  }

  _getUser() async {
    if (_currentUser != null) _currentUser;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User user = userCredential.user!;
        return user;
      }
    } catch (error) {
      return null;
    }
  }

  void _sendMessage({String? text, XFile? imgFile}) async {
    final User? user = await _getUser();

    if (user == null) {
      final BuildContext context = _scaffoldKey.currentContext!;
      const snackBar = SnackBar(
        content: Text('Não foi possível fazer o login. Tente outra vez!'),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Map<String, dynamic> data = {
      'id': user!.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
    };

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

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFce4257),
        elevation: 0,
        title: const Text(
          'Olá',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: messages.snapshots(),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<DocumentSnapshot<Object?>> documents =
                      snapshot.data!.docs.reversed.toList();
                  return ListView.builder(
                    itemCount: documents.length,
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      return ChatMessage(
                        data,
                        myMessage: true,
                      );
                    },
                  );
              }
            },
          )),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}
