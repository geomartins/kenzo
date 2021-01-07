import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomFlatButton extends FlatButton {
  final Color color;
  final Color textColor;
  final String title;
  final VoidCallback onPressed;
  final double radius;

  CustomFlatButton(
      {@required this.color,
      @required this.textColor,
      @required this.title,
      @required this.onPressed,
      this.radius})
      : super(
          disabledColor: kPrimaryColor.shade300,
          color: color,
          child: Text(
            title,
            style: TextStyle(color: textColor),
          ),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 5.0),
            //side: BorderSide(color: Colors.red)
          ),
        );
}
