import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomTicketsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool offStage;
  final Function onPressed;

  CustomTicketsCard({
    @required this.title,
    @required this.icon,
    @required this.iconColor,
    @required this.offStage,
    @required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey.shade200,
        ),
        width: 170.0,
        height: 170.0,
        child: Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              top: -30.0,
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 100.0,
                    color: iconColor,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    title,
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 19.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -15.0,
              child: Offstage(
                offstage: offStage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white),
                      child: Icon(
                        Icons.check_circle,
                        color: kPrimaryColor,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
