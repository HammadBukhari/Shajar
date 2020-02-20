import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shajar/firebase/chat_helper.dart';
import 'package:shajar/firebase/login_helper.dart';
import 'package:shajar/firebase/plant_helper.dart';
import 'package:shajar/model/plant.dart';
import 'package:shajar/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shajar/model/user_location_status.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum OnlineProgress {
  notstarted,
  ongoing,
  completed,
  error,
}

class LoginProvider extends ChangeNotifier {
  OnlineProgress uploadPlantProgress = OnlineProgress.notstarted;
  FirebaseUser firebaseUser;
  bool isNewLogin = false;
  bool isloggedIn = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User user;
  Position userLocation;
  Placemark userPlacemark;
  UserLocationStatus userLocationStatus = UserLocationStatus.notstarted;

  int calculateUsage(double electricity, double gas, double fuel) {
    double emission = 0;
    emission += (electricity * 12.0) * 0.99;
    emission += (fuel / 3.7854) * 19.56;
    emission += (gas * 12.08);
    emission *= 0.10; // only taking 10%
    return (emission / 48.0).floor();
  }

  void resetPlantUploadProgress() {
    uploadPlantProgress = OnlineProgress.notstarted;
  }

  Future<bool> uploadPlant(String name, int quantity, File image) async {
    uploadPlantProgress = OnlineProgress.ongoing;
    notifyListeners();
    String pictureUrl;
    if (image != null) {
      final String uuid = Uuid().v1();
      final StorageReference storageReference =
          FirebaseStorage().ref().child('images/$uuid');
      final StorageUploadTask uploadTask = storageReference.putFile(image);

      // final StreamSubscription<StorageTaskEvent> streamSubscription =
      //     uploadTask.events.listen((event) {
      //   print('EVENT ${event.type}');
      // });
      try {
        StorageTaskSnapshot snapshot =
            await uploadTask.onComplete.timeout(Duration(seconds: 60));
        pictureUrl = await snapshot.ref.getDownloadURL();
      } on TimeoutException {
        uploadPlantProgress = OnlineProgress.error;
        notifyListeners();
        return false;
      }
    }
    final plant = {
      PlantFirebaseHelper.NAME: name,
      PlantFirebaseHelper.QUANTITY: quantity,
      PlantFirebaseHelper.PICTURE_URL: pictureUrl,
      PlantFirebaseHelper.STATUS: Plant.STATUS_START,
      PlantFirebaseHelper.UPLOAD_TIMESTAMP:
          DateTime.now().millisecondsSinceEpoch,
      PlantFirebaseHelper.DONATED_TIMESTAMP: null,
      PlantFirebaseHelper.DONOR_UID: firebaseUser.uid,
      PlantFirebaseHelper.ACCEPTOR_UID: null,
      PlantFirebaseHelper.LATITUDE: userLocation.latitude,
      PlantFirebaseHelper.LONGITUDE: userLocation.longitude,
      PlantFirebaseHelper.PID: Uuid().v1(),
      PlantFirebaseHelper.DONOR_ADDRESS:
          '${userPlacemark.name}, ${userPlacemark.subLocality}, ${userPlacemark.locality}, ${userPlacemark.administrativeArea}, ${userPlacemark.country} ',
    };
    try {
      DocumentReference ref =
          await Future.value(Firestore.instance.collection('plant').add(plant))
              .timeout(Duration(seconds: 30));
    } on TimeoutException {
      uploadPlantProgress = OnlineProgress.error;
      notifyListeners();
      return false;
    }
    uploadPlantProgress = OnlineProgress.completed;
    notifyListeners();
    return true;
  }

