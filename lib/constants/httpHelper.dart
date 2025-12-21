class HttpHelper {
  // Production URLs
  static const baseUrl = 'https://sakan-sd.com/api/v1/user';
  static const baseUrlPerson = 'https://sakan-sd.com/api/v1/person';
  static const baseUrl2 = 'https://sakan-sd.com/api/v1/daklia';

  // Local development URLs
  //static const baseUrl = 'http://localhost:8000/api/v1/user';
  //static const baseUrlPerson = 'http://localhost:8000/api/v1/person';
  //static const baseUrl2 = 'http://localhost:8000/api/v1/daklia';
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
}
