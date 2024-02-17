import 'package:flutter/material.dart';

class MyChatBubble extends StatelessWidget {
  final String content;

  const MyChatBubble({
    super.key,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 0, 107, 1),
                  Color.fromRGBO(255, 69, 147, 1),
                ],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                topLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Text(
              content,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              softWrap: true,
            ),
          ),
        )
      ],
    );
  }
}