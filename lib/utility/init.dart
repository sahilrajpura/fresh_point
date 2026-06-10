import 'package:fresh_point/utility/sharedprefrence.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();

    // Register the actual SharedPreferences instance
    Get.put<SharedPreferences>(sharedPref, permanent: true);

    // Register your wrapper manager
    Get.put(
      SharedPreferencesManager(sharedPreferences: sharedPref),
      permanent: true,
    );
  }
}
