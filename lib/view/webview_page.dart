import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class webview_page extends StatefulWidget {
  final String url;

  const webview_page({Key? key, required this.url}) : super(key: key);

  @override
  webview_pageState createState() => webview_pageState();
}

class webview_pageState extends State<webview_page> {
  late WebViewController webViewController;
  bool isLoading = true;
  String? progress = "0";

  @override
  void initState() {
    super.initState();
    print("WebView URL: ${widget.url}");

    // Enable screenshot protection and data leakage prevention
    // addListenerPreventScreenshot();
    // preventScreenshotOn();
    // protectDataLeakageOn();

    // Initialize WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xffffffff))
      ..addJavaScriptChannel('Back', onMessageReceived: (message) {
        if (message.message == "1") {
          showConfirm(context);
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress.toString();
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('tested')) {
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url), method: LoadRequestMethod.get);
  }

  @override
  void dispose() {
    // Disable screenshot protection and data leakage prevention
    // removeListenerPreventScreenshot();
    // preventScreenshotOff();
    // ScreenProtector.protectDataLeakageOff();

    // Clean up resources
    webViewController.clearCache(); // Optional: Clear WebView cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showConfirm(context);
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            onPressed: () {
              showConfirm(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: webViewController),
            if (isLoading || progress != "100")
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirm(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Head's Up!",
                style: TextStyle(fontFamily: 'poppins_bold', fontSize: 23),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure to exit?",
                style: TextStyle(
                    fontFamily: 'poppins_regular',
                    color: Colors.black54,
                    fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text("NO", style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("YES",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}