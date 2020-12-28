import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String id;
  final String title;
  final String description;
  final String toDepartment;
  final String fromDepartment;
  final Timestamp createdAt;
  TicketModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        toDepartment = data['to_department'],
        fromDepartment = data['from_department'],
        createdAt = data['created_at'];
}
