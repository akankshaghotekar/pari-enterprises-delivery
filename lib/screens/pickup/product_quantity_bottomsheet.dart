import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/screens/pickup/cart_screen.dart';
import 'package:pari_enterprises_delivery/shared_pref/shared_pref.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';

class ProductQuantityBottomSheet extends StatefulWidget {
  final String productName;
  final String image;
  final double price;

  final String laundrySubCategorySrNo;
  final String pickupSrNo;
  final String customerUserSrNo;

  const ProductQuantityBottomSheet({
    super.key,
    required this.productName,
    required this.image,
    required this.price,
    required this.laundrySubCategorySrNo,
    required this.pickupSrNo,
    required this.customerUserSrNo,
  });

  @override
  State<ProductQuantityBottomSheet> createState() =>
      _ProductQuantityBottomSheetState();
}

class _ProductQuantityBottomSheetState
    extends State<ProductQuantityBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DRAG HANDLE
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          /// PRODUCT IMAGE
          Center(
            child: Image.asset(
              widget.image,
              height: 160.h,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 20.h),

          /// PRODUCT NAME
          Text(
            widget.productName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            "Choose The Quantity",
            style: TextStyle(fontSize: 14.sp, color: AppColor.textLight),
          ),

          SizedBox(height: 16.h),

          /// QUANTITY + BUTTON
          Row(
            children: [
              _quantitySelector(),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final assignedUserSrNo = await SharedPref.getUserSrNo();

                    if (assignedUserSrNo == null) return;

                    await ApiService.addToCart(
                      laundrySubCategorySrNo: widget.laundrySubCategorySrNo,
                      qty: quantity.toString(),
                      assignedToUserSrNo: assignedUserSrNo,
                      userSrNo: widget.customerUserSrNo,
                      pickupSrNo: widget.pickupSrNo,
                    );

                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CartScreen(pickupSrNo: widget.pickupSrNo),
                      ),
                    );
                  },

                  child: _addButton(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────── QUANTITY SELECTOR ─────────
  Widget _quantitySelector() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColor.lightGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _qtyButton(Icons.remove, () {
            if (quantity > 1) {
              setState(() => quantity--);
            }
          }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "$quantity",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
          _qtyButton(Icons.add, () {
            setState(() => quantity++);
          }),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        alignment: Alignment.center,
        child: Icon(icon, size: 18.sp),
      ),
    );
  }

  // ───────── ADD BUTTON ─────────
  Widget _addButton() {
    return Container(
      height: 44.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        "Add Item ₹${(widget.price * quantity).toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.white,
        ),
      ),
    );
  }
}
