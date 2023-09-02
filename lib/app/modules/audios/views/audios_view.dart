import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:healingapp/app/modules/audios/bindings/audios_binding.dart';
import 'package:healingapp/app/modules/audios/views/audiocard.dart';
import 'package:healingapp/app/modules/stories/views/reviewmodel.dart';
import 'package:healingapp/app/modules/stories/views/stories_view.dart';
import 'package:healingapp/app/routes/app_pages.dart';
import 'package:healingapp/awesomebottomnav/awesome_bottom_bar.dart';
import 'package:healingapp/awesomebottomnav/widgets/inspired/inspired.dart';
import 'package:healingapp/home/views/widget/nativehelper.dart';
import 'package:healingapp/home/views/widget/webviewpage.dart';

import '../controllers/audios_controller.dart';

class AudiosView extends GetView<AudiosController> {
  const AudiosView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.controllers.curr.value = 0;
        Get.offAll(WebViewMini("https://spiritualhealing.co.uk/"));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Free healing Meditations',
              style: TextStyle(
                fontFamily: "Mulish",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            backgroundColor: HexColor("#597D85"),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: HexColor("#597D85"),
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: HexColor('#102e47'),
                systemNavigationBarDividerColor: HexColor('#102e47'),
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarContrastEnforced: false),
          ),
          backgroundColor: HexColor('#102e37'),
          bottomNavigationBar: Obx(() => BottomBarInspiredInside(
                elevation: 8,
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
                indexSelected: controller.controllers.curr.value,
                height: 37,
                chipStyle: ChipStyle(
                    convexBridge: true,
                    background: HexColor("#597D85"),
                    color: Colors.white),
                itemStyle: ItemStyle.circle,
                animated: false,
                onTap: (int i) {
                  if (controller.controllers.curr.value != i) {
                    controller.controllers.curr.value = i;
                    if (i == 0) {
                      Get.offAll(
                          WebViewMini("https://spiritualhealing.co.uk/"));
                    } else if (i == 3) {
                      Get.offAll(WebViewMini(
                          "https://spiritualhealing.co.uk/diploma/"));
                    } else if (i == 4) {
                      Get.offAll(
                          WebViewMini("https://spiritualhealing.co.uk/blog/"));
                    } else if (i == 1) {
                      Get.toNamed(Routes.AUDIOS);
                    } else if (i == 2) {
                      Get.to(const StoriesView(), binding: SAudiosBinding());
                    }
                  }
                },
              )),
          body: FirebaseDatabaseQueryBuilder(
            query: controller.usersQuery,
            builder: (context, snapshot, _) {
              // ...
              return snapshot.hasData
                  ? GridView.builder(
                      itemCount: snapshot.docs.length,
                      // crossAxisCount: 2,
                      // childAspectRatio: (itemWidth / itemHeight),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      itemBuilder: (context, index) {
                        // if we reached the end of the currently obtained items, we try to
                        // obtain more items
                        if (snapshot.hasMore &&
                            index + 1 == snapshot.docs.length) {
                          // Tell FirebaseDatabaseQueryBuilder to try to obtain more items.
                          // It is safe to call this function from within the build method.
                          snapshot.fetchMore();
                        }

                        final user =
                            snapshot.docs[index].value as Map<dynamic, dynamic>;
                        var model = AudiosModel.fromJson(
                            user, snapshot.docs[index].key);
                        return SleepMusicCard(
                          music: model,
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 20,
                      ),
                    )
                  : Container();
            },
          )),
    );
  }
}
