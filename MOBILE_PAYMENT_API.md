# Sakan Mobile App - Payment & Subscription API Documentation

## Overview

This document provides the complete API reference for integrating subscription payments in the Sakan mobile app (Flutter). The payment system supports **multiple gateways**:

| Gateway   | Code      | Flow                    | Use case                          |
|-----------|-----------|-------------------------|-----------------------------------|
| **YallaPay** | `yallapay` | WebView (hosted checkout) | Open `payment_url` in WebView     |
| **CashiPay** | `cashipay` | Reference / QR (optional OTP) | Show reference/QR; optionally confirm with OTP |

Subscriptions activate only after payment is confirmed (via webhook or provider verification). The app should poll **Verify Payment** or wait for push notification after the user completes payment.

---

## Base URL

```
Production: https://sakan-sd.com
Development: http://localhost:8000
```

---

## Authentication

All endpoints require token authentication:

```
Authorization: Token <user_token>
```

---

## Endpoints

### 1. Get Subscription Plans

Retrieves all active subscription plans with bilingual support (Arabic & English).

**Endpoint:**
```
GET /api/v1/subscription/plans/
```

**Headers:**
```
Authorization: Token <user_token>
```

**Response (200 OK):**
```json
{
    "plans": [
        {
            "plan_id": 1,
            "code": "monthly",
            "name": "Monthly Plan",
            "name_ar": "الباقة الشهرية",
            "duration_days": 30,
            "price": "20000.00",
            "currency": "SDG",
            "description": "30 days subscription",
            "description_ar": "اشتراك لمدة 30 يوم"
        },
        {
            "plan_id": 2,
            "code": "quarterly",
            "name": "Quarterly Plan",
            "name_ar": "الباقة ربع السنوية",
            "duration_days": 90,
            "price": "50000.00",
            "currency": "SDG",
            "description": "3 months subscription",
            "description_ar": "اشتراك لمدة 3 أشهر"
        },
        {
            "plan_id": 3,
            "code": "yearly",
            "name": "Yearly Plan",
            "name_ar": "الباقة السنوية",
            "duration_days": 365,
            "price": "180000.00",
            "currency": "SDG",
            "description": "12 months subscription",
            "description_ar": "اشتراك لمدة 12 شهر"
        }
    ],
    "currency": "SDG"
}
```

**Usage in Flutter:**
```dart
// Display plan name based on locale
String getPlanName(Map plan, String locale) {
  return locale == 'ar' ? plan['name_ar'] : plan['name'];
}
```

---

### 2. Get Current Subscription Status

Check the current subscription status of the authenticated user's Daklia.

**Endpoint:**
```
GET /api/v1/subscription/status/
```

**Headers:**
```
Authorization: Token <user_token>
```

**Response (200 OK):**
```json
{
    "has_active_subscription": true,
    "subscription_type": "PAID",
    "status": "ACTIVE",
    "start_date": "2026-01-24T12:00:00Z",
    "end_date": "2026-02-24T12:00:00Z",
    "days_remaining": 30,
    "is_expiring_soon": false,
    "trial_used": true,
    "can_receive_bookings": true,
    "plan_name": "Monthly Plan",
    "plan_name_ar": "الباقة الشهرية",
    "daklia_id": 1,
    "daklia_name": "داكلية السعادة",
    "daklia_is_active": true
}
```

**Subscription Types:**
| Type | Description |
|------|-------------|
| `TRIAL` | Free trial subscription |
| `PAID` | Paid subscription |

**Subscription Status:**
| Status | Description |
|--------|-------------|
| `ACTIVE` | Subscription is valid |
| `EXPIRED` | Subscription has ended |
| `CANCELLED` | Subscription was cancelled |

---

### 3. Initiate Payment

Start a new subscription payment. Supports **YallaPay** (WebView) and **CashiPay** (reference/QR, optional OTP). Request body can include gateway and CashiPay options.

**Endpoint:**
```
POST /api/v1/subscription/payment/initiate/
```

**Headers:**
```
Authorization: Token <user_token>
Content-Type: application/json
```

