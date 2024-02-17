import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isUserOnline;
  final String username;
  final String message;
  final String? profileUrl;
  final String date;

  const ChatBubble(
      {super.key,
      this.profileUrl,
      required this.isUserOnline,
      required this.username,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: profileUrl != null && profileUrl != ""
                  ? NetworkImage(profileUrl!)
                  : null,
              backgroundColor: Colors.brown.shade800,
              child: profileUrl == null || profileUrl == ""
                  ? Text(username != "" ? username[0] : "")
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(26, 26, 26, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(username,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(173, 173, 173, 1))),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: isUserOnline
                                ? const Color.fromRGBO(70, 249, 245, 1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24.0)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              date,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(173, 173, 173, 1)),
            ),
          ),
        ],
      ),
    );
  }
}
