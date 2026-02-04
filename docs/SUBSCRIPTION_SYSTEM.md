# Subscription Management System Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [User Flows](#user-flows)
4. [API Integration](#api-integration)
5. [Code Reference](#code-reference)
6. [Backend Requirements](#backend-requirements)
7. [Testing Guide](#testing-guide)
8. [Troubleshooting](#troubleshooting)

---

## Overview

The subscription management system enforces subscription requirements for service providers using the app. It includes:

- **Automatic subscription checks** on app launch
- **Forced subscription screen** for expired users
- **Payment gateway integration** via WebView
- **Real-time UI updates** after payment
- **Free plan support** to exempt certain users

---

## Architecture

### Components

```
┌─────────────────────────────────────────────────────────────┐
│                         User Login                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    SplashController                          │
│              Navigate to Home if logged in                   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     HomeController                           │
│           Check Subscription Status (onReady)                │
│     If expired & not free → Force to Subscription Page      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 SubscriptionPlansView                        │
│          Display plans, current status, subscribe            │
│              Back/Skip disabled if forced                    │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 PaymentWebViewView                           │
│        Opens YallaPay, monitors URL, verifies payment        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Subscription Page (Refreshed)                   │
│       Shows active status, success message, updated UI       │
└─────────────────────────────────────────────────────────────┘
```

### Key Files

| File | Purpose |
|------|---------|
| `lib/app/modules/home/controllers/home_controller.dart` | Post-login subscription check |
| `lib/app/modules/home/bindings/home_binding.dart` | Forces controller initialization |
| `lib/app/modules/subscription/controllers/subscription_controller.dart` | Subscription business logic |
| `lib/app/modules/subscription/views/subscription_plans_view.dart` | Displays plans and handles payment flow |
| `lib/app/modules/subscription/views/payment_webview_view.dart` | Payment WebView with success detection |
| `lib/app/data/providers/subscription_provider.dart` | API calls for subscription |
| `lib/app/data/models/subscription_status_model.dart` | Subscription status data model |

---

## User Flows

### Flow 1: User with Active Subscription

```
1. User logs in
2. SplashController → HomeController
3. HomeController checks subscription
4. Status: Active → User accesses app normally
```

### Flow 2: User with Expired Subscription

```
1. User logs in
2. SplashController → HomeController
3. HomeController checks subscription
4. Status: Expired, Not Free Plan
5. FORCED redirect to SubscriptionPlansView (canSkip: false)
6. User cannot go back, must subscribe or close app
7. User selects plan → PaymentWebViewView opens
8. User completes payment
9. WebView detects success URL → verifies → closes
10. SubscriptionPlansView refreshes status
11. Success message shown, UI updates
12. User can now access app
```

### Flow 3: Free Plan User

```
1. User logs in
2. HomeController checks subscription
3. Status: subscription_type = null (Free Plan)
4. User accesses app normally (no redirect)
```

---

## API Integration

### Endpoints Used

#### 1. Get Subscription Status
```
GET /api/v1/subscription/status/

Response:
{
  "has_active_subscription": true,
  "subscription_type": "PAID" | null,
  "status": "ACTIVE" | "EXPIRED",
  "start_date": "2026-01-26T...",
  "end_date": "2026-02-25T...",
  "days_remaining": 29,
  "plan_name": "Monthly Plan",
  "plan_name_ar": "الباقة الشهرية"
}
```

**Free Plan Detection:** `subscription_type: null`

#### 2. Initiate Payment
```
POST /api/v1/subscription/payment/initiate/

Body:
{
  "plan_id": 1
}

Response:
{
  "success": true,
  "payment_url": "https://yallapay.com/pay/...",
  "client_reference_id": "SUB24_P1_xxx",
  "message": "Payment session created"
}
```

#### 3. Verify Payment
```
POST /api/v1/subscription/payment/verify/

Body:
{
  "client_reference_id": "SUB24_P1_xxx"
}

Response:
{
  "status": "completed",
  "subscription_active": true,
  "subscription": {
    "subscription_type": "PAID",
    "status": "ACTIVE",
    "end_date": "2026-02-25T..."
  }
}
```

#### 4. Webhook (Backend Only)
```
POST /api/v1/subscription/payment/webhook/

Body (from YallaPay):
{
  "paymentStatus": "SUCCESSFUL",
  "clientReferenceId": "SUB24_P1_xxx",
  "paymentReferenceId": "01KFXKN5...",
  "timestamp": 1769446494613,
  "secretHash": "8d56d84b..."
}

Backend Action: Activate subscription in database
```

---

## Code Reference

### Free Plan Detection

```dart
// subscription_status_model.dart
bool get isFreePlan => subscriptionType == null;
```

### Forced Subscription Check

```dart
// home_controller.dart
if (!status.hasActiveSubscription && !status.isFreePlan) {
  await Get.toNamed(
    Routes.SUBSCRIPTION_PLANS,
    arguments: {'canSkip': false},
  );
}
```

### Preventing Back Navigation

```dart
// subscription_plans_view.dart
return WillPopScope(
  onWillPop: () async => canSkip, // false = cannot go back
  child: Scaffold(
    appBar: AppBar(
      leading: canSkip ? IconButton(...) : SizedBox.shrink(),
      actions: [
        if (canSkip) TextButton(child: Text('skip'))
      ],
    ),
  ),
);
```

### WebView Success Detection

```dart
// payment_webview_view.dart
NavigationDelegate(
  onNavigationRequest: (NavigationRequest request) {
    if (request.url.contains('/payment/success')) {
      _handlePaymentSuccess();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  },
)
```

### Auto-Refresh After Payment

```dart
// subscription_plans_view.dart
if (paymentResult != null && paymentResult['success'] == true) {
  // Refresh both in parallel
  await Future.wait([
    controller.loadStatus(),
    controller.loadPlans(),
  ]);

  Get.snackbar('success', 'subscription_activated');
}
```

---

## Backend Requirements

### 1. YallaPay Configuration

When creating a payment session, configure these URLs:

```python
yallapay_payment = {
    "success_url": f"{FRONTEND_URL}/payment/success?client_reference_id={ref_id}",
    "failure_url": f"{FRONTEND_URL}/payment/failure",
    "webhook_url": f"{BACKEND_URL}/api/v1/subscription/payment/webhook/"
}
```

### 2. Create Redirect Endpoints

```python
# views.py
def payment_success(request):
    client_ref = request.GET.get('client_reference_id')
    return render(request, 'payment_success.html', {'ref': client_ref})

def payment_failure(request):
    return render(request, 'payment_failure.html')
```

```html
<!-- payment_success.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>
</head>
<body>
    <h1>✅ Payment Successful!</h1>
    <p>Your subscription has been activated.</p>
    <p>Redirecting back to app...</p>
</body>
</html>
```

### 3. Webhook Handler

```python
@api_view(['POST'])
def payment_webhook(request):
    """Handle YallaPay webhook"""

    # 1. Verify signature
    verify_webhook_signature(request.data)

    # 2. Extract data
    payment_status = request.data.get('paymentStatus')
    client_ref_id = request.data.get('clientReferenceId')

    # 3. Update subscription
    if payment_status == 'SUCCESSFUL':
        subscription = Subscription.objects.get(
            client_reference_id=client_ref_id
        )
        subscription.status = 'ACTIVE'
        subscription.payment_status = 'completed'
        subscription.save()

    return Response({'status': 'ok'}, status=200)
```

---

## Testing Guide

### Test Case 1: Expired Subscription Flow

**Setup:**
- User with expired subscription in database

**Steps:**
1. Login with expired user
2. Should redirect to subscription page immediately
3. Verify back button is hidden
4. Verify skip button is hidden
5. Try device back button → should not work

**Expected:** User locked on subscription page

### Test Case 2: Successful Payment

**Steps:**
1. On subscription page, select a plan
2. Click "Subscribe"
3. WebView opens with payment URL
4. Complete payment on YallaPay
5. Wait for redirect

**Expected:**
- Logs show: `✅ Payment verified successfully`
- Logs show: `🚪 Closing WebView...`
- WebView closes
- Subscription page refreshes
- Green success message appears
- Active subscription badge shown

### Test Case 3: Free Plan User

**Setup:**
- User with `subscription_type: null` in database

**Steps:**
1. Login with free plan user
2. Navigate to home

**Expected:**
- No redirect to subscription page
- User accesses app normally

### Test Case 4: Payment Failure

**Steps:**
1. Start payment flow
2. Cancel or fail payment
3. YallaPay redirects to failure URL

**Expected:**
- WebView detects failure URL
- WebView closes
- No success message
- Status unchanged

---

## Troubleshooting

### Issue: WebView Doesn't Close After Payment

**Symptoms:**
- Logs show "Payment verified" but no "Closing WebView"
- WebView remains open

**Solution:**
- Check if snackbar is being called in WebView (causes blocking)
- Ensure `Get.back()` is called without await
- Verify `mounted` check isn't preventing closure

**Fixed in:** Removed snackbar from WebView context

### Issue: Subscription Check Not Running

**Symptoms:**
- User with expired subscription not redirected
- No logs from `HomeController`

**Solution:**
- Ensure `HomeBinding` uses `Get.put()` not `Get.lazyPut()`
- Controller must initialize even if view doesn't use it

**Fixed in:** Changed to `Get.put<HomeController>()`

### Issue: User Can Skip Subscription

**Symptoms:**
- Back button visible when shouldn't be
- Skip button appears for forced users

**Solution:**
- Check `arguments: {'canSkip': false}` is passed
- Verify `WillPopScope` implementation
- Test `canSkip` getter logic

### Issue: Status Doesn't Update After Payment

**Symptoms:**
- Payment succeeds but UI still shows "No Active Subscription"

**Solution:**
- Ensure `controller.loadStatus()` is called after payment
- Check API is returning updated status
- Verify `Obx()` widgets are wrapping reactive data

---

## Configuration

### Enable Polling (Alternative Detection)

If YallaPay doesn't support redirect URLs, enable polling:

```dart
// payment_webview_view.dart line 61

@override
void initState() {
  super.initState();
  _initializeWebView();
  _startVerificationPolling(); // Uncomment this line
}
```

Also uncomment:
- Timer declaration (line 53-55)
- Timer disposal (line 67)
- Polling function (line 238-284)

Polling will check backend every 3 seconds for webhook-processed payments.

---

## Security Considerations

1. **Webhook Verification:** Backend must verify `secretHash` from YallaPay
2. **HTTPS Only:** All URLs must use HTTPS in production
3. **Client Reference ID:** Use secure random generation
4. **Idempotency:** Handle duplicate webhooks gracefully
5. **Authorization:** Verify user owns the subscription being modified

---

## Future Improvements

- [ ] Add retry mechanism for failed API calls
- [ ] Implement subscription renewal reminders
- [ ] Add analytics for conversion tracking
- [ ] Support multiple payment gateways
- [ ] Add promotional codes/discounts
- [ ] Implement subscription pause/resume
- [ ] Add subscription upgrade/downgrade flows

---

## Support

For issues or questions:
1. Check logs for debug output (all operations log with emojis)
2. Verify backend endpoints are working
3. Test with YallaPay sandbox environment first
4. Review this documentation's troubleshooting section

## Change Log

- **2026-01-26:** Initial implementation
  - Post-login subscription check
  - Forced subscription for expired users
  - Payment WebView integration
  - Auto-refresh after payment
