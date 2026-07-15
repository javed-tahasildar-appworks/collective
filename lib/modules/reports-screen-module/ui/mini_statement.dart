import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniStatement extends StatefulWidget {
  static String routeName =
      "/modules/collect-screen-module/mini_statement_screen";

  const MiniStatement({super.key});

  @override
  State<MiniStatement> createState() => _MiniStatementState();
}

class _MiniStatementState extends State<MiniStatement>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      log("Arguments: $args");
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar
          _buildCustomAppBar(),

          // Main Content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAccountSummaryCard(),
                      SizedBox(height: 24.h),
                      _buildTransactionHeader(),
                      SizedBox(height: 16.h),
                      _buildTransactionList(),
                      SizedBox(height: 100.h), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 20.w,
        right: 20.w,
        bottom: 16.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'Mini Statement',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          _buildActionButton(
            icon: Icons.share_rounded,
            onTap: () => _shareMiniStatement(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withAlpha((255 * 0.08).round()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1)
                    ..withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: const Color(0xFF6366F1),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jamna Mobiles',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Savings Account',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 32.h,
            thickness: 1,
            color: const Color(0xFFE2E8F0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                'Account Number',
                '#01234******',
                Icons.credit_card_rounded,
              ),
              _buildInfoItem(
                'Statement Date',
                'Dec 16, 2023 • 12:30 PM',
                Icons.schedule_rounded,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: const Color(0xFF94A3B8),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
            textAlign: alignment == CrossAxisAlignment.end
                ? TextAlign.end
                : TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      children: [
        Icon(
          Icons.receipt_long_rounded,
          size: 20.sp,
          color: const Color(0xFF6366F1),
        ),
        SizedBox(width: 8.w),
        Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '7 transactions',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF10B981),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final List<Map<String, dynamic>> transactions = [
      {
        'date': 'Dec 16, 2023',
        'time': '12:30 PM',
        'amount': '₹500.00',
        'type': 'Deposit',
        'isCredit': true,
      },
      {
        'date': 'Dec 14, 2023',
        'time': '10:15 AM',
        'amount': '₹300.00',
        'type': 'Deposit',
        'isCredit': true,
      },
      {
        'date': 'Dec 12, 2023',
        'time': '03:45 PM',
        'amount': '₹400.00',
        'type': 'Withdrawal',
        'isCredit': false,
      },
      {
        'date': 'Dec 10, 2023',
        'time': '11:20 AM',
        'amount': '₹200.00',
        'type': 'Deposit',
        'isCredit': true,
      },
      {
        'date': 'Dec 08, 2023',
        'time': '04:10 PM',
        'amount': '₹600.00',
        'type': 'Withdrawal',
        'isCredit': false,
      },
      {
        'date': 'Dec 06, 2023',
        'time': '09:30 AM',
        'amount': '₹350.00',
        'type': 'Deposit',
        'isCredit': true,
      },
      {
        'date': 'Dec 04, 2023',
        'time': '02:15 PM',
        'amount': '₹800.00',
        'type': 'Deposit',
        'isCredit': true,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final transaction = entry.value;
          final isLast = index == transactions.length - 1;

          return _buildTransactionItem(
            transaction,
            isLast: isLast,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(
    Map<String, dynamic> transaction, {
    bool isLast = false,
  }) {
    final isCredit = transaction['isCredit'] as bool;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0xFFF1F5F9),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFF10B981).withAlpha((255 * 0.1).round())
                  : const Color(0xFFEF4444).withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color:
                  isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['type'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${transaction['date']} • ${transaction['time']}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}${transaction['amount']}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isCredit
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isCredit
                      ? const Color(0xFF10B981).withAlpha((255 * 0.1).round())
                      : const Color(0xFFEF4444).withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  isCredit ? 'CR' : 'DR',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isCredit
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(0xFF6366F1).withAlpha((255 * 0.3).round()),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _printMiniStatement(context),
                  borderRadius: BorderRadius.circular(28.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.print_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Print Statement',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareMiniStatement(BuildContext context) async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Statement shared successfully!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  Future<void> _printMiniStatement(BuildContext context) async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
            SizedBox(height: 16.h),
            const Text('Preparing statement for print...'),
          ],
        ),
      ),
    );

    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Statement sent to printer!'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.w),
        ),
      );
    }
  }
}

// import 'dart:developer';
// import 'dart:ui';

// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MiniStatement extends StatelessWidget {
//   static String routeName =
//       "/modules/collect-screen-module/mini_statement_screen";

//   const MiniStatement({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (ModalRoute.of(context)!.settings.arguments != null) {
//       final args = ModalRoute.of(context)!.settings.arguments as String;
//       log("Arguments: $args");
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(miniStatement,
//             style: TextStyle(
//                 color: corporateBlueDark,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w500)),
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.close_rounded, color: corporateBlueDark)),
//         backgroundColor: Colors.grey.shade100,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: corporateBlueDark),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share, color: corporateBlueDark),
//             onPressed: () => _shareMiniStatement(context),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Date Time section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Dec 16, 2023',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(
//                     width: getProportionateWidth(16.0),
//                   ),
//                   Text(
//                     '12:30 PM',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ).withPadding(EdgeInsets.symmetric(
//                   horizontal: getProportionateWidth(16.0),
//                   vertical: getProportionateHeight(8.0))),

