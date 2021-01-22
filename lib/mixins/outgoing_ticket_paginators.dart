import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class OutgoingTicketPaginators {
  BehaviorSubject departmentX = new BehaviorSubject<String>();
  ////////
  BehaviorSubject _pendingTickets =
      new BehaviorSubject<List<QueryDocumentSnapshot>>();
  BehaviorSubject _pendingTicketsMoreDataAvailability =
      new BehaviorSubject<bool>();
  BehaviorSubject _pendingTicketsFetchingMoreData = new BehaviorSubject<bool>();
  BehaviorSubject _pendingTicketsIsFetchingData = new BehaviorSubject<bool>();

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
    departmentX.sink.add(value);
  }

  Stream get department => departmentX.stream;
  Stream get pendingTickets => _pendingTickets.stream;
  Stream get openedTickets => _openedTickets.stream;
  Stream get closedTickets => _closedTickets.stream;

  Future<void> fetchPendingTickets(
      {int perPage = 25, bool more = false}) async {
    if (_pendingTicketsIsFetchingData.value == true) {
      return;
    }

    if (_pendingTicketsFetchingMoreData.value == null) {
      try {
        _pendingTicketsIsFetchingData.sink.add(true);
        Query q = FirebaseFirestore.instance
            .collection('tickets')
            .where('status', isEqualTo: 'pending')
            .where('from_department', isEqualTo: departmentX.value)
            .orderBy('created_at', descending: true)
            .limit(perPage);
        List<QueryDocumentSnapshot> querySnapshot;
        q.snapshots().listen((event) {
          querySnapshot = event.docs;

          _pendingTickets.sink.add(querySnapshot);
          _pendingTicketsFetchingMoreData.sink.add(true);
          print(querySnapshot);
        });
      } catch (e) {
        print(e);
      } finally {
        _pendingTicketsIsFetchingData.sink.add(false);
      }

      print('First ${_pendingTickets.value}');
    }
    //

    if (more == true) {
      if (_pendingTicketsFetchingMoreData.value == true) {
        if (_pendingTicketsMoreDataAvailability.value == false) {
          print('Stopped fetching data');
          return;
        }
        try {
          _pendingTicketsIsFetchingData.sink.add(true);
          final lastRetrievedDoc =
              _pendingTickets.value[_pendingTickets.value.length - 1];
          Query q = FirebaseFirestore.instance
              .collection('tickets')
              .where('status', isEqualTo: 'pending')
              .where('from_department', isEqualTo: departmentX.value)
              .orderBy('created_at', descending: true)
              .startAfterDocument(lastRetrievedDoc)
              .limit(perPage);

          List<QueryDocumentSnapshot> querySnapshot;
          q.snapshots().listen((event) {
            querySnapshot = event.docs;
            print('${querySnapshot.length} adddddddddddddddd');
            if (querySnapshot.length < perPage) {
              print('No More data avaialable');
              _pendingTicketsMoreDataAvailability.sink.add(false);
            }

            final old = _pendingTickets.value;
            old.addAll(querySnapshot);
            _pendingTickets.sink.add(old);
          });
        } catch (e) {} finally {
          _pendingTicketsIsFetchingData.sink.add(false);
          print('Final ${_pendingTickets.value.length}');
        }
      }
    }
  }

  Future<void> fetchOpenedTickets({int perPage = 25, bool more = false}) async {
    print('Per Page $perPage');

    //If it is still fetching data
    if (_openedTicketsIsFetchingData.value == true) {
      print('Hold on!! am still fetch data');
      return;
    }

    if (_openedTicketsFetchingMoreData.value == null) {
      print('Preparing to Fetch Fresh Data');

      try {
        print('Still Preparing to fetch fresh data');

        _openedTicketsIsFetchingData.sink.add(true);
        Query q = FirebaseFirestore.instance
            .collection('tickets')
            .where('status', isEqualTo: 'opened')
            .where('from_department', isEqualTo: departmentX.value)
            .orderBy('created_at', descending: true)
            .limit(perPage);

        List<QueryDocumentSnapshot> querySnapshot;
        q.snapshots().listen((event) {
          querySnapshot = event.docs;

          _openedTickets.sink.add(querySnapshot);
          _openedTicketsFetchingMoreData.sink.add(true);
          print(querySnapshot);
        });
      } catch (e) {
        print(e);
      } finally {
        print('Am done fetching fresh data ');
        _openedTicketsIsFetchingData.sink.add(false);

        print('I fetched ---  ${_openedTickets.value} fresh data');
      }
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
              _openedTickets.value[_pendingTickets.value.length - 1];
          Query q = FirebaseFirestore.instance
              .collection('tickets')
              .where('status', isEqualTo: 'opened')
              .where('from_department', isEqualTo: departmentX.value)
              .orderBy('created_at', descending: true)
              .startAfterDocument(lastRetrievedDoc)
              .limit(perPage);

          List<QueryDocumentSnapshot> querySnapshot;
          q.snapshots().listen((event) {
            querySnapshot = event.docs;
            print('${querySnapshot.length} adddddddddddddddd');
            if (querySnapshot.length < perPage) {
              print(
                  'No More data avaialable ---------------------------------------------------');
              _openedTicketsMoreDataAvailability.sink.add(false);
            }

            final old = _openedTickets.value;
            old.addAll(querySnapshot);
            _openedTickets.sink.add(old);
          });
        } catch (e) {} finally {
          _openedTicketsIsFetchingData.sink.add(false);
          print('Final ${_openedTickets.value.length}');
        }
      }
    }
  }

  Future<void> fetchClosedTickets({int perPage = 25, bool more = false}) async {
    if (_closedTicketsIsFetchingData.value == true) {
      return;
    }

    if (_closedTicketsFetchingMoreData.value == null) {
      try {
        _closedTicketsIsFetchingData.sink.add(true);
        Query q = FirebaseFirestore.instance
            .collection('tickets')
            .where('status', isEqualTo: 'closed')
            .where('from_department', isEqualTo: departmentX.value)
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
              .where('status', isEqualTo: 'closed')
              .where('from_department', isEqualTo: departmentX.value)
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

  void dispose() {
    _pendingTickets.close();
    _pendingTicketsMoreDataAvailability.close();
    _pendingTicketsIsFetchingData.close();
    _pendingTicketsFetchingMoreData.close();

    /////
    _openedTickets.close();
    _openedTicketsMoreDataAvailability.close();
    _openedTicketsIsFetchingData.close();
    _openedTicketsFetchingMoreData.close();

    _closedTickets.close();
    _closedTicketsMoreDataAvailability.close();
    _closedTicketsIsFetchingData.close();
    _closedTicketsFetchingMoreData.close();

    departmentX.close();
  }
}
