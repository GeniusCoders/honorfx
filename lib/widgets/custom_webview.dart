import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:honorfx/widgets/loading/linear_loading.dart';

class CustomWebview extends StatefulWidget {
  final Function(InAppWebViewController)? onWebViewCreated;
  final Function(InAppWebViewController, Uri?)? onLoadStart;
  final Function(InAppWebViewController, Uri?)? onLoadStop;
  final Widget? loadingWidget;
  final Future<NavigationActionPolicy?> Function(
    InAppWebViewController,
    NavigationAction,
  )?
  shouldOverrideUrlLoading;
  const CustomWebview({
    Key? key,
    required this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.loadingWidget,
    this.shouldOverrideUrlLoading,
  }) : super(key: key);
  @override
  State<CustomWebview> createState() => _CustomWebviewState();
}

class _CustomWebviewState extends State<CustomWebview> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          onWebViewCreated: widget.onWebViewCreated,
          initialSettings: InAppWebViewSettings(
            useHybridComposition: true,
            javaScriptEnabled: true,
            useOnLoadResource: true,
            transparentBackground: true,
            userAgent:
                "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
          ),
          shouldOverrideUrlLoading: widget.shouldOverrideUrlLoading,
          onLoadStart:
              widget.onLoadStart ??
              (controller, url) {
                setState(() {
                  _page = 1;
                });
              },
          onLoadStop:
              widget.onLoadStop ??
              (controller, url) async {
                setState(() {
                  _page = 0;
                });
              },
        ),
        if (_page == 1) widget.loadingWidget ?? const LinearLoading(),
      ],
    );
  }
}
