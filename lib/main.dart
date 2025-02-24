import 'package:dermalens/pages/home.dart';
import 'package:dermalens/Auth/login.dart';
import 'package:dermalens/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dermalens/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const dermalens());
}

class dermalens extends StatefulWidget {
  const dermalens({super.key});

  @override
  State<dermalens> createState() => _dermalensState();
}

class _dermalensState extends State<dermalens> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('====================== User is currently signed out!');
      } else {
        print('====================== User is signed in!');
      }
    });
    super.initState();
  }

	@override
	Widget build(BuildContext context) {
	return MaterialApp(
		title: 'dermalens',
		debugShowCheckedModeBanner: false,
		scrollBehavior: MyCustomScrollBehavior(),
		theme: ThemeData(
		primarySwatch: Colors.blue,
		),
		  home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : const Home(firstName: '',),
      routes: {
        "login": (context) => const Login(),
        "signup": (context) => const Signup(),
        "home": (context) => const Home(firstName: '',)
      },
    );
  }
}