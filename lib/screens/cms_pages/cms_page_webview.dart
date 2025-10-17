import 'dart:io';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/screens/cms_pages/cms_page_webview_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CmsView extends StatefulWidget {
  String page;
  CmsView({required this.page});
  @override
  State<CmsView> createState() => _CmsViewState();
}

class _CmsViewState extends State<CmsView> {
  final CmsPageWebViewCtrl controller = Get.put(CmsPageWebViewCtrl());
  late final WebViewController _webViewController;

  final String privacyUrl = ApiUrls.privacyUrl;
  final String termsUrl = ApiUrls.termsUrl;

  @override
  void initState() {
    super.initState();
    // Android initialization
    // if (Platform.isAndroid) {
    //   WebView.platform = AndroidWebView();
    // }

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => controller.setLoading(true),
          onPageFinished: (_) => controller.setLoading(false),
          onNavigationRequest: (request) {
            return NavigationDecision.navigate; // allow all links
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.page=='terms'?termsUrl:privacyUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Obx(() => Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (controller.isLoading.value)
            Center(child: CircularProgressIndicator()),
        ],
      )),
    );
  }
}
