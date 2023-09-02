import 'package:get/get.dart';
import 'package:healingapp/home/bindings/home_binding.dart';
import 'package:healingapp/home/views/home_view.dart';

import '../modules/audios/bindings/audios_binding.dart';
import '../modules/audios/views/audios_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.AUDIOS,
      page: () => const AudiosView(),
      binding: AudiosBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
