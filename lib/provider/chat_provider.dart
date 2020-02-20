import 'dart:core';
import 'package:shajar/firebase/chat_helper.dart';
import 'package:shajar/firebase/login_helper.dart';
import 'package:shajar/firebase/message_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shajar/firebase/plant_helper.dart';
import 'package:shajar/model/plant.dart';
import 'package:shajar/model/message.dart';
import 'package:shajar/model/user.dart';

class ChatProvider with ChangeNotifier {
  String combinedDocumentId;
  FirebaseUser appUser;
  String plantToDiscussUid;
  String secondParticipantUid;
  User secondParticipant;
  Plant plant;
  // List<User> chatUsers;
  // bool isChatUsersLoaded = false;
  Future<Plant> getPlant() async {
    final QuerySnapshot plantSs = await Firestore.instance
        .collection('plant')
        .where(PlantFirebaseHelper.PID, isEqualTo: plantToDiscussUid)
        .getDocuments();
    return Plant(status: plantSs.documents[0][PlantFirebaseHelper.STATUS]);
  }

  getSecondParticiantDetails() async {
    final QuerySnapshot userDocument = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: secondParticipantUid)
        .getDocuments();
    if (userDocument.documents.length != 0) {
      final userFromDocument = userDocument.documents[0].data;
      List<Map<String, dynamic>> userGoal = [];
      for (dynamic goal in userFromDocument['goals']) {
        userGoal.add(Map<String, dynamic>.from(goal));
      }
      if (userGoal is List<Map<String, dynamic>>) {
        print('yes');
      }
      secondParticipant = User(
          goals: userGoal,
          name: userFromDocument['name'],
          photoUrl: userFromDocument['photo_url'],
          uid: userFromDocument['uid']);
      combinedDocumentId = createCombinedId();
      notifyListeners();
    }
  }

  String createCombinedId() {
    if (appUser.uid.compareTo(secondParticipant.uid) == 1) {
      return '${appUser.uid}$secondParticipantUid';
    } else {
      return '$secondParticipantUid${appUser.uid}';
    }
  }

  ChatProvider(
      {this.appUser, this.secondParticipantUid, this.plantToDiscussUid}) {
    getSecondParticiantDetails();
  }
  List<Message> messagesFromSecondParticipant = [];
  Future<void> sendMessage(MessageType type, String content) async {
    final DocumentSnapshot messagesDocument = await Firestore.instance
        .collection('messages')
        .document(combinedDocumentId)
        .get();

    if (messagesDocument.exists) {
      messagesDocument.reference.updateData({
        ChatFirebaseHelper.messages: FieldValue.arrayUnion([
          {
            MessageFirebaseHelper.content: content,
            MessageFirebaseHelper.type: type.index,
            MessageFirebaseHelper.senderUid: appUser.uid,
            MessageFirebaseHelper.receiverUid: secondParticipantUid,
            MessageFirebaseHelper.timestamp:
                DateTime.now().millisecondsSinceEpoch
          }
        ])
      });
    } else {
      Firestore.instance
          .collection('messages')
          .document(combinedDocumentId)
          .setData({
        ChatFirebaseHelper.plantUid: plantToDiscussUid,
        ChatFirebaseHelper.combinedUid: combinedDocumentId,
        ChatFirebaseHelper.participants: [appUser.uid, secondParticipantUid],
        ChatFirebaseHelper.messages: [
          {
            MessageFirebaseHelper.content: content,
            MessageFirebaseHelper.type: type.index,
            MessageFirebaseHelper.senderUid: appUser.uid,
            MessageFirebaseHelper.receiverUid: secondParticipantUid,
            MessageFirebaseHelper.timestamp:
                DateTime.now().millisecondsSinceEpoch
          }
        ]
      });
      // change status of plant from start to ongoing
      final QuerySnapshot querySnapshot = await Firestore.instance
          .collection('plant')
          .where(PlantFirebaseHelper.PID, isEqualTo: plantToDiscussUid)
          .getDocuments();
      if (querySnapshot.documents.length != 0) {
        await querySnapshot.documents[0].reference.updateData({
          PlantFirebaseHelper.STATUS: Plant.STATUS_ONGOING,
        });
      }
      // add chatWith on appUser and secondParticipant user node
      Firestore.instance.collection('user').document(appUser.uid).updateData({
        LoginFirebaseHelper.CHAT_WITH:
            FieldValue.arrayUnion([secondParticipantUid])
      });
      Firestore.instance
          .collection('user')
          .document(secondParticipantUid)
          .updateData({
        LoginFirebaseHelper.CHAT_WITH: FieldValue.arrayUnion([appUser.uid])
      });
    }
  }

  Future<void> confirmDonation() async {
    // change status of plant
    final QuerySnapshot plantSs = await Firestore.instance
        .collection('plant')
        .where(PlantFirebaseHelper.PID, isEqualTo: plantToDiscussUid)
        .getDocuments();
    plantSs.documents[0].reference.updateData({
      PlantFirebaseHelper.STATUS: Plant.STATUS_DONATED,
    });
    // increment point of appUser
    final DocumentSnapshot appUserSs =
        await Firestore.instance.collection('user').document(appUser.uid).get();
    final userFromDocument = appUserSs.data;
    List<Map<String, dynamic>> userGoal = [];
    for (dynamic goal in userFromDocument['goals']) {
      userGoal.add(Map<String, dynamic>.from(goal));
    }
    await appUserSs.reference.updateData(
        {LoginFirebaseHelper.GOALS: FieldValue.arrayRemove(userGoal)});
    // updateGoal
    userGoal[0]['goalCompleted'] = userGoal[0]['goalCompleted'] + 1;
    await appUserSs.reference.updateData(
        {LoginFirebaseHelper.GOALS: FieldValue.arrayUnion(userGoal)});

    // increment point of secondParticipant
    final DocumentSnapshot secondUserSs = await Firestore.instance
        .collection('user')
        .document(secondParticipantUid)
        .get();
    final secondUserFromDocument = secondUserSs.data;
    List<Map<String, dynamic>> secondUserGoal = [];
    for (dynamic goal in secondUserFromDocument['goals']) {
      secondUserGoal.add(Map<String, dynamic>.from(goal));
    }
    await secondUserSs.reference.updateData(
        {LoginFirebaseHelper.GOALS: FieldValue.arrayRemove(secondUserGoal)});
    // updateGoal
    secondUserGoal[0]['goalCompleted'] = secondUserGoal[0]['goalCompleted'] + 1;
    await secondUserSs.reference.updateData(
        {LoginFirebaseHelper.GOALS: FieldValue.arrayUnion(secondUserGoal)});
  }

  Stream<DocumentSnapshot> getMessagesStreamWithSecondParticipant() {
    return Firestore.instance
        .collection('messages')
        .document(combinedDocumentId)
        .snapshots();
  }
}
