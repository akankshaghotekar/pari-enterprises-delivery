import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const AppBarIcon({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 10.w),
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          color: AppColor.selectedBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 25.sp),
      ),
    );
  }
}
