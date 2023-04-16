import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_reminder/firebase_options.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/home_layout.dart';
import 'package:my_reminder/main_loading.dart';
import 'package:my_reminder/modules/login/login_screen.dart';
import 'package:my_reminder/modules/test_screen.dart';
import 'package:my_reminder/shared/bloc_observer.dart';

import 'package:my_reminder/shared/components/constants.dart';
import 'package:my_reminder/shared/network/local/cache_helper.dart';
import 'package:my_reminder/shared/network/local/notification_helper.dart';
import 'package:my_reminder/shared/styles/styles.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.notification}");
}

void main() async {
  //This will make sure that await methods will be initialized before calling runApp
  WidgetsFlutterBinding.ensureInitialized();
  // Fill sharedPrefrences object when I run app using init method in cache_helper

  await CacheHelper.init();
  // Fill the notificationsService when I run app
  // await NotificationHelper.init();
  // Observe states of blocs
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'main_channel',
          channelName: 'Main Channel',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
          // max - high : sound/pop-up (high is better)
          // default :  sound/no pop-up
          // low : no sound/no pop-up (you need to scroll)
          // min : no sound/no pop-up (silent)
          defaultPrivacy: NotificationPrivacy.Public,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          channelShowBadge: true, // number of notifications appear on app //
        )
      ],
      debug: true);

  // Get token
  // var token = await FirebaseMessaging.instance.getToken();

  // Notification when app is in foreground
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
  // // Notification when app is in background/terminated
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // // Notifications

  uId = CacheHelper.getData('uId');
  Widget widget;
  if (uId == null) {
    widget = LoginScreen();
  } else {
    widget = HomeLayout();
  }

  runApp(MyApp(startwidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget? startwidget;
  const MyApp({super.key, this.startwidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()
              ..requestPermission()
              ..getUser()
              ..getTask()
              ..getCategories()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar')],
        debugShowCheckedModeBanner: false,
        theme: lightMode, // In styles file

        home: startwidget,
      ),
    );
  }
}
