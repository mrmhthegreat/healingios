import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healingapp/app/modules/stories/views/reviewmodel.dart';
import 'package:healingapp/home/controllers/home_controller.dart';

class AudiosController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  final controllers = Get.find<HomeController>();
  final usersQuery = FirebaseDatabase.instance.ref('audios');
  void setdata() async {
    await FirebaseDatabase.instance.ref("audios").push().set(AudiosModel(
            dur: 2,
            title: "A wave of light ",
            des: "Auy",
            thumimage: "https://i.ibb.co/fN20hnN/A-Wave-of-Light.png",
            dateadd: DateTime.now(),
            audiourl:
                "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")
        .toJson());
    await FirebaseDatabase.instance.ref("audios").push().set(AudiosModel(
            dur: 3,
            title: "A connection to the light",
            des: "Auay",
            thumimage: "https://i.ibb.co/C68k11y/A-connection-to-the-light.png",
            dateadd: DateTime.now(),
            audiourl:
                "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")
        .toJson());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
