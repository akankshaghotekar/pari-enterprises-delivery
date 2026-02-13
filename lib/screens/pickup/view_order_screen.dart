import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/order_model.dart';
import 'package:pari_enterprises_delivery/screens/pickup/order_summary_screen.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class ViewOrderScreen extends StatefulWidget {
  final String pickupSrNo;

  const ViewOrderScreen({super.key, required this.pickupSrNo});

  @override
  State<ViewOrderScreen> createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  late Future<List<OrderModel>> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = ApiService.getOrdersByPickup(pickupSrNo: widget.pickupSrNo);
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
            /// APP BAR
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
                "My Orders",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: FutureBuilder<List<OrderModel>>(
                future: _orderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No orders found"));
                  }

                  final orders = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderSummaryScreen(
                                orderSrNo: order.orderSrNo,
                                orderNo: order.orderNo,
                                orderDate: order.orderDate,
                                clientName: order.clientName,
                                mobile: order.mobile,
                                amount: order.amount,
                                status: order.status,
                              ),
                            ),
                          );
                        },
                        child: _orderCard(order),
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

  Widget _orderCard(OrderModel order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.warningOrange.withOpacity(0.6)),
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
          /// STATUS CHIP (TOP RIGHT)
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
                order.status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
            ),
          ),

          /// ORDER CONTENT
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ORDER NO
                Text(
                  order.clientName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.primaryBlue,
                  ),
                ),

                SizedBox(height: 10.h),

                _infoRow("Date", order.orderDate),
                _infoRow("Order No", order.orderNo),
                _infoRow("Mobile", order.mobile),

                SizedBox(height: 12.h),

                /// AMOUNT
                Text(
                  "₹ ${order.amount}",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ],
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

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
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
}
