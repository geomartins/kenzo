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



      exports.createTicketResponse = functions.firestore
           .document('tickets/{docId}/responses/{repId}')
           .onCreate((snap, context) => {
            const data = snap.data();

           //Push Notification
             admin.messaging().sendToTopic(data.notifier, {
                 notification: {
                     title: data.user.firstname+' '+data.user.lastname+' @'+data.user.department+'  #'+snap.id,
                     body: 'New Response!!! '+data.reply,
                     clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                 },
                 data: {
                    view_id: data.notifier_view_id,
                    arguments: context.params.repId,
                 }
             })
      });


      exports.createTicket = functions.firestore
          .document('tickets/{docId}')
          .onCreate((snap, context) => {

                const newValue = snap.data();

                //Message to Algolia
                newValue.objectID = snap.id;
                var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
                var index = client.initIndex(ALGOLIA_INDEX_NAME);
                index.saveObject(newValue);
                console.log('finished');


                //Push Notification
                admin.messaging().sendToTopic(newValue.notifier, {
                    notification: {
                       title: newValue.user.firstname+' '+newValue.user.lastname+' @'+newValue.user.department+'  #'+snap.id,
                       body: 'New Ticket!!! '+newValue.title,
                       clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    },
                    data: {
                         view_id: newValue.notifier_view_id,
                         arguments: context.params.docId,
                    }
               });

          });


           exports.updateTicket = functions.firestore
                    .document('tickets/{docId}')
                    .onUpdate((snap, context) => {

                          const beforeUpdate = snap.before.data();
                          const afterUpdate = snap.after.data();
                          afterUpdate.objectID = snap.after.id;
                          var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
                          var index = client.initIndex(ALGOLIA_INDEX_NAME);
                          index.saveObject(afterUpdate);


                           //Push Notification
//
                           if(afterUpdate.status !== beforeUpdate.status){
                                 admin.messaging().sendToTopic(afterUpdate.from_department+'_ticket', {
                                     notification: {
                                         title: '@'+afterUpdate.to_department+'  #'+context.params.docId,
                                         body: 'Status Update!!! Ticket marked as '+afterUpdate.status,
                                         clickAction: 'FLUTTER_NOTIFICATION_CLICK',

                                     },
                                     data: {
                                         view_id: 'outgoing_ticket_response',
                                         arguments: context.params.docId,
                                     }
                                 });
                           }


                    });

            exports.deleteTicket = functions.firestore
                               .document('tickets/{docId}')
                               .onDelete((snap, context) => {
                                     const oldID = snap.id;
                                     var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
                                     var index = client.initIndex(ALGOLIA_INDEX_NAME);
                                     index.deleteObject(oldID);
                               });