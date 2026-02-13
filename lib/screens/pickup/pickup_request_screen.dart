import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/pickup_request_model.dart';
import 'package:pari_enterprises_delivery/screens/pickup/pickup_category_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/pickup_details_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/view_order_screen.dart';
import 'package:pari_enterprises_delivery/shared_pref/shared_pref.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class PickupRequestScreen extends StatefulWidget {
  const PickupRequestScreen({super.key});

  @override
  State<PickupRequestScreen> createState() => _PickupRequestScreenState();
}

class _PickupRequestScreenState extends State<PickupRequestScreen> {
  Future<List<PickupRequestModel>>? _pickupFuture;
  final TextEditingController _searchController = TextEditingController();

  List<PickupRequestModel> _allPickups = [];
  List<PickupRequestModel> _filteredPickups = [];

  String _userName = "";
  String _userSrNo = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _openDialer(String mobile) {
    final uri = Uri.parse("tel:$mobile");
    launchUrl(uri);
  }

  Future<void> _loadData() async {
    final name = await SharedPref.getUserName();
    final srNo = await SharedPref.getUserSrNo();

    final future = ApiService.getPickupRequests(userSrNo: srNo ?? "");

    setState(() {
      _userName = name ?? "";
      _userSrNo = srNo ?? "";
      _pickupFuture = future;
    });

    final data = await future;
    if (mounted) {
      setState(() {
        _allPickups = data;
        _filteredPickups = data;
      });
    }
  }

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
                  GestureDetector(onTap: () {}, child: _addButton()),
                ],
              ),

              SizedBox(height: 20.h),

              /// PICKUP CARD
              _pickupFuture == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<PickupRequestModel>>(
                      future: _pickupFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("No pickup requests found"),
                          );
                        }

                        final pickups = _filteredPickups;

                        return Column(
                          children: pickups.map((item) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PickupCategoryScreen(
                                      pickupSrNo: item.pickupSrNo,
                                      customerUserSrNo: item.userSrNo,
                                    ),
                                  ),
                                );
                              },
                              child: _pickupCard(
                                name: item.clientName ?? "Unknown Client",
                                mobile: item.mobile,
                                orderId: item.pickupSrNo,
                                services: item.services,
                                date: item.pickupDate,
                                time: item.pickupTime,
                                orderGenerated: item.orderGenerated,
                                pickupSrNo: item.pickupSrNo,
                              ),
                            );
                          }).toList(),
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
      controller: _searchController,
      onChanged: (value) {
        final query = value.toLowerCase().trim();

        setState(() {
          _filteredPickups = _allPickups.where((item) {
            final name = item.clientName?.toLowerCase() ?? "";
            // final orderId = item.pickupSrNo.toLowerCase();

            final services = item.services
                .toLowerCase()
                .replaceAll('\n', ' ')
                .replaceAll(',', ' ');

            final date = item.pickupDate
                .toLowerCase()
                .replaceAll('-', ' ')
                .replaceAll(',', ' ');

            return name.contains(query) ||
                // orderId.contains(query) ||
                services.contains(query) ||
                date.contains(query);
          }).toList();
        });
      },

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
  Widget _pickupCard({
    required String name,
    required String orderId,
    required String services,
    required String date,
    required String time,
    required int orderGenerated,
    required String pickupSrNo,
    String? mobile,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          /// USER NAME (FROM SHARED PREF)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ),

              if (mobile != null && mobile!.isNotEmpty)
                GestureDetector(
                  onTap: () => _openDialer(mobile!),
                  child: Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.call,
                      color: AppColor.primaryBlue,
                      size: 20.sp,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 8.h),
          _infoRow(
            "Mobile:",
            (mobile != null && mobile!.isNotEmpty) ? mobile! : "N/A",
          ),

          _infoRow("Order ID:", orderId),
          _infoRow("Services:", services),
          _infoRow("Pickup Time:", time),
          _infoRow("Date:", date),
          if (orderGenerated == 1) ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewOrderScreen(pickupSrNo: pickupSrNo),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "View Order",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