**Request Body:**
| Field                  | Type    | Required | Description |
|------------------------|---------|----------|-------------|
| `plan_id`              | integer | Yes      | Subscription plan ID from `/plans/` |
| `payment_gateway`      | string  | No       | `yallapay` (default) or `cashipay` |
| `wallet_account_number`| string  | No       | Required **only** when `payment_gateway` is `cashipay` **and** OTP mode is used |
| `requires_otp`        | boolean | No       | If `true` and gateway is CashiPay, user will confirm payment with OTP; `wallet_account_number` is then required |

**Example – YallaPay (default, backward compatible):**
```json
{
    "plan_id": 1
}
```

**Example – CashiPay (reference flow, no OTP):**
```json
{
    "plan_id": 1,
    "payment_gateway": "cashipay"
}
```

**Example – CashiPay with OTP:**
```json
{
    "plan_id": 1,
    "payment_gateway": "cashipay",
    "requires_otp": true,
    "wallet_account_number": "1234567890"
}
```

**Response (200 OK) – YallaPay:**
```json
{
    "success": true,
    "payment_url": "https://gateway.yallapaysudan.com/checkout/web/...",
    "client_reference_id": "SUB1_P1_3e050b9896f9",
    "amount": 20000.0,
    "currency": "SDG",
    "plan_name": "Monthly Plan",
    "message": "Redirect user to payment_url to complete payment",
    "instructions": "Open payment_url in WebView and listen for success/failure callbacks"
}
```

**Response (200 OK) – CashiPay:**
```json
{
    "success": true,
    "payment_gateway": "cashipay",
    "payment_flow": "reference",
    "client_reference_id": "SUB1_P1_abc123xyz",
    "provider_reference": "2549702362",
    "display_reference": "CASHI-2549702362",
    "amount": 20000.0,
    "currency": "SDG",
    "plan_name": "Monthly Plan",
    "status": "pending",
    "expires_at": "2026-03-14T20:00:00Z",
    "message": "Use display_reference or scan the QR code via MyCashi app or pay at any Cashi merchant location.",
    "qr_code_data_url": "data:image/png;base64,...",
    "qr_code_content": "https://www.getcashi.com/ScanAndPay?ref=cashipay|2549702362"
}
```
Use `display_reference` (or `provider_reference`) and/or `qr_code_data_url` for the user to pay. If you used `requires_otp: true`, after the user pays, call **Confirm Payment** with the OTP, then **Verify Payment**.

**Error Response (400):**
```json
{
    "wallet_account_number": ["Required when payment_gateway is cashipay and OTP mode is used."]
}
```

**Error Response (404):**
```json
{
    "error": "No Daklia account found for this user"
}
```

---

### 4. Confirm Payment (CashiPay OTP only)

After the user enters the OTP received from CashiPay, call this endpoint. It does **not** mark the payment as completed; the backend sets status to `processing`. Subscription is activated only when the provider or webhook confirms (then use **Verify Payment** to get `completed`).

Arabic + English OTP guidance for UI:

- **AR:** ١. قم بإدخال رقم محفظة Cashi الخاصة بك.
- **AR:** ٢. ستستلم رمز تحقق (OTP) عبر رسالة SMS.
- **AR:** ٣. قم بإدخال رمز التحقق (OTP) المكون من 6 أرقام.
- **AR:** ٤. بعد إدخال الرمز بشكل صحيح، سيتم إتمام عملية الدفع بنجاح.
- **EN:** 1) Enter your Cashi wallet number.
- **EN:** 2) You will receive a 6-digit OTP by SMS.
- **EN:** 3) Enter the OTP to confirm payment.
- **EN:** 4) After successful OTP validation, payment moves to processing/completed.

**Endpoint:**
```
POST /api/v1/subscription/payment/confirm/
```

**Headers:**
```
Authorization: Token <user_token>
Content-Type: application/json
```

**Request Body:**
| Field                  | Type   | Required | Description |
|------------------------|--------|----------|-------------|
| `client_reference_id`  | string | Yes      | Value from initiate response |
| `otp`                  | string | Yes      | OTP code from user/CashiPay |

**Example:**
```json
{
    "client_reference_id": "SUB1_P1_abc123xyz",
    "otp": "123456"
}
```

**Response (200 OK):**
```json
{
    "success": true,
    "message": "OTP confirmed. Payment is processing; subscription will activate after provider confirms.",
    "client_reference_id": "SUB1_P1_abc123xyz",
    "cashi_ref": "153106-29850086"
}
```

