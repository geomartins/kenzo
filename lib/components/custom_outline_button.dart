import 'package:flutter/material.dart';

class CustomOutlineButton extends OutlineButton {
  final Color color;
  final String title;
  final VoidCallback onPressed;

  CustomOutlineButton({
    @required this.color,
    @required this.title,
    @required this.onPressed,
  }) : super(
          color: color,
          child: Text(title),
          onPressed: onPressed,
        );
}
