import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color btnColor = Color(0xFFff4f5a);
Color textColor = Color(0xFF212121);

void snackBar(String title, String message) {
  Get.rawSnackbar(title: title, message: message, backgroundColor: btnColor);
}

ButtonStyle buttonStyle() {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    backgroundColor: MaterialStateProperty.all(btnColor),
  );
}

getText(String title, Color color, double size, FontWeight fontWeight) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    ),
  );
}

getNoPaddingText(
    String title, Color color, double size, FontWeight fontWeight) {
  return Text(
    title,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    ),
  );
}
