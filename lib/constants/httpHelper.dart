import 'flavor_config.dart';

class HttpHelper {
  // Dynamic URLs based on current flavor
  static String get baseUrl => '${FlavorConfig.instance.baseUrl}/api/v1/user';
  static String get baseUrlPerson =>
      '${FlavorConfig.instance.baseUrl}/api/v1/person';
  static String get baseUrl2 =>
      '${FlavorConfig.instance.baseUrl}/api/v1/daklia';
  static const register = '/create';
  static const login = '/login';
  static const verifyOtp = '/verify-code';
  static const sendOtp = '/send-otp';
  static const changePassword = '/change-password';
  static const resetPassword = '/reset-password';
  static const logout = '/logout';
  static const dakliaInfo = '/daklia-info/';
  static const dakliaLocation = '/daklia-location/';
  static const verifyAccount = '/verify-account/';
  static const dakliaProfile = '/daklia-profile/';
  static const updateProfile = '/update-profile/';
  static const rooms = '/rooms/';
  static const addRoom = '/rooms/add/';
  static const deleteRoom = 'delete/';
  static const addFeatures = 'features/add/';
  static const servicesAdd = '/services/add/';
  static const updateFcmToken = '/profile/update-fcm-token/';

  // Booking endpoints
  static const ownerBookings = '/owner/bookings/';
  static const bookingDetails = '/bookings/';
  static const bookingAction = '/action/';
  static const bookingCancel = '/cancel/';

  // Notification endpoints
  static const notifications = '/notifications/';

  // App configuration endpoint (uses FlavorConfig.baseUrl directly)
  static const appConfiguration = '/api/app-configuration/';

  // Subscription endpoints
  static String get subscriptionBaseUrl =>
      '${FlavorConfig.instance.baseUrl}/api/v1/subscription';
  static const subscriptionPlans = '/plans/';
  static const subscriptionStatus = '/status/';
  static const subscriptionPaymentInitiate = '/payment/initiate/';
  static const subscriptionPaymentVerify = '/payment/verify/';
  static const subscriptionHistory = '/history/';
}
