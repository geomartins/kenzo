import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const CustomIconButton({this.icon, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
            color: color,
            icon: Icon(
              icon,
              size: 25.0,
            ),
            onPressed: onPressed),
      ],
    );
  }
}
