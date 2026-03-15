import 'dart:developer';

import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../providers/booking_provider.dart';

class MyAppointmentsController extends GetxController {
  final bookingProvider = BookingProvider.instance;

  // Tab indices
  RxInt tabIndex = 0.obs; // 0 = New, 1 = Previous
  RxInt tabIndex2 = 0.obs; // 0 = Awaiting Daklia, 1 = Awaiting User

  // Loading state
  RxBool isLoading = false.obs;

  // All bookings
  RxList<BookingModel> allBookings = <BookingModel>[].obs;

  // Selected booking for details
  Rx<BookingModel?> selectedBooking = Rx<BookingModel?>(null);

  // Computed lists
  List<BookingModel> get pendingBookings =>
      allBookings.where((b) => b.isPending).toList();

  List<BookingModel> get approvedBookings =>
      allBookings.where((b) => b.isApproved).toList();

  List<BookingModel> get rejectedBookings =>
      allBookings.where((b) => b.isRejected).toList();

  List<BookingModel> get previousBookings => allBookings
      .where((b) => b.isApproved || b.isRejected || b.isCancelled)
      .toList();

  // Stats
  int get totalBookings => allBookings.length;
  int get pendingCount => pendingBookings.length;
  int get approvedCount => approvedBookings.length;
  int get rejectedCount => rejectedBookings.length;

  @override
  void onInit() {
    super.onInit();
    log('>>> MyAppointmentsController.onInit() called - fetching bookings...');
    fetchBookings();
  }

  /// Change the main tab (New / Previous)
  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }

  /// Change the secondary tab (Awaiting Daklia / Awaiting User)
  void changeTabIndex2(int index) {
    tabIndex2.value = index;
    update();
  }

  /// Fetch all bookings from API
  Future<void> fetchBookings() async {
    log('>>> fetchBookings() called');
    isLoading.value = true;
    try {
      log('>>> Calling bookingProvider.getOwnerBookings()...');
      final bookings = await bookingProvider.getOwnerBookings();
      allBookings.assignAll(bookings);
      log('>>> Fetched ${bookings.length} bookings');
    } catch (e) {
      log('>>> Error fetching bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get booking details
  Future<void> getBookingDetails(int bookingId) async {
    isLoading.value = true;
    try {
      final booking = await bookingProvider.getBookingDetails(bookingId);
      if (booking != null) {
        selectedBooking.value = booking;
      }
    } catch (e) {
      log('Error getting booking details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Approve a booking
  Future<bool> approveBooking(int bookingId) async {
    final success = await bookingProvider.approveBooking(bookingId);
    if (success) {
      // Update local state
      final index = allBookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        // Refresh bookings to get updated status
        await fetchBookings();
      }
    }
    return success;
  }

  /// Reject a booking with reason
  Future<bool> rejectBooking(int bookingId, String reason) async {
    final success = await bookingProvider.rejectBooking(bookingId, reason);
    if (success) {
      // Update local state
      final index = allBookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        // Refresh bookings to get updated status
        await fetchBookings();
      }
    }
    return success;
  }

  /// Cancel a booking (pending or approved)
  Future<bool> cancelBooking(int bookingId, {String? reason}) async {
    final success = await bookingProvider.cancelBooking(bookingId, reason: reason);
    if (success) {
      await fetchBookings();
    }
    return success;
  }

  /// Set selected booking
  void setSelectedBooking(BookingModel booking) {
    selectedBooking.value = booking;
  }

  /// Clear selected booking
  void clearSelectedBooking() {
    selectedBooking.value = null;
  }

  /// Refresh bookings
  Future<void> refreshBookings() async {
    await fetchBookings();
  }
}
