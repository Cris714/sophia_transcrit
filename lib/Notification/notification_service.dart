import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../Authentication/firebase_options.dart';

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: false,
              onlyAlertOnce: false,
              enableVibration: false,
              importance: NotificationImportance.Low,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;

  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents(func) async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: func);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.KeepOnTop ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      debugPrint(
          'Message sent via notification input: "${receivedAction
              .buttonKeyInput}"');
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        debugPrint(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
        IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          debugPrint('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    null;
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        // -1 is replaced by a random number
        channelKey: 'alerts',
        title: 'Recording audio...',
        body: 'Tap to manage',
        locked: true,
        autoDismissible: false,
        displayOnBackground: true,
        displayOnForeground: true
      ),
      /*actionButtons: [
        NotificationActionButton(
          key: 'PAUSE',
          label: 'Pause',
          showInCompactView: true,
          actionType: ActionType.KeepOnTop
        ),
        NotificationActionButton(
          key: 'STOP',
          label: 'Stop',
          actionType: ActionType.DismissAction,
          isDangerousOption: true,
          showInCompactView: true
        ),
      ]*/
    );
  }

  static dismissRecordingNotification() async {
    AwesomeNotifications().dismiss(1);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("Handling a background message: ${message.messageId}");
}
