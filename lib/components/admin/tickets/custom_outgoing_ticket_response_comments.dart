import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';


class CustomOutgoingTicketResponseComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('MA'),
        backgroundColor: kPrimaryColor,
      ),
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kTertiaryColor.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Martins Abiodun',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 15.0,
                  ),
            ),
//            _buildMediaFrame(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5.0),
                Text(
                  '2020-04-51 8am',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: kTertiaryColor.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
