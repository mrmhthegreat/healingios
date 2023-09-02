import 'package:get/get.dart';
import 'package:healingapp/app/modules/stories/controllers/stories_controller.dart';

import '../controllers/audios_controller.dart';

class AudiosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudiosController>(
      () => AudiosController(),
    );
  }
}

class SAudiosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoriesController>(
      () => StoriesController(),
    );
  }
}
