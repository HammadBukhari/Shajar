import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shajar/firebase/login_helper.dart';
import 'package:shajar/model/user.dart';
import 'package:shajar/provider/chat_provider.dart';
import 'package:shajar/provider/login_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shajar/firebase/chat_helper.dart';
import 'package:shajar/presentation/message_screen.dart';
import 'package:shajar/model/chat_argument.dart';

class ChatListScreen extends StatefulWidget {
  static const route = 'chatlist';
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

enum ChatStatus { ongoing, donated }

class _ChatListScreenState extends State<ChatListScreen> {
  FirebaseUser appUser;
  List<User> chatUsers;
  bool isChatUsersLoaded = false;

  getChatUsers() async {
    isChatUsersLoaded = false;
    final DocumentSnapshot userFromFirebase =
        await Firestore.instance.collection('user').document(appUser.uid).get();
    try {
      if (userFromFirebase.data[LoginFirebaseHelper.CHAT_WITH] != null) {
        final List<String> chatUserUids = List<String>.from(
            userFromFirebase.data[LoginFirebaseHelper.CHAT_WITH]);
        chatUsers = [];
        for (final user in chatUserUids) {
          final userDocument =
              await Firestore.instance.collection('user').document(user).get();
          chatUsers.add(User(
            name: userDocument[LoginFirebaseHelper.NAME],
            photoUrl: userDocument[LoginFirebaseHelper.PHOTO_URL],
            uid: userDocument[LoginFirebaseHelper.UID],
          ));
        }
      }
    } on NoSuchMethodError {
      return;
    }
    isChatUsersLoaded = true;
    setState(() {
      chatUsers = chatUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Inbox',
              style: TextStyle(
                fontFamily: "Airbnb Cereal App",
                fontWeight: FontWeight.w700,
                fontSize: 36,
                color: Color(0xff707070),
              )),
        ),
        body: Container(
            color: Colors.white,
            child: buildChatListBody(context, ChatStatus.ongoing)),
      ),
    );
  }

  Widget buildChatListBody(BuildContext context, ChatStatus chatStatus) {
    if (isChatUsersLoaded) {
      if (chatUsers == null) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
              child: Text(
            '😧 Its lonely here. Start chat with people on map for donation/care taking',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )),
        );
      }
      return ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) =>
            buildChatItem(context, chatUsers[index]),
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => onWidgetBuildCompleted(context));
  }

  void onWidgetBuildCompleted(BuildContext context) async {
    appUser = Provider.of<LoginProvider>(context, listen: false).firebaseUser;
    while (true) {
      await Future.delayed(Duration(seconds: 10)).then((value) => getChatUsers());
    }
  }

  String createCombinedId(String id1, String id2) {
    if (id1.compareTo(id2) == 1) {
      return '$id1$id2';
    } else {
      return '$id2$id1';
    }
  }

  onUserClicked(User user) async {
    final document = await Firestore.instance
        .collection('messages')
        .document(createCombinedId(appUser.uid, user.uid))
        .get();
    final selectedPlantUid = document.data[ChatFirebaseHelper.plantUid];
    Navigator.pushNamed(context, MessageScreen.route,
        arguments: ChatArguments(
            appUser:
                Provider.of<LoginProvider>(context, listen: false).firebaseUser,
            plantToDiscussUid: selectedPlantUid,
            secondParticipantUid: user.uid));
  }

  Widget buildChatItem(BuildContext context, User user) {
    return GestureDetector(
      onTap: () => onUserClicked(user),
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48.0),
                child: CachedNetworkImage(
                  imageUrl: user.photoUrl,
                  height: 64,
                  width: 64,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 25, 20, 20),
              child: Text(
                user.name,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
