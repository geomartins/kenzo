import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';

class CustomTicketResponseMetaData extends StatelessWidget {
  final TicketModel data;
  final String responseType;
  CustomTicketResponseMetaData(
      {@required this.data, @required this.responseType});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          data.title,
          style: TextStyle(letterSpacing: 0.7),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.0),
            Text(
              data.description,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10.0),
            _buildWrap(),
          ],
        ));
  }

  Widget _buildWrap() {
    if (responseType == 'incoming') {
      return Wrap(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.accessibility_new_outlined,
                  color: kPrimaryColor, size: 20.0),
              SizedBox(width: 3.0),
              Text(
                data.user['firstname'] != null
                    ? data.user['firstname'] + ' ' + data.user['lastname']
                    : data.user['department'],
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          SizedBox(width: 20.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_outlined,
                  color: kPrimaryColor, size: 20.0),
              SizedBox(width: 3.0),
              Text(
                data.user['department'] != null
                    ? data.user['department']
                    : 'Unknown department',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          SizedBox(width: 20.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_clock, color: kPrimaryColor, size: 20.0),
              SizedBox(width: 3.0),
              Text(
                DateFormat.yMMMEd().format(data.createdAt.toDate()),
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ],
      );
    } else if (responseType == 'outgoing') {
      return Wrap(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_outlined,
                  color: kPrimaryColor, size: 20.0),
              SizedBox(width: 3.0),
              Text(
                data.toDepartment != null
                    ? data.toDepartment
                    : 'Unknown department',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          SizedBox(width: 20.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_clock, color: kPrimaryColor, size: 20.0),
              SizedBox(width: 3.0),
              Text(
                DateFormat.yMMMEd().format(data.createdAt.toDate()),
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ],
      );
    }

    return Container();
  }
}
