# Sakan Mobile App - Payment & Subscription API Documentation

## Overview

This document provides the complete API reference for integrating subscription payments in the Sakan mobile app (Flutter). The payment system uses YallaPay Sudan as the payment gateway.

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

Start a new subscription payment. Returns a payment URL to open in WebView.

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
```json
{
    "plan_id": 1
}
```

**Response (200 OK):**
```json
{
    "success": true,
    "payment_url": "https://gateway-dev.yallapaysudan.com/checkout/web/01KFRK2JHB239X9WXK50AKVH37",
    "client_reference_id": "SUB1P13e050b9896f9",
    "amount": 20000.0,
    "currency": "SDG",
    "plan_name": "Monthly Plan",
    "message": "Redirect user to payment_url to complete payment",
    "instructions": "Open payment_url in WebView and listen for success/failure callbacks"
}
```

**Error Response (400):**
```json
{
    "error": "Invalid plan_id"
}
```

**Error Response (404):**
```json
{
    "error": "No Daklia found for this user"
}
```

---

### 4. Verify Payment Status

Check if a subscription was successfully activated after payment.

**Endpoint:**
```
GET /api/v1/subscription/payment/verify/?client_reference_id=<order_id>
```

**Headers:**
```
Authorization: Token <user_token>
```

**Query Parameters:**
| Parameter | Required | Description |
|-----------|----------|-------------|
| `client_reference_id` | Yes | The order ID returned from initiate endpoint |

**Response (200 OK) - Payment Successful:**
```json
{
    "status": "completed",
    "subscription_active": true,
    "message": "Payment completed and subscription activated",
    "subscription": {
        "subscription_type": "PAID",
        "status": "ACTIVE",
        "start_date": "2026-01-24T12:00:00Z",
        "end_date": "2026-02-24T12:00:00Z",
        "days_remaining": 30,
        "plan_name": "Monthly Plan"
    }
}
```

**Response (200 OK) - Payment Pending:**
```json
{
    "status": "pending",
    "subscription_active": false,
    "message": "Payment not yet confirmed. Please wait or try again."
}
```

---

### 5. Get Subscription History

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

  // Step 3: Initiate payment
  Future<PaymentInitResult> initiatePayment(int planId) async {
    final response = await api.post(
      '/api/v1/subscription/payment/initiate/',
      body: {'plan_id': planId},
    );
    return PaymentInitResult.fromJson(response);
  }

  // Step 4: Verify payment after WebView closes
  Future<PaymentVerifyResult> verifyPayment(String clientReferenceId) async {
    final response = await api.get(
      '/api/v1/subscription/payment/verify/',
      queryParams: {'client_reference_id': clientReferenceId},
    );
    return PaymentVerifyResult.fromJson(response);
  }
}
```

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

### Usage Example

```dart
// In your subscription screen
void _subscribeToPlan(SubscriptionPlan plan) async {
  try {
    // Show loading
    setState(() => _isLoading = true);

    // Initiate payment
    final initResult = await _paymentService.initiatePayment(plan.planId);

    if (!initResult.success) {
      _showError('Failed to initiate payment');
      return;
    }

    // Open WebView
    final paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(
          paymentUrl: initResult.paymentUrl,
          clientReferenceId: initResult.clientReferenceId,
        ),
      ),
    );

    // Handle result
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

---

## Models

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
| 404 | `No Daklia found` | User doesn't have a Daklia account |
| 400 | `Invalid plan_id` | Plan ID doesn't exist or is inactive |
| 400 | `Active subscription exists` | User already has an active subscription |
| 500 | `Failed to create payment` | YallaPay gateway error |

### Error Response Format

```json
{
    "error": "Error message here",
    "details": "Additional details if available"
}
```

---

## Testing

### Test Credentials

For development/testing, use the YallaPay sandbox:
- Gateway URL: `https://gateway-dev.yallapaysudan.com`
- Use test card numbers provided by YallaPay

### Test Flow

1. Call `/api/v1/subscription/plans/` to get available plans
2. Call `/api/v1/subscription/payment/initiate/` with a plan_id
3. Open the returned `payment_url` in a WebView
4. Complete payment using test credentials
5. After redirect, call `/api/v1/subscription/payment/verify/` to confirm

---

## Webhook (Backend Only)

The backend automatically receives payment notifications via webhook:

```
POST /api/v1/subscription/payment/webhook/
```

This is handled server-to-server by YallaPay. The mobile app doesn't need to interact with this endpoint.

---

## Support

For API issues, contact the backend team.
For payment gateway issues, contact YallaPay Sudan support.
