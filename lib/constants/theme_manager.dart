import 'package:flutter/material.dart';

import 'colors_manager.dart';
import 'fonts_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main color
    primaryColor: ColorsManager.primaryColor,

    // card theme
    cardTheme: const CardThemeData(
      color: ColorsManager.whiteColor,
      shadowColor: ColorsManager.greyColor,
      elevation: AppSize.s4,
    ),

    // appBar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorsManager.mainColor,
      elevation: AppSize.s4,
      titleTextStyle: getMediumStyle(
          fontSize: FontSizeManager.s14, color: ColorsManager.whiteColor),
    ),

    // Button Theme
    buttonTheme: const ButtonThemeData(
        shape: StadiumBorder(),
        // disabledColor: ColorsManager.greyColor
        buttonColor: ColorsManager.greyColor),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
            color: ColorsManager.whiteColor, fontSize: AppSize.s14),
        backgroundColor: ColorsManager.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s20)),
      ),
    ),

// TextTheme
    textTheme: TextTheme(
      // use in welcome screen
      displayLarge: getBoldStyle(
        color: ColorsManager.fontColor,
        fontSize: AppSize.s16,
      ),
      // use in welcome scrren
      titleMedium: getRegularStyle(
        color: ColorsManager.fontColor,
        fontSize: AppSize.s15,
      ),
      // use in onBoarding screens
      displayMedium: getMediumStyle(
        color: ColorsManager.fontColor,
        fontSize: AppSize.s16,
      ),
      // use in onBoarding screens
      titleSmall: getRegularStyle(
        color: ColorsManager.fontColor,
        fontSize: AppSize.s14,
      ),
      // use in Login and Register screens
    ),
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p20),
      hintStyle: getRegularStyle(
          color: ColorsManager.hintStyleColor, fontSize: FontSizeManager.s12),
      errorStyle: getRegularStyle(color: ColorsManager.errorColor),
      fillColor: ColorsManager.greyColor,
      filled: true,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s50),
        borderSide: const BorderSide(color: ColorsManager.errorColor),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    ),
  );
}
