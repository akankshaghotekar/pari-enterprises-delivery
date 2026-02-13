import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/cart_item_model.dart';
import 'package:pari_enterprises_delivery/screens/pickup/order_summary_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/pickup_request_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/view_order_screen.dart';
import 'package:pari_enterprises_delivery/shared_pref/shared_pref.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class CartScreen extends StatefulWidget {
  final String pickupSrNo;
  const CartScreen({super.key, required this.pickupSrNo});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<ViewCartResponse?>? _cartFuture;
  bool _isPlacingOrder = false;
  bool _isCartEmpty = true;

  @override
  void initState() {
    super.initState();
    _cartFuture = ApiService.viewCart(pickupSrNo: widget.pickupSrNo);
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
            /// APP BAR (BACK)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CommonAppBar(
                showBack: true,
                actions: [
                  _actionIcon(Icons.notifications_none),
                  _actionIcon(Icons.info_outline),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Orders Details",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            /// ITEMS LIST
            Expanded(
              child: FutureBuilder<ViewCartResponse?>(
                future: _cartFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _isCartEmpty = true);
                    });

                    return const Center(child: Text("Cart is empty"));
                  }
                  final cart = snapshot.data!;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _isCartEmpty = false);
                  });

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return _CartItem(
                        name: item.subCategory,
                        qty: item.qty,
                        image: "assets/images/image2.png",
                        tempSrNo: item.tempSrNo,
                        onDelete: () async {
                          await ApiService.removeCartItem(
                            tempSrNo: item.tempSrNo,
                          );

                          setState(() {
                            _cartFuture = ApiService.viewCart(
                              pickupSrNo: widget.pickupSrNo,
                            );
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),

            /// CREATE ORDER BUTTON
            Padding(
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: (_isPlacingOrder || _isCartEmpty)
                    ? null
                    : () async {
                        setState(() => _isPlacingOrder = true);

                        final assignedUserSrNo = await SharedPref.getUserSrNo();

                        if (assignedUserSrNo != null) {
                          final res = await ApiService.checkout(
                            pickupSrNo: widget.pickupSrNo,
                            assignedToUserSrNo: assignedUserSrNo,
                          );

                          if (res != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PickupRequestScreen(),
                              ),
                            );
                          }
                        }

                        if (mounted) {
                          setState(() => _isPlacingOrder = false);
                        }
                      },

                child: _createOrderButton(),
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

  // ───────── CREATE ORDER BUTTON ─────────
  Widget _createOrderButton() {
    return Container(
      width: double.infinity,
      height: 52.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (_isCartEmpty || _isPlacingOrder)
            ? AppColor.warningOrange.withOpacity(0.4)
            : AppColor.warningOrange,

        borderRadius: BorderRadius.circular(10.r),
      ),
      child: _isPlacingOrder
          ? SizedBox(
              height: 24.h,
              width: 24.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              "Create Order",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.white,
              ),
            ),
    );
  }
}

/// ───────── CART ITEM CARD ─────────
class _CartItem extends StatefulWidget {
  final String name;
  final int qty;
  final String image;
  final String tempSrNo;
  final Future<void> Function() onDelete;

  const _CartItem({
    required this.name,
    required this.qty,
    required this.image,
    required this.tempSrNo,
    required this.onDelete,
  });

  @override
  State<_CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<_CartItem> {
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          /// IMAGE
          Image.asset(
            widget.image,
            height: 60.h,
            width: 60.w,
            fit: BoxFit.contain,
          ),

          SizedBox(width: 12.w),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Quantity: ${widget.qty}",
                  style: TextStyle(fontSize: 13.sp, color: AppColor.textLight),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    // _actionBtn("Edit", AppColor.primaryBlue),
                    // SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: _isDeleting
                          ? null
                          : () async {
                              setState(() => _isDeleting = true);
                              await widget.onDelete();
                              if (mounted) {
                                setState(() => _isDeleting = false);
                              }
                            },
                      child: _isDeleting
                          ? SizedBox(
                              height: 28.h,
                              width: 28.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.warningOrange,
                              ),
                            )
                          : _actionBtn("Delete", AppColor.warningOrange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColor.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
