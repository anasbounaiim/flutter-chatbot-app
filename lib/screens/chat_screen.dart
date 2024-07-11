import 'package:flutter/material.dart';
import 'package:tp/api/api_service.dart';
import 'package:tp/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      _controller.clear();
      setState(() {
        _messages.add(Message(text: text, isUser: true));
      });

      try {
        final response = await _apiService.getResponse(text);
        setState(() {
          _messages.add(Message(text: response, isUser: false));
        });
      } catch (e) {
        setState(() {
          _messages.add(Message(text: 'Error: $e', isUser: false));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.message, color: Colors.white), // Message icon
            SizedBox(width: 8),
            Text(
              'ChatBot',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1E1E1E), // Dark primary color
      ),
      body: Container(
        color: Color(0xFF121212), // Dark background color
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false, // Show latest messages at the bottom
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message.isUser ? Color(0xc9a82dff) : Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Material(
                    color: Color(0xc9a82dff), // Blue color for the send button
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
