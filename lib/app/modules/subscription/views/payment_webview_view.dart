import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/constants/responsive_helper.dart';
import '../controllers/subscription_controller.dart';

class PaymentWebViewView extends GetView<SubscriptionController> {
  final String paymentUrl;
  final String clientReferenceId;

  const PaymentWebViewView({
    Key? key,
    required this.paymentUrl,
    required this.clientReferenceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaymentWebViewWidget(
      paymentUrl: paymentUrl,
      clientReferenceId: clientReferenceId,
      controller: controller,
    );
  }
}

class PaymentWebViewWidget extends StatefulWidget {
  final String paymentUrl;
  final String clientReferenceId;
  final SubscriptionController controller;

  const PaymentWebViewWidget({
    Key? key,
    required this.paymentUrl,
    required this.clientReferenceId,
    required this.controller,
  }) : super(key: key);

  @override
  State<PaymentWebViewWidget> createState() => _PaymentWebViewWidgetState();
}

class _PaymentWebViewWidgetState extends State<PaymentWebViewWidget> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _paymentCompleted = false;

  // DISABLED: Polling approach - not needed if relying on URL redirect
  // Timer? _verificationTimer;
  // int _pollCount = 0;
  // static const int _maxPolls = 100;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    // Polling disabled - relying on URL redirect detection
    // _startVerificationPolling();
  }

  @override
  void dispose() {
    // _verificationTimer?.cancel();
    super.dispose();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ColorsManager.whiteColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
            _checkForRedirect(url); // URL redirect detection
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _checkForRedirect(url); // URL redirect detection
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('🔗 Navigation Request: ${request.url}');

            // URL Detection (Fast Path) - If YallaPay redirects properly
            if (request.url.contains('/payment/success') ||
                request.url.contains('status=success') ||
                request.url.contains('status=SUCCESS') ||
                request.url.contains('/success') ||
                request.url.contains('payment_status=success')) {
              debugPrint('✅ Success URL detected via redirect!');
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            if (request.url.contains('/payment/failure') ||
                request.url.contains('status=failed') ||
                request.url.contains('status=FAILED') ||
                request.url.contains('/failure') ||
                request.url.contains('payment_status=failed')) {
              debugPrint('❌ Failure URL detected via redirect!');
              _handlePaymentFailure();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Check URL for success/failure patterns
  void _checkForRedirect(String url) {
    debugPrint('🌐 WebView URL: $url');

    if (url.contains('/payment/success') ||
        url.contains('status=success') ||
        url.contains('status=SUCCESS') ||
        url.contains('/success') ||
        url.contains('payment_status=success')) {
      debugPrint('✅ Success URL detected!');
      _handlePaymentSuccess();
    } else if (url.contains('/payment/failure') ||
        url.contains('status=failed') ||
        url.contains('status=FAILED') ||
        url.contains('/failure') ||
        url.contains('payment_status=failed')) {
      debugPrint('❌ Failure URL detected!');
      _handlePaymentFailure();
    }
  }

  void _handlePaymentSuccess() async {
    if (_paymentCompleted) return; // Prevent duplicate calls
    _paymentCompleted = true;

    debugPrint('🔄 Verifying payment...');

    // Verify payment with backend
    final result = await widget.controller.verifyPayment(
      widget.clientReferenceId,
    );

    debugPrint('📦 Verification result received: ${result != null}');
    if (result != null) {
      debugPrint('📦 subscription_active: ${result.subscriptionActive}');
    }

    if (!mounted) {
      debugPrint('⚠️ Widget not mounted after verification');
      return;
    }

    if (result != null && result.subscriptionActive) {
      debugPrint('✅ Payment verified successfully');

      // Close immediately - snackbar in WebView context causes issues
      // Success message will show on subscription page instead
      debugPrint('🚪 Closing WebView with success result...');
      Get.back(result: {'success': true, 'result': result});
      debugPrint('✅ Get.back() called');
    } else {
      // Payment pending - show dialog
      debugPrint('⏳ Payment pending, showing dialog...');
      _showPendingDialog();
    }
  }

  void _handlePaymentFailure() {
    if (_paymentCompleted) return; // Prevent duplicate calls
    _paymentCompleted = true;

    debugPrint('❌ Payment failed');

    if (mounted) {
      Get.back(result: {'success': false, 'error': 'payment_failed'.tr});
    }
  }

  void _showPendingDialog() {
    _paymentCompleted = false; // Allow retry
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'payment_processing'.tr,
          style: getSemiBoldStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
            color: ColorsManager.blackColor,
          ),
        ),
        content: Text(
          'payment_pending_message'.tr,
          style: getRegularStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s14),
            color: ColorsManager.fontColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back(result: {'success': false, 'cancelled': true});
            },
            child: Text(
              'cancel'.tr,
              style: getMediumStyle(
                fontSize:
                    ResponsiveHelper.responsiveFontSize(FontSizeManager.s14),
                color: ColorsManager.hintStyleColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handlePaymentSuccess(); // Retry verification
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.mainColor,
              foregroundColor: ColorsManager.whiteColor,
            ),
            child: Text(
              'check_again'.tr,
              style: getMediumStyle(
                fontSize:
                    ResponsiveHelper.responsiveFontSize(FontSizeManager.s14),
                color: ColorsManager.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.whiteColor,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'complete_payment'.tr,
          style: getMediumStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
            color: ColorsManager.blackColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: ColorsManager.blackColor),
          onPressed: () => Get.back(result: {
            'success': false,
            'cancelled': true,
          }),
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
