import 'dart:io';

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
          controller.phone = '+${controller.key}${value!}';
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
                          '${controller.key.value}+' ?? '+966',
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
                      color: ColorsManager.primaryColor,
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
              obscureText: controller.isObscure.value == true ? true : false,
              controller: controller.newPasswordController,
              validator: (value) {
                return Validations().validatePassword(value!);
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

// Daklia name form field
Widget dakliaNameFormField(BuildContext context, dynamic controller,
    Color color, String hinText, Color hinTextColor) {
  return SizedBox(
    width: 315,
    child: TextFormField(
      keyboardType: TextInputType.name,
      controller: controller.nameController,
      onSaved: (String? value) {
        controller.name = value!;
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

// first name form field
Widget firstNameFormField(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
  return SizedBox(
    width: 315,
    child: TextFormField(
      keyboardType: TextInputType.name,
      controller: controller.firstNameController,
      onSaved: (String? value) {
        controller.fname = value!;
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

// last name form field
Widget lastNameFormField(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
  return SizedBox(
    width: 315,
    child: TextFormField(
      keyboardType: TextInputType.name,
      controller: controller.lastNameController,
      onSaved: (String? value) {
        controller.lname = value!;
      },
      validator: (value) {
        return Validations().validateLastName(value!);
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
                    value!, controller.confirmPasswordController.text);
              },
              onSaved: (String? value) {
                controller.confirmPassword = value!;
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
          return Validations()
              .textValidation(value!, controller.birthDateController.text);
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
          // return Validations().validateIdentityNumber(value!);
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

// // Attach File
// Widget attachFileWidget(BuildContext context) {
//   var isArabic = Get.locale!.languageCode == 'ar';
//   return Padding(
//     padding: isArabic
//         ? const EdgeInsets.only(top: 15, right: 40, left: 40)
//         : const EdgeInsets.only(
//             top: 15,
//             right: 10,
//           ),
//     child: Container(
//       height: 103,
//       width: 315,
//       decoration: BoxDecoration(
//         color: ColorsManager.greyColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: isArabic
//                 ? const EdgeInsets.only(
//                     top: 30,
//                   )
//                 : const EdgeInsets.only(
//                     top: 30,
//                   ),
//             child: SvgPicture.asset(
//               Images.attachFileIcon,
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             'attach'.tr,
//             style: getRegularStyle(
//               color: ColorsManager.blackColor,
//               fontSize: FontSizeManager.s13,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

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
                  SizedBox(
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
              child: Image.file(
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
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 80,
          ),
          isDense: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget roomCountWidget(BuildContext context, dynamic controller, String hinText) {
  return SizedBox(
    width: 315,
    height: 50,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller.roomCountController,
      enabled: true,
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
          borderSide: BorderSide(
            color: ColorsManager.lightGreyColor
            ),
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

// add photo widget
Widget  addRoomPhotoWidget(BuildContext context, dynamic controller, String text) {
  return Obx(
    () => controller.imagePath.value == ''
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
                      // controller.getImage(ImageSource.camera);
                      selectImage(context, controller);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  SizedBox(
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
              child: Image.file(
                File(controller.imagePath.value),
                fit: BoxFit.cover,
              ),
            ),
          ),
  );
}

Widget addressDetailsWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.addressDetailsController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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
Widget dakliaConfirmationWidget(BuildContext context, dynamic controller, String text) {
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
                      controller.getConfirmationImage(ImageSource.camera);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  SizedBox(
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
              child: Image.file(
                File(controller.confirmationPath.value),
                fit: BoxFit.cover,
              ),
            ),
          ),
  );
}

// add daklia owner id photo widget
Widget dakliaOwnerIdWidget(BuildContext context, dynamic controller, String text) {
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
                      controller.getOwnerIdImage(ImageSource.camera);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  SizedBox(
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
              child: Image.file(
                File(controller.ownerIdPath.value),
                fit: BoxFit.cover,
              ),
            ),
          ),
  );
}

// add Daklia Confirmation widget
Widget dakliaImageWidget(BuildContext context, dynamic controller, String text) {
    return Obx(
    () => controller.imagePath.value == ''
        ? Container(
            height: 94,
            width: 105,
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
                      selectImage(context, controller);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.daklia_image,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s13,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 94,
            width: 105,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.file(
                File(controller.imagePath.value),
                fit: BoxFit.cover,
              ),
            ),
          ),
  );
}

Widget roomNumberWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.roomNumberController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget allBedsNumberWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.allBedsNumberController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget emptyBedsNumberWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.emptyBedsNumberController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget dailyBedPriceWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.dailyBedPriceController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget monthlyBedPriceWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.monthlyBedPriceController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget featureWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.featureController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget otherDetailsWidget(BuildContext context, dynamic controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.otherDetailsController,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget editFeatureWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.featureController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget editOtherDetailsWidget(BuildContext context, dynamic controller , String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.otherDetailsController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget serviceNameWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.serviceNameController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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

Widget servicePriceWidget(BuildContext context, dynamic controller, String hinText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      width: 315,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.servicePriceController,
        enabled: true,
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
            borderSide: BorderSide(
              color: ColorsManager.lightGreyColor
              ),
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