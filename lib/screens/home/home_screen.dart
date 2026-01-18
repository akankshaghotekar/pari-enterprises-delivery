import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/appbar_icon.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const CommonBottomNav(currentIndex: 0),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAppBar(
                  showLogo: true,
                  actions: [
                    AppBarIcon(icon: Icons.notifications_none),
                    AppBarIcon(icon: Icons.info_outline),
                  ],
                ),

                SizedBox(height: 18.h),
                _statsCard(),
                SizedBox(height: 22.h),
                Text(
                  "Recent Order",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                _orderCardProcessed(),
                SizedBox(height: 12.h),
                _orderCardActive(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────── TOP BAR ─────────
  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/pari-enterprises-logo.png', height: 34.h),
        Row(
          children: [
            _iconBox(Icons.notifications_none),
            SizedBox(width: 10.w),
            _iconBox(Icons.info_outline),
          ],
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      height: 36.h,
      width: 36.h,
      decoration: BoxDecoration(
        color: AppColor.selectedBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(icon, size: 20.sp),
    );
  }

  // ───────── STATS CARD ─────────
  Widget _statsCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _stat("15", "Total Pickup\nRequest"),
          _verticalDivider(),
          _stat("10", "Total Drop\nRequest"),
          _verticalDivider(),
          _stat("0", "Failed"),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: AppColor.textLight),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 60.h,
      width: 2.w,
      color: AppColor.primaryBlue.withOpacity(0.5),
    );
  }

  // ───────── ORDER CARDS ─────────
  Widget _orderCardProcessed() {
    return _orderCard(
      price: "Rs. 250",
      orderNo: "Order No: 123456",
      status: "Processed",
      badgeBg: AppColor.badgeOrangeBg,
      badgeText: AppColor.warningOrange,
      pickupTitle: "88 Zurab Gorgiladze St",
      pickupSub: "Georgia, Batumi",
      dropTitle: "5 Noe Zhordania St",
      dropSub: "Georgia, Batumi",
    );
  }

  Widget _orderCardActive() {
    return _orderCard(
      price: "Rs. 190",
      orderNo: "Order No: 123456",
      status: "Active",
      badgeBg: AppColor.badgeGreenBg,
      badgeText: AppColor.successGreen,
      pickupTitle: "Shop address",
      pickupSub: "Area name etc",
      dropTitle: "Customer address",
      dropSub: "Same as above",
    );
  }

  Widget _orderCard({
    required String price,
    required String orderNo,
    required String status,
    required Color badgeBg,
    required Color badgeText,
    required String pickupTitle,
    required String pickupSub,
    required String dropTitle,
    required String dropSub,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                price,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                orderNo,
                style: TextStyle(fontSize: 13.sp, color: AppColor.textLight),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: badgeText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: AppColor.black),
          SizedBox(height: 12.h),
          _locationRow(true, pickupTitle, pickupSub),
          SizedBox(height: 10.h),
          _locationRow(false, dropTitle, dropSub),
        ],
      ),
    );
  }

  Widget _locationRow(bool isPickup, String title, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isPickup ? Icons.radio_button_checked : Icons.location_on,
          size: 18.sp,
          color: AppColor.locationGreen,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 2.h),
            Text(
              sub,
              style: TextStyle(fontSize: 13.sp, color: AppColor.textLight),
            ),
          ],
        ),
      ],
    );
  }
}
