import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:staff_portal/models/fcm_configure_model.dart';
import 'package:staff_portal/services/firestore_service.dart';

class FirebaseMessagingService {
  final fbm = FirebaseMessaging();

  Future<void> topicSubscription({@required String topic}) async {
    //get department
    //merge topic with department;
    final profile = await FirestoreService().getProfileByUID();
    String fullTopic = profile.department + '_' + topic;

    fbm.requestNotificationPermissions();
    fbm.subscribeToTopic(fullTopic);
  }

  void configure(BuildContext context) {
    fbm.configure(
      onMessage: (msg) {
        print('onMessage -------- ${msg['data']}');
        return null;
      },
      onLaunch: (msg) {
        print('onLaunch ------------- ${msg['data']}');
        return null;
      },
      onResume: (msg) {
        print('onResume --------- ${msg['data']}');
        if (msg['data'] != null) {
          final data = FcmConfigureModel.fromMap(msg['data']);
          if (data.viewId != null) {
            print('View IDD : ${data.viewId}');
            SchedulerBinding.instance.addPostFrameCallback((_) {
              print('View IDDD : ${data.viewId}');
              Navigator.pushNamed(context, data.viewId,
                  arguments: data.arguments);
            });
          }
        }

        return null;
      },
    );
  }
}
