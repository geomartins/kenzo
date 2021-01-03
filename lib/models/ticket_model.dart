import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String id;
  final String title;
  final String description;
  final String toDepartment;
  final String fromDepartment;
  final Timestamp createdAt;
  final Map<String, dynamic> user;
  final List<dynamic> images;
  final String status;
  TicketModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        toDepartment = data['to_department'],
        fromDepartment = data['from_department'],
        user = data['user'],
        status = data['status'],
        images = data['images'] ?? [],
        createdAt = data['created_at'] ?? Timestamp.now();
}
