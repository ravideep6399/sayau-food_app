import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
            isLoading = false;
          });
        },
        onNavigationRequest: (navigation) {
          final host = Uri.parse(navigation.url).host;
          if (host.contains('youtube.com')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Blocking navigation to $host',
                ),
              ),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isLoading
            ? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(),
                  Container(
                    height: 65,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          // height: 350,
                          decoration: const BoxDecoration(
                              // color: Colors.yellow,
                              image: DecorationImage(
                                  image: AssetImage("assets/syau_logo.png"),fit: BoxFit.contain)),
                        ),
                    ),
                  ),
                  const CircularProgressIndicator(color: Colors.red,)
                ],
              ),
            )
            : WebViewWidget(
                controller: widget.controller,
              ),
        if (loadingPercentage < 100 && !isLoading)
          Container(
            color: Color.fromARGB(150, 0, 0, 0),
            child: const Center(
              child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
            ),
          ),
        // LinearProgressIndicator(
        //   backgroundColor: Colors.white,
        //   color: Colors.red,
        //   value: loadingPercentage / 100.0,
        // ),
      ],
    );
  }
}
