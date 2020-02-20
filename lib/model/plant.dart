import 'dart:core';

class Plant {
  static const STATUS_START = 1;
  static const STATUS_ONGOING = 2;
  static const STATUS_DONATED = 3;
  String pid;
  String name;
  int quantity;
  String pictureUrl;
  int status;
  double latitude;
  double longitude;
  String donorAddress;
  String donorUid;
  String acceptorUid;
  num uploadTimestamp;
  num donatedTimestamp;
  Plant({
    this.pid,
    this.name,
    this.quantity,
    this.pictureUrl,
    this.status,
    this.latitude,
    this.longitude,
    this.donorAddress,
    this.donorUid,
    this.acceptorUid,
    this.uploadTimestamp,
    this.donatedTimestamp,
  });
  
}
