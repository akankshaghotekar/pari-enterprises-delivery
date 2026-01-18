import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/screens/drop/delivery_success_screen.dart';
import 'package:pari_enterprises_delivery/utils/animation_helper/animated_page_route.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class ConfirmDeliveryScreen extends StatelessWidget {
  const ConfirmDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const CommonBottomNav(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// APP BAR
              CommonAppBar(
                showBack: true,
                title: "",
                actions: [
                  _actionIcon(Icons.notifications_none),
                  _actionIcon(Icons.info_outline),
                ],
              ),

              SizedBox(height: 16.h),

              /// TITLE
              Text(
                "Confirm Delivery",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),

              SizedBox(height: 16.h),

              /// ORDER SUMMARY
              _sectionCard(
                title: "Order Summary",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoText("Order ID: 123456"),
                    _infoText("Items: 15 (Wash and Iron)"),
                    _infoText("Price - Rs. 250.00"),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              /// DELIVERY ADDRESS
              _sectionCard(
                title: "Delivery Address",
                child: Text(
                  "45, Green Avenue, Near City Center mall, Nashik",
                  style: TextStyle(fontSize: 14.sp, color: AppColor.textDark),
                ),
              ),

              SizedBox(height: 12.h),

              /// PROOF OF DELIVERY
              _sectionCard(
                title: "Proof Of Delivery",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mobile No",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColor.textLight,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _inputField("Enter your mobile No"),

                    SizedBox(height: 8.h),

                    /// SEND OTP
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.successGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "Send OTP",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColor.textLight,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _inputField("Enter your OTP"),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// MARK AS DELIVERED BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    AnimatedPageRoute(page: const DeliverySuccessScreen()),
                  );
                },
                child: _markDeliveredButton(),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── COMMON SECTION CARD ─────────
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.primaryBlue,
            ),
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, color: AppColor.textDark),
      ),
    );
  }

  // ───────── INPUT FIELD ─────────
  Widget _inputField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: AppColor.hintText),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColor.primaryBlue),
        ),
      ),
    );
  }

  // ───────── BUTTON ─────────
  Widget _markDeliveredButton() {
    return Container(
      width: double.infinity,
      height: 52.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        "Mark As Delivered",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.white,
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