**Error (400):** Invalid OTP or wrong gateway. **Error (404):** Transaction not found.

---

### 5. Verify Payment Status

Check if a subscription was successfully activated after payment. Logic is **transaction-centric**: this endpoint validates the exact `client_reference_id` transaction; it does not mark payment completed based on unrelated old subscriptions. If the transaction is pending/processing, backend may query provider and return latest status.

**Endpoint:**
```
GET /api/v1/subscription/payment/verify/?client_reference_id=<order_id>
```

**Headers:**
```
Authorization: Token <user_token>
```

**Query Parameters:**
| Parameter             | Required | Description |
|-----------------------|----------|-------------|
| `client_reference_id` | Yes      | Order ID returned from initiate endpoint |

**Response (200 OK) – Payment completed:**
```json
{
    "status": "completed",
    "subscription_active": true,
    "message": "Payment completed and subscription activated",
    "subscription": {
        "subscription_id": 2,
        "subscription_type": "PAID",
        "status": "ACTIVE",
        "start_date": "2026-01-24T12:00:00Z",
        "end_date": "2026-02-24T12:00:00Z",
        "days_remaining": 30,
        "plan_name": "Monthly Plan",
        "plan_name_ar": "الباقة الشهرية"
    },
    "client_reference_id": "SUB1_P1_abc123xyz"
}
```

**Response (200 OK) – Payment pending/processing:**
```json
{
    "status": "pending",
    "subscription_active": false,
    "message": "Payment not yet confirmed. Please wait or try again.",
    "client_reference_id": "SUB1_P1_abc123xyz"
}
```
Poll this endpoint (e.g. every few seconds) until `status` is `completed` or you show a timeout.

**Transaction not found (404):**
```json
{
    "error": "Payment transaction not found",
    "client_reference_id": "SUB1_P1_abc123xyz"
}
```

---

### 5.1 CashiPay Provider APIs (Backend-managed)

These are called by backend integration logic (not by the mobile app directly):

- `GET {CASHIPAY_BASE_URL}/payment-requests/{referenceNumber}` (provider status verification)
- `POST {CASHIPAY_BASE_URL}/payment-requests/{referenceNumber}/cancel` (cancel pending request)
- `POST {CASHIPAY_BASE_URL}/payment-requests/payment-confirm` (OTP confirm with `referenceNumber`, `amount`, `otp`, `walletAccountNumber`)

Mobile app should continue calling:

- `/api/v1/subscription/payment/confirm/`
- `/api/v1/subscription/payment/verify/`

### 6. Get Subscription History

Retrieve all subscription records for the authenticated user's Daklia.

**Endpoint:**
```
GET /api/v1/subscription/history/
```

**Headers:**
```
Authorization: Token <user_token>
```

**Response (200 OK):**
```json
{
    "subscriptions": [
        {
            "subscription_id": 1,
            "subscription_type": "TRIAL",
            "status": "EXPIRED",
            "start_date": "2025-10-01T00:00:00Z",
            "end_date": "2025-12-30T00:00:00Z",
            "plan_name": null,
            "plan_code": null,
            "days_remaining": 0,
            "source": "LEGACY_MIGRATION"
        },
        {
            "subscription_id": 2,
            "subscription_type": "PAID",
            "status": "ACTIVE",
            "start_date": "2026-01-24T12:00:00Z",
            "end_date": "2026-02-24T12:00:00Z",
            "plan_name": "Monthly Plan",
            "plan_code": "monthly",
            "days_remaining": 30,
            "source": "GATEWAY"
        }
    ]
}
```

---

## Flutter Integration

### Complete Payment Flow

