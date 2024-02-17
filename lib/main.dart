import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jiffy/jiffy.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import 'package:flutter/material.dart';
import 'package:chat/widgets/chat_bubble.dart';
import 'package:chat/widgets/chat_input.dart';
import 'package:chat/widgets/my_bubble.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SendbirdChat.init(appId: 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF');
    await SendbirdChat.connect("USER_ID");

    runApp(const MyApp());
  }, (error, stackTrace) async {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        disabledColor: const Color.fromRGBO(58, 58, 58, 1),
        colorScheme: const ColorScheme.dark().copyWith(
            primary: const Color.fromRGBO(255, 0, 106, 1),
            background: const Color.fromRGBO(14, 13, 13, 1),
            surface: const Color.fromRGBO(26, 26, 26, 1)),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '강남스팟'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final channelUrl =
      "sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211";

  OpenChannel? openChannel;
  List<BaseMessage> messageList = [];

  @override
  void initState() {
    super.initState();
    SendbirdChat.addChannelHandler(
        'OpenChannel', CustomOpenChannelHandler(this));

    (() async {
      final channel = await OpenChannel.getChannel(channelUrl);
      await channel.enter();
      final messages = await PreviousMessageListQuery(
              channelType: ChannelType.open, channelUrl: channelUrl)
          .next();

      setState(() {
        messageList
          ..clear()
          ..addAll(messages);
        openChannel = channel;
      });
    })();
  }

  @override
  void dispose() {
    SendbirdChat.removeChannelHandler('OpenChannel');
    OpenChannel.getChannel(channelUrl).then((channel) => channel.exit());
    super.dispose();
  }

  void _addMessage(BaseMessage message) {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        messageList.add(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.menu))
        ],
        leading: IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        title: Text(
          "${widget.title} ${messageList.length}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: messageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return messageList[index].sender == null ||
                          !(messageList[index].sender!).isCurrentUser
                      ? ChatBubble(
                          isUserOnline:
                              messageList[index].sender?.connectionStatus ==
                                  UserConnectionStatus.online,
                          username:
                              messageList[index].sender?.nickname ?? "Unknown",
                          profileUrl: messageList[index].sender?.profileUrl,
                          message: messageList[index].message,
                          date: timeago.format(
                              Jiffy.parseFromMillisecondsSinceEpoch(
                                      messageList[index].createdAt)
                                  .dateTime,
                              locale: 'en_short'),
                        )
                      : MyChatBubble(content: messageList[index].message);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 12),
              ),
            ),
          ),
          ChatInput(
            openChannel: openChannel,
            sendMessage: _addMessage,
          )
        ],
      ),
    );
  }
}

class CustomOpenChannelHandler extends OpenChannelHandler {
  final MyHomePageState _state;

  CustomOpenChannelHandler(this._state);

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    _state._addMessage(message);
  }
}
