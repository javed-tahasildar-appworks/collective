import 'package:collectiv/di_container.dart';
import 'package:collectiv/modules/login-module/ui/login_screen.dart';
import 'package:collectiv/routes.dart';
import 'package:collectiv/utils/color_constants.dart';
import 'package:collectiv/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  await setupLocator();

  runApp(ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) => const ProviderScope(child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collectiv Agent App',
      theme: ThemeData(
        scaffoldBackgroundColor: kWhite,
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
        textTheme: GoogleFonts.ibmPlexSansTextTheme().copyWith(
          bodyMedium: GoogleFonts.ibmPlexSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
          titleLarge: GoogleFonts.ibmPlexSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.ibmPlexSans(
            color: const Color(0xFF1E293B),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF1E293B),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: corporateBlue,
          secondary: trendDark,
        ),
      ),
      home: const LoginScreen(),
      routes: routes,
    );
  }
}
