import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sakan/app/data/models/subscription_otp_confirm_model.dart';
import 'package:sakan/app/data/providers/subscription_provider.dart';
import 'package:sakan/app/modules/subscription/controllers/subscription_controller.dart';

class FakeSubscriptionProvider extends SubscriptionProvider {
  SubscriptionOtpConfirmModel? confirmOtpResult;

  @override
  Future<SubscriptionOtpConfirmModel?> confirmOtp(String clientReferenceId, String otp) async {
    return confirmOtpResult;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('SubscriptionController OTP Confirm', () {
    late SubscriptionController controller;
    late FakeSubscriptionProvider fakeProvider;

    setUp(() {
      Get.testMode = true; // To prevent snackbars from throwing errors in tests
      fakeProvider = FakeSubscriptionProvider();
      controller = SubscriptionController(provider: fakeProvider);
    });

    tearDown(() {
      controller.onClose();
    });

    test('successful confirmOtp sets isConfirmingOtp to false and returns true', () async {
      fakeProvider.confirmOtpResult = SubscriptionOtpConfirmModel(success: true);

      final result = await controller.confirmOtp('ref123', '123456');

      expect(result, isTrue);
      expect(controller.isOtpLocked.value, isFalse);
    });

    test('failed confirmOtp with otp_confirmation_failed without lock message does not lock', () async {
      fakeProvider.confirmOtpResult = SubscriptionOtpConfirmModel(
        success: false,
        errorCode: 'otp_confirmation_failed',
        errorMessage: 'OTP confirmation failed. 2 attempt(s) remaining.',
      );

      final result = await controller.confirmOtp('ref123', '123456');

      expect(result, isFalse);
      expect(controller.isOtpLocked.value, isFalse);
    });

    test('failed confirmOtp with lock message sets isOtpLocked to true', () async {
      fakeProvider.confirmOtpResult = SubscriptionOtpConfirmModel(
        success: false,
        errorCode: 'otp_confirmation_failed',
        errorMessage: 'OTP confirmation failed. Payment request is now locked.',
      );

      final result = await controller.confirmOtp('ref123', '123456');

      expect(result, isFalse);
      expect(controller.isOtpLocked.value, isTrue);
    });

    test('failed confirmOtp with otp_attempts_exceeded sets isOtpLocked to true', () async {
      fakeProvider.confirmOtpResult = SubscriptionOtpConfirmModel(
        success: false,
        errorCode: 'otp_attempts_exceeded',
        errorMessage: 'Maximum attempts exceeded.',
      );

      final result = await controller.confirmOtp('ref123', '123456');

      expect(result, isFalse);
      expect(controller.isOtpLocked.value, isTrue);
    });

    test('confirmOtp returns false immediately if already locked', () async {
      controller.isOtpLocked.value = true;
      fakeProvider.confirmOtpResult = SubscriptionOtpConfirmModel(success: true);

      final result = await controller.confirmOtp('ref123', '123456');

      expect(result, isFalse);
      // It shouldn't have changed back to false
      expect(controller.isOtpLocked.value, isTrue);
    });
  });
}