  Future<bool> uploadGoal(int role, int goal) async {
    var data = {
      LoginFirebaseHelper.NAME: firebaseUser.displayName,
      LoginFirebaseHelper.UID: firebaseUser.uid,
      LoginFirebaseHelper.PHOTO_URL: firebaseUser.photoUrl,
      LoginFirebaseHelper.GOALS: [
        {'year': DateTime.now().year, 'goal': goal, 'goalCompleted': 0}
      ],
      LoginFirebaseHelper.ROLE: role
    };
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: firebaseUser.uid)
        .getDocuments();
    if (result.documents.length == 0) {
      await Firestore.instance
          .collection('user')
          .document(firebaseUser.uid)
          .setData(data);
      return true;
    }
    return false;
  }

  List<User> chatUsers = [];
  List<Plant> chatPlants = [];
  getChatUsers() async {
    final DocumentSnapshot userFromFirebase = await Firestore.instance
        .collection('user')
        .document(firebaseUser.uid)
        .get();
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
  }

  Future<void> getOngoingplantsFromFirebase() async {
    await getChatUsers();
    chatPlants = [];
    for (var chatuser in chatUsers) {
      final uid = createCombinedId(firebaseUser.uid, chatuser.uid);
      final DocumentSnapshot doc =
          await Firestore.instance.collection('messages').document(uid).get();
      String plantid = doc.data[ChatFirebaseHelper.plantUid];
      final QuerySnapshot plantDoc = await Firestore.instance
          .collection('plant')
          .where(PlantFirebaseHelper.PID, isEqualTo: plantid)
          .getDocuments();
      // if (plantDoc.documents[0].data[PlantFirebaseHelper.STATUS] ==
      //     Plant.STATUS_DONATED) {
      //   chatUsers.remove(chatuser);
      //   continue;
      // }
      chatPlants.add(Plant(
        name: plantDoc.documents[0].data[PlantFirebaseHelper.NAME],
        pictureUrl: plantDoc.documents[0].data[PlantFirebaseHelper.PICTURE_URL],
        status: plantDoc.documents[0].data[PlantFirebaseHelper.STATUS],
        uploadTimestamp:
            plantDoc.documents[0].data[PlantFirebaseHelper.UPLOAD_TIMESTAMP],
      ));
    }
  }

  String createCombinedId(String id1, String id2) {
    if (id1.compareTo(id2) == 1) {
      return '$id1$id2';
    } else {
      return '$id2$id1';
    }
  }

  Future<void> getUserProfileFromFirebase() async {
    final QuerySnapshot userDocument = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: firebaseUser.uid)
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
      List<String> chatWith;
      try {
        if (userFromDocument[LoginFirebaseHelper.CHAT_WITH] != null) {
          chatWith = List<String>.from(
              userFromDocument[LoginFirebaseHelper.CHAT_WITH]);
        }
      } on NoSuchMethodError {}

      user = User(
          goals: userGoal,
          role: userFromDocument[LoginFirebaseHelper.ROLE],
          chatWith: chatWith,
          name: userFromDocument['name'],
          photoUrl: userFromDocument['photo_url'],
          uid: userFromDocument['uid']);
    }
  }

  Future<Position> getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    userLocationStatus = UserLocationStatus.fetching;

    try {
      userLocation = await Future.value(geolocator
          .getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          )
          .timeout(const Duration(seconds: 7)));
    } on TimeoutException {
      userLocationStatus = UserLocationStatus.disabled;
      notifyListeners();
      return null;
    }
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus != GeolocationStatus.granted) {
      userLocationStatus = UserLocationStatus.disabled;
      notifyListeners();
    }

    userLocationStatus = UserLocationStatus.sucessful;
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        userLocation.latitude, userLocation.longitude);
    if (placemark.length != 0) userPlacemark = placemark[0];
    notifyListeners();
    return userLocation;
  }

  Future<bool> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseUser != null) {
      Fluttertoast.showToast(
          msg: "Sign in success ${firebaseUser.displayName}");
      final QuerySnapshot result = await Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      if (result.documents.length == 0) {
        // var data = {
        //   LoginFirebaseHelper.NAME: firebaseUser.displayName,
        //   LoginFirebaseHelper.UID: firebaseUser.uid,
        //   LoginFirebaseHelper.PHOTO_URL: firebaseUser.photoUrl,
        //   LoginFirebaseHelper.GOALS: [{}]
        // };
        // Firestore.instance
        //     .collection('user')
        //     .document(firebaseUser.uid)
        //     .setData(data);
        return true;
        // isNewLogin = true;
        // isloggedIn = true;
        // notifyListeners();
      }
      return false;
    }
  }

  Future<List<Plant>> getMarkerInformation() async {
    List<Plant> donatedPlants = [];
    QuerySnapshot result = await Firestore.instance
        .collection('plant')
        .where(PlantFirebaseHelper.ACCEPTOR_UID, isNull: true)
        .getDocuments();

    for (var document in result.documents) {
      final documentMap = document.data;
      final plantFromMap = Plant(
        name: documentMap[PlantFirebaseHelper.NAME],
        quantity: documentMap[PlantFirebaseHelper.QUANTITY],
        pictureUrl: documentMap[PlantFirebaseHelper.PICTURE_URL],
        latitude: documentMap[PlantFirebaseHelper.LATITUDE],
        longitude: documentMap[PlantFirebaseHelper.LONGITUDE],
        pid: documentMap[PlantFirebaseHelper.PID],
        status: documentMap[PlantFirebaseHelper.STATUS],
        donorAddress: documentMap[PlantFirebaseHelper.DONOR_ADDRESS],
        donatedTimestamp: documentMap[PlantFirebaseHelper.DONATED_TIMESTAMP],
        acceptorUid: documentMap[PlantFirebaseHelper.ACCEPTOR_UID],
        donorUid: documentMap[PlantFirebaseHelper.DONOR_UID],
        uploadTimestamp: documentMap[PlantFirebaseHelper.UPLOAD_TIMESTAMP],
      );
      donatedPlants.add(plantFromMap);
    }
    notifyListeners();
    return donatedPlants;
  }
}
