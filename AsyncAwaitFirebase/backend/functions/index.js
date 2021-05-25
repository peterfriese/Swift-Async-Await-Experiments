const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.helloWorld = functions.https.onCall((data, context) => {
    return "Hello World from Firebase";
});
  
exports.helloUser = functions.https.onCall((data, context) => {
    return `Hello ${data} from Firebase`;
});
  