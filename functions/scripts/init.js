const admin = require("firebase-admin");
const { favoriteName } = require("../models/favorite");
const { deviceTokenName } = require("../models/device_token");
const { userName } = require("../models/user");

admin.initializeApp({
  projectId: "ag-viewer-dev",
});

const db = admin.firestore();
db.settings({
  host: "localhost:8080",
  ssl: false,
});

const run = async () => {
  console.log("Start running...");
  const user = db.collection(userName).doc();
  console.log(user.id);
  await db.collection(userName).doc(user.id).set({
    name: "guest",
    userId: user.id,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await db.collection(deviceTokenName).doc(user.id).set({
    token:
      "cvJfyb5IOkaWgYDWRiAO7K:APA91bEN9UTYwBYoA1ZJfMX3WiALZGY7wqoHeclO1Lh2ckZzve4CLoMBELAHLYIPEcfjqYKRQxH0yTDwKTdJmJRIly2eHTw_J1QLaHSYO6u-wayputHa6aSfDed6bJoG7DWxoZYVljil",
    userId: user.id,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const fav = db
    .collection(userName)
    .doc(user.id)
    .collection(favoriteName)
    .doc();
  console.log(fav.id);
  await db
    .collection(userName)
    .doc(user.id)
    .collection(favoriteName)
    .doc(fav.id)
    .set({
      favoriteId: fav.id,
      userId: user.id,
      dur: 30,
      isBroadcast: true,
      isRepeat: false,
      pfm: "三澤紗千香",
      subscribed: true,
      title: "三澤紗千香のラジオを聴くじゃんね",
      ft: admin.firestore.Timestamp.fromDate(
        new Date("2021/2/23 14:00:00 UTC+9")
      ),
      to: admin.firestore.Timestamp.fromDate(
        new Date("2021/2/23 14:30:00 UTC+9")
      ),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
};

run();
