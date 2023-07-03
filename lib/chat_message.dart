import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(this.data, {super.key, required this.myMessage});

  final Map<String, dynamic> data;
  final bool myMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          !myMessage
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['senderPhotoUrl'] ?? ''),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data['imgUrl'] != null
                    ? Image.network(data['imgUrl'],
                        height: 350, fit: BoxFit.fill)
                    : Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          data['text'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                Text(data['senderName'] ?? '',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          myMessage
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['senderPhotoUrl'] ?? ''),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
