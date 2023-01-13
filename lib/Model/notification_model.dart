// To parse this JSON data, do
//
//     final classNotificationModel = classNotificationModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ClassNotificationModel? classNotificationModelFromJson(String str) => ClassNotificationModel.fromJson(json.decode(str));

String classNotificationModelToJson(ClassNotificationModel? data) => json.encode(data!.toJson());

class ClassNotificationModel {
    ClassNotificationModel({
        required this.avatarUrl,
        required this.comment,
        required this.username,
        required this.timestamp,
    });

    String? avatarUrl;
    String? comment;
    String? username;
    Timestamp? timestamp;

    factory ClassNotificationModel.fromJson(Map<String, dynamic> json) => ClassNotificationModel(
        avatarUrl: json["avatarUrl"],
        comment: json["comment"],
        username: json["username"],
        timestamp: json["timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "avatarUrl": avatarUrl,
        "comment": comment,
        "username": username,
        "timestamp": timestamp,
    };
}
