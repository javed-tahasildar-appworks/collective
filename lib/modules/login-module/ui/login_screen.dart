import 'package:collectiv/modules/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/modules/login-module/ui/login_screen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Top Section - Logo and Welcome (30% of screen)
              Expanded(
                flex: 3,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1)
                                  .withAlpha((255 * 0.3).round()),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 36.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Sign in to continue your collection journey',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Middle Section - Form Fields (50% of screen)
              Expanded(
                flex: 5,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Agent ID Field
                        Text(
                          'Agent ID',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                            letterSpacing: 0.1,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 52.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: _emailFocus.hasFocus
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFE2E8F0),
                              width: _emailFocus.hasFocus ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withAlpha((255 * 0.04).round()),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            decoration: InputDecoration(
                              hintText: 'Enter your agent ID',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Container(
                                margin: EdgeInsets.only(left: 12.w, right: 8.w),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  color: _emailFocus.hasFocus
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF94A3B8),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // PIN Field
                        Text(
                          'PIN',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                            letterSpacing: 0.1,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 52.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: _passwordFocus.hasFocus
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFE2E8F0),
                              width: _passwordFocus.hasFocus ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withAlpha((255 * 0.04).round()),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              hintText: 'Enter your PIN',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Container(
                                margin: EdgeInsets.only(left: 12.w, right: 8.w),
                                child: Icon(
                                  Icons.lock_outline_rounded,
                                  color: _passwordFocus.hasFocus
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF94A3B8),
                                  size: 20.sp,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12.w),
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF94A3B8),
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Forgot PIN
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Handle forgot password
                            },
                            child: Text(
                              'Forgot PIN?',
                              style: TextStyle(
                                color: const Color(0xFF6366F1),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Login Button
                        Container(
                          width: double.infinity,
                          height: 52.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF6366F1),
                                Color(0xFF8B5CF6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1)
                                    .withAlpha((255 * 0.04).round()),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to AppBottomNav
                              Navigator.pushReplacementNamed(
                                  context, AppBottomNav.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Section - Biometric Option (20% of screen)
              Expanded(
                flex: 2,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        margin: EdgeInsets.symmetric(horizontal: 40.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFE2E8F0)
                                  .withAlpha((255 * 0.0).round()),
                              const Color(0xFFE2E8F0),
                              const Color(0xFFE2E8F0)
                                  .withAlpha((255 * 0.0).round()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Or sign in with biometrics',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () {
                          // Handle biometric login
                        },
                        child: Container(
                          width: 56.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1)
                                    .withAlpha((255 * 0.1).round()),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fingerprint_rounded,
                            size: 28.sp,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:collectiv/modules/app_bottom_nav.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class LoginScreen extends StatefulWidget {
//   static String routeName = "/modules/login-module/ui/login_screen";

//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _obscureText = true;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: SizeConfig.screenWidth * 0.05,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: getProportionateHeight(302.0),
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.only(
//                 top: getProportionateHeight(40.0),
//                 left: getProportionateWidth(36.0),
//                 right: getProportionateWidth(36.0),
//               ),
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/login_logo.png'),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             SizedBox(height: getProportionateHeight(36.0)),
//             Text(
//               welcome,
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//                 color: kBlack,
//               ),
//             ),
//             SizedBox(height: getProportionateHeight(24.0)),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   hintText: userId,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//             ),
//             SizedBox(height: getProportionateHeight(16.0)),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: _obscureText,
//                 decoration: InputDecoration(
//                   hintText: userPin,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureText = !_obscureText;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: getProportionateHeight(16.0)),
//             GestureDetector(
//               onTap: () {
//                 // Handle forgot password
//               },
//               child: Text(
//                 forgotPin,
//                 style: TextStyle(
//                   color: accentBlue,
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             SizedBox(height: getProportionateHeight(24.0)),
//             ElevatedButton(
//               onPressed: () => Navigator.pushReplacementNamed(
//                   context, AppBottomNav.routeName),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: darkBlue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 48),
//               ),
//               child: Text(
//                 login,
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
