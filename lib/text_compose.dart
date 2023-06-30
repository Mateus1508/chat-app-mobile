import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage, {super.key});

  Function(String) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;

  final TextEditingController _textController = TextEditingController();

  void _resetTextField() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar uma mensagem'),
              onChanged: (text) =>
                  {setState(() => _isComposing = text.isNotEmpty)},
              onSubmitted: (text) {
                widget.sendMessage(text);
                _resetTextField();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(_textController.text);
                    _resetTextField();
                  }
                : null,
          )
        ],
      ),
    );
  }
}
