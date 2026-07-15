import 'package:collectiv/modules/collect-screen-module/ui/collect_screen.dart';
import 'package:collectiv/modules/customer-screen-module/ui/customers-screen.dart';
import 'package:collectiv/modules/login-module/ui/login_screen.dart';
import 'package:collectiv/modules/notification-screen-module/ui/notifications_screen.dart';
import 'package:collectiv/modules/qr-code-scanner-module/qr_code_scanner.dart';
import 'package:collectiv/modules/reports-screen-module/ui/reports-screen.dart';
import 'package:collectiv/utils/app_extensions.dart';
import 'package:collectiv/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home-screen-module/ui/home_screen.dart';

class AppBottomNav extends StatelessWidget {
  static String routeName = "/modules/app-bottom-nav";

  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return _AppBottomNavContent();
  }
}

class _AppBottomNavContent extends StatefulWidget {
  @override
  State<_AppBottomNavContent> createState() => _AppBottomNavContentState();
}

class _AppBottomNavContentState extends State<_AppBottomNavContent> {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier(0);
  final ValueNotifier<String> _appBarTitleNotifier = ValueNotifier("Dashboard");

  final List<Widget> widgetOptions = const [
    HomeScreen(),
    CollectScreen(),
    CustomerScreen(),
    ReportsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndexNotifier.addListener(_updateAppBarTitle);
  }

  @override
  void dispose() {
    _selectedIndexNotifier.removeListener(_updateAppBarTitle);
    _selectedIndexNotifier.dispose();
    _appBarTitleNotifier.dispose();
    super.dispose();
  }

  void _updateAppBarTitle() {
    switch (_selectedIndexNotifier.value) {
      case 0:
        _appBarTitleNotifier.value = "Dashboard";
        break;
      case 1:
        _appBarTitleNotifier.value = "Collect";
        break;
      case 2:
        _appBarTitleNotifier.value = "Customers";
        break;
      case 3:
        _appBarTitleNotifier.value = "Reports";
        break;
    }
  }

  void _onItemTapped(int index) {
    _selectedIndexNotifier.value = index;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: ValueListenableBuilder<String>(
        valueListenable: _appBarTitleNotifier,
        builder: (context, title, _) => Text(
          title,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            NotificationScreen.routeName,
          ),
          icon: const Icon(Icons.notifications_outlined,
              color: Color(0xFF94A3B8)),
        ).withMargin(EdgeInsets.only(right: 8.w)),
        IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, LoginScreen.routeName),
          icon: const Icon(Icons.power_settings_new_outlined,
              color: Color(0xFF94A3B8)),
        ).withMargin(EdgeInsets.only(right: 8.w)),
      ],
    );
  }

  // PreferredSizeWidget _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     systemOverlayStyle: SystemUiOverlayStyle.dark,
  //     title: const Text(
  //       'Dashboard',
  //       style: TextStyle(
  //         color: Color(0xFF1E293B),
  //         fontSize: 20,
  //         fontWeight: FontWeight.w700,
  //       ),
  //     ),
  //     actions: [
  //       Container(
  //         margin: const EdgeInsets.only(right: 16),
  //         decoration: BoxDecoration(
  //           color: Colors.transparent,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.05),
  //               blurRadius: 10,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: IconButton(
  //           onPressed: () {},
  //           icon: const Icon(
  //             Icons.notifications_outlined,
  //             color: Color(0xFF64748B),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: _buildAppBar(),
      extendBody: true,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [trendDark.withOpacity(0.7), trendDark.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () =>
              Navigator.pushNamed(context, QRCodeScannerScreen.routeName),
          child: const Icon(Icons.qr_code_scanner_rounded, size: 28),
        ),
      ),

      // FloatingActionButton(
      //   backgroundColor: trendDark.withOpacity(0.6),
      //   foregroundColor: kWhite,
      //   elevation: 0,
      //   highlightElevation: 0,
      //   hoverElevation: 0,
      //   focusElevation: 0,
      //   shape: const CircleBorder(),
      //   onPressed: () =>
      //       Navigator.pushNamed(context, QRCodeScannerScreen.routeName),
      //   child: const Icon(Icons.qr_code_scanner_rounded),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (context, index, _) {
          return widgetOptions.elementAt(index);
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (context, index, _) {
          return BottomNavigationBar(
            backgroundColor: kWhite,
            elevation: 8,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: corporateBlue,
            unselectedItemColor: neutralLight,
            selectedIconTheme: const IconThemeData(size: 28),
            unselectedIconTheme: const IconThemeData(size: 24),
            // selectedLabelStyle: GoogleFonts.urbanist(
            //   fontWeight: FontWeight.w600,
            //   fontSize: 12,
            // ),
            // unselectedLabelStyle: GoogleFonts.urbanist(
            //   fontWeight: FontWeight.w400,
            //   fontSize: 12,
            // ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_rounded),
                label: 'Collect',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_rounded),
                label: 'Customers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Reports',
              ),
            ],
            currentIndex: index,
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
