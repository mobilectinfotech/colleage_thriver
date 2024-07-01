import 'package:colleage_thriver/widgets/app_bar/appbar_home_page.dart';
import 'controller/choose_your_college_controller.dart';
import 'package:flutter/material.dart';
import 'package:colleage_thriver/core/app_export.dart';
import 'package:colleage_thriver/core/utils/validation_functions.dart';
import 'package:colleage_thriver/widgets/custom_elevated_button.dart';
import 'package:colleage_thriver/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class ChooseYourCollegeScreen extends GetWidget<ChooseYourCollegeController> {
  ChooseYourCollegeScreen({Key? key}) : super(key: key,);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppbar(title: "msg_choose_your_college".tr),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.only(left: 20.0.h ,right: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _activityRow(),
              SizedBox(height: 33.v),
              Text(
                "msg_congrats_on_all".tr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    CustomTextStyles.titleMediumPrimaryMedium.copyWith(
                  height: 1.23,
                ),
              ),
              SizedBox(height: 22.v),
              Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Text(
                  "msg_which_college_will".tr,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 8.v),
              CustomTextFormField(
                controller: controller.nameController,
                hintText: "msg_enter_college_name".tr,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (!isText(value)) {
                    return "err_msg_please_enter_valid_text".tr;
                  }
                  return null;
                },
              ),
              Spacer(),
              _buttonRow(),
              SizedBox(height: 30.v),

            ],
          ),
        ),
      ),
    );
  }


  /// Section Widget
  Widget _activityRow() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.v),
          child: Text(
            "lbl_activity".tr,
            style: CustomTextStyles.titleSmallRobotoBlack90001,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.h),
          child: Text(
            "lbl_4_of_5".tr,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(top: 3.v),
          child: Text(
            "lbl_earn_25_points".tr,
            style: CustomTextStyles.titleSmallRobotoBlack90001,
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgClose,
          height: 22.adaptSize,
          width: 22.adaptSize,
          margin: EdgeInsets.only(left: 10.h),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: () {
              onTapBack();
            },
            text: "lbl_do_it_later".tr,
            margin: EdgeInsets.only(right: 12.h),
            buttonStyle: CustomButtonStyles.fillYellowTL12,
          ),
        ),
        Expanded(
          child: Obx(
           ()=> CustomElevatedButton(
              isLoading: controller.isLoadingUpdateCollegeMatchOne.value,
               onPressed: () {
                 // Get.back();
                  controller.updateCollefefairs();
               },
              text: "lbl_mark_as_done".tr,
              margin: EdgeInsets.only(left: 12.h),
            ),
          ),
        ),
      ],
    );
  }


  onTapBack() {
    Get.toNamed(
      AppRoutes.chooseTheRightCollegeScreen,
    );
  }

}