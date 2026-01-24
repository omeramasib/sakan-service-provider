import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import 'fonts_manager.dart';

class ButtonsManager {
  static Widget primaryButton({
    required String text,
    required Function onPressed,
    required BuildContext context,
    Size? minimumSize,
    Size? maximumSize,
    Color? buttonColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize ?? Size(315, 50),
        maximumSize: maximumSize ?? Size(315, 50),
        textStyle: getRegularStyle(
          color: ColorsManager.whiteColor,
        ),
        backgroundColor: buttonColor ?? ColorsManager.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style: getRegularStyle(
          color: textColor ?? ColorsManager.whiteColor,
        ),
      ),
    );
  }

  // secondary button
  static Widget secondaryButton({
    required String text,
    required Function onPressed,
    required BuildContext context,
    Size? minimumSize,
    Size? maximumSize,
    Color? buttonColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize ?? Size(315, 50),
        maximumSize: maximumSize ?? Size(315, 50),
        textStyle: getMediumStyle(
            color: ColorsManager.whiteColor, fontSize: FontSizeManager.s15),
        backgroundColor: buttonColor ?? ColorsManager.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style: getRegularStyle(
          color: textColor ?? ColorsManager.whiteColor,
        ),
      ),
    );
  }
}
