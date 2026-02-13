import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/drop_request_model.dart';
import 'package:pari_enterprises_delivery/screens/drop/confirm_delivery_screen.dart';
import 'package:pari_enterprises_delivery/shared_pref/shared_pref.dart';
import 'package:pari_enterprises_delivery/utils/animation_helper/animated_page_route.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class DropRequestScreen extends StatefulWidget {
  const DropRequestScreen({super.key});

  @override
  State<DropRequestScreen> createState() => _DropRequestScreenState();
}

class _DropRequestScreenState extends State<DropRequestScreen> {
  List<DropRequestModel> dropRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDropRequests();
  }

  Future<void> _fetchDropRequests() async {
    final userSrNo = await SharedPref.getUserSrNo();

    if (userSrNo == null || userSrNo.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    final res = await ApiService.getDropRequests(userSrNo: userSrNo);

    if (!mounted) return;

    setState(() {
      dropRequests = res;
      isLoading = false;
    });
  }

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
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dropRequests.length,
                      separatorBuilder: (_, __) => SizedBox(height: 14.h),
                      itemBuilder: (context, index) {
                        final drop = dropRequests[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              AnimatedPageRoute(
                                page: ConfirmDeliveryScreen(
                                  billSrNo: drop.billSrNo,
                                ),
                              ),
                            );
                          },
                          child: _dropCard(
                            drop: drop,
                            status: index % 2 == 0 ? "Delivered" : "Pending",
                            statusBg: index % 2 == 0
                                ? AppColor.locationGreen
                                : AppColor.orange.withOpacity(0.9),
                            statusText: AppColor.white,
                          ),
                        );
                      },
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
    required DropRequestModel drop,
    required String status,
    required Color statusBg,
    required Color statusText,
  }) {
    final address =
        "${drop.addressLine1 ?? ""}, ${drop.addressLine2 ?? ""}, ${drop.city ?? ""}";

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order: ${drop.billNo}",
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
          _infoRow("Bill Date", drop.billDate),
          _infoRow("Name", drop.clientName ?? "-"),
          _infoRow("Mobile", drop.mobile ?? "-"),
          _infoRow("Address", address),
          _infoRow("Pincode", drop.pincode ?? "-"),
          _infoRow("Price", "Rs. ${drop.amount}"),
          _infoRow("Delivery Date", drop.deliveryDate),
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
