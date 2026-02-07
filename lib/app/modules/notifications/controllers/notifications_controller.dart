import 'package:get/get.dart';
import '../model/notification_model.dart';
import '../provider/notification_provider.dart';

class NotificationsController extends GetxController {
  final NotificationProvider _provider = NotificationProvider.instance;

  // Observables
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Pagination config
  static const int pageSize = 10;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  /// Load initial notifications (page 1)
  Future<void> loadNotifications() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    _currentPage = 1;
    _hasMore = true;

    try {
      final result =
          await _provider.getNotifications(page: 1, pageSize: pageSize);

      if (result['results'] != null) {
        final List<dynamic> results = result['results'];
        notifications.value =
            results.map((json) => NotificationModel.fromJson(json)).toList();
        _hasMore = result['next'] != null;
      } else {
        // Handle empty or error case
        notifications.clear();
        _hasMore = false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next page when user scrolls past current items
  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;

    isLoadingMore.value = true;
    _currentPage += 1;

    try {
      final result = await _provider.getNotifications(
          page: _currentPage, pageSize: pageSize);

      if (result['results'] != null) {
        final List<dynamic> newResults = result['results'];
        final newNotifications =
            newResults.map((json) => NotificationModel.fromJson(json)).toList();
        notifications.addAll(newNotifications);
        _hasMore = result['next'] != null;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      // creating a snackbar to show error
      Get.snackbar('Error', 'Failed to load more notifications');
      _currentPage -= 1; // Revert page increment on failure
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final success = await _provider.markAsRead(notificationId);
    if (success) {
      // Update local state to reflect read status
      final index =
          notifications.indexWhere((n) => n.notificationId == notificationId);
      if (index != -1) {
        // Create a new copy with isRead = true
        final old = notifications[index];
        notifications[index] = NotificationModel(
          notificationId: old.notificationId,
          title: old.title,
          body: old.body,
          data: old.data,
          isRead: true, // Mark as read
          createdAt: old.createdAt,
          readAt: DateTime.now().toIso8601String(),
        );
        notifications.refresh(); // Build clean UI
      }
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  int get unreadCount => notifications.where((n) => n.isRead == false).length;
}
