import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/constants/responsive_helper.dart';
import 'package:sakan/constants/values_manager.dart';
import 'package:sakan/widgets/responsive_builder.dart';
import 'package:sakan/constants/dialogs.dart';
import '../controllers/subscription_controller.dart';
import '../../../data/models/subscription_payment_init_model.dart';

class CashiPayPaymentView extends GetView<SubscriptionController> {
  const CashiPayPaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
      appBar: AppBar(
        backgroundColor: ColorsManager.whiteColor,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'complete_payment'.tr,
          style: getMediumStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
            color: ColorsManager.blackColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsManager.blackColor),
          onPressed: () {
            controller.cancelPolling();
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        final payment = controller.currentPayment.value;
        if (payment == null) {
          return const Center(child: Text("No payment data"));
        }

        return Stack(
          children: [
            ResponsiveContainer(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveHorizontalPadding(context),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildToggleSection(context),
                    const SizedBox(height: 20),
                    if (controller.cashiPaymentMethod.value == 'reference') ...[
                      _buildPaymentDetailsCard(context, payment),
                      const SizedBox(height: 20),
                      _buildHowToPaySection(context),
                      const SizedBox(height: 30),
                      _buildReferenceActionSection(context, payment),
                    ] else ...[
                      _buildOtpPaymentSection(context, payment),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            if (controller.isPolling.value)
              Container(
                color: ColorsManager.blackColor.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorsManager.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: ColorsManager.mainColor),
                        const SizedBox(height: 20),
                        Text(
                          'waiting_for_confirmation'.tr,
                          style: getMediumStyle(
                            fontSize: FontSizeManager.s14,
                            color: ColorsManager.fontColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildToggleSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsManager.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!controller.isOtpInitiated.value) {
                  controller.cashiPaymentMethod.value = 'reference';
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: controller.cashiPaymentMethod.value == 'reference'
                      ? ColorsManager.mainColor
                      : ColorsManager.whiteColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(9), right: Radius.circular(9)),
                ),
                child: Center(
                  child: Text(
                    'reference_and_qr'.tr,
                    style: getMediumStyle(
                      fontSize: FontSizeManager.s14,
                      color: controller.cashiPaymentMethod.value == 'reference'
                          ? ColorsManager.whiteColor
                          : ColorsManager.fontColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.cashiPaymentMethod.value = 'otp';
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: controller.cashiPaymentMethod.value == 'otp'
                      ? ColorsManager.mainColor
                      : ColorsManager.whiteColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(9), right: Radius.circular(9)),
                ),
                child: Center(
                  child: Text(
                    'pay_with_otp'.tr,
                    style: getMediumStyle(
                      fontSize: FontSizeManager.s14,
                      color: controller.cashiPaymentMethod.value == 'otp'
                          ? ColorsManager.whiteColor
                          : ColorsManager.fontColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard(BuildContext context, SubscriptionPaymentInitModel payment) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorsManager.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'amount'.tr,
            style: getRegularStyle(
              fontSize: FontSizeManager.s14,
              color: ColorsManager.hintStyleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${payment.currency} ${NumberFormat('#,###').format(payment.amount.toInt())}',
            style: getBoldStyle(
              fontSize: FontSizeManager.s24,
              color: ColorsManager.mainColor,
            ),
          ),
          const SizedBox(height: 20),

          if (payment.displayReference != null && payment.displayReference!.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'reference_number'.tr,
                style: getSemiBoldStyle(
                  fontSize: FontSizeManager.s14,
                  color: ColorsManager.blackColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ColorsManager.lightGreyColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorsManager.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      payment.displayReference!,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s16,
                        color: ColorsManager.blackColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: payment.displayReference!));
                      Dialogs.successDialog(context, 'copied_to_clipboard'.tr);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorsManager.mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'copy'.tr,
                        style: getSemiBoldStyle(
                          fontSize: FontSizeManager.s12,
                          color: ColorsManager.mainColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (payment.qrCodeDataUrl != null && payment.qrCodeDataUrl!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Divider(color: ColorsManager.borderColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or_scan_qr_code'.tr,
                    style: getRegularStyle(
                      fontSize: FontSizeManager.s12,
                      color: ColorsManager.hintStyleColor,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: ColorsManager.borderColor)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsManager.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorsManager.borderColor),
              ),
              child: _buildQrImage(payment.qrCodeDataUrl!),
            ),
          ],

          if (payment.expiresAt != null) ...[
            const SizedBox(height: 20),
            _CountdownTimer(expiresAt: payment.expiresAt!),
          ],
        ],
      ),
    );
  }

  Widget _buildQrImage(String dataUrl) {
    try {
      final base64String = dataUrl.split(',').last;
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      );
    } catch (e) {
      return const SizedBox(
        width: 150,
        height: 150,
        child: Icon(Icons.qr_code, size: 100, color: ColorsManager.defaultGreyColor),
      );
    }
  }

  Widget _buildHowToPaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'how_to_pay'.tr,
          style: getSemiBoldStyle(
            fontSize: FontSizeManager.s16,
            color: ColorsManager.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildExpandableInstruction(
          title: 'option_1_mycashi_app'.tr,
          steps: [
            'mycashi_step_1'.tr,
            'mycashi_step_2'.tr,
            'mycashi_step_3'.tr,
            'mycashi_step_4'.tr,
          ],
        ),
        const SizedBox(height: 12),
        _buildExpandableInstruction(
          title: 'option_2_cashi_merchant'.tr,
          steps: [
            'merchant_step_1'.tr,
            'merchant_step_2'.tr,
            'merchant_step_3'.tr,
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableInstruction({required String title, required List<String> steps}) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsManager.borderColor),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: ColorsManager.mainColor,
          collapsedIconColor: ColorsManager.hintStyleColor,
          title: Text(
            title,
            style: getMediumStyle(
              fontSize: FontSizeManager.s14,
              color: ColorsManager.fontColor,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ',
                          style: getSemiBoldStyle(
                            fontSize: FontSizeManager.s14,
                            color: ColorsManager.mainColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: getRegularStyle(
                              fontSize: FontSizeManager.s14,
                              color: ColorsManager.fontColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceActionSection(BuildContext context, SubscriptionPaymentInitModel payment) {
    return ElevatedButton(
      onPressed: () {
        controller.startPolling(payment.clientReferenceId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.mainColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'ive_completed_payment'.tr,
        style: getMediumStyle(
          fontSize: FontSizeManager.s16,
          color: ColorsManager.whiteColor,
        ),
      ),
    );
  }

  Widget _buildOtpPaymentSection(BuildContext context, SubscriptionPaymentInitModel payment) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorsManager.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'amount'.tr,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: FontSizeManager.s14,
              color: ColorsManager.hintStyleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${payment.currency} ${NumberFormat('#,###').format(payment.amount.toInt())}',
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSizeManager.s24,
              color: ColorsManager.mainColor,
            ),
          ),
          const SizedBox(height: 20),
          
          Text(
            'how_to_pay'.tr,
            style: getSemiBoldStyle(
              fontSize: FontSizeManager.s16,
              color: ColorsManager.blackColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'cashi_otp_step_1'.tr,
            style: getRegularStyle(fontSize: FontSizeManager.s14, color: ColorsManager.fontColor),
          ),
          const SizedBox(height: 4),
          Text(
            'cashi_otp_step_2'.tr,
            style: getRegularStyle(fontSize: FontSizeManager.s14, color: ColorsManager.fontColor),
          ),
          const SizedBox(height: 4),
          Text(
            'cashi_otp_step_3'.tr,
            style: getRegularStyle(fontSize: FontSizeManager.s14, color: ColorsManager.fontColor),
          ),
          const SizedBox(height: 4),
          Text(
            'cashi_otp_step_4'.tr,
            style: getRegularStyle(fontSize: FontSizeManager.s14, color: ColorsManager.fontColor),
          ),
          const SizedBox(height: 20),

          if (!controller.isOtpInitiated.value) ...[
            TextField(
              key: const ValueKey('wallet_number_input'),
              keyboardType: TextInputType.number,
              maxLength: 9,
              onChanged: (val) => controller.walletNumber.value = val,
              decoration: InputDecoration(
                hintText: 'enter_wallet_number'.tr,
                filled: true,
                fillColor: ColorsManager.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.mainColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.walletNumber.value.length < 9
                  ? null
                  : () {
                      controller.initiatePayment(
                        controller.selectedPlanId.value,
                        'cashipay',
                        requiresOtp: true,
                        walletAccountNumber: controller.walletNumber.value,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'send_otp'.tr,
                style: getMediumStyle(
                  fontSize: FontSizeManager.s16,
                  color: ColorsManager.whiteColor,
                ),
              ),
            )),
          ] else ...[
            Obx(() => TextField(
              key: const ValueKey('otp_code_input'),
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (val) => controller.otpCode.value = val,
              enabled: !controller.isOtpLocked.value,
              decoration: InputDecoration(
                hintText: 'payment_enter_otp'.tr,
                filled: true,
                fillColor: controller.isOtpLocked.value ? ColorsManager.lightGreyColor : ColorsManager.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.mainColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorsManager.borderColor),
                ),
              ),
            )),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isConfirmingOtp.value || controller.otpCode.value.length < 6 || controller.isOtpLocked.value
                  ? null
                  : () {
                      controller.confirmOtp(payment.clientReferenceId, controller.otpCode.value);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: controller.isConfirmingOtp.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: ColorsManager.whiteColor,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'confirm_otp'.tr,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s16,
                        color: ColorsManager.whiteColor,
                      ),
                    ),
            )),
            Obx(() => controller.isOtpLocked.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'otp_attempts_exceeded'.tr,
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s14,
                        color: ColorsManager.errorColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  final String expiresAt;

  const _CountdownTimer({Key? key, required this.expiresAt}) : super(key: key);

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    try {
      final expiry = DateTime.parse(widget.expiresAt);
      final now = DateTime.now().toUtc();
      if (expiry.isAfter(now)) {
        if (mounted) {
          setState(() {
            _timeLeft = expiry.difference(now);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _timeLeft = Duration.zero;
          });
        }
        _timer?.cancel();
      }
    } catch (e) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero) {
      return Text(
        'Expired',
        style: getMediumStyle(
          fontSize: FontSizeManager.s14,
          color: ColorsManager.errorColor,
        ),
      );
    }

    final minutes = _timeLeft.inMinutes;
    final seconds = _timeLeft.inSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorsManager.warningStyleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: ColorsManager.warningStyleColor),
          const SizedBox(width: 8),
          Text(
            '${'expires_in'.tr}: $timeString',
            style: getSemiBoldStyle(
              fontSize: FontSizeManager.s14,
              color: ColorsManager.warningStyleColor,
            ),
          ),
        ],
      ),
    );
  }
}
