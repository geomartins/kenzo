import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/services/firestore_service.dart';
import '../models/ticket_model.dart';
import 'package:staff_portal/services/algolia_service.dart';

class OutgoingTicketBloc extends Object with Validators {
  BehaviorSubject _department = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();
  BehaviorSubject _openTickets = new BehaviorSubject<List<TicketModel>>();
  BehaviorSubject _pendingTickets = new BehaviorSubject<List<TicketModel>>();
  BehaviorSubject _closedTickets = new BehaviorSubject<List<TicketModel>>();
  BehaviorSubject _result = new BehaviorSubject<List<TicketModel>>();
  BehaviorSubject _search = new BehaviorSubject<List<TicketModel>>();

  void departmentSink(String value) {
    _department.sink.add(value);
  }

  void openTicketsSink(List<TicketModel> value) {
    _openTickets.sink.add(value);
  }

  void pendingTicketsSink(List<TicketModel> value) {
    _pendingTickets.sink.add(value);
  }

  void closedTicketsSink(List<TicketModel> value) {
    _closedTickets.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get department => _department.stream;
  Stream get isLoading => _isLoading.stream;
  Stream get search => _search.stream;

  Stream<List<TicketModel>> get allTickets => FirebaseFirestore.instance
          .collection('tickets')
          .where('from_department', isEqualTo: _department.value)
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((data) {
        List<TicketModel> result = [];

        data.docs.forEach((doc) {
          Map<String, dynamic> document = doc.data();
          document['id'] = doc.id;
          result.add(TicketModel.fromMap(document));
        });
        return result.toList();
      });

  Future<void> fetchDepartment() async {
    ProfileModel profileModel = await FirestoreService().getProfileByUID();
    print(profileModel.department);
    departmentSink(profileModel.department);
  }

  Future<void> searchTicket(String query) async {
    _search.sink.add(await AlgoliaService()
        .outgoingTicketSearch(input: query, fromDepartment: _department.value));
  }

  // ScrollController _scrollController = new ScrollController();
  // _scrollController.addListener(() {
  //   double maxScroll = _scrollController.position.maxScrollExtent;
  //   double currentScroll = _scrollController.position.pixels;
  //   double delta = MediaQuery.of(context).size.height * 0.25;
  //
  //   if(maxScroll - currentScroll <= delta){
  //     getMoreProducts();
  // }
  // })
  //
  // List<DocumentSnapshot> products = [];
  // DocumentSnapshot lastDocument = [];
  // bool loadingProducts = false;
  // int perPage = 20;
  // bool gettingMoreProducts = false;
  // bool moreProductAvailable = true;
  //
  // Future<void> getProducts() async {
  //   Query q = FirebaseFirestore.instance
  //       .collection('tickets')
  //       .orderBy('created_at', descending: true)
  //       .limit(perPage);
  //   loadingProducts = true;
  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   products = querySnapshot.documents;
  //   lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
  //   loadingProducts = false;
  // }
  //
  // Future<void> getMoreProducts() async {
  //
  //   if(moreProductAvailable == false){
  //     return;
  //   }
  //
  //   if(gettingMoreProducts == true){
  //     return;
  //   }
  //
  //   gettingMoreProducts = true;
  //   Query q = FirebaseFirestore.instance
  //       .collection('tickets')
  //       .orderBy('created_at', descending: true)
  //       .startAfter([lastDocument.data()['created_at']]).limit(perPage);
  //
  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   if(querySnapshot.documents.length  < perPage){
  //     moreProductAvailable = false;
  //   }
  //   lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
  //   products.addAll(querySnapshot.documents);
  //
  //   gettingMoreProducts = false;
  //
  // }

  // Future<void> fetchOpenTickets() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection('tickets').limit(10).get();
  //   List<QueryDocumentSnapshot> openTickets = querySnapshot.docs;
  //   openTickets[openTickets.dlength - 1];
  // }

  void dispose() {
    _department.close();
    _result.close();
    _isLoading.close();
    _pendingTickets.close();
    _openTickets.close();
    _closedTickets.close();
    _search.close();
  }
}
