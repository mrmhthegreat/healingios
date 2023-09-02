import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var curr = 0.obs;
  final player = AudioPlayer();
}
