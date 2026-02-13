import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class DeliverySuccessScreen extends StatelessWidget {
  final String billNo;
  final String deliveryDate;
  const DeliverySuccessScreen({
    super.key,
    required this.billNo,
    required this.deliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const CommonBottomNav(currentIndex: -1),
      body: SafeArea(
        child: Column(
          children: [
            /// APP BAR (BACK)
            CommonAppBar(
              showBack: true,
              actions: [
                _actionIcon(Icons.notifications_none),
                _actionIcon(Icons.info_outline),
              ],
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// SUCCESS ICON
                  Container(
                    height: 90.h,
                    width: 90.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.successGreen,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 46.sp,
                      color: AppColor.successGreen,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// TITLE
                  Text(
                    "Successful",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textDark,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// MESSAGE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.textLight,
                        ),
                        children: [
                          const TextSpan(text: "Your Order "),
                          TextSpan(
                            text: billNo,
                            style: TextStyle(
                              color: AppColor.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: "\nhas been Delivered On "),
                          TextSpan(
                            text: deliveryDate,
                            style: TextStyle(
                              color: AppColor.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── APP BAR ICON ─────────
  Widget _actionIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      height: 36.h,
      width: 36.h,
      decoration: BoxDecoration(
        color: AppColor.selectedBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(icon, size: 20.sp),
    );
  }
}
