import 'package:arkenergyapp/Screens/about.dart';
import 'package:arkenergyapp/Screens/data.dart';
import 'package:flutter/material.dart';
import 'package:arkenergyapp/Constants.dart';
import 'package:toastification/toastification.dart';
import 'Screens/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAr5rgYwkP54WwMNLoV74eBXb35LArxebU",
        appId: "1:54668765287:android:866efde282b0fbdb57ccc2",
        messagingSenderId: "54668765287",
        projectId: "arkenergy-5ea5e",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  
  await subscribeToWindowAlertTopic();
  runApp(const MyApp());
}

Future<void> subscribeToWindowAlertTopic() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions if on iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    await messaging.subscribeToTopic('window-alert');
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ark Energy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: darkblue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Welcome to Ark Energy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Data(),
    About(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: _pages[_selectedIndex],
      
    bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2), // Shadow coming from the bottom
            ),
          ],
        ),
        child: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: blue,
        backgroundColor: background,
        shadowColor: black,
        elevation: 4,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.arrow_outward_rounded, color: white,),
            icon: Icon(Icons.arrow_outward_rounded, color: darkblue),
            label: 'Ark Energy',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_pin, color: white,),
            icon: Badge(
              child: Icon(Icons.person_pin, color: darkblue),
            ),
            label: 'About',
          ),
        ],
      ),
    ),
      
      
    );
  }
}
