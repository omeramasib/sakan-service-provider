import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/widgets/choose_image/choose_image.dart';
import '../constants/colors_manager.dart';
import '../constants/fonts_manager.dart';
import '../constants/styles_manager.dart';
import '../constants/validations.dart';
import '../constants/values_manager.dart';
import 'choose_image/choose_confirmation_image.dart';
import 'choose_image/choose_owner_id_image.dart';

// phone number text form field
Widget phoneNumberFormField(
  BuildContext context,
  dynamic controller,
  Color color,
  String hinText,
  Color hintTextColor,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: controller.phoneNumberController,
        onSaved: (value) {
          controller.phone = '${controller.key.value}${value!}';
          print('this is the daklia phone number: ${controller.phone}');
        },
        validator: (value) {
          return Validations().validatePhoneNumber(value);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: hintTextColor,
            fontSize: FontSizeManager.s14,
          ),
          fillColor: color,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          suffixIcon: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Obx(
                    () => Row(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: ColorsManager.blackColor,
                          size: 15,
                        ),
                        Text(
                          '${controller.key.value}+',
                          style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// password text form field
Widget passwordFormField(BuildContext context, dynamic controller, Color color,
    String hinText, Color hintTextColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Obx(
      (() => SizedBox(
            width: 315,
            child: TextFormField(
              obscureText: controller.isObscure.value == true ? true : false,
              controller: controller.passwordController,
              validator: (value) {
                return Validations().validatePassword(value!);
              },
              onSaved: (String? value) {
                controller.password = value!;
                print('this is the daklia password: ${controller.password}');
              },
              decoration: InputDecoration(
                hintText: hinText,
                hintStyle: getRegularStyle(
                  color: hintTextColor,
                  fontSize: FontSizeManager.s14,
                ),
                fillColor: color,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isObscure.value = !controller.isObscure.value;
                    },
                    child: Icon(
                      controller.isObscure.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          )),
    ),
  );
}

// old password form field
Widget oldPasswordFormField(BuildContext context, Color color, String hinText,
    Color hintTextColor, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Obx(
      (() => SizedBox(
            width: 315,
            child: TextFormField(
              obscureText: controller.isObscure.value == true ? true : false,
              controller: controller.oldPasswordController,
              validator: (value) {
                return Validations().validatePassword(value!);
              },
              onSaved: (value) {
                controller.oldPassword = value!;
              },
              decoration: InputDecoration(
                hintText: hinText,
                hintStyle: getRegularStyle(
                  color: hintTextColor,
                  fontSize: FontSizeManager.s14,
                ),
                fillColor: color,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isObscure.value = !controller.isObscure.value;
                    },
                    child: Icon(
                      controller.isObscure.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          )),
    ),
  );
}

// new password form field
Widget newPasswordFormField(BuildContext context, Color color, String hinText,
    Color hintTextColor, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Obx(
      (() => SizedBox(
            width: 315,
            child: TextFormField(
              obscureText: controller.isObscureNew.value,
              controller: controller.passwordController,
              validator: (value) {
                return Validations().validatePassword(value!);
              },
              onSaved: (value) {
                controller.newPassword = value!;
              },
              decoration: InputDecoration(
                hintText: hinText,
                hintStyle: getRegularStyle(
                  color: hintTextColor,
                  fontSize: FontSizeManager.s14,
                ),
                fillColor: color,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isObscureNew.value =
                          !controller.isObscureNew.value;
                    },
                    child: Icon(
                      controller.isObscureNew.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          )),
    ),
  );
}

// Daklia name form field
Widget dakliaNameFormField(BuildContext context, dynamic controller,
    Color color, String hinText, Color hinTextColor) {
  return SizedBox(
    width: double.infinity,
    child: TextFormField(
      keyboardType: TextInputType.name,
      controller: controller.nameController,
      onSaved: (String? value) {
        controller.username = value!;
        print('this is the daklia name: ${controller.username}');
      },
      validator: (value) {
        return Validations().validateFirstName(value!);
      },
      decoration: InputDecoration(
        hintText: hinText,
        hintStyle: getRegularStyle(
          color: hinTextColor,
          fontSize: FontSizeManager.s14,
        ),
        fillColor: color,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

// identity text form field
Widget identityFormField(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.identityNumberController,
        validator: (value) {
          return Validations().validateIdentityNumber(value!);
        },
        onSaved: (String? value) {
          controller.igama = value!;
        },
        decoration: InputDecoration(
          hintText: hinText,
          fillColor: color,
          hintStyle: getRegularStyle(
            color: hinTextColor,
            fontSize: FontSizeManager.s14,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}

// confirm password widget
Widget confirmPasswordFormField(BuildContext context, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Obx(
      (() => SizedBox(
            width: 315,
            child: TextFormField(
              obscureText:
                  controller.isObscureConfirm.value == true ? true : false,
              controller: controller.confirmPasswordController,
              validator: (value) {
                return Validations().validateConfirmPassword(
                    value!, controller.passwordController.text);
              },
              onSaved: (String? value) {
                controller.confirmPassword = value!;
                print(
                    'this is the confirm password: ${controller.confirmPassword}');
              },
              decoration: InputDecoration(
                hintText: 'confirm_password'.tr,
                fillColor: ColorsManager.greyColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isObscureConfirm.value =
                          !controller.isObscureConfirm.value;
                    },
                    child: Icon(
                      controller.isObscureConfirm.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          )),
    ),
  );
}

Widget confirmNewPassword(BuildContext context, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Obx(
      (() => SizedBox(
            width: 315,
            child: TextFormField(
              obscureText:
                  controller.isObscureConfirm.value == true ? true : false,
              controller: controller.confirmPasswordController,
              validator: (value) {
                return Validations().validateConfirmPassword(
                    value!, controller.passwordController.text);
              },
              onSaved: (String? value) {
                controller.confirmPassword = value!;
                print(
                    'this is the confirm password: ${controller.confirmPassword}');
              },
              decoration: InputDecoration(
                hintText: 'confirm_password'.tr,
                fillColor: ColorsManager.greyColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isObscureConfirm.value =
                          !controller.isObscureConfirm.value;
                    },
                    child: Icon(
                      controller.isObscureConfirm.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          )),
    ),
  );
}

// Birth Date Widget
Widget birthDateWidget(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        onTap: () async {
          var date = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: ColorsManager.primaryColor,
                  ),
                  dialogBackgroundColor: ColorsManager.greyColor,
                ),
                child: child!,
              );
            },
          );
          controller.birthDateController.text =
              date.toString().substring(0, 10);
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        controller: controller.birthDateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: hinTextColor,
            fontSize: FontSizeManager.s14,
          ),
          fillColor: color,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            onPressed: () async {
              var date = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: ColorsManager.primaryColor,
                      ),
                      dialogBackgroundColor: ColorsManager.greyColor,
                    ),
                    child: child!,
                  );
                },
              );
              controller.birthDateController.text =
                  date.toString().substring(0, 10);
            },
            icon: SvgPicture.asset(
              ImagesManager.calenderIcon,
              height: 24,
              width: 24,
            ),
            padding: const EdgeInsets.only(left: 20, right: 20),
          ),
        ),
      ),
    ),
  );
}

