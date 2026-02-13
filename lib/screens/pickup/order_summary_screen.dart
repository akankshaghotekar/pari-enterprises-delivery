import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/order_detail_model.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String orderSrNo;
  final String orderNo;
  final String orderDate;
  final String clientName;
  final String mobile;
  final String amount;
  final String status;

  const OrderSummaryScreen({
    super.key,
    required this.orderSrNo,
    required this.orderNo,
    required this.orderDate,
    required this.clientName,
    required this.mobile,
    required this.amount,
    required this.status,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Future<List<OrderDetailModel>> _orderDetailFuture;

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = ApiService.getOrderDetails(
      orderSrNo: widget.orderSrNo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const CommonBottomNav(currentIndex: -1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonAppBar(
              showBack: true,
              actions: [
                _actionIcon(Icons.notifications_none),
                _actionIcon(Icons.info_outline),
              ],
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Order Details",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
              ),
            ),

            SizedBox(height: 16.h),

            /// ORDER INFO
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _orderInfoCard(),
            ),

            SizedBox(height: 16.h),

            /// ORDER ITEMS
            Expanded(
              child: FutureBuilder<List<OrderDetailModel>>(
                future: _orderDetailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No items found"));
                  }

                  final items = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return _OrderItem(
                        name: item.subCategory,
                        qty: item.qty.toInt(),
                        image: "assets/images/image2.png",
                        amount: item.amount,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.warningOrange),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// STATUS LABEL (TOP RIGHT)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.warningOrange,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Text(
                widget.status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
            ),
          ),

          /// ORDER INFO
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.clientName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryBlue,
                  ),
                ),
                SizedBox(height: 10.h),

                _infoText("Order No", widget.orderNo),
                _infoText("Order Date", widget.orderDate),
                _infoText("Mobile", widget.mobile),

                SizedBox(height: 10.h),

                Text(
                  "₹ ${widget.amount}",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.successGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoText(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              "$title:",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

class _OrderItem extends StatelessWidget {
  final String name;
  final int qty;
  final String image;
  final double amount;

  const _OrderItem({
    required this.name,
    required this.qty,
    required this.image,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          /// IMAGE
          Container(
            height: 60.h,
            width: 60.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Image.asset(image),
          ),

          SizedBox(width: 14.w),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textDark,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Qty: $qty",
                  style: TextStyle(fontSize: 13.sp, color: AppColor.textLight),
                ),
              ],
            ),
          ),

          /// AMOUNT
          Text(
            "₹ $amount",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
