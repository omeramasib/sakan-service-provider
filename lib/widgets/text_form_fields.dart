import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';
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
                  onTap: () {
                  },
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
Widget oldPasswordFormField(
    BuildContext context, Color color, String hinText, Color hintTextColor, dynamic controller) {
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
Widget newPasswordFormField(
    BuildContext context, Color color, String hinText, Color hintTextColor, dynamic controller) {
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
Widget dakliaNameFormField(BuildContext context, dynamic controller, Color color,
    String hinText, Color hinTextColor) {
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
