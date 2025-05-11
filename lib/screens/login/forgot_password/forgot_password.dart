import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:honorfx/utils/constant/base_url.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/custom_webview.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Forgot Password'),
      body: CustomWebview(
        onWebViewCreated: (InAppWebViewController controller) {
          _controller = controller;
          _controller!.loadUrl(
            urlRequest: URLRequest(
              url: WebUri('${BaseUrl.domain}/forget-password'),
            ),
          );
        },
      ),
    );
  }
}
