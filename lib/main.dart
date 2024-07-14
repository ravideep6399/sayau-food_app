import 'package:flutter/material.dart';
import 'package:food_app/menu.dart';
import 'package:food_app/navigation_controls.dart';
import 'package:food_app/web_view_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://demo.sayau.in/public/'),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller), 
        ],
        backgroundColor: Colors.white,
      ),
      body: WebViewStack(controller: controller,),
    );
  }
}
