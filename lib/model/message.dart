enum MessageType { message_text, message_image, message_special }

class Message {
  String senderUid;
  String recevierUid;
  String content;
  int timestamp;
  Message({this.senderUid, this.recevierUid, this.content, this.type, this.timestamp});
  MessageType type;
}
