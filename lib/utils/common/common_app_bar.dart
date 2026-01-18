import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';

class CommonAppBar extends StatelessWidget {
  final String? title;
  final bool showBack;
  final bool showLogo;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.showLogo = false,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT
          Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: onBack ?? () => Navigator.pop(context),
                  child: Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: BoxDecoration(
                      color: AppColor.selectedBg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.arrow_back_ios_new, size: 20.sp),
                  ),
                ),

              if (showBack && title != null) SizedBox(width: 10.w),

              if (showLogo)
                Image.asset(
                  'assets/images/pari-enterprises-logo.png',
                  height: 50.h,
                ),

              if (!showLogo && title != null)
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          Row(children: actions ?? []),
        ],
      ),
    );
  }
}
