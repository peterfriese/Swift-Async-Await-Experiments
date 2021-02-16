import * as functions from "firebase-functions";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onCall((data, context) => {
  functions.logger.info("Hello logs!", {structuredData: true})
  return {result: "Hello from Firebase!"}
})
