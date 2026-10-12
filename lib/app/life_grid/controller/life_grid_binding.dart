import 'package:get/get.dart';

import 'life_grid_controller.dart';

class LifeGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LifeGridController());
  }
}
