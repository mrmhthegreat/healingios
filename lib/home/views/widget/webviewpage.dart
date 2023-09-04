// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:get/get.dart';
import 'package:healingapp/app/modules/audios/bindings/audios_binding.dart';
import 'package:healingapp/app/modules/stories/views/stories_view.dart';
import 'package:healingapp/app/routes/app_pages.dart';
import 'package:healingapp/awesomebottomnav/awesome_bottom_bar.dart';
import 'package:healingapp/awesomebottomnav/widgets/inspired/inspired.dart';
import 'package:healingapp/home/controllers/home_controller.dart';
import 'package:healingapp/home/views/widget/brokenlink.dart';
import 'package:healingapp/home/views/widget/nativehelper.dart';
import 'package:healingapp/home/views/primarybutton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewMini extends StatefulWidget {
  final String url;

  WebViewMini(this.url);

  @override
  State<WebViewMini> createState() => _WebViewMiniState();
}

class _WebViewMiniState extends State<WebViewMini> {
  InAppWebViewController? ctrl;
  Future<bool> backbuton(BuildContext context) async {
    if (await ctrl!.canGoBack()) {
      var u = await ctrl!.getUrl();
      if (u.toString() == "https://spiritualhealing.co.uk/diploma/") {
        Get.find<HomeController>().curr.value = 0;
      } else if (u.toString() == "https://spiritualhealing.co.uk/blog/") {
        Get.find<HomeController>().curr.value = 0;
      }
      ctrl!.goBack();

      return false;
    } else {
      var c = false;
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Close App'),
            content: SingleChildScrollView(
              child: Column(
                children: const <Widget>[
                  Text('Are you sure,You want to exit.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  c = true;
                  Navigator.of(context).pop();
                  exit(0);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return c;
    }
  }

  var error = false.obs;
  var error4 = false.obs;
  late PullToRefreshController pullToRefreshController;
  var loading = false.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final adUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
  ];
  final List<ContentBlocker> contentBlockers = [];
  @override
  void initState() {
    super.initState();
    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          )));
    }
    // apply the "display: none" style to some HTML elements
    contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector:
                ".elementor-widget-woocommerce-menu-cart, .elementor-widget-wc-add-to-cart, .add_to_cart_button, #menu-item-2672, #PopupSignupForm_0, .mc-banner")));
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) async {
      if (e == ConnectivityResult.none) {
        error.value = true;
      } else {
        error.value = false;
      }
    });
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          ctrl?.reload();
        }
        if (Platform.isIOS) {
          ctrl?.loadUrl(urlRequest: URLRequest(url: Uri.parse(widget.url)));
        }
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor("#597D85"),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return WillPopScope(
        onWillPop: () => backbuton(context),
        child: SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: false,
            extendBody: false,
            bottomNavigationBar: Obx(() => BottomBarInspiredInside(
                  items: [
                    const TabItem(
                        icon: Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        title: 'Home'),
                    TabItem(
                        icon: Image.asset(
                          "assets/images/l.png",
                          width: 27,
                          height: 27,
                          color: Colors.white,
                        ),
                        title: 'Meditations'),
                    const TabItem(
                        icon: Icon(
                          Icons.slow_motion_video_sharp,
                          color: Colors.white,
                        ),
                        title: 'Wisdom'),
                    const TabItem(
                        icon: Icon(
                          Icons.school_outlined,
                          color: Colors.white,
                        ),
                        title: 'Diploma'),
                    const TabItem(
                        icon: Icon(
                          Icons.newspaper_outlined,
                          color: Colors.white,
                        ),
                        title: 'Blog')
                  ],
                  backgroundColor: HexColor("#102e47"),
                  color: HexColor("#ffffff"),
                  colorSelected: Colors.white,
                  indexSelected: Get.find<HomeController>().curr.value,
                  height: 37,
                  elevation: 8,
                  chipStyle: ChipStyle(
                      convexBridge: true,
                      background: HexColor("#597D85"),
                      color: Colors.white),
                  itemStyle: ItemStyle.circle,
                  animated: false,
                  onTap: (int i) {
                    if (Get.find<HomeController>().curr.value != i) {
                      Get.find<HomeController>().curr.value = i;
                      if (i == 0) {
                        ctrl?.loadUrl(
                            urlRequest: URLRequest(url: Uri.parse(widget.url)));
                      } else if (i == 3) {
                        ctrl?.loadUrl(
                            urlRequest: URLRequest(
                                url: Uri.parse(
                                    "https://spiritualhealing.co.uk/diploma/")));
                      } else if (i == 4) {
                        ctrl?.loadUrl(
                            urlRequest: URLRequest(
                                url: Uri.parse(
                                    "https://spiritualhealing.co.uk/blog/")));
                      } else if (i == 1) {
                        Get.offNamed(Routes.AUDIOS);
                      } else if (i == 2) {
                        Get.to(const StoriesView(), binding: SAudiosBinding());
                      }
                    }
                  },
                )),
            backgroundColor: HexColor('#102e37'),
            body: Obx(
              () => error.value
                  ? errorpage()
                  : error4.value
                      ? Stack(
                          children: [
                            Image.asset(
                              'assets/images/broken_link.png',
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const Positioned(
                              bottom: 230,
                              left: 30,
                              child: Text(
                                'Broken Link',
                                style: kTitleTextStyle,
                              ),
                            ),
                            const Positioned(
                              bottom: 170,
                              left: 30,
                              child: Text(
                                'The link you followed may be broken,\nor the page may have been removed.',
                                style: kSubtitleTextStyle,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 40,
                              right: 40,
                              child: ReusablePrimaryButton(
                                childText: 'Go Back',
                                buttonColor: Colors.blue[800]!,
                                childTextColor: Colors.white,
                                onPressed: () async {
                                  ctrl!.loadUrl(
                                      urlRequest: URLRequest(
                                          url: Uri.parse(widget.url)));

                                  error4.value = false;
                                },
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            InAppWebView(
                                androidOnGeolocationPermissionsShowPrompt:
                                    (InAppWebViewController controller,
                                        String origin) async {
                                  return Future.value(
                                      GeolocationPermissionShowPromptResponse(
                                          origin: origin,
                                          allow: true,
                                          retain: true));
                                },
                                androidOnPermissionRequest:
                                    (InAppWebViewController controller,
                                        String origin,
                                        List<String> resources) async {
                                  if (resources.isNotEmpty) {
                                    for (var element in resources) {
                                      if (element.contains("AUDIO_CAPTURE")) {
                                        await Permission.microphone.request();
                                        await Permission.audio.request();
                                      }
                                      if (element.contains("VIDEO_CAPTURE")) {
                                        await Permission.camera.request();
                                        await Permission.microphone.request();
                                      }
                                    }
                                  } else {
                                    await Permission.camera.request();
                                    await Permission.microphone.request();
                                  }
                                  return PermissionRequestResponse(
                                      resources: resources,
                                      action: PermissionRequestResponseAction
                                          .GRANT);
                                },
                                initialUserScripts: UnmodifiableListView([]),
                                initialUrlRequest:
                                    URLRequest(url: Uri.parse(widget.url)),
                                initialOptions: InAppWebViewGroupOptions(
                                    crossPlatform: InAppWebViewOptions(
                                      disableHorizontalScroll: true,
                                      useOnDownloadStart: true,
                                      cacheEnabled: true,
                                      horizontalScrollBarEnabled: false,
                                      transparentBackground: true,
                                      contentBlockers: contentBlockers,
                                      verticalScrollBarEnabled: false,
                                      supportZoom: false,
                                      preferredContentMode:
                                          UserPreferredContentMode.MOBILE,
                                      userAgent:
                                          'Mozilla/5.0 (Linux; Android 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Mobile Safari/537.36',
                                      useShouldOverrideUrlLoading: true,
                                      mediaPlaybackRequiresUserGesture: false,
                                    ),
                                    android: AndroidInAppWebViewOptions(
                                        textZoom: 96,
                                        useHybridComposition: false,
                                        builtInZoomControls: false,
                                        mixedContentMode:
                                            AndroidMixedContentMode
                                                .MIXED_CONTENT_ALWAYS_ALLOW),
                                    ios: IOSInAppWebViewOptions(
                                      allowsInlineMediaPlayback: true,
                                    )),
                                onWebViewCreated:
                                    (InAppWebViewController controlle) {
                                  ctrl = controlle;
                                },
                                onEnterFullscreen: (ctrl) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft
                                  ]);
                                },
                                onExitFullscreen: (ctrl) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitDown,
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft,
                                  ]);
                                },
                                onProgressChanged: (controlle, progress) async {
                                  if (progress == 100) {
                                    pullToRefreshController.endRefreshing();
                                  }
                                },
                                onLoadHttpError:
                                    (controlle, url, statusCode, description) {
                                  error4.value = true;
                                },
                                shouldOverrideUrlLoading:
                                    (controller, request) async {
                                  var uri = request.request.url;
                                  var url = request.request.url.toString();
                                  if (Platform.isAndroid &&
                                      url.contains("intent")) {
                                    if (url.contains("maps")) {
                                      var mNewURL = url.replaceAll(
                                          "intent://", "https://");
                                      if (await canLaunchUrl(
                                          Uri.parse(mNewURL))) {
                                        await launchUrl(Uri.parse(mNewURL));
                                        return NavigationActionPolicy.CANCEL;
                                      }
                                    } else {
                                      String id = url.substring(
                                          url.indexOf('id%3D') + 5,
                                          url.indexOf('#Intent'));
                                      await StoreRedirect.redirect(
                                          androidAppId: id);
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  } else if (url.contains("linkedin.com") ||
                                      url.contains("market://") ||
                                      url.contains("whatsapp://") ||
                                      url.contains("truecaller://") ||
                                      url.contains("facebook.com") ||
                                      url.contains("twitter.com") ||
                                      url.contains(
                                          "https://spiritualhealing.co.uk/checkout/") ||
                                      url.contains(
                                          "https://spiritualhealing.co.uk/cart/") ||
                                      url.contains(
                                          "https://spiritualhealing.co.uk/shop-all/") ||
                                      url.contains(
                                          "https://spiritualhealing.co.uk/courses/") ||
                                      url.contains(
                                          "https://spiritualhealing.co.uk/product/") ||
                                      url.contains("www.google.com/maps") ||
                                      url.contains("pinterest.com") ||
                                      url.contains("youtube.com") ||
                                      url.contains("snapchat.com") ||
                                      url.contains("tiktok.com") ||
                                      url.contains("instagram.com") ||
                                      url.contains("linkedin.com") ||
                                      url.contains("play.google.com") ||
                                      url.contains("mailto:") ||
                                      url.contains("tel:") ||
                                      url.contains("google.it") ||
                                      url.contains("share=telegram") ||
                                      url.contains("messenger.com")) {
                                    try {
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        launchUrl(Uri.parse(url),
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        launchUrl(Uri.parse(url),
                                            mode:
                                                LaunchMode.externalApplication);
                                      }
                                      return NavigationActionPolicy.CANCEL;
                                    } catch (e) {
                                      launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  } else if (![
                                    "http",
                                    "https",
                                    "chrome",
                                    "data",
                                    "javascript",
                                    "about"
                                  ].contains(uri!.scheme)) {
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  }

                                  return NavigationActionPolicy.ALLOW;
                                },
                                onJsConfirm:
                                    (controller, jsConfirmRequest) async {
                                  JsConfirmResponseAction.CONFIRM;
                                },
                                onJsAlert:
                                    ((controller, jsAlertRequest) async {}),
                                pullToRefreshController:
                                    pullToRefreshController,
                                onLoadStop: (ctr, urli) {
                                  loading.value = false;
                                  pullToRefreshController.endRefreshing();
                                },
                                onDownloadStartRequest:
                                    (controller, url) async {
                                  if (await Permission.storage.isGranted) {
                                    var appDirectory = Platform.isIOS
                                        ? await getApplicationSupportDirectory()
                                        : await getExternalStorageDirectory();
                                    var filename =
                                        "doc_${DateTime.now().microsecondsSinceEpoch.toString()}.${url.suggestedFilename!.split('.')[1]}";
                                    if (appDirectory != null) {
                                      await FlutterDownloader.enqueue(
                                          url: url.url.toString(),
                                          savedDir: appDirectory.path,
                                          fileName: filename,
                                          showNotification:
                                              true, // show download progress in status bar (for Android)
                                          openFileFromNotification: true,
                                          saveInPublicStorage: true);
                                    } else {
                                      var d =
                                          await getApplicationDocumentsDirectory();
                                      await FlutterDownloader.enqueue(
                                        url: url.url.toString(),
                                        savedDir: d.path,
                                        fileName: filename,
                                        showNotification:
                                            true, // show download progress in status bar (for Android)
                                        openFileFromNotification: false,
                                      );
                                    }
                                  } else {
                                    await Permission.storage.request();
                                  }
                                },
                                onPrint: (controller, url) async {
                                  var webViewController = controller;
                                  if (await Permission.storage.isGranted) {
                                    var widgetsBingind =
                                        WidgetsBinding.instance;
                                    if (widgetsBingind
                                            .window.viewInsets.bottom >
                                        0.0) {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      if (FocusManager.instance.primaryFocus !=
                                          null) {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();
                                      }
                                      await webViewController.evaluateJavascript(
                                          source:
                                              "document.activeElement.blur();");
                                      await Future.delayed(
                                          const Duration(milliseconds: 100));
                                    }
                                    // }

                                    var a = await controller
                                        .takeScreenshot(
                                            screenshotConfiguration:
                                                ScreenshotConfiguration())
                                        .timeout(
                                          const Duration(milliseconds: 1500),
                                          onTimeout: () => null,
                                        );

                                    if (a != null) {
                                      var appDirectory =
                                          await getExternalStorageDirectory();

                                      if (appDirectory != null) {
                                        final pathOfImage = await File(
                                                '${appDirectory.path}/${DateTime.now().millisecond.toString()}.png')
                                            .create();
                                        final Uint8List bytes =
                                            a.buffer.asUint8List();
                                        await pathOfImage.writeAsBytes(bytes);
                                      } else {
                                        final directory =
                                            await getApplicationDocumentsDirectory();
                                        final pathOfImage = await File(
                                                '${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png')
                                            .create();
                                        final Uint8List bytes =
                                            a.buffer.asUint8List();
                                        await pathOfImage.writeAsBytes(bytes);
                                      }
                                    }
                                  } else {
                                    await Permission.storage.request();
                                  }
                                },
                                onLoadError: (controlle, url, code, message) {
                                  pullToRefreshController.endRefreshing();

                                  error.value = true;
                                },
                                onLoadStart: (ctr, urli) {
                                  loading.value = true;
                                  pullToRefreshController.endRefreshing();
                                }),
                            Obx(() => loading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox.shrink())
                          ],
                        ),
            ),
          ),
        ));
  }

  Widget errorpage() {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/10_Connection Lost.png'),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Align(
          alignment: FractionalOffset.bottomRight,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: RawMaterialButton(
              onPressed: () async {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult != ConnectivityResult.none) {
                  error.value = false;

                  // I am connected to a mobile network.
                }
              },
              elevation: 2.0,
              fillColor: Colors.amberAccent,
              padding: const EdgeInsets.all(18.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.refresh,
                color: Colors.blueGrey,
                size: 38.0,
              ),
            ),
          ),
        ));
  }
}

Future load(BuildContext context) async {
  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //           content: SizedBox(
  //             height: 50,
  //             width: MediaQuery.of(context).size.width * 0.90,
  //             child: Row(
  //               children: [
  //                 const CircularProgressIndicator(),
  //                 const SizedBox(
  //                   width: 20,
  //                 ),
  //                 const Text("Loading")
  //               ],
  //             ),
  //           ),
  //         ));
  // Future.delayed(const Duration(seconds: 3), () => Navigator.of(context).pop());
}
