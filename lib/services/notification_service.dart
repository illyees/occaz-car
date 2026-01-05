import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialiser les notifications
  Future<void> initialize() async {
    // Demander la permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notifications autorisées');

      // Configuration des notifications locales
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Gérer le clic sur la notification
          print('Notification cliquée: ${response.payload}');
        },
      );

      // Écouter les messages en arrière-plan
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

      // Écouter les messages au premier plan
      FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);

      // Gérer les clics sur notifications
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    }
  }

  // Récupérer le token FCM
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  // Sauvegarder le token utilisateur
  Future<void> saveUserToken(String userId) async {
    String? token = await getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Sauvegarder les critères de recherche pour alertes
  Future<void> saveSearchCriteria({
    required String userId,
    String? brand,
    double? maxPrice,
    int? minYear,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('searchAlerts')
        .add({
      'brand': brand,
      'maxPrice': maxPrice,
      'minYear': minYear,
      'createdAt': FieldValue.serverTimestamp(),
      'active': true,
    });
  }

  // Récupérer les alertes de recherche
  Stream<List<Map<String, dynamic>>> getSearchAlerts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('searchAlerts')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // Supprimer une alerte
  Future<void> deleteSearchAlert(String userId, String alertId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('searchAlerts')
        .doc(alertId)
        .delete();
  }

  // Afficher une notification locale
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'occazcar_channel',
      'OccazCar Notifications',
      channelDescription: 'Notifications pour nouvelles annonces',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  // Handler pour messages en arrière-plan
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Message en arrière-plan: ${message.messageId}');
  }

  // Handler pour messages au premier plan
  void _foregroundMessageHandler(RemoteMessage message) {
    print('Message au premier plan: ${message.notification?.title}');
    
    if (message.notification != null) {
      showLocalNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'Nouvelle notification',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  // Handler pour ouverture de notification
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification ouverte: ${message.messageId}');
    // Navigation vers l'écran approprié
  }
}
