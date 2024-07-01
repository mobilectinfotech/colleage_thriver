import 'package:colleage_thriver/presentation/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:colleage_thriver/core/app_export.dart';
import 'package:colleage_thriver/core/utils/progress_dialog_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/data_sources/remote/apI_endpoint_urls.dart';
import '../../../data/data_sources/remote/api_client.dart';
import '../home_page_model.dart';

class HomePageCollegeController extends GetxController {
  TextEditingController emailExampleController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  RxString profiePic = ImageConstant.nullProfile.obs;
  RxString userName = "*****".obs;
  RxInt points = 0.obs;
  Rx<num> roadmapProgress = RxNum(0);
  RxDouble hight = 0.45.obs;

  HomePageModel? homePageModel;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getProfile();
  }

  RxBool isLoading = false.obs;

  Future<void> getProfile() async {
    isLoading.value = true;

    try {
      var response = await ApiClient().getRequest(endPoint: AppUrls.homePage);
      if (response.statusCode == 200) {

        if (HomePageModel.fromJson(response.data).data!.profileImg == null) {
        } else {
          profiePic.value =
              HomePageModel.fromJson(response.data).data!.profileImg!;
        }
        // profiePic.value =    HomePageModel.fromJson(response.data).data!.profileImg!;
        userName.value = HomePageModel.fromJson(response.data).data?.name ?? "";
        points.value = HomePageModel.fromJson(response.data).data!.rewardPoints!;
         roadmapProgress.value =    num.parse(HomePageModel.fromJson(response.data).data!.roadmapProgress!);
        isLoading.value = false;
      } else {
        Get.dialog(AlertDialog(
          title: Text('Internal Server Error'),
          content: Text(
              'Sorry, there was an internal server error. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog using GetX
              },
              child: Text('OK'),
            ),
          ],
        ));

        AppDialogUtils.showToast(message: "${response.data["message"]}");
      }
    } catch (e, log) {
      print("object${e.toString()}");
      print("object${log}");
    }
  }


}


