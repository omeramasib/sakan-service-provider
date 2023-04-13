import 'package:get/get.dart';

class Validations {
  String? validatePhoneNumber(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{9,9}$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return 'phone_empty'.tr;
    } else if (!regExp.hasMatch(value)) {
      return 'valid_phone'.tr;
    } else {
      return null;
    }
  }

  String? validateIdentityNumber(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return 'validate_identity_number'.tr;
    } else if (!regExp.hasMatch(value)) {
      return 'valid_identity_number'.tr;
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'valid_password'.tr;
    } else if (value.length < 8) {
      return 'valid_password'.tr;
    } else {
      return null;
    }
  }

  String? textValidation(String value) {
    if (value.isEmpty) {
      return "required_field".tr;
    } else {
      return null;
    }
  }

  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return 'required_field'.tr;
    } else if (value.length < 2) {
      return 'valid_first_name'.tr;
    } else {
      return null;
    }
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return 'required_field'.tr;
    } else if (value.length < 2) {
      return 'valid_last_name'.tr;
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String value, String password) {
    if (value.isEmpty) {
      return 'valid_password'.tr;
    } else if (value != password) {
      return 'validate_confirm_passwords'.tr;
    } else {
      return null;
    }
  }

  // make validation of otp
  String? validateOtp(String value) {
    if (value.isEmpty) {
      return 'validate_otp'.tr;
    } else if (value.length < 6) {
      return 'valid_otp'.tr;
    } else {
      return null;
    }
  }

  String? validateNumber(String value) {
    if (value.isEmpty || value == '0') {
      return "required_field".tr;
    } else {
      return null;
    }
  }


}