// Card Name Holder Form Field
Widget cardHolderNameFormField(BuildContext context, dynamic controller,
    Color color, String hinText, Color hinTextColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.cardHolderNameController,
        validator: (value) {
          return null; // Add proper validation if needed
        },
        decoration: InputDecoration(
          hintText: hinText,
          fillColor: color,
          hintStyle: getRegularStyle(
            color: hinTextColor,
            fontSize: FontSizeManager.s12,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}

// Card Number Form Field
Widget cardNumberFormField(BuildContext context, dynamic controller,
    Color color, String hinText, Color hinTextColor) {
  return SizedBox(
    width: 315,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller.cardNumberController,
      validator: (value) {
        // return Validations().validateIdentityNumber(value!);
      },
      decoration: InputDecoration(
        hintText: hinText,
        fillColor: color,
        hintStyle: getRegularStyle(
          color: hinTextColor,
          fontSize: FontSizeManager.s12,
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

// Cvv Form Field
Widget cvvFormField(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.cvvController,
        validator: (value) {
          return null; // Add proper validation if needed
        },
        decoration: InputDecoration(
          hintText: hinText,
          fillColor: color,
          hintStyle: getRegularStyle(
            color: hinTextColor,
            fontSize: FontSizeManager.s12,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}

// Expiry Date Form Field
Widget expiryDateFormField(BuildContext context, dynamic controller,
    Color color, String hinText, Color hinTextColor) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller.expiryDateController,
    validator: (value) {
      // return Validations().validateIdentityNumber(value!);
    },
    decoration: InputDecoration(
      hintText: hinText,
      fillColor: color,
      hintStyle: getRegularStyle(
        color: hinTextColor,
        fontSize: FontSizeManager.s12,
      ),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

// Ticket Title Form Field
Widget ticketTitleFormField(BuildContext context, dynamic controller,
    Color color, String hinText, Color hinTextColor) {
  var isEnglish = Get.locale!.languageCode == 'en';
  return Padding(
    // padding: const EdgeInsets.only(left: 20, right: 20),
    padding: isEnglish
        ? const EdgeInsets.only(
            right: 10,
          )
        : const EdgeInsets.only(left: AppPadding.p20, right: AppPadding.p20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        // controller: controller.cardHolderNameController,
        validator: (value) {
          return null; // Add proper validation if needed
        },
        decoration: InputDecoration(
          hintText: hinText,
          fillColor: color,
          hintStyle: getRegularStyle(
            color: hinTextColor,
            fontSize: FontSizeManager.s13,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}

// Details Widget
Widget detailsWidget(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller.otherDetailsController,
    enabled: true,
    decoration: InputDecoration(
      hintText: hinText,
      hintStyle: getRegularStyle(
        color: hinTextColor,
        fontSize: FontSizeManager.s12,
      ),
      contentPadding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 20,
        bottom: 20,
      ),
      isDense: true,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: ColorsManager.lightGreyColor),
      ),
      filled: true,
      fillColor: color,
    ),
  );
}

// add photo widget
Widget addPhotoWidget(BuildContext context, dynamic controller, String text) {
  return Obx(
    () => controller.imagePath.value == ''
        ? Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // controller.getImage(ImageSource.camera);
                      selectImage(context, controller);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: kIsWeb
                  ? Icon(
                      Icons.check_circle,
                      color: ColorsManager.mainColor,
                      size: 40,
                    )
                  : Image.file(
                      File(controller.imagePath.value),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
  );
}

// add description widget
Widget addDescriptionWidget(BuildContext context, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.descriptionController,
        enabled: true,
        onSaved: (value) {
          controller.dakliaDescription = value!;
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: ColorsManager.whiteColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

// room count widget

Widget roomCountWidget(
    BuildContext context, dynamic controller, String hinText) {
  return SizedBox(
    width: 315,
    height: 50,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller.roomCountController,
      enabled: true,
      onSaved: (value) {
        controller.roomCount = int.parse(value!);
      },
      validator: (value) {
        return Validations().textValidation(value!);
      },
      decoration: InputDecoration(
        hintText: hinText,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.lightGreyColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintStyle: getRegularStyle(
          color: ColorsManager.fontColor,
          fontSize: FontSizeManager.s13,
        ),
        contentPadding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 10,
          bottom: 20,
        ),
        isDense: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.lightGreyColor),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        filled: true,
        fillColor: ColorsManager.whiteColor,
      ),
      maxLines: 5,
      minLines: 1,
    ),
  );
}

// edit profile room count
Widget editProfileRoomCountWidget(
    BuildContext context, dynamic controller, String hinText) {
  return SizedBox(
    width: 315,
    height: 50,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller.roomCountController,
      enabled: true,
      onChanged: (value) {
        controller.roomCount = int.parse(value);
      },
      decoration: InputDecoration(
        hintText: hinText,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.lightGreyColor),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        hintStyle: getRegularStyle(
          color: ColorsManager.fontColor,
          fontSize: FontSizeManager.s13,
        ),
        contentPadding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 10,
          bottom: 20,
        ),
        isDense: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.lightGreyColor),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        filled: true,
        fillColor: ColorsManager.whiteColor,
      ),
      maxLines: 5,
      minLines: 1,
    ),
  );
}

// add photo widget for room with multiple image support
Widget addRoomPhotoWidget(
    BuildContext context, dynamic controller, String text) {
  return Obx(
    () => controller.imagePaths.isEmpty
        ? Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.lightGreyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectMultipleImages(context, controller);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Image grid
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.imagePaths.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.imagePaths.length) {
                        // Add more button
                        return GestureDetector(
                          onTap: () {
                            selectMultipleImages(context, controller);
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorsManager.lightGreyColor,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: ColorsManager.mainColor),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                color: ColorsManager.mainColor,
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      }
                      // Image thumbnail with delete option
                      return Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: kIsWeb
                                  ? Icon(
                                      Icons.check_circle,
                                      color: ColorsManager.mainColor,
                                      size: 40,
                                    )
                                  : Image.file(
                                      File(controller.imagePaths[index]),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                controller.removeImage(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorsManager.errorColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: ColorsManager.whiteColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Image count label
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${controller.imagePaths.length} ${'images_selected'.tr}',
                    style: getRegularStyle(
                      color: ColorsManager.fontColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}

// Dialog for selecting multiple images
void selectMultipleImages(BuildContext context, dynamic controller) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'select_images'.tr,
            style: getMediumStyle(
              color: ColorsManager.blackColor,
              fontSize: FontSizeManager.s16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  controller.getImageFromCamera(ImageSource.camera);
                },
                child: Column(
                  children: [
                    Icon(Icons.camera_alt,
                        size: 40, color: ColorsManager.mainColor),
                    const SizedBox(height: 8),
                    Text('camera'.tr),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.pickMultipleImages();
                },
                child: Column(
                  children: [
                    Icon(Icons.photo_library,
                        size: 40, color: ColorsManager.mainColor),
                    const SizedBox(height: 8),
                    Text('gallery'.tr),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget addressDetailsWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.addressDetailsController,
        enabled: true,
        onSaved: (value) {
          log('this is the value $value');
          controller.additionalAddress = value;
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          filled: true,
          fillColor: ColorsManager.greyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

// add Daklia Confirmation widget
Widget dakliaConfirmationWidget(
    BuildContext context, dynamic controller, String text) {
  return Obx(
    () => controller.confirmationPath.value == ''
        ? Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // controller.getConfirmationImage(ImageSource.camera);
                      selectConfirmationImage(context, controller);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: kIsWeb
                  ? Icon(
                      Icons.check_circle,
                      color: ColorsManager.mainColor,
                      size: 40,
                    )
                  : Image.file(
                      File(controller.confirmationPath.value),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
  );
}

// add daklia owner id photo widget
Widget dakliaOwnerIdWidget(
    BuildContext context, dynamic controller, String text) {
  return Obx(
    () => controller.ownerIdPath.value == ''
        ? Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // controller.getOwnerIdImage(ImageSource.camera);
                      selectOwnerIdImage(context, controller);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 94,
            width: 315,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: kIsWeb
                  ? Icon(
                      Icons.check_circle,
                      color: ColorsManager.mainColor,
                      size: 40,
                    )
                  : Image.file(
                      File(controller.ownerIdPath.value),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
  );
}

Widget roomNumberWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.roomNumberController,
        enabled: true,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            log('this is the roomNumber value $value');
            controller.roomNumber = int.parse(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'room_number_required'.tr;
          }
          if (int.tryParse(value) == null) {
            return 'room_number_invalid'.tr;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editRoomNumberWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.roomNumberController,
        enabled: true,
        onChanged: (value) {
          controller.roomNumber = int.parse(value);
        },
        // validator: (value) {
        //   return Validations().validateNumber(value!);
        // },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget allBedsNumberWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.allBedsNumberController,
        enabled: true,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            log('this is the numberOfBeds value $value');
            controller.numberOfBeds = int.parse(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'beds_number_required'.tr;
          }
          if (int.tryParse(value) == null) {
            return 'beds_number_invalid'.tr;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editAllBedsNumberWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.allBedsNumberController,
        enabled: true,
        onChanged: (value) {
          controller.numberOfBeds = int.parse(value);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget emptyBedsNumberWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.emptyBedsNumberController,
        enabled: true,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            log('this is the empty Beds Number value $value');
            controller.numAvailableBeds = int.parse(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'available_beds_required'.tr;
          }
          if (int.tryParse(value) == null) {
            return 'available_beds_invalid'.tr;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editEmptyBedsNumberWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.emptyBedsNumberController,
        enabled: true,
        onChanged: (value) {
          log('this is the empty Beds Number value $value');
          controller.numAvailableBeds = int.parse(value);
        },
        onSaved: (value) {
          log('this is the empty Beds Number value $value');
          controller.numAvailableBeds = int.parse(value!);
        },
        validator: (value) {
          return Validations().validateNumber(value!);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget dailyBedPriceWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.dailyBedPriceController,
        enabled: true,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            log('this is the price Per Day value $value');
            controller.pricePerDay = int.parse(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'price_required'.tr;
          }
          if (int.tryParse(value) == null) {
            return 'price_invalid'.tr;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget monthlyBedPriceWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.monthlyBedPriceController,
        enabled: true,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            log('this is the price Per Month value $value');
            controller.pricePerMonth = int.parse(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'price_required'.tr;
          }
          if (int.tryParse(value) == null) {
            return 'price_invalid'.tr;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget featureWidget(BuildContext context, dynamic controller, String hinText) {
  final isArabic = Get.locale?.languageCode == 'ar';
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        controller: controller.featureController,
        enabled: true,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: const TextStyle(),
        onSaved: (value) {
          log('this is the feature value $value');
          controller.featureName = value!;
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.greyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget otherDetailsWidget(BuildContext context, dynamic controller) {
  final isArabic = Get.locale?.languageCode == 'ar';
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        controller: controller.otherDetailsController,
        enabled: true,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: const TextStyle(),
        onSaved: (value) {
          log('this is the other details value $value');
          controller.featureDescription = value!;
        },
        decoration: InputDecoration(
          hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          isDense: true,
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editFeatureWidget(
    BuildContext context, dynamic controller, String hinText) {
  final isArabic = Get.locale?.languageCode == 'ar';
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        controller: controller.featureController,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: const TextStyle(),
        onChanged: (value) {
          controller.featureName = value;
        },
        enabled: true,
        decoration: InputDecoration(
          hintText: hinText,
          hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          hintStyle: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          filled: true,
          fillColor: ColorsManager.greyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editOtherDetailsWidget(
    BuildContext context, dynamic controller, String hinText) {
  final isArabic = Get.locale?.languageCode == 'ar';
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        controller: controller.otherDetailsController,
        enabled: true,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: const TextStyle(),
        onChanged: (value) {
          log('this is the other details value $value');
          controller.featureDescription = value;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          hintText: hinText,
          hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          hintStyle: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: FontSizeManager.s13,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget serviceNameWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.serviceNameController,
        enabled: true,
        onSaved: (value) {
          log('this is the service name value $value');
          controller.serviceNameController.text = value;
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editServiceNameWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.editServiceNameController,
        enabled: true,
        onChanged: (value) {
          log('this is the service name value ${controller.editServiceNameController.text}');
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget servicePriceWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.servicePriceController,
        enabled: true,
        onChanged: (value) {
          log('this is the service price value $value');
          controller.servicePrice = value;
          controller.chooseServiceType(value);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 20,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editServicePriceWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.editServicePriceController,
        enabled: true,
        onChanged: (value) {
          log('this is the service price value $value');
          controller.editServicePrice = value;
          controller.chooseEditServiceType(value);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 20,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget serviceDescriptionWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.serviceDescriptionController,
        enabled: true,
        onSaved: (value) {
          log('this is the service description value ${controller.serviceDescriptionController.text}');
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editServiceDescriptionWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.editServiceDescriptionController,
        enabled: true,
        onChanged: (value) {
          log('this is the service description value ${controller.editServiceDescriptionController.text}');
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget regulationTextWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.regulationTextController,
        enabled: true,
        onSaved: (value) {
          controller.regulationTextController.text = value!;
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.hintStyleColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          // enabledBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: ColorsManager.lightGreyColor),
          //   borderRadius: BorderRadius.all(Radius.circular(50)),
          // ),
          filled: true,
          fillColor: ColorsManager.greyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget regulationDescriptionWidget(BuildContext context, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.regulationDescriptionController,
        enabled: true,
        onSaved: (value) {
          controller.regulationDescriptionController.text = value!;
        },
        validator: (value) {
          return Validations().textValidation(value!);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          isDense: true,
          // enabledBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: ColorsManager.lightGreyColor),
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          // ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editRegulationWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.editRegulationTextController,
        enabled: true,
        onChanged: (value) {
          log('this is the regulation value ${controller.editRegulationTextController.text}');
        },
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: FontSizeManager.s13,
          ),
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 20,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          filled: true,
          fillColor: ColorsManager.greyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget editRegulationDetailsWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.editRegulationDescriptionController,
        enabled: true,
        onChanged: (value) {
          log('this is the regulation description value ${controller.editRegulationDescriptionController.text}');
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: FontSizeManager.s13,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget appointmentRejectWidget(BuildContext context, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.appointmentRejectController,
        enabled: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightGreyColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: ColorsManager.lightGreyColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}

Widget dakliaDescriptionWidget(
    BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.descriptionController,
        enabled: true,
        onChanged: (value) {
          log('this the value of daklia Description ********: $value');
          controller.dakliaDescription = value;
          log('daklia Description ********: ${controller.dakliaDescription}');
        },
        // onSaved: (value) {
        //   log('this the value of daklia Description ********: $value');
        //   controller.dakliaDescription = value;
        //   log('daklia Description ********: ${controller.dakliaDescription}');
        // },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          hintText: hinText,
          hintStyle: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: FontSizeManager.s12,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.whiteColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: ColorsManager.whiteColor,
        ),
        maxLines: 5,
        minLines: 1,
      ),
    ),
  );
}
