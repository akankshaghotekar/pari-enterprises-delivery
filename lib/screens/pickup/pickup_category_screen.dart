import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/model/laundry_category_model.dart';
import 'package:pari_enterprises_delivery/screens/pickup/cart_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/pickup_product_list_screen.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_app_bar.dart';
import 'package:pari_enterprises_delivery/utils/common/common_bottom_nav.dart';

class PickupCategoryScreen extends StatefulWidget {
  final String pickupSrNo;
  final String customerUserSrNo;
  const PickupCategoryScreen({
    super.key,
    required this.pickupSrNo,
    required this.customerUserSrNo,
  });

  @override
  State<PickupCategoryScreen> createState() => _PickupCategoryScreenState();
}

class _PickupCategoryScreenState extends State<PickupCategoryScreen> {
  late Future<List<LaundryCategoryModel>> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = ApiService.getLaundryCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const CommonBottomNav(currentIndex: -1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonAppBar(
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

              SizedBox(height: 20.h),

              Text(
                "Pickup Category",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),

              SizedBox(height: 20.h),

              /// CATEGORY FROM API
              FutureBuilder<List<LaundryCategoryModel>>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No category found");
                  }

                  final categories = snapshot.data!;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: categories.map((cat) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PickupProductListScreen(
                                categoryName: cat.laundry,
                                laundrySrNo: cat.laundrySrNo,
                                pickupSrNo: widget.pickupSrNo,
                                customerUserSrNo: widget.customerUserSrNo,
                              ),
                            ),
                          );
                        },
                        child: _CategoryCard(
                          title: cat.laundry,
                          image: "assets/images/pari-enterprises-logo.png",
                          isSelected: false,
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

/// ───────── CATEGORY CARD ─────────
class _CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;

  const _CategoryCard({
    required this.title,
    required this.image,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColor.primaryBlue : AppColor.warningOrange,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Image.asset(image, height: 40.h, fit: BoxFit.contain),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColor.primaryBlue : AppColor.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
