import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class PickupDetailsScreen extends StatelessWidget {
  const PickupDetailsScreen({super.key});

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
              /// APP BAR WITH BACK
              CommonAppBar(
                showBack: true,

                actions: [
                  _actionIcon(Icons.notifications_none),
                  _actionIcon(Icons.info_outline),
                ],
              ),

              SizedBox(height: 12.h),

              /// TITLE
              Text(
                "Pickup Details",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),

              SizedBox(height: 12.h),

              /// PICKUP ID
              Text(
                "pickup Id",
                style: TextStyle(fontSize: 14.sp, color: AppColor.textLight),
              ),
              SizedBox(height: 6.h),
              _readOnlyField("#123456"),

              SizedBox(height: 14.h),

              /// CUSTOMER INFO CARD
              _infoCard(),

              SizedBox(height: 16.h),

              /// CATEGORY SECTION
              _categorySection(),

              SizedBox(height: 24.h),

              /// CREATE ORDER BUTTON
              _createOrderButton(),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── READ ONLY FIELD ─────────
  Widget _readOnlyField(String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.black),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 14.sp, color: AppColor.textLight),
      ),
    );
  }

  // ───────── INFO CARD ─────────
  Widget _infoCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.black),
      ),
      child: Column(
        children: [
          _infoRow("Name", "Rohan Gupta"),
          _divider(),
          _infoRow("Date", "24-04-2025"),
          _divider(),
          _infoRow("Mobile No.", "7040040015"),
          _divider(),
          _infoRow("Address", "45, Green Avenue, Near City Center ....."),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: AppColor.textLight),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 13.sp, color: AppColor.textDark),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: AppColor.black, height: 1);
  }

  // ───────── CATEGORY + ITEMS ─────────
  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.orange.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Category",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6.h),
              _dropdown(),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        _itemRow("Silk Shirt", 3),
        _itemRow("Coat", 3),

        SizedBox(height: 12.h),

        /// ADD MORE
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColor.primaryBlue,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            "Add More",
            style: TextStyle(color: AppColor.white, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _dropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColor.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: "Man",
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: "Man", child: Text("Man")),
            DropdownMenuItem(value: "Woman", child: Text("Woman")),
          ],
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _itemRow(String name, int qty) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 14.sp)),
          Row(
            children: [
              Icon(
                Icons.remove_circle_outline,
                color: AppColor.red,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text("$qty", style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 8.w),
              Icon(
                Icons.add_circle_outline,
                color: AppColor.locationGreen,
                size: 22.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────── CREATE ORDER ─────────
  Widget _createOrderButton() {
    return Container(
      width: double.infinity,
      height: 52.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.orange.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        "Create Order",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.white,
        ),
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
