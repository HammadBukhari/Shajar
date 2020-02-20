import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shajar/model/chat_argument.dart';
import 'package:shajar/model/message.dart';
import 'package:shajar/model/plant.dart';
import 'package:shajar/provider/chat_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shajar/firebase/message_helper.dart';
import 'package:intl/intl.dart';
import 'package:shajar/provider/login_provider.dart';

class MessageScreen extends StatefulWidget {
  static const route = 'message';
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool isDonated = false;
  bool isDialogBoxShown = false;
  ScrollController _scrollController = ScrollController();

  final _inputController = TextEditingController();
  Widget _buildChatBody(BuildContext context, ChatProvider proivder) {
    // return ListView.builder(
    //   itemCount: proivder.messagesFromSecondParticipant.length,
    //   itemBuilder: (context, index) => _buildChatItem(context, index),
    // );
    return StreamBuilder(
      stream: proivder.getMessagesStreamWithSecondParticipant(),
      builder: (context, snapshot) => _buildChat(context, snapshot),
    );
  }

  Widget _buildChat(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData && snapshot.data.exists) {
      final List<Message> allMessage = [];
      final List<dynamic> allMessagesDocument = snapshot.data['messages'];
      for (var message in allMessagesDocument) {
        final messageMap = Map<String, dynamic>.from(message);
        allMessage.add(Message(
            content: messageMap[MessageFirebaseHelper.content],
            recevierUid: messageMap[MessageFirebaseHelper.receiverUid],
            senderUid: messageMap[MessageFirebaseHelper.senderUid],
            type: MessageType.values[messageMap[MessageFirebaseHelper.type]],
            timestamp: messageMap[MessageFirebaseHelper.timestamp]));
      }

      allMessage.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return ListView.builder(
          controller: _scrollController,
          itemCount: allMessage.length,
          itemBuilder: (context, index) =>
              buildChatItem(context, allMessage[index]));
    }
    return Container();
  }

  Widget buildChatItem(BuildContext context, Message message) {
    bool isMessageOnLeft = (message.senderUid
            .compareTo(Provider.of<ChatProvider>(context).appUser.uid)) ==
        0;
    return Row(
        mainAxisAlignment:
            isMessageOnLeft ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Card(
              color:
                  isMessageOnLeft ? const Color(0xFFC9D1B2) : Color(0xFFEEEEEE),
              margin: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: isMessageOnLeft
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message.content,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      DateFormat.jm().format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              message.timestamp * 1000)),
                      style: TextStyle(
                        color: Colors.grey[600],
                        // color : const Color(0xFF212121),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
            ),
          ),
        ]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => onWidgetBuildCompleted(context));
  }

  void onWidgetBuildCompleted(BuildContext context) async {
    int role = Provider.of<LoginProvider>(context, listen: false).user.role;
    if (!isDialogBoxShown && role == 2)
      Future.delayed(Duration.zero).then((value) {
        isDialogBoxShown = true;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Donated the plant?'),
            content: Row(
              children: <Widget>[
                Text('Tap on '),
                Icon(Icons.check),
                Text(' when you donate the plant')
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      });

    if (role == 1) {
      isDonated = true;
    }
    setState(() {
      isDonated = isDonated;
    });
  }

  Widget _buildInput(BuildContext context, ChatProvider provider) {
    provider.getPlant().then((value) {
      if (value.status == Plant.STATUS_DONATED) {
        setState(() {
          isDonated = true;
        });
      }
    });
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Container(
            margin: EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 3.0),
            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8.0,
                    color: Colors.grey,
                  ),
                ]),
            child: Row(
              children: <Widget>[
                !isDonated
                    ? IconButton(
                        onPressed: () {
                          confirmDonation(context);
                        },
                        icon: Icon(Icons.done),
                      )
                    : Container(),
                SizedBox(width: 10),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: TextField(
                    controller: _inputController,
                    style: TextStyle(fontSize: 15.0),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 3.0),
          decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8.0,
                  color: Colors.grey,
                ),
              ]),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_inputController.text.trim().length != 0) {
                provider.sendMessage(
                    MessageType.message_text, _inputController.text.trim());
                _inputController.clear();
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent + 100.0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut);
              }
            },
          ),
        )
      ],
    );
  }

  void confirmDonation(BuildContext context) {
    setState(() {
      isDonated = true;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!',
            style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: Color(0xff51b055),
            )),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              image: AssetImage('assets/congo.png'),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
                "You're a step nearer to your goal now\nYou can continue to chat to ask for your plant health.",
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(color: Color(0xff51b055)),
            ),
          )
        ],
      ),
    );
    Provider.of<ChatProvider>(context, listen: false).confirmDonation();
  }

  Widget _buildAppBar(BuildContext context, ChatProvider provider) {
    if (Provider.of<ChatProvider>(context, listen: true).secondParticipant !=
        null) {
      return AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.0),
            child: CachedNetworkImage(
              imageUrl: provider.secondParticipant.photoUrl,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        title: Text(provider.secondParticipant.name,
            style: TextStyle(
              fontFamily: "Airbnb Cereal App",
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: Color(0xff143109),
            )),
      );
    }
    return AppBar(
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatArguments args = ModalRoute.of(context).settings.arguments;

    return ChangeNotifierProvider(
        create: (context) => ChatProvider(
            appUser: args.appUser,
            secondParticipantUid: args.secondParticipantUid,
            plantToDiscussUid: args.plantToDiscussUid),
        child: MaterialApp(
          home: Consumer<ChatProvider>(builder: (context, provider, child) {
            return Scaffold(
              appBar: _buildAppBar(context, provider),
              body: Column(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Container(
                        color: Colors.white,
                        child: _buildChatBody(context, provider)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: _buildInput(context, provider),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
