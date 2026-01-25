import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/app/routes/app_pages.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/constants/responsive_helper.dart';
import 'package:sakan/widgets/customer_service/customer_service_button.dart';
import 'package:sakan/widgets/responsive_builder.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
      body: SafeArea(
        child: ResponsiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.responsiveHorizontalPadding(context),
          ),
          child: Column(
            children: [
              ResponsiveSpacing(
                  mobileHeight: 40, tabletHeight: 50, desktopHeight: 60),
              _buildHeader(context, isArabic),
              ResponsiveSpacing(
                  mobileHeight: 30, tabletHeight: 40, desktopHeight: 50),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildMenuGrid(context, isArabic),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: ColorsManager.mainColor,
        child: const CustomerServiceButton(),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: SizedBox()),
        Text(
          'home'.tr,
          style: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
          ),
        ),
        Expanded(
          child: Align(
            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Get.toNamed('/notifications'),
              child: SvgPicture.asset(
                ImagesManager.notification,
                height: context.responsive(
                    mobile: 24.0, tablet: 28.0, desktop: 32.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid(BuildContext context, bool isArabic) {
    final menuItems = [
      _MenuItem(
        icon: ImagesManager.building,
        title: 'daklia_management'.tr,
        route: Routes.DAKLIA_PROFILE,
      ),
      _MenuItem(
        icon: ImagesManager.rooms,
        title: 'rooms_management'.tr,
        route: Routes.ROOM_MANAGEMENT,
      ),
      _MenuItem(
        icon: ImagesManager.booking,
        title: 'appointments_management'.tr,
        route: Routes.MY_APPOINTMENTS,
      ),
      _MenuItem(
        icon: ImagesManager.service,
        title: 'services_management'.tr,
        route: Routes.SERVICES_MANAGEMENT,
      ),
      _MenuItem(
        icon: ImagesManager.terms,
        title: 'terms'.tr,
        route: Routes.REGULATIONS_MANAGEMENT,
      ),
      _MenuItem(
        icon: ImagesManager.subscription,
        title: 'subscription_management'.tr,
        route: Routes.SUBSCRIPTION_PLANS,
      ),
      _MenuItem(
        icon: ImagesManager.setting,
        title: 'settings'.tr,
        route: Routes.MORE_SCREEN,
      ),
    ];

    final columns = ResponsiveHelper.responsiveGridColumns(context);
    final spacing =
        context.responsive(mobile: 12.0, tablet: 16.0, desktop: 20.0);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio:
            context.responsive(mobile: 1.0, tablet: 1.0, desktop: 1.0),
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) =>
          _buildMenuCard(context, menuItems[index]),
    );
  }

  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    final cardPadding =
        context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0);
    final iconSize =
        context.responsive(mobile: 50.0, tablet: 60.0, desktop: 60.0);
    final fontSize = ResponsiveHelper.responsiveFontSize(FontSizeManager.s14);

    return GestureDetector(
      onTap: () => Get.toNamed(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.shadowColor,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: item.icon.endsWith('.png')
                    ? Image.asset(
                        item.icon,
                        height: iconSize,
                        width: iconSize,
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.asset(
                        item.icon,
                        height: iconSize,
                        width: iconSize,
                        fit: BoxFit.contain,
                      ),
              ),
              SizedBox(
                  height: context.responsive(
                      mobile: 8.0, tablet: 12.0, desktop: 16.0)),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  color: ColorsManager.fontColor,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String icon;
  final String title;
  final String route;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}
