import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:social_app/social_layout/layoutCubit/layout_cubit.dart';
import 'package:social_app/social_layout/socail_layout.dart';

import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on background message');
  print(message.data.toString());
  showToast(text: 'on background message', state: toastStates.SUCCESS);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
          () async
      {
        await CacheHelper.init();
        Widget widget;
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        var token = await FirebaseMessaging.instance.getToken();
        print(token);

        FirebaseMessaging.onMessage.listen((event)
        {
          print('on message');
          print(event.data.toString());
          showToast(text: 'on message', state: toastStates.SUCCESS);
          //print(event.notification?.body);

        });

        FirebaseMessaging.onMessageOpenedApp.listen((event)
        {
          print('on message opened app');
          print(event.data.toString());
          showToast(text: 'on message opened app', state: toastStates.SUCCESS);

          //print(event.notification?.body);

        });

        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);



        uId=CacheHelper.getData(key: 'uId');
        if(uId != null)
        {
          widget = SocailLayout();
        }
        else
        {
          widget = LoginScreen();
        }
        runApp(MyApp(widget));
      },
      blocObserver: MyBlocObserver()
  );
}


class MyApp extends StatelessWidget {

  final Widget startWidget;

   MyApp( this.startWidget);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: 
      [
        BlocProvider(create:(context)=>LayoutCubit()..getUserData()..getPosts() ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget ,
      ),
    );
  }
}



