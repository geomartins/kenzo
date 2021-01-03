import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_portal/models/ticket_model.dart';

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'SDIR2DEWN9',
    apiKey: 'f9fa89cf92ff58f2ce95d793b44f8269',
  );
}

class AlgoliaService {
  Algolia algolia = Application.algolia;

  Future<List<TicketModel>> outgoingTicketSearch(
      {String input, String fromDepartment}) async {
    List<TicketModel> result = [];
    AlgoliaQuery query = algolia.instance.index('tickets').search(input);
    //query = query.setFacetFilter('from_department:ict');
    AlgoliaQuerySnapshot algoliaQuerySnapshot = await query.getObjects();
    print(algoliaQuerySnapshot.hits);
    List<AlgoliaObjectSnapshot> algoliaObjectSnapshot =
        algoliaQuerySnapshot.hits;
    for (AlgoliaObjectSnapshot snapshot in algoliaObjectSnapshot) {
      Map<String, dynamic> data = snapshot.data;
      data['id'] = snapshot.objectID;
      data['created_at'] = Timestamp.now();

      TicketModel ticketModel = TicketModel.fromMap(data);
      if (ticketModel.fromDepartment == fromDepartment) {
        result.add(ticketModel);
      }
    }

    print('Inside algolia Service $result');
    return result;
  }
}
