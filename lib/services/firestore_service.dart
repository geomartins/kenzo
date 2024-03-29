import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/models/department_model.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'dart:async';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<ProfileModel> getProfileByUID() async {
    String uid = auth.currentUser.uid;
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('users').doc(uid).get();
      Map<String, dynamic> data = snapshot.data();
//      print(data);
      return ProfileModel.fromFirestore(data);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<ProfileModel> getProfileByUIDStream() async {
    String uid = auth.currentUser.uid;
    try {
      Map<String, dynamic> data = {};
      await firestore
          .collection('users')
          .doc(uid)
          .snapshots()
          .forEach((element) {
        data = element.data();
      });
      return ProfileModel.fromFirestore(data);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  void updatePhotoURL({String photoURL}) async {
    try {
      await auth.currentUser.updateProfile(photoURL: photoURL);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> updateCoverUrl({String url}) async {
    String uid = auth.currentUser.uid;
    try {
      await firestore.collection('users').doc(uid).update({'cover_url': url});
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<List<String>> getDepartmentList() async {
    try {
      List<String> result = [];
      QuerySnapshot snapshot = await firestore
          .collection('configurations')
          .doc('department')
          .collection('lists')
          .get();
      snapshot.docs.forEach((doc) {
        DepartmentModel departmentModel =
            DepartmentModel.fromFirestore(doc.data());
        result.add(departmentModel.name);
      });
      return result;
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> createOutgoingTicket({
    String title,
    String description,
    String toDepartment,
    List<String> imageURLs,
    List<String> subscriptionTopics,
  }) async {
    try {
      DocumentReference userReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid);

      DocumentReference ticketReference =
          FirebaseFirestore.instance.collection('tickets').doc();

      // DocumentReference mediaReference = FirebaseFirestore.instance
      //     .collection('tickets')
      //     .doc(ticketReference.id)
      //     .collection('media')
      //     .doc();

      firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot userSnapshot = await transaction.get(userReference);
        if (!userSnapshot.exists) {
          throw Exception("User does not exist!");
        }
        ProfileModel profileModel =
            ProfileModel.fromFirestore(userSnapshot.data());

        //
        transaction.set(ticketReference, {
          "title": title,
          "description": description,
          "from_department": profileModel.department,
          "to_department": toDepartment,
          "user": profileModel.toMap(),
          "status": 'opened',
          "images": imageURLs,
          "created_at": FieldValue.serverTimestamp(),
          "subscriptionTopics": subscriptionTopics,
        });

        // ticketReference.collection('medias').doc()
        // transaction.set(mediaReference, {'test': 'yyyyyyyyyyy'});
      });
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  // List<TicketModel> getTickets() {
  //   List<TicketModel> result = [];
  //   firestore.collection('tickets').get().then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       final ticketModel = TicketModel.fromMap(doc.data());
  //       result.add(ticketModel);
  //     });
  //   });
  //
  //   return result;
  // }

  Future<void> createOutgoingTicketResponse(
      {String ticketID,
      String reply,
      List<String> imageURLs,
      String notifier,
      String notifierViewId}) async {
    try {
      DocumentReference userReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid);

      DocumentReference ticketResponseReference = FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketID)
          .collection('responses')
          .doc();

      firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot userSnapshot = await transaction.get(userReference);
        if (!userSnapshot.exists) {
          throw Exception("User does not exist!");
        }
        ProfileModel profileModel =
            ProfileModel.fromFirestore(userSnapshot.data());

        //
        transaction.set(ticketResponseReference, {
          "reply": reply,
          "user": profileModel.toMap(),
          "images": imageURLs,
          "created_at": FieldValue.serverTimestamp(),
          "notifier": notifier,
          "notifier_view_id": notifierViewId,
        });
      });
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> createIncomingTicketResponse(
      {String ticketID, String reply, List<String> imageURLs}) async {
    try {
      DocumentReference userReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid);

      DocumentReference ticketResponseReference = FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketID)
          .collection('responses')
          .doc();

      firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot userSnapshot = await transaction.get(userReference);
        if (!userSnapshot.exists) {
          throw Exception("User does not exist!");
        }
        ProfileModel profileModel =
            ProfileModel.fromFirestore(userSnapshot.data());

        //
        transaction.set(ticketResponseReference, {
          "reply": reply,
          "user": profileModel.toMap(),
          "images": imageURLs,
          "created_at": FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> updateTicketStatus({String ticketID, String status}) async {
    try {
      firestore.collection('tickets').doc(ticketID).update({"status": status});
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> createOpinion({String description}) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('users').doc(auth.currentUser.uid).get();
      await firestore.collection('ticket_feedbacks').doc().set({
        'description': description,
        'user': snapshot.data(),
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> createTicketResponse(
      {String ticketID,
      String reply,
      List<String> imageURLs,
      List<dynamic> subscriptionTopics,
      String arguments}) async {
    try {
      DocumentReference userReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid);

      DocumentReference ticketResponseReference = FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketID)
          .collection('responses')
          .doc();

      firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot userSnapshot = await transaction.get(userReference);
        if (!userSnapshot.exists) {
          throw Exception("User does not exist!");
        }
        ProfileModel profileModel =
            ProfileModel.fromFirestore(userSnapshot.data());

        //
        transaction.set(ticketResponseReference, {
          "reply": reply,
          "user": profileModel.toMap(),
          "images": imageURLs,
          "subscriptionTopics": subscriptionTopics,
          "arguments": arguments,
          "created_at": FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }
}
