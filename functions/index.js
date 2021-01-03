const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = 'SDIR2DEWN9';
const ALGOLIA_ADMIN_KEY = '503416d91974a195dbdbe88d84376c5d';
const ALGOLIA_INDEX_NAME = 'tickets';

admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

//exports.myFunction = functions.firestore
//  .document('users/{docId}')
//  .onCreate((snap, context) => {
//        console.log(snap.data());
//        admin.messaging().sendToTopic('chat', { notification: {
//            title: snap.data().surname,
//            body: 'New Message Incoming',
//            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
//        }})
//        return;
//   });


   exports.outgoingTicketCreate = functions.firestore
     .document('tickets/{docId}')
     .onCreate((snap, context) => {
           console.log(snap.data());
           //ict_ticket
           //clientservices_ticket
           //ict_response_ticket
           const data = snap.data();
           let title = data.title;
           let description = data.description;
           let department = data.to_department;
           let subscriptionTopic = department+'_ticket';

           admin.messaging().sendToTopic(subscriptionTopic, { notification: {
               title: title,
               body: description,
               clickAction: 'FLUTTER_NOTIFICATION_CLICK'
           }})
           return;
      });


      exports.createTicket = functions.firestore
          .document('tickets/{docId}')
          .onCreate((snap, context) => {
                const newValue = snap.data();
                newValue.objectID = snap.id;

                var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);

                var index = client.initIndex(ALGOLIA_INDEX_NAME);
                index.saveObject(newValue);
                console.log('finished');

          });


           exports.updateTicket = functions.firestore
                    .document('tickets/{docId}')
                    .onUpdate((snap, context) => {
                          const afterUpdate = snap.after.data();
                          afterUpdate.objectID = snap.after.id;
                          var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
                          var index = client.initIndex(ALGOLIA_INDEX_NAME);
                          index.saveObject(afterUpdate);


                    });

            exports.deleteTicket = functions.firestore
                               .document('tickets/{docId}')
                               .onDelete((snap, context) => {
                                     const oldID = snap.id;
                                     var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
                                     var index = client.initIndex(ALGOLIA_INDEX_NAME);
                                     index.deleteObject(oldID);
                               });