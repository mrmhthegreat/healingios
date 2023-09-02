import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:get/get.dart';
import 'package:healingapp/app/modules/stories/views/reviewmodel.dart';
import 'package:healingapp/home/controllers/home_controller.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key, required this.model}) : super(key: key);
  final AudiosModel model;
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    voidinit();
  }

  final player = Get.find<HomeController>().player;
  voidinit() async {
    if (player.playing) {
      await player.stop();
    }
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playerStateStream.listen((state) {}, onError: (a, b) {});

    try {
      await player.setAudioSource(AudioSource.uri(
        Uri.parse(widget.model.audiourl),
        tag: MediaItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          album: widget.model.des,
          title: widget.model.title,
          artUri: Uri.parse(widget.model.thumimage),
        ),
      ));
      player.positionStream.listen((event) {
        if (mounted) {
          if (position.inSeconds <= 1) {
            duration = player.duration ?? Duration.zero;
          }
          setState(() {
            position = event;
          });
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused)
  //     super.didChangeAppLifecycleState(state);
  // }

  var dis = false.obs;
  var loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarContrastEnforced: false),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              )),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder<PaletteGenerator>(
            future: getImageColors(widget.model),
            builder: (context, snapshot) {
              return Container(
                color: snapshot.data?.mutedColor?.color,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(.7)
                  ])),
            ),
          ),
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 30,
                  child: Marquee(
                    text: widget.model.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.model.des,
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        durationFormat(duration),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const VerticalDivider(
                        color: Colors.white54,
                        thickness: 2,
                        width: 25,
                        indent: 2,
                        endIndent: 2,
                      ),
                      Text(
                        durationFormat(duration - position),
                        style: const TextStyle(color: kPrimaryColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
              child: SleekCircularSlider(
            min: 0,
            max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 60,
            initialValue: position.inSeconds.toDouble(),
            onChange: (value) async {
              await player.seek(Duration(seconds: value.toInt()));
            },
            innerWidget: (percentage) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: CachedNetworkImage(
                  imageUrl: widget.model.thumimage,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => const Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: SizedBox(
                              width: 30, child: LinearProgressIndicator()))),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              );
            },
            appearance: CircularSliderAppearance(
                size: 330,
                angleRange: 300,
                startAngle: 300,
                customColors: CustomSliderColors(
                    progressBarColor: kPrimaryColor,
                    dotColor: kPrimaryColor,
                    trackColor: Colors.grey.withOpacity(.4)),
                customWidths: CustomSliderWidths(
                    trackWidth: 6, handlerSize: 10, progressBarWidth: 6)),
          )),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.3,
            left: 0,
            right: 0,
            child: Center(
              child: StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final prostate = snapshot.data;
                    final prcosta = prostate?.processingState;
                    final plystae = prostate?.playing;
                    if (prcosta == ProcessingState.loading || loading.value) {
                      return const CircularProgressIndicator();
                    } else {
                      return Obx(() => loading.value
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // await widget.player.playOrPause();
                                    loading.value = true;
                                    if (plystae == true) {
                                      await player.pause();
                                    } else {
                                      player.play();
                                    }
                                    loading.value = false;
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: plystae == true
                                      ? const Icon(
                                          Icons.pause_circle_outline_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.play_circle_outline_outlined,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                ),
                                plystae == true
                                    ? IconButton(
                                        onPressed: () async {
                                          loading.value = true;
                                          await player.stop();
                                          loading.value = false;
                                        },
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.stop_circle_outlined,
                                          size: 50,
                                          color: Colors.white,
                                        ))
                                    : const SizedBox.shrink(),
                                plystae == true
                                    ? IconButton(
                                        onPressed: () async {
                                          // await widget.player.playOrPause();
                                          if (!dis.value) {
                                            setInterruptionFilter(FlutterDnd
                                                .INTERRUPTION_FILTER_PRIORITY);
                                            dis.value = true;
                                          } else {
                                            setInterruptionFilter(FlutterDnd
                                                .INTERRUPTION_FILTER_ALL);
                                            dis.value = false;
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          dis.value
                                              ? Icons.do_disturb_on_outlined
                                              : Icons.do_disturb_off_outlined,
                                          size: 50,
                                          color: Colors.white,
                                        ))
                                    : const SizedBox.shrink(),
                              ],
                            ));
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
  // for example => 03:09
}

// get song cover image colors
Future<PaletteGenerator> getImageColors(AudiosModel player) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
    NetworkImage(player.thumimage),
  );
  return paletteGenerator;
}

const kPrimaryColor = Color(0xFFebbe8b);
void setInterruptionFilter(int filter) async {
  final bool? isNotificationPolicyAccessGranted =
      await FlutterDnd.isNotificationPolicyAccessGranted;
  if (isNotificationPolicyAccessGranted != null &&
      isNotificationPolicyAccessGranted) {
    await FlutterDnd.setInterruptionFilter(filter);
  } else {
    FlutterDnd.gotoPolicySettings();
  }
}
