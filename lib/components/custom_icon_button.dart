import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final String title;

  const CustomIconButton({this.icon, this.onPressed, this.color, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            color: color,
            icon: Icon(
              icon,
              size: 25.0,
            ),
            onPressed: onPressed),
        Text(title ?? 'Dashboard'),
      ],
    );
  }
}
