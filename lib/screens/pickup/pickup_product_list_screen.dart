import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/laundry_sub_category_model.dart';
import 'package:pari_enterprises_delivery/screens/pickup/cart_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/product_quantity_bottomsheet.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class PickupProductListScreen extends StatefulWidget {
  final String categoryName;
  final String laundrySrNo;
  final String pickupSrNo;
  final String customerUserSrNo;

  const PickupProductListScreen({
    super.key,
    required this.categoryName,
    required this.laundrySrNo,
    required this.pickupSrNo,
    required this.customerUserSrNo,
  });

  @override
  State<PickupProductListScreen> createState() =>
      _PickupProductListScreenState();
}

class _PickupProductListScreenState extends State<PickupProductListScreen> {
  late Future<List<LaundrySubCategoryModel>> _subCategoryFuture;

  @override
  void initState() {
    super.initState();
    _subCategoryFuture = ApiService.getLaundrySubCategory(
      laundrySrNo: widget.laundrySrNo,
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
            /// APP BAR (BACK)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CommonAppBar(
                showBack: true,
                actions: [
                  _actionIcon(Icons.notifications_none),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CartScreen(pickupSrNo: widget.pickupSrNo),
                        ),
                      );
                    },
                    child: _actionIcon(Icons.trolley),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// CATEGORY TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                widget.categoryName,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Divider(color: AppColor.textDark, thickness: 0.6),

            /// PRODUCT LIST
            Expanded(
              child: FutureBuilder<List<LaundrySubCategoryModel>>(
                future: _subCategoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final item = subCategories[index];

                      return _ProductRow(
                        name: item.subCategory,
                        image: "assets/images/image2.png",
                        laundrySubCategorySrNo: item.subCategorySrNo,
                        pickupSrNo: widget.pickupSrNo,
                        customerUserSrNo: widget.customerUserSrNo,
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
}

/// ───────── PRODUCT ROW ─────────
class _ProductRow extends StatelessWidget {
  final String name;
  final String image;
  final String laundrySubCategorySrNo;
  final String pickupSrNo;
  final String customerUserSrNo;

  const _ProductRow({
    required this.name,
    required this.image,
    required this.laundrySubCategorySrNo,
    required this.pickupSrNo,
    required this.customerUserSrNo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ProductQuantityBottomSheet(
            productName: name,
            image: image,
            price: 10.00,
            laundrySubCategorySrNo: laundrySubCategorySrNo,
            pickupSrNo: pickupSrNo,
            customerUserSrNo: customerUserSrNo,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.sp, color: AppColor.textDark),
                ),
                Image.asset(
                  image,
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Divider(color: AppColor.textDark, thickness: 0.6),
        ],
      ),
    );
  }
}
