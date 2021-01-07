import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/incoming_ticket_paginators.dart';
import '../models/ticket_model.dart';
import 'package:staff_portal/services/algolia_service.dart';

class IncomingTicketBloc extends Object with IncomingTicketPaginators {
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();
  BehaviorSubject _result = new BehaviorSubject<List<TicketModel>>();
  BehaviorSubject _search = new BehaviorSubject<List<TicketModel>>();

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get isLoading => _isLoading.stream;
  Stream get search => _search.stream;

  Future<void> searchTicket(String query) async {
    _search.sink.add(await AlgoliaService()
        .incomingTicketSearch(input: query, toDepartment: departmentX.value));
  }

  List<TicketModel> convertQueryDocumentSnapshotToTicketModel(
      List<QueryDocumentSnapshot> datas) {
    List<TicketModel> result = [];
    for (final x in datas) {
      Map<String, dynamic> info = x.data();
      info['id'] = x.id;
      result.add(TicketModel.fromMap(info));
    }
    return result;
  }

  void dispose() {
    _result.close();
    _isLoading.close();
    _search.close();
  }
}