//               Text(
//                 'Jamna Mobiles',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ).withPadding(EdgeInsets.symmetric(
//                   horizontal: getProportionateWidth(16.0),
//                   vertical: getProportionateHeight(8.0))),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Account Type: Savings',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ).withPadding(EdgeInsets.symmetric(
//                       horizontal: getProportionateWidth(16.0),
//                       vertical: getProportionateHeight(8.0))),
//                   Text(
//                     '#01234******',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ).withPadding(EdgeInsets.symmetric(
//                       horizontal: getProportionateWidth(16.0),
//                       vertical: getProportionateHeight(8.0))),
//                 ],
//               ),

//               // Divider
//               const Divider(
//                 height: 1,
//                 thickness: 1,
//                 indent: 10,
//                 endIndent: 20,
//                 color: Colors.black12,
//               ),

//               SizedBox(height: getHeight() * 0.6, child: TransactionTable()),
//             ],
//           ).withMargin(
//             EdgeInsets.symmetric(
//               horizontal: getProportionateWidth(24.0),
//               vertical: getProportionateHeight(16.0),
//             ),
//           ),
//           const Spacer(),
//           Container(
//             width: double.infinity,
//             padding:
//                 EdgeInsets.symmetric(vertical: getProportionateHeight(14.0)),
//             decoration: BoxDecoration(
//               color: trendDark,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: const Center(
//               child: Text(
//                 print,
//                 style: TextStyle(
//                   color: kWhite,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           )
//               .withPadding(
//                 EdgeInsets.symmetric(
//                   horizontal: getProportionateWidth(16.0),
//                   vertical: getProportionateHeight(16.0),
//                 ),
//               )
//               .onClick(
//                 onClick: () => _printMiniStatement(context),
//                 borderRadius: BorderRadius.circular(30),
//                 splashColor: Colors.white.withOpacity(0.1),
//               )
//         ],
//       ),
//     );
//   }

//   Future<void> _shareMiniStatement(BuildContext context) async {}

//   Future<void> _printMiniStatement(BuildContext context) async {}
// }

// class TransactionTable extends StatelessWidget {
//   final List<Map<String, String>> transactions = [
//     {'date': 'Dec 16, 2023', 'amount': '₹500.00', 'type': 'Deposit'},
//     {'date': 'Dec 14, 2023', 'amount': '₹300.00', 'type': 'Deposit'},
//     {'date': 'Dec 12, 2023', 'amount': '₹400.00', 'type': 'Withdrawal'},
//     {'date': 'Dec 10, 2023', 'amount': '₹200.00', 'type': 'Deposit'},
//     {'date': 'Dec 08, 2023', 'amount': '₹600.00', 'type': 'Withdrawal'},
//     {'date': 'Dec 06, 2023', 'amount': '₹350.00', 'type': 'Deposit'},
//     {'date': 'Dec 04, 2023', 'amount': '₹800.00', 'type': 'Deposit'},
//   ];

//   TransactionTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Fixed Header
//         Table(
//           columnWidths: const {
//             0: FlexColumnWidth(2),
//             1: FlexColumnWidth(1),
//             2: FlexColumnWidth(1.5),
//           },
//           children: [
//             TableRow(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//               ),
//               children: [
//                 _buildHeaderCell('Date/Time'),
//                 _buildHeaderCell('Amount'),
//                 _buildHeaderCell('Transaction'),
//               ],
//             ),
//           ],
//         ),
//         // Scrollable Content
//         Expanded(
//           child: SingleChildScrollView(
//             child: Table(
//               columnWidths: const {
//                 0: FlexColumnWidth(2),
//                 1: FlexColumnWidth(1),
//                 2: FlexColumnWidth(1.5),
//               },
//               border: TableBorder(
//                 horizontalInside: BorderSide(
//                   color: Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//               ),
//               children: transactions
//                   .map((transaction) => _buildDataRow(
//                         transaction['date']!,
//                         transaction['amount']!,
//                         transaction['type']!,
//                       ))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   TableCell _buildHeaderCell(String text) {
//     return TableCell(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }

//   TableRow _buildDataRow(String date, String amount, String type) {
//     return TableRow(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       children: [
//         _buildDataCell(date, TextAlign.left),
//         _buildDataCell(amount, TextAlign.right),
//         _buildDataCell(type, TextAlign.right),
//       ],
//     );
//   }

//   Widget _buildDataCell(String text, TextAlign alignment) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//       child: Text(
//         text,
//         textAlign: alignment,
//         style: TextStyle(
//           fontSize: 14.sp,
//           color: text == 'Withdrawal' ? Colors.red : Colors.black87,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
