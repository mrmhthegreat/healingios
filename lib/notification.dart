// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:healingapp/app/routes/app_pages.dart';
// import 'package:healingapp/home/controllers/home_controller.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// @pragma('vm:entry-point')
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// @pragma('vm:entry-point')
// FirebaseMessaging messaging = FirebaseMessaging.instance;

// const iosDetails = DarwinNotificationDetails(
//     presentAlert: true, presentBadge: true, presentSound: true);
// const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//   'high_importance_channel',
//   'Notifications',
//   channelDescription: "description",
//   enableVibration: true,
//   enableLights: true,
//   importance: Importance.max,
//   playSound: true,
//   priority: Priority.high,
// );

// Future<void> initMessaging() async {
//   await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('ic_launcher'),
//         iOS: DarwinInitializationSettings(),
//       ), onDidReceiveNotificationResponse: (res) {
//     if (res.payload!.split(',')[0] == 'url') {
//       try {
//         var hm = Get.find<HomeController>();
//         if (hm.ctrl != null) {
//           hm.ctrl!.loadUrl(
//               urlRequest: URLRequest(url: WebUri(res.payload!.split(',')[1])));
//         }
//       } catch (e) {
//         Get.offAllNamed(Routes.HOME, arguments: res.payload!.split(',')[1]);
//       }
//     } else if (res.payload!.split(',')[0] == 'blog') {
//       try {
//         // Get.toNamed(Routes.BLOG);
//       } catch (e) {}
//     }
//   });
//   if (Platform.isIOS) {
//     await messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   } else {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .requestPermission();
//   }
//   sub();

//   FirebaseMessaging.onMessage.listen(
//     (RemoteMessage message) async {
//       var data = message.notification!;

//       var title = data.title.toString();
//       var body = data.body.toString();
//       var image = message.data['image'] ?? '';

//       var type = message.data['type'] ?? '';
//       var id = '';
//       id = message.data['url'] ?? '';

//       if (image != null && image != 'null' && image != '') {
//         await generateImageNotication(title, body, image, type, id);
//       } else {
//         await generateSimpleNotication(title, body, type, id);
//       }
//     },
//   );

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     var id = '';
//     var type = message.data['type'] ?? '';

//     id = message.data['url'] ?? '';

//     if (type == 'url') {
//       try {
//         var hm = Get.find<HomeController>();
//         if (hm.ctrl != null) {
//           hm.ctrl!.loadUrl(urlRequest: URLRequest(url: WebUri(id)));
//         }
//       } catch (e) {
//         Get.offAllNamed(Routes.HOME, arguments: id);
//       }
//     } else if (type == 'blog') {
//       try {
//         // Get.toNamed(Routes.BLOG);
//       } catch (e) {}
//     }
//   });

//   FirebaseMessaging.instance
//       .getInitialMessage()
//       .then((RemoteMessage? message) async {
//     if (message != null) {
//       var type = message.data['type'] ?? '';
//       var id = '';
//       id = message.data['url'] ?? '';

//       if (type == 'url') {
//         try {
//           var hm = Get.find<HomeController>();
//           if (hm.ctrl != null) {
//             hm.ctrl!.loadUrl(urlRequest: URLRequest(url: WebUri(id)));
//           }
//         } catch (e) {
//           Get.offAllNamed(
//             Routes.HOME,
//           );
//         }
//       } else if (type == 'blog') {
//         try {
//           // Get.toNamed(Routes.BLOG);
//         } catch (e) {}
//       }
//     }
//   });
// }

// void sub() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   var sb = prefs.getBool(
//         'sub',
//       ) ??
//       false;

//   if (!sb) {
//     var fbi = FirebaseMessaging.instance;
//     await fbi.subscribeToTopic('tiger');
//     await prefs.setBool('sub', true);
//   } else {}
// }

// @pragma('vm:entry-point')
// Future<String> _downloadAndSaveImage(String url, String fileName) async {
//   var directory = await getApplicationDocumentsDirectory();
//   var filePath = '${directory.path}/$fileName';
//   var response = await http.get(Uri.parse(url));

//   var file = File(filePath);
//   await file.writeAsBytes(response.bodyBytes);
//   return filePath;
// }

// @pragma('vm:entry-point')
// Future<void> generateImageNotication(
//     String title, String msg, String image, String type, String id) async {
//   var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
//   var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
//   var bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       hideExpandedLargeIcon: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//       summaryText: msg,
//       htmlFormatSummaryText: true);

//   var platformChannelSpecifics = const NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iosDetails);
//   await flutterLocalNotificationsPlugin.show(
//     DateTime.now().minute + DateTime.now().second,
//     title,
//     msg,
//     platformChannelSpecifics,
//     payload: '$type,$id',
//   );
// }

// @pragma('vm:entry-point')
// Future<void> generateSimpleNotication(
//     String title, String msg, String type, String id) async {
//   var platformChannelSpecifics = const NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iosDetails);
//   await flutterLocalNotificationsPlugin.show(
//     DateTime.now().minute + DateTime.now().second,
//     title,
//     msg,
//     platformChannelSpecifics,
//     payload: '$type,$id',
//   );
// }

// var generalNotificationDetails = const NotificationDetails(
//     android: androidPlatformChannelSpecifics, iOS: iosDetails);
