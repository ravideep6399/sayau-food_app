import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/api/cookie_manager.dart';
import 'package:food_app/api/firebase_api.dart';
import 'package:food_app/firebase_options.dart';
// import 'package:food_app/menu.dart';
import 'package:food_app/navigation_controls.dart';
import 'package:food_app/web_view_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WebViewApp(),
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  final CookieManager _cookieManager = CookieManager();
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://demo.sayau.in/public/'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          NavigationControls(controller: controller),
          // Menu(controller: controller),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _cookieManager.clearCookies();
              // Reload WebView or navigate to login screen
              controller.clearCache();
              controller.loadRequest(Uri.parse('https://demo.sayau.in/public/'));
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: WebViewStack(
        controller: controller,
      ),
    );
  }
}
