import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomAuthorBox extends StatelessWidget {
  final String author;
  CustomAuthorBox({this.author});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30.0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        height: 40.0,
        color: kTertiaryColor.shade200,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 40.0,
                color: kPrimaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Author',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(width: 15.0),
                    Text(author),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
