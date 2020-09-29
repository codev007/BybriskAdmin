// Replace with server token from firebase console settings.
import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

final String serverToken =
    'AAAADJv32bk:APA91bGQooOHmGJc0aezmCIToGGLP8LbNnQ0FcLKDBxCBXlBgp3ciywmTP0MVtFd4Cyi_A0IQVnJ60qSIZxdV8x-7m6PYCjK8IGtN96LpY5NWnakVeLLRHJQ8kMUuldM_6urmC4B0YoY';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<Map<String, dynamic>> sendAndRetrieveMessage(
    String title, String description, String token,String route) async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': '$description',
          'title': '$title',
          'route':'$route'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': '$token',
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  return completer.future;
}
