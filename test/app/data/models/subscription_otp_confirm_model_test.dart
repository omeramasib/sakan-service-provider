import 'package:flutter_test/flutter_test.dart';
import 'package:sakan/app/data/models/subscription_otp_confirm_model.dart';

void main() {
  group('SubscriptionOtpConfirmModel', () {
    test('parses successful confirm response correctly', () {
      final json = {
        'success': true,
      };

      final model = SubscriptionOtpConfirmModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.errorCode, isNull);
      expect(model.errorMessage, isNull);
    });

    test('parses nested error for remaining attempts correctly', () {
      final json = {
        'status': 'error',
        'error': {
          'code': 'otp_confirmation_failed',
          'message': 'OTP confirmation failed. 2 attempt(s) remaining.',
        }
      };

      final model = SubscriptionOtpConfirmModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.errorCode, 'otp_confirmation_failed');
      expect(model.errorMessage, 'OTP confirmation failed. 2 attempt(s) remaining.');
    });

    test('parses nested error for locked attempts correctly', () {
      final json = {
        'status': 'error',
        'error': {
          'code': 'otp_attempts_exceeded',
          'message': 'OTP confirmation failed. Payment request is now locked.',
        }
      };

      final model = SubscriptionOtpConfirmModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.errorCode, 'otp_attempts_exceeded');
      expect(model.errorMessage, 'OTP confirmation failed. Payment request is now locked.');
    });

    test('parses top-level error message correctly', () {
      final json = {
        'success': false,
        'message': 'Something went wrong',
      };

      final model = SubscriptionOtpConfirmModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.errorCode, isNull);
      expect(model.errorMessage, 'Something went wrong');
    });
  });
}
