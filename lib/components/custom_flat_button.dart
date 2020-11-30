import 'package:flutter/material.dart';

class CustomFlatButton extends FlatButton {
  final Color color;
  final Color textColor;
  final String title;
  final VoidCallback onPressed;

  CustomFlatButton({
    @required this.color,
    @required this.textColor,
    @required this.title,
    @required this.onPressed,
  }) : super(
          color: color,
          child: Text(
            title,
            style: TextStyle(color: textColor),
          ),
          onPressed: onPressed,
        );
}
