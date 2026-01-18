import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/screens/pickup/pickup_details_screen.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class PickupRequestScreen extends StatelessWidget {
  const PickupRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const CommonBottomNav(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// APP BAR
              CommonAppBar(
                showLogo: true,
                actions: [
                  _actionIcon(Icons.notifications_none),
                  _actionIcon(Icons.info_outline),
                ],
              ),

              SizedBox(height: 16.h),

              /// TITLE
              Text(
                "Pickup Request",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),

              SizedBox(height: 16.h),

              /// SEARCH + ADD
              Row(
                children: [
                  Expanded(child: _searchField()),
                  SizedBox(width: 12.w),
                  _addButton(),
                ],
              ),

              SizedBox(height: 20.h),

              /// PICKUP CARD
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PickupDetailsScreen(),
                    ),
                  );
                },
                child: _pickupCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── SEARCH FIELD ─────────
  Widget _searchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search Name or Order.....",
        hintStyle: TextStyle(fontSize: 16.sp, color: AppColor.hintText),
        prefixIcon: Icon(Icons.search, size: 20.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColor.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColor.primaryBlue),
        ),
      ),
    );
  }

  // ───────── ADD BUTTON ─────────
  Widget _addButton() {
    return Container(
      height: 46.h,
      width: 46.h,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.textDark),
      ),
      child: Icon(Icons.add, size: 24.sp),
    );
  }

  // ───────── PICKUP CARD ─────────
  Widget _pickupCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME
          Text(
            "Rohan Gupta",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.primaryBlue,
            ),
          ),

          SizedBox(height: 8.h),

          _infoRow("Order ID:", "123456"),
          _infoRow("Items:", "6 (Wash and Iron)"),
          _infoRow("Price -", "Rs. 250.00"),
          _infoRow("Date:", "15-01-2026"),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: AppColor.textDark),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── APP BAR ACTION ICON ─────────
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
