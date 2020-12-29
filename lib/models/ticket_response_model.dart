import 'package:cloud_firestore/cloud_firestore.dart';

class TicketResponseModel {
  final String id;
  final String reply;
  final Timestamp createdAt;
  final Map<String, dynamic> user;
  final List<dynamic> images;

  TicketResponseModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        reply = data['reply'],
        user = data['user'],
        images = data['images'] ?? [],
        createdAt = data['created_at'];
}
