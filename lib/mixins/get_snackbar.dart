import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetSnackbar {
  void buildCustomSnackbar(
      {@required String messageText,
      @required String titleText,
      @required Color iconColor,
      @required IconData icon}) {
    Get.snackbar(
      "Oops",
      'Something Went Wrong',
      colorText: Colors.black,
      titleText: Text(
        titleText,
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0),
      ),
      messageText: Text(messageText),
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}
