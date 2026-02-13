import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/api/api_service.dart';
import 'package:pari_enterprises_delivery/screens/home/home_screen.dart';
import 'package:pari_enterprises_delivery/shared_pref/shared_pref.dart';
import 'package:pari_enterprises_delivery/utils/animation_helper/animated_page_route.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';
import 'package:pari_enterprises_delivery/utils/common/common_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      _showMsg("Username required");
      return;
    }
    if (password.isEmpty) {
      _showMsg("Password required");
      return;
    }

    setState(() => _isLoading = true);

    final res = await ApiService.login(username: username, password: password);

    setState(() => _isLoading = false);

    if (res != null) {
      await SharedPref.saveLogin(userSrNo: res.userSrNo, name: res.name);

      Navigator.pushReplacement(
        context,
        AnimatedPageRoute(page: const HomeScreen()),
      );
    } else {
      _showMsg("Invalid username or password");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/images/pari-enterprises-logo.png',
                    width: 320.w,
                  ),
                ),

                _label("Username"),
                _textField(
                  controller: _usernameController,
                  hint: "Enter your username",
                ),
                SizedBox(height: 16.h),

                _label("Password"),
                _textField(
                  controller: _passwordController,
                  hint: "Enter your password",
                  isPassword: true,
                ),

                SizedBox(height: 30.h),

                _isLoading
                    ? const CircularProgressIndicator()
                    : CommonButton(title: "Login", onTap: _login),

                /// Extra space so button is not hidden by keyboard
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
