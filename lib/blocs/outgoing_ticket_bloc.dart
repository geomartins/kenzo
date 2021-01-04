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

  BehaviorSubject _result = new BehaviorSubject<List<TicketModel>>();
  BehaviorSubject _search = new BehaviorSubject<List<TicketModel>>();

  ////////////
  BehaviorSubject _openedTickets =
      new BehaviorSubject<List<QueryDocumentSnapshot>>();
  BehaviorSubject _openedTicketsMoreDataAvailability =
      new BehaviorSubject<bool>();
  BehaviorSubject _openedTicketsFetchingMoreData = new BehaviorSubject<bool>();
  BehaviorSubject _openedTicketsIsFetchingData = new BehaviorSubject<bool>();

  ////////
  BehaviorSubject _closedTickets =
      new BehaviorSubject<List<QueryDocumentSnapshot>>();
  BehaviorSubject _closedTicketsMoreDataAvailability =
      new BehaviorSubject<bool>();
  BehaviorSubject _closedTicketsFetchingMoreData = new BehaviorSubject<bool>();
  BehaviorSubject _closedTicketsIsFetchingData = new BehaviorSubject<bool>();

  void departmentSink(String value) {
    _department.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get department => _department.stream;
  Stream get isLoading => _isLoading.stream;
  Stream get search => _search.stream;
  Stream get openedTickets => _openedTickets.stream;
  Stream get closedTickets => _closedTickets.stream;

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

  Future<void> fetchOpenedTickets({int perPage, bool more = false}) async {
    if (_openedTicketsIsFetchingData.value == true) {
      return;
    }

    if (_openedTicketsFetchingMoreData.value == null) {
      try {
        _openedTicketsIsFetchingData.sink.add(true);
        Query q = FirebaseFirestore.instance
            .collection('tickets')
            .where('status', isEqualTo: 'opened')
            .orderBy('created_at', descending: true)
            .limit(perPage);
        QuerySnapshot querySnapshot = await q.get();
        _openedTickets.sink.add(querySnapshot.docs);
        _openedTicketsFetchingMoreData.sink.add(true);
      } catch (e) {
        print(e);
      } finally {
        _openedTicketsIsFetchingData.sink.add(false);
      }

      print('First ${_openedTickets.value}');
    }
    //
    if (more == true) {
      if (_openedTicketsFetchingMoreData.value == true) {
        if (_openedTicketsMoreDataAvailability.value == false) {
          return;
        }
        try {
          _openedTicketsIsFetchingData.sink.add(true);
          final lastRetrievedDoc =
              _openedTickets.value[_openedTickets.value.length - 1];
          Query q = FirebaseFirestore.instance
              .collection('tickets')
              .orderBy('created_at', descending: true)
              .startAfterDocument(lastRetrievedDoc)
              .limit(perPage);

          QuerySnapshot querySnapshot = await q.get();
          print('${querySnapshot.docs} Second');
          if (querySnapshot.docs.length < perPage) {
            print('No More data avaialable');
            _openedTicketsMoreDataAvailability.sink.add(false);
          }

          List<QueryDocumentSnapshot> old = _openedTickets.value;
          old.addAll(querySnapshot.docs);
          _openedTickets.sink.add(old);
        } catch (e) {} finally {
          _openedTicketsIsFetchingData.sink.add(false);
          print('Final ${_openedTickets.value.length}');
        }
      }
    }
  }

  Future<void> fetchClosedTickets({int perPage, bool more = false}) async {
    if (_closedTicketsIsFetchingData.value == true) {
      return;
    }

    if (_closedTicketsFetchingMoreData.value == null) {
      try {
        _closedTicketsIsFetchingData.sink.add(true);
        Query q = FirebaseFirestore.instance
            .collection('tickets')
            .where('status', isEqualTo: 'closed')
            .orderBy('created_at', descending: true)
            .limit(perPage);
        List<QueryDocumentSnapshot> querySnapshot;
        q.snapshots().listen((event) {
          querySnapshot = event.docs;

          _closedTickets.sink.add(querySnapshot);
          _closedTicketsFetchingMoreData.sink.add(true);
          print(querySnapshot);
        });
      } catch (e) {
        print(e);
      } finally {
        _closedTicketsIsFetchingData.sink.add(false);
      }

      print('First ${_closedTickets.value}');
    }
    //

    if (more == true) {
      if (_closedTicketsFetchingMoreData.value == true) {
        if (_closedTicketsMoreDataAvailability.value == false) {
          return;
        }
        try {
          _closedTicketsIsFetchingData.sink.add(true);
          final lastRetrievedDoc =
              _closedTickets.value[_closedTickets.value.length - 1];
          Query q = FirebaseFirestore.instance
              .collection('tickets')
              .orderBy('created_at', descending: true)
              .startAfterDocument(lastRetrievedDoc)
              .limit(perPage);

          List<QueryDocumentSnapshot> querySnapshot;
          q.snapshots().listen((event) {
            querySnapshot = event.docs;
            print('${querySnapshot.length} adddddddddddddddd');
            if (querySnapshot.length < perPage) {
              print('No More data avaialable');
              _closedTicketsMoreDataAvailability.sink.add(false);
            }

            final old = _closedTickets.value;
            old.addAll(querySnapshot);
            _closedTickets.sink.add(old);
          });
        } catch (e) {} finally {
          _closedTicketsIsFetchingData.sink.add(false);
          print('Final ${_closedTickets.value.length}');
        }
      }
    }
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
    _search.close();

    /////
    _openedTickets.close();
    _openedTicketsMoreDataAvailability.close();
    _openedTicketsIsFetchingData.close();
    _openedTicketsFetchingMoreData.close();

    _closedTickets.close();
    _closedTicketsMoreDataAvailability.close();
    _closedTicketsIsFetchingData.close();
    _closedTicketsFetchingMoreData.close();
  }
}
