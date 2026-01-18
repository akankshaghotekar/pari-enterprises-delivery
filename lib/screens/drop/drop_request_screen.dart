import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/screens/drop/confirm_delivery_screen.dart';
import 'package:pari_enterprises_delivery/utils/animation_helper/animated_page_route.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class DropRequestScreen extends StatelessWidget {
  const DropRequestScreen({super.key});

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
                showLogo: true,
                actions: [
                  _actionIcon(Icons.notifications_none),
                  _actionIcon(Icons.info_outline),
                ],
              ),

              SizedBox(height: 16.h),

              /// TITLE
              Text(
                "My Drops",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),

              SizedBox(height: 16.h),

              /// SEARCH
              _searchField(),

              SizedBox(height: 20.h),

              /// DROP CARDS
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    AnimatedPageRoute(page: const ConfirmDeliveryScreen()),
                  );
                },
                child: _dropCard(
                  status: "Out For Delivery",
                  statusBg: AppColor.primaryBlue,
                  statusText: AppColor.white,
                ),
              ),

              SizedBox(height: 14.h),

              _dropCard(
                status: "Pending",
                statusBg: AppColor.orange.withOpacity(0.9),
                statusText: AppColor.white,
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
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColor.hintText),
        prefixIcon: Icon(Icons.search, size: 20.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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

  // ───────── DROP CARD ─────────
  Widget _dropCard({
    required String status,
    required Color statusBg,
    required Color statusText,
  }) {
    return Container(
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
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order: #123456",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: statusText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          _infoRow("Name", "xyz"),
          _infoRow("Address", "45, Green Avenue, Near City Center ....."),
          _infoRow("Price", "Rs. 250.00"),
          _infoRow("Delivered Date", "Deliver by 5:00 PM Today"),
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
            "$title : ",
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13.sp, color: AppColor.textDark),
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
