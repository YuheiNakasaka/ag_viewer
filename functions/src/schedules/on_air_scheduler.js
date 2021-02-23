const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// exports.onAirScheduler = functions.pubsub
//   .schedule("every 5 minutes")
//   .timeZone("Asia/Tokyo")
//   .onRun((context) => {
//     console.log("This will be run every 5 minutes!");
//     return null;
//   });

exports.onAirScheduler = functions.https.onRequest(async (req, res) => {
  res.json({ message: "Hello World!" });
});
