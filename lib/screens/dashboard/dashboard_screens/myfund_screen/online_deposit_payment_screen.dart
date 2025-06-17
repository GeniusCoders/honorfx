import 'package:honorfx/utils/constant/strings.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/linear_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class OnlineDepositPayementScreen extends StatefulWidget {
  final String data;
  final String title;
  const OnlineDepositPayementScreen({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  State<OnlineDepositPayementScreen> createState() =>
      _OnlineDepositPayementScreenState();
}

class _OnlineDepositPayementScreenState
    extends State<OnlineDepositPayementScreen> {
  int _page = 1;
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('about:blank')),
              onWebViewCreated: (InAppWebViewController controller) {
                _controller = controller;
                var htmlRegex = RegExp(Constant.htmlRegex);
                if (htmlRegex.hasMatch(widget.data)) {
                  _controller.loadData(data: widget.data);
                } else {
                  _controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri(widget.data)),
                  );
                }
              },
              initialSettings: InAppWebViewSettings(useHybridComposition: true),
              onLoadStart: (controller, url) {
                setState(() {
                  _page = 1;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _page = 0;
                });
              },
            ),
            if (_page == 1) const LinearLoading(),
          ],
        ),
      ),
    );
  }
}
