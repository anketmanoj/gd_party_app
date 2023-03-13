const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const firestore = admin.firestore();

// This function will run every minute
exports.sendEventNotification = functions.pubsub
  .schedule('* * * * *')
  .onRun(async (context) => {
    const currentTime = new Date().getTime();
    const eventsSnapshot = await firestore.collection('events').get();
    const usersSnapshot = await firestore.collection('users').get();

    eventsSnapshot.forEach(async (eventDoc) => {
      const event = eventDoc.data();
      const eventTime = event.timestamp.toDate().getTime();
      const timeDifference = eventTime - currentTime;

      // Only send notifications for events that are happening in the next 30 minutes
      if (timeDifference > 0 && timeDifference <= 30 * 60 * 1000) {
        const notificationSent = event.notificationSent || {};

        usersSnapshot.forEach(async (userDoc) => {
          const user = userDoc.data();
          const userId = userDoc.id;
          const userDeviceToken = user.userDeviceToken;

          // Only send notification to users who haven't received it yet
          if (!notificationSent[userId]) {
            await admin.messaging().sendToDevice(userDeviceToken, {
              notification: {
                title: `Event ${event.name} is happening soon!`,
                body: `Event ${event.name} is starting in ${timeDifference /
                  60000} minutes.`,
              },
            });

            // Update the notificationSent field so we don't send the same notification again
            await eventDoc.ref.update({
              notificationSent: {
                ...notificationSent,
                [userId]: true,
              },
            });
          }
        });
      }
    });
  });