```dart
import 'package:webview_flutter/webview_flutter.dart';

class PaymentService {
  final ApiClient api;

  PaymentService(this.api);

  // Step 1: Fetch available plans
  Future<List<SubscriptionPlan>> getPlans() async {
    final response = await api.get('/api/v1/subscription/plans/');
    return (response['plans'] as List)
        .map((p) => SubscriptionPlan.fromJson(p))
        .toList();
  }

  // Step 2: Check current subscription status
  Future<SubscriptionStatus> getStatus() async {
    final response = await api.get('/api/v1/subscription/status/');
    return SubscriptionStatus.fromJson(response);
  }

  // Step 3: Initiate payment (YallaPay default, or CashiPay with optional OTP)
  Future<PaymentInitResult> initiatePayment(
    int planId, {
    String? paymentGateway,
    bool requiresOtp = false,
    String? walletAccountNumber,
  }) async {
    final body = <String, dynamic>{'plan_id': planId};
    if (paymentGateway != null) body['payment_gateway'] = paymentGateway;
    if (requiresOtp) body['requires_otp'] = true;
    if (walletAccountNumber != null) body['wallet_account_number'] = walletAccountNumber;

    final response = await api.post(
      '/api/v1/subscription/payment/initiate/',
      body: body,
    );
    return PaymentInitResult.fromJson(response);
  }

  // Step 4a: Confirm OTP (CashiPay only, when requires_otp was true)
  Future<ConfirmResult> confirmPayment(String clientReferenceId, String otp) async {
    final response = await api.post(
      '/api/v1/subscription/payment/confirm/',
      body: {'client_reference_id': clientReferenceId, 'otp': otp},
    );
    return ConfirmResult.fromJson(response);
  }

  // Step 4b: Verify payment (after WebView close or after OTP confirm / polling)
  Future<PaymentVerifyResult> verifyPayment(String clientReferenceId) async {
    final response = await api.get(
      '/api/v1/subscription/payment/verify/',
      queryParams: {'client_reference_id': clientReferenceId},
    );
    return PaymentVerifyResult.fromJson(response);
  }
}
```

**PaymentInitResult** should handle both gateway responses: `payment_url` for YallaPay; `provider_reference`, `payment_flow`, `qr_code_data_url`, `expires_at` for CashiPay.

### WebView Payment Screen

```dart
class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String clientReferenceId;

  const PaymentWebViewScreen({
    required this.paymentUrl,
    required this.clientReferenceId,
  });

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _checkForRedirect(url);
          },
          onNavigationRequest: (request) {
            // Check if redirected to success/failure URL
            if (request.url.contains('/payment/success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            if (request.url.contains('/payment/failure')) {
              _handlePaymentFailure();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkForRedirect(String url) {
    if (url.contains('/payment/success') || url.contains('status=success')) {
      _handlePaymentSuccess();
    } else if (url.contains('/payment/failure') || url.contains('status=failed')) {
      _handlePaymentFailure();
    }
  }

  void _handlePaymentSuccess() async {
    // Verify payment with backend
    final result = await PaymentService(api).verifyPayment(widget.clientReferenceId);

    if (result.subscriptionActive) {
      Navigator.of(context).pop({'success': true, 'result': result});
    } else {
      // Payment pending - webhook not received yet
      _showPendingDialog();
    }
  }

  void _handlePaymentFailure() {
    Navigator.of(context).pop({'success': false, 'error': 'Payment failed'});
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Processing'),
        content: Text('Your payment is being processed. Please wait a moment.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handlePaymentSuccess(); // Retry verification
            },
            child: Text('Check Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Payment'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop({'success': false, 'cancelled': true}),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
```

### Usage Example – YallaPay (WebView)

