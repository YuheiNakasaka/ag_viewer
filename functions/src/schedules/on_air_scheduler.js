const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { favoriteName } = require("../../models/favorite");
const { deviceTokenName } = require("../../models/device_token");
const dayjs = require("dayjs");
var utc = require("dayjs/plugin/utc");
var timezone = require("dayjs/plugin/timezone");
dayjs.extend(utc);
dayjs.extend(timezone);
dayjs.tz.setDefault("Asia/Tokyo");

admin.initializeApp();

const db = admin.firestore();

// ローカルエミュレータでのPub/Subテストはだるいのでhttpsで試したりする
// exports.onAirScheduler = functions.https.onRequest(async (req, res) => {
//   const now = dayjs().tz("Asia/Tokyo");
//   const from = now.toDate();
//   const to = now.add(10, "minute").toDate();
//   const start = admin.firestore.Timestamp.fromDate(from);
//   const end = admin.firestore.Timestamp.fromDate(to);
//   console.log(from, to);
//   const snapshots = await db
//     .collectionGroup(favoriteName)
//     .where("ft", ">", start)
//     .where("ft", "<=", end)
//     .get();
//   const promises = snapshots.docs.map((snapshot) => {
//     const data = snapshot.data();
//     return notificationHandler(data);
//   });
//   await Promise.all(promises);
//   console.log("success");
//   res.json({ status: "success" });
// });

exports.onAirScheduler = functions.pubsub
  .schedule("every 10 minutes")
  .timeZone("Asia/Tokyo")
  .onRun(async (context) => {
    const now = dayjs().tz("Asia/Tokyo");
    const from = now.toDate();
    const to = now.add(10, "minute").toDate();
    const start = admin.firestore.Timestamp.fromDate(from);
    const end = admin.firestore.Timestamp.fromDate(to);
    console.log(from, to);

    const snapshots = await db
      .collectionGroup(favoriteName)
      .where("ft", ">", start)
      .where("ft", "<=", end)
      .get();

    const promises = snapshots.docs.map((snapshot) => {
      const data = snapshot.data();
      return notificationHandler(data);
    });

    await Promise.all(promises);
  });

notificationHandler = (data) => {
  // eslint-disable-next-line no-loop-func
  return new Promise((resolve, reject) => {
    console.log("Sending notification.");
    return db
      .collection(deviceTokenName)
      .doc(data.userId)
      .get()
      .then((doc) => {
        const deviceToken = doc.data();
        // eslint-disable-next-line promise/no-nesting
        return admin
          .messaging()
          .sendToDevice(
            deviceToken["token"],
            {
              notification: {
                title: `${data["title"]}`,
                body: "お気に入りの放送がもうすぐ始まります。",
                sound: "default",
                mutable_content: "true",
                content_available: "true",
              },
              data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                status: "done",
              },
            },
            {
              priority: "high",
              collapseKey: `${data.userId}`,
            }
          )
          .then(() => {
            return resolve();
          })
          .catch((e) => {
            return reject(
              Error(`Notification can not be sent in some reason: ${e}`)
            );
          });
      })
      .catch((e) => {
        return reject(Error(`Device Token fetching error: ${e}`));
      });
  });
};
