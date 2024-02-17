import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatInput extends StatefulWidget {
  final OpenChannel? openChannel;
  final dynamic sendMessage;

  const ChatInput({super.key, this.openChannel, this.sendMessage});

  @override
  State<StatefulWidget> createState() => _ChatInput();
}

class _ChatInput extends State<ChatInput> {
  bool _isActive = false;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.add)),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: textController,
                  onChanged: (value) => {
                    setState(() {
                      _isActive = value.trim() != "";
                    })
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    constraints: BoxConstraints(maxHeight: 48),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(50, 50, 50, 1), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(50, 50, 50, 1), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    hintText: "메세지 보내기",
                    isDense: true,
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: _isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                      child: IconButton(
                        onPressed: _isActive
                            ? () {
                          print("submitting");
                          print(widget.openChannel);
                                widget.openChannel?.sendUserMessage(
                                  UserMessageCreateParams(
                                    message: textController.value.text,
                                  ),
                                  handler: (UserMessage message,
                                      SendbirdException? e) async {
                                    if (e == null) {
                                      widget.sendMessage(message);
                                    } else {
                                      print("Unexpected error " + e.toString());
                                    }
                                  },
                                );
                                textController.clear();
                              }
                            : null,
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.black,
                        ),
                        padding: const EdgeInsets.all(4),
                        iconSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
