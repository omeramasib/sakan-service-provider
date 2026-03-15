import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../controllers/notifications_controller.dart';
import '../model/notification_model.dart';

Widget notificationExist(
    BuildContext context, NotificationsController controller) {
  final ScrollController scrollController = ScrollController();

  // Add scroll listener for pagination
  scrollController.addListener(() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      if (!controller.isLoadingMore.value) {
        controller.loadMore();
      }
    }
  });

  return Obx(() => ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 20),
        shrinkWrap: true,
        itemCount: controller.notifications.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (index >= controller.notifications.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final notification = controller.notifications[index];
          return _notificationItem(context, controller, notification);
        },
      ));
}

Widget _notificationItem(BuildContext context,
    NotificationsController controller, NotificationModel notification) {
  // Parsing date
  String timeAgo = '';
  if (notification.createdAt != null) {
    try {
      final date = DateTime.parse(notification.createdAt!);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        timeAgo = '${difference.inDays} ' + 'days_ago'.tr;
      } else if (difference.inHours > 0) {
        timeAgo = '${difference.inHours} ' + 'hours_ago'.tr;
      } else if (difference.inMinutes > 0) {
        timeAgo = '${difference.inMinutes} ' + 'minutes_ago'.tr;
      } else {
        timeAgo = 'just_now'.tr;
      }
    } catch (e) {
      timeAgo = '';
    }
  }

  final bool isRead = notification.isRead ?? false;

  return GestureDetector(
    onTap: () {
      if (!isRead && notification.notificationId != null) {
        controller.markAsRead(notification.notificationId!);
      }
    },
    child: Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
        left: AppPadding.p20,
        right: AppPadding.p20,
      ),
      child: Container(
        width: 315,
        decoration: BoxDecoration(
          color: isRead
              ? ColorsManager.whiteColor
              : ColorsManager
                  .lightGreyColor, // Distinct read/unread (fillColor is usually a light grey)
          borderRadius: BorderRadius.circular(10),
          border: isRead
              ? null
              : Border.all(color: ColorsManager.mainColor.withOpacity(0.3)),
          // boxShadow: isRead ? null : [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 1),
          //   ),
          // ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 5 // Reduced bottom padding for title
                        ),
                    child: Row(
                      children: [
                        // Unread indicator dot
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: ColorsManager.mainColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            notification.title ?? '',
                            style: getMediumStyle(
                              // Using Medium for title
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppPadding.p20,
                    right: AppPadding.p20,
                  ),
                  child: Text(
                    timeAgo,
                    style: getRegularStyle(
                      color: ColorsManager.fontColor,
                      fontSize: FontSizeManager.s10,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p20,
                right: AppPadding.p20,
                bottom: 15, // Padding at bottom
              ),
              child: Align(
                alignment: Alignment.centerRight, // Align body text
                child: Text(
                  notification.body ?? '',
                  style: getRegularStyle(
                    color: ColorsManager.fontColor,
                    fontSize:
                        FontSizeManager.s12, // Slightly larger for readability
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
