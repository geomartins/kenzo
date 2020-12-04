import 'package:flutter/material.dart';

class CustomOffstageProgressIndicator extends StatelessWidget {
  final bool status;
  CustomOffstageProgressIndicator({@required this.status});
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: status,
      child: Center(
        child: Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.all(5),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(Colors.teal),
          ),
        ),
      ),
    );
  }
}
