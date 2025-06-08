import 'package:flutter/material.dart';

class ChatDetailsPage extends StatelessWidget {
  final String name;
  final String image;

  const ChatDetailsPage({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    final myImage = "https://randomuser.me/api/portraits/men/44.jpg";

    final messages = [
      {'text': 'Hello! How can I assist you ?', 'isMe': false},
      {'text': "I'd like to book an appointment .", 'isMe': true},
      {'text': 'We have available slots next week.', 'isMe': false},
      {'text': "I'd prefer an appointment on Monday.", 'isMe': true},
      {'text': 'Your appointment is at 10 AM .', 'isMe': false},
      {'text': 'Yes sounds good.', 'isMe': true},
      {'text': 'Who is the Doctor ?', 'isMe': true},
      {'text': 'With Dr. Mohammed.', 'isMe': false},
      {'text': 'Good luck !!', 'isMe': false},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment:
                    isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      if (isMe)
                        CircleAvatar(radius: 18, backgroundImage: NetworkImage(myImage)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.white : Colors.blue.shade600,
                          border: Border.all(color: Colors.blue.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['text'] as String,

                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (!isMe)
                        CircleAvatar(radius: 18, backgroundImage: NetworkImage(image)),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom text field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type message here',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.attachment_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                const Icon(Icons.camera_alt_outlined, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