```dart
void _subscribeWithYallaPay(SubscriptionPlan plan) async {
  setState(() => _isLoading = true);
  try {
    final initResult = await _paymentService.initiatePayment(plan.planId);
    if (!initResult.success) {
      _showError(initResult.error ?? 'Failed to initiate payment');
      return;
    }
    if (initResult.paymentUrl == null) {
      _showError('No payment URL returned');
      return;
    }

    final paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(
          paymentUrl: initResult.paymentUrl!,
          clientReferenceId: initResult.clientReferenceId!,
        ),
      ),
    );

    if (paymentResult != null && paymentResult['success'] == true) {
      _showSuccess('Subscription activated successfully!');
      _refreshSubscriptionStatus();
    } else if (paymentResult?['cancelled'] == true) {
      _showMessage('Payment cancelled');
    } else {
      _showError('Payment failed. Please try again.');
    }
  } catch (e) {
    _showError('Error: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### Usage Example – CashiPay (reference / QR ± OTP)

```dart
void _subscribeWithCashiPay(SubscriptionPlan plan, {bool useOtp = false, String? walletNumber}) async {
  setState(() => _isLoading = true);
  try {
    final initResult = await _paymentService.initiatePayment(
      plan.planId,
      paymentGateway: 'cashipay',
      requiresOtp: useOtp,
      walletAccountNumber: walletNumber,
    );
    if (!initResult.success) {
      _showError(initResult.error ?? 'Failed to initiate payment');
      return;
    }

    // Show UI: provider_reference, qr_code_data_url (if present), expiry
    // User pays via bank/app using reference or QR.
    if (useOtp) {
      // Show OTP input dialog; then:
      final otp = await _showOtpDialog();
      if (otp == null) return;
      await _paymentService.confirmPayment(initResult.clientReferenceId!, otp);
    }

    // Poll verify until completed or timeout
    final verified = await _pollVerify(initResult.clientReferenceId!);
    if (verified) {
      _showSuccess('Subscription activated successfully!');
      _refreshSubscriptionStatus();
    } else {
      _showMessage('Payment still processing. Check back later.');
    }
  } catch (e) {
    _showError('Error: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

Future<bool> _pollVerify(String clientReferenceId) async {
  for (var i = 0; i < 30; i++) {
    await Future.delayed(Duration(seconds: 2));
    final result = await _paymentService.verifyPayment(clientReferenceId);
    if (result.status == 'completed' && result.subscriptionActive) return true;
  }
  return false;
}
```

---

## Models

### PaymentInitResult (initiate response)

Handle both gateways. Common fields: `success`, `client_reference_id`, `amount`, `currency`, `plan_name`, `message`.  
**YallaPay:** `payment_url`, `instructions`.  
**CashiPay:** `payment_gateway` (`"cashipay"`), `payment_flow` (`"reference"`), `provider_reference`, `display_reference`, `qr_code_data_url`, `qr_code_content`, `expires_at`, `status` (`"pending"`).

### SubscriptionPlan

```dart
class SubscriptionPlan {
  final int planId;
  final String code;
  final String name;
  final String nameAr;
  final int durationDays;
  final double price;
  final String currency;
  final String description;
  final String descriptionAr;

  SubscriptionPlan.fromJson(Map<String, dynamic> json)
      : planId = json['plan_id'],
        code = json['code'],
        name = json['name'],
        nameAr = json['name_ar'] ?? '',
        durationDays = json['duration_days'],
        price = double.parse(json['price'].toString()),
        currency = json['currency'],
        description = json['description'] ?? '',
        descriptionAr = json['description_ar'] ?? '';

  // Get localized name
  String getName(String locale) => locale == 'ar' ? nameAr : name;
  String getDescription(String locale) => locale == 'ar' ? descriptionAr : description;
}
```

### SubscriptionStatus

```dart
class SubscriptionStatus {
  final bool hasActiveSubscription;
  final String? subscriptionType;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? daysRemaining;
  final bool isExpiringSoon;
  final bool trialUsed;
  final bool canReceiveBookings;
  final String? planName;
  final String? planNameAr;

  SubscriptionStatus.fromJson(Map<String, dynamic> json)
      : hasActiveSubscription = json['has_active_subscription'],
        subscriptionType = json['subscription_type'],
        status = json['status'],
        startDate = json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
        endDate = json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
        daysRemaining = json['days_remaining'],
        isExpiringSoon = json['is_expiring_soon'] ?? false,
        trialUsed = json['trial_used'] ?? false,
        canReceiveBookings = json['can_receive_bookings'] ?? false,
        planName = json['plan_name'],
        planNameAr = json['plan_name_ar'];

  String getPlanName(String locale) => locale == 'ar' ? (planNameAr ?? '') : (planName ?? '');
}
```

---

## Error Handling

### Common Error Responses

| Status Code | Error | Description |
|-------------|-------|-------------|
| 401 | `Invalid token` | Authentication token is missing or invalid |
| 404 | `No Daklia account found` | User doesn't have a Daklia account |
| 400 | `Invalid plan_id` / serializer errors | Plan ID invalid or validation failed (e.g. wallet required for CashiPay OTP) |
| 400 | `OTP confirmation failed` | Invalid OTP or confirm only for CashiPay |
| 404 | `Payment transaction not found` | client_reference_id not found on confirm/verify |
| 4xx/5xx | `Failed to create payment` | Gateway validation/upstream errors are returned with provider status when available |

### Error Response Format

Standard errors return:
```json
{
    "error": "Error message here",
    "details": "Additional details if available"
}
```

**CashiPay OTP Confirmation Errors (`/confirm-payment/`)**:
For OTP confirmation failures, the endpoint returns a nested `error` object so clients can distinguish between remaining attempts and lockout states.

```json
{
    "status": "error",
    "error": {
        "code": "otp_confirmation_failed",
        "message": "OTP confirmation failed. 2 attempt(s) remaining."
    }
}
```

Common OTP Error Codes:
- `otp_confirmation_failed`: Invalid OTP. Look at `message` to see if it's the 1st/2nd wrong attempt or if it just reached the 3rd wrong attempt (e.g., `"OTP confirmation failed. Payment request is now locked."`).
- `otp_attempts_exceeded`: Returned from the 4th attempt onward, indicating the transaction is permanently locked.

---

## WebView Payment Detection

### How Payment Status Detection Works

After the user completes (or cancels) payment on YallaPay, they are redirected to our success/failure URLs. The WebView can detect this in several ways:

### Method 1: URL Detection (Recommended)

The WebView should monitor navigation and detect when the URL contains:
- **Success**: `/payment/success`
- **Failure**: `/payment/failure`

```dart
NavigationDelegate(
  onNavigationRequest: (request) {
    if (request.url.contains('/payment/success')) {
      _handlePaymentSuccess();
      return NavigationDecision.prevent;
    }
    if (request.url.contains('/payment/failure')) {
      _handlePaymentFailure();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  },
)
```

### Method 2: JavaScript Channel

The success/failure pages include JavaScript that posts messages to Flutter:

```dart
// Add JavaScript channel to WebViewController
_controller.addJavaScriptChannel(
  'PaymentSuccess',
  onMessageReceived: (message) {
    final data = jsonDecode(message.message);
    if (data['status'] == 'success') {
      _handlePaymentSuccess();
    }
  },
);

_controller.addJavaScriptChannel(
  'PaymentFailure',
  onMessageReceived: (message) {
    final data = jsonDecode(message.message);
    _handlePaymentFailure();
  },
);
```

### Success Page Response

When payment succeeds, user is redirected to:
```
https://sakan-sd.com/api/v1/subscription/payment/success/
```

The page displays:
- Success icon and message
- Arabic translation
- Hidden data element with status

### Failure Page Response

When payment fails, user is redirected to:
```
https://sakan-sd.com/api/v1/subscription/payment/failure/
```

The page displays:
- Failure icon and message
- Error details
- Arabic translation

---

## Testing

### Test Credentials

- **YallaPay:** Use sandbox (e.g. `https://gateway-dev.yallapaysudan.com`) and test cards from YallaPay.
- **CashiPay:** Use test credentials and base URL provided by CashiPay.

### Test Flow – YallaPay

1. `GET /api/v1/subscription/plans/` to get plans.
2. `POST /api/v1/subscription/payment/initiate/` with `{"plan_id": 1}` (defaults to YallaPay).
3. Open returned `payment_url` in a WebView.
4. Complete payment; WebView detects redirect to `/payment/success` or `/payment/failure`.
5. Call `GET /api/v1/subscription/payment/verify/?client_reference_id=...` to confirm subscription activation.

### Test Flow – CashiPay

1. Same plans and initiate with `{"plan_id": 1, "payment_gateway": "cashipay"}`.
2. Show user `provider_reference` and/or `qr_code_data_url`; user pays via bank/app.
3. If OTP was used: collect OTP, call `POST /api/v1/subscription/payment/confirm/` with `client_reference_id` and `otp`.
4. Poll `GET /api/v1/subscription/payment/verify/?client_reference_id=...` until `status` is `completed` or timeout.

---

## Webhooks (Backend Only)

The backend receives payment notifications from each gateway. The mobile app does not call these; they are used to activate subscriptions when the provider confirms payment.

| Gateway   | Webhook URL |
|-----------|-------------|
| YallaPay  | `POST /api/v1/subscription/payment/webhook/` or `POST /api/v1/subscription/payment/webhook/yallapay/` |
| CashiPay  | `POST /api/v1/subscription/payment/webhook/cashipay/` |

---

## Support

For API issues, contact the backend team.  
For gateway-specific issues: YallaPay Sudan support (YallaPay); CashiPay support (CashiPay).
