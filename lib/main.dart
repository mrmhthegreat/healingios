import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:healingapp/animationsplash/animationsplash.dart';
import 'package:healingapp/app/routes/app_pages.dart';
import 'package:healingapp/introduction_animation/onboarding_screen.dart';
import 'package:healingapp/home/views/widget/nativehelper.dart';
import 'package:healingapp/home/views/widget/webviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send =
      IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   var data = message.notification!;
//   var title = data.title.toString();
//   var body = data.body.toString();
//   var image = message.data['image'] ?? '';
//   var type = message.data['type'] ?? '';
//   var id = '';
//   id = message.data['url'] ?? '';
//   if (image != null && image != 'null' && image != '') {
//     await generateImageNotication(title, body, image, type, id);
//   } else {
//     await generateSimpleNotication(title, body, type, id);
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // initMessaging();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FlutterDownloader.initialize(ignoreSsl: true);
  await FlutterDownloader.registerCallback(downloadCallback);
  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      androidNotificationIcon: 'drawable/ic_launcher');
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var a = prefs.getBool('into') ?? false;
  runApp(MyApp(
    home: a,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.home,
  });
  final bool home;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Spiritual Healing with Stuart Morris",
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      theme:
          ThemeData(primarySwatch: Colors.blue, textTheme: const TextTheme()),
      home: home
          ? FlutterSplashScreen.scale(
              duration: const Duration(milliseconds: 5000),
              animationDuration: const Duration(milliseconds: 5000),
              backgroundColor: HexColor('#102e37'),
              defaultNextScreen: WebViewMini('https://spiritualhealing.co.uk/'),
              onEnd: () {
                Get.offAllNamed(Routes.HOME);
              },
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(16, 46, 55, 1),
                Color.fromRGBO(28, 9, 31, 0.8),
                Color.fromRGBO(18, 80, 97, 1),
                Color.fromRGBO(28, 9, 31, 0.7),
                Color.fromRGBO(16, 46, 55, 1),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              childWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: FadeInDown(
                        duration: const Duration(milliseconds: 2000),
                        child: Image.asset(
                          'assets/images/l.png',
                          fit: BoxFit.contain,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 2000),
                    child: const Text(
                      "Spiritual Healing",
                      style: TextStyle(
                          fontFamily: "Andina",
                          fontSize: 22,
                          color: Colors.white),
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: const Text(
                      "Stuart William Morris",
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  )
                ],
              ))
          : const OnboardingScreen(),
    );
  }
}
