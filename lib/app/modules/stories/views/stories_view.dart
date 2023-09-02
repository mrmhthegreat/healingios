import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:healingapp/app/modules/stories/controllers/stories_controller.dart';
import 'package:healingapp/home/controllers/home_controller.dart';
import 'package:healingapp/home/views/widget/nativehelper.dart';
import 'package:story_view/story_view.dart';

class StoriesView extends GetView<StoriesController> {
  const StoriesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // showStatusBar();

    return WillPopScope(
      onWillPop: () async {
        Get.find<HomeController>().curr.value = 0;
        return true;
      },
      child: Scaffold(
          extendBody: true,
          backgroundColor: HexColor('#102e37'),
          body: Obx(() => controller.isLoading.value == false
              ? controller.stories.isNotEmpty
                  ? SafeArea(
                      child: StoryView(
                        storyItems: controller.stories,
                        onStoryShow: (s) {
                          print("Showing a story");
                        },
                        onComplete: () {
                          Get.back();
                        },
                        progressPosition: ProgressPosition.top,
                        repeat: false,
                        controller: controller.storyController,
                      ),
                    )
                  : Center(
                      child: Container(
                        height: 120,
                        alignment: Alignment.center,
                        child: const Text(
                          'No Data To Show',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                ))),
    );
  }
}
