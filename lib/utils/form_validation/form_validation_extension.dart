import 'package:easy_localization/easy_localization.dart';

extension EmailValidator on String {
  String? isValidEmail(String? value) {
    bool valid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value!);
    if (!valid) {
      return "Please enter valid email".tr();
    }
    return null;
  }

  oldPasswordValid(String? value) {
    if (value!.isEmpty && value.length <= 6) {
      return "Please enter old password".tr();
    }
    // if (value.length <= 6) {
    //   return "AppFormMessage.passwordValidatCountMessage";
    // }
    return null;
  }

  String? isMemberIdValid(String? value) {
    if (value!.isEmpty) {
      return "Please enter memberID".tr();
    }
    return null;
  }

  String? isValidName(String? value) {
    if (value!.isEmpty) {
      return "Please enter name".tr();
    }
    return null;
  }

  String? iswordNumberValid(String? value) {
    if (value!.isEmpty) {
      return "Please enter ward number".tr();
    }
    return null;
  }

  String? isFirtNameValid(String? value) {
    if (value!.isEmpty) {
      return "Please enter first name".tr();
    }
    return null;
  }

  String? isLastNameValid(String? value) {
    if (value!.isEmpty) {
      return "Please enter last name".tr();
    }
    return null;
  }

  String? isfeedBackValidate(String? value) {
    if (value!.isEmpty) {
      return "Please enter feedback name".tr();
    }
    return null;
  }

  String? isWordNumber(String? value) {
    if (value!.isEmpty) {
      return "Please enter ward number".tr();
    }
    return null;
  }

  String? isAddressValid(String? value) {
    if (value!.isEmpty) {
      return "Please enter address".tr();
    }
    return null;
  }

  String? isPasswordValid(String? value) {
    if (value!.length <= 4) {
      return "Please enter password".tr();
    }
    return null;
  }

  String? iscodeValidated(String? value) {
    if (value!.length < 6) {
      return "Please enter 6 digits code".tr();
    }
    return null;
  }

  String? isPhoneValidate(String? value) {
    if (value!.length <= 9) {
      return "Please enter 10 digits number".tr();
    }
    return null;
  }

  confirmPasswordValidation(String? val, String oldPassword) {
    if (val!.isEmpty)
      return 'Please enter password of atleast 6 characters'.tr();
    if (val != oldPassword) return 'Password did not match'.tr();
    return null;
  }
}
