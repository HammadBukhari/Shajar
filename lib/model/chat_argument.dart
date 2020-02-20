import 'package:firebase_auth/firebase_auth.dart';

import 'package:shajar/model/plant.dart';

class ChatArguments {
  FirebaseUser appUser;
  String plantToDiscussUid;
  String secondParticipantUid;
  ChatArguments({
    this.appUser,
    this.plantToDiscussUid,
    this.secondParticipantUid,
  });
}
