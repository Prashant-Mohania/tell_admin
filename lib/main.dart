import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tell_admin/screen/AuthPage/auth_screen.dart';
import 'package:tell_admin/screen/HomePage/home_page.dart';
import 'package:tell_admin/service/local_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Firebase.initializeApp(
  //     // options: const FirebaseOptions(
  //     //     apiKey: "AIzaSyA5M9V9rITeL_uQs7hDR-enURE8OUAnxDc",
  //     //     appId: "1:902703766477:web:079f729ede65c96d4dc284",
  //     //     messagingSenderId: "902703766477",
  //     //     projectId: "admintell-834b3"),
  //     );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Admin",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // home: const SplashScreen(),
      home: FutureBuilder(
          future: LocalData.getAuth(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            print(snapshot.data);
            // if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data == true
                ? const HomePage()
                : const AuthScreen();
            // }
            // return const Center(
            //   child: CircularProgressIndicator(),
            // );
          }),
    );
  }
}
