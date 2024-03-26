import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  String? mToken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mToken = token;
    });
  }
  Future<void> sendNotification(
    // tokens,
    String title,
    String body,
    // String imageUrl,
  ) async {
    FirebaseFunctions functions =
        FirebaseFunctions.instanceFor(region: 'us-central1');

    try {
      final HttpsCallable callable =
          functions.httpsCallable('sendNotification');
      final response = await callable.call({
        'tokens': [mToken],
        'title': title,
        'body': body,
        // 'imageUrl': imageUrl,
      });

      print('Message sent: ${response.data}');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  // Método para enviar uma notificação push para um usuário específico
  // Future<void> sendNotification({
  //   required List<String> tokens,
  //   required String title,
  //   required String body,
  //   String? imageUrl,
  // }) async {
  //   try {
  //     // Construir o corpo da notificação
  //     final payload = {
  //       'tokens': tokens,
  //       'title': title,
  //       'body': body,
  //       'imageUrl': imageUrl ?? '',
  //     };
  //
  //     // Chamar a função de Cloud Functions para enviar a notificação
  //     final response = await _callCloudFunction(payload);
  //
  //     // Verificar se a notificação foi enviada com sucesso
  //     if (response.statusCode == 200) {
  //       print('Notificação enviada com sucesso!');
  //     } else {
  //       print('Erro ao enviar notificação: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Erro ao enviar notificação: $e');
  //   }
  // }
  //
  // // Método privado para chamar a função de Cloud Functions
  // Future<http.Response> _callCloudFunction(Map<String, dynamic> payload) {
  //   final url = Uri.parse('https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/sendNotification');
  //   return http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(payload),
  //   );
  // }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
