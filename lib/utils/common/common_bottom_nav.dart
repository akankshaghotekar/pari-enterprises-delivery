import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/screens/drop/drop_request_screen.dart';
import 'package:pari_enterprises_delivery/screens/home/home_screen.dart';
import 'package:pari_enterprises_delivery/screens/pickup/pickup_request_screen.dart';
import 'package:pari_enterprises_delivery/screens/profile/profile_screen.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';

class CommonBottomNav extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget? page;

    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const PickupRequestScreen();
        break;

      case 2:
        page = const DropRequestScreen();
        break;

      case 3:
        page = const ProfileScreen();
        break;
    }

    if (page != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        height: 64.h,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.home, "Home", 0),
            _navItem(context, Icons.add, "Pickup Request", 1),
            _navItem(context, Icons.messenger_outline_sharp, "Drop Request", 2),
            _navItem(context, Icons.person_outline, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26.sp,
            color: isActive ? AppColor.primaryBlue : AppColor.bottomNavInactive,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? AppColor.primaryBlue
                  : AppColor.bottomNavInactive,
            ),
          ),
        ],
      ),
    );
  }
}
