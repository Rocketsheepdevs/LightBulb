import 'package:flutter/cupertino.dart';

class ChatMessageModel {
  String messageContent;
  String messageType;
  String timestamp;
  ChatMessageModel(
      {required this.messageContent,
      required this.messageType,
      required this.timestamp});
}
