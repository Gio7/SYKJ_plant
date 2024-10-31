import 'package:flutter/material.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebview extends StatefulWidget {
  const CommonWebview({super.key, this.title, required this.url});
  final String? title;
  final String url;

  @override
  State<CommonWebview> createState() => _CommonWebviewState();
}

class _CommonWebviewState extends State<CommonWebview> {
  late final WebViewController _webViewController;
  String? _title;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _title = widget.title;

    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF3F4F3))
      ..setNavigationDelegate(navigationDelegate())
      ..loadRequest(Uri.parse(widget.url));

    _webViewController = controller;
  }

  NavigationDelegate navigationDelegate() {
    return NavigationDelegate(
      onProgress: (int progress) {
        debugPrint('WebView is loading (progress : $progress%)');
        if (mounted) {
          setState(() => _progress = progress.toDouble());
        }
      },
      onPageStarted: (String url) {
        debugPrint('Page started loading: $url');
        if (mounted) {
          setState(() => _progress = 0);
        }
      },
      onPageFinished: (String url) {
        debugPrint('Page finished loading: $url');
        _webViewController.getTitle().then((value) {
          if (mounted) {
            setState(() => _title = value);
          }
        });
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint('''
Page resource error:
code: ${error.errorCode}
description: ${error.description}
errorType: ${error.errorType}
isForMainFrame: ${error.isForMainFrame}
          ''');
      },
      // onNavigationRequest: (NavigationRequest request) {
      //   if (request.url.startsWith('https://www.youtube.com/')) {
      //     debugPrint('blocking navigation to ${request.url}');
      //     return NavigationDecision.prevent;
      //   }
      //   debugPrint('allowing navigation to ${request.url}');
      //   return NavigationDecision.navigate;
      // },
      onHttpError: (HttpResponseError error) {
        debugPrint('Error occurred on page: ${error.response?.statusCode}');
      },
      onUrlChange: (UrlChange change) {
        debugPrint('url change to ${change.url}');
      },
      // onHttpAuthRequest: (HttpAuthRequest request) {
      //   openDialog(request);
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: _title),
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: _webViewController)),
          if (_progress < 99)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 2,
              child: LinearProgressIndicator(
                minHeight: 2,
                value: _progress / 100,
                backgroundColor: UIColor.transparentPrimary20,
                valueColor: const AlwaysStoppedAnimation<Color>(UIColor.primary),
              ),
            ),
        ],
      ),
    );
  }
}
