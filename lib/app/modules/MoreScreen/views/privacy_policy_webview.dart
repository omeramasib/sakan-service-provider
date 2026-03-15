import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/constants/responsive_helper.dart';

/// A WebView page that displays the privacy policy.
class PrivacyPolicyWebView extends StatefulWidget {
  const PrivacyPolicyWebView({Key? key}) : super(key: key);

  /// The privacy policy URL
  static const String privacyPolicyUrl =
      'https://sakan-sd.com/privacy-policy/ar/';

  @override
  State<PrivacyPolicyWebView> createState() => _PrivacyPolicyWebViewState();
}

class _PrivacyPolicyWebViewState extends State<PrivacyPolicyWebView> {
  late WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ColorsManager.whiteColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(PrivacyPolicyWebView.privacyPolicyUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.whiteColor,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'privacy_policy'.tr,
          style: getMediumStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
            color: ColorsManager.blackColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsManager.blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            Container(
              color: ColorsManager.whiteColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.mainColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
