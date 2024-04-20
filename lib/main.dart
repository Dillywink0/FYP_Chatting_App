import 'package:chat_app/FontSizeProvider.dart';
import 'package:chat_app/colours/ColorProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/firebase_options.dart';
import 'Pages/Login/login.dart';
import 'Pages/Register/register.dart';
import 'Pages/profile/profile.dart';
import 'Pages/search/search.dart';
import 'Pages/settings/setting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => FontSizeProvider()), // Add FontSizeProvider
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.notification?.title}");
  // Handle background messages
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData.light(),
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const RegisterPage(),
        '/search': (context) => const SearchPage(),
        '/settings': (context) => const SettingsPage(),
      //  '/chat': (context) => const ChatterScreen(),
        '/profile': (context) => ProfileScreen()
      //  '/chats': (context) => const ChatStream(),
      },
    );
  }
}
