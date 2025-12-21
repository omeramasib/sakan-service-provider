importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDqbuXcafVDsudZYsQbMIP_Bfknro6Ofo8",
  appId: "1:858864824848:web:29a9e91ed840c23a081095",
  messagingSenderId: "858864824848",
  projectId: "sakan-service-provider",
  storageBucket: "sakan-service-provider.firebasestorage.app",
  measurementId: "G-Q6DRPYK1E5"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification?.title || 'New Notification';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
