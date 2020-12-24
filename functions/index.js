const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

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