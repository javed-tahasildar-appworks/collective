import 'package:collectiv/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Modern Color Scheme (consistent with loan report screen)
class AppColors {
  static const Color primaryBlue = Color(0xFF6B73FF);
  static const Color lightBlue = Color(0xFFF0F2FF);
  static const Color softGray = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);
  static const Color success = Color(0xFF48BB78);
  static const Color successLight = Color(0xFFE6FFFA);
  static const Color warning = Color(0xFFED8936);
  static const Color warningLight = Color(0xFFFFF5E6);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color gradientStart = Color(0xFF667EEA);
  static const Color gradientEnd = Color(0xFF764BA2);
}

class LoanRecord {
  final String accountNumber;
  final String name;
  final double amount;
  final bool isActive;
  final String loanType;
  final DateTime issuedDate;
  final double interestRate;
  final double outstanding;
  final String tenure;
  final double? emiAmount;

  LoanRecord({
    required this.accountNumber,
    required this.name,
    required this.amount,
    required this.isActive,
    required this.loanType,
    required this.issuedDate,
    required this.interestRate,
    required this.outstanding,
    required this.tenure,
    this.emiAmount,
  });
}

class LoanDetails extends StatelessWidget {
  static const String routeName = "/modules/reports-screen-module/loan_details";

  const LoanDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample loan data - in real app, this would come from arguments
    final loan = LoanRecord(
      accountNumber: "LN001234",
      name: "John Smith",
      amount: 544500.00,
      isActive: true,
      loanType: "Personal Loan",
      issuedDate: DateTime(2024, 6, 8),
      interestRate: 24.0,
      outstanding: 544500.00,
      tenure: "1 Year",
      emiAmount: null,
    );

    return Scaffold(
      backgroundColor: AppColors.softGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, loan),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildLoanCard(loan),
                    SizedBox(height: 20.h),
                    _buildLoanParticulars(loan),
                    SizedBox(height: 20.h),
                    _buildPaymentHistory(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LoanRecord loan) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryBlue,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Details',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  loan.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.more_vert_rounded,
              color: AppColors.primaryBlue,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(LoanRecord loan) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withAlpha((255 * 0.3).round()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((255 * 0.2).round()),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIDDHESHWARFIN',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '**** 0006',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withAlpha((255 * 0.8).round()),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.loanType,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withAlpha((255 * 0.8).round()),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Issued on ${_formatDate(loan.issuedDate)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withAlpha((255 * 0.6).round()),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((255 * 0.2).round()),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.percent_rounded,
                          color: Colors.white,
                          size: 14.w,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Interest: ${loan.interestRate}% p.a.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color:
                          loan.isActive ? AppColors.success : AppColors.warning,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      loan.isActive ? 'Active' : 'Closed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ).withMargin(EdgeInsets.only(top: 8.h)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanParticulars(LoanRecord loan) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.04).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Particulars',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildParticularItem(
                  'Outstanding',
                  '₹${_formatAmount(loan.outstanding)}',
                  Icons.trending_up_rounded,
                  AppColors.warning,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildParticularItem(
                  'Loan Amount',
                  '₹${_formatAmount(loan.amount)}',
                  Icons.account_balance_wallet_rounded,
                  AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildParticularItem(
                  'EMI Amount',
                  loan.emiAmount != null
                      ? '₹${_formatAmount(loan.emiAmount!)}'
                      : 'Not Available',
                  Icons.calendar_month_rounded,
                  AppColors.success,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildParticularItem(
                  'Tenure',
                  loan.tenure,
                  Icons.schedule_rounded,
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticularItem(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.08).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha((255 * 0.2).round()),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.04).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment History',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.primaryBlue,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '2025',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primaryBlue,
                    size: 20.w,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildMonthsGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthsGrid() {
    final months = [
      ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
      ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    ];
    final paidMonths = ['Jan', 'Feb', 'Mar', 'Apr'];
    final currentMonth = DateTime.now().month;

    return Column(
      children: [
        // First row
        Row(
          children: List.generate(
            months[0].length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _buildMonthTile(
                  months[0][index],
                  paidMonths.contains(months[0][index]),
                  _getMonthIndex(months[0][index]) == currentMonth,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Second row
        Row(
          children: List.generate(
            months[1].length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _buildMonthTile(
                  months[1][index],
                  paidMonths.contains(months[1][index]),
                  _getMonthIndex(months[1][index]) == currentMonth,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthTile(String month, bool isPaid, bool isCurrent) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    Widget? icon;

    if (isPaid) {
      backgroundColor = AppColors.successLight;
      textColor = AppColors.success;
      borderColor = AppColors.success.withAlpha((255 * 0.3).round());
      icon = Icon(
        Icons.check_rounded,
        color: AppColors.success,
        size: 20.w,
      );
    } else if (isCurrent) {
      backgroundColor = AppColors.warningLight;
      textColor = AppColors.warning;
      borderColor = AppColors.warning.withAlpha((255 * 0.3).round());
      icon = Icon(
        Icons.schedule_rounded,
        color: AppColors.warning,
        size: 20.w,
      );
    } else {
      backgroundColor = AppColors.softGray;
      textColor = AppColors.textTertiary;
      borderColor = AppColors.divider;
    }

    return Column(
      children: [
        Text(
          month,
          style: TextStyle(
            fontSize: 12.sp,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Center(child: icon),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  int _getMonthIndex(String month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months.indexOf(month) + 1;
  }
}

// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class LoanDetails extends StatelessWidget {
//   static const String routeName = "/modules/reports-screen-module/loan_details";

//   const LoanDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(loanDetails,
//             style: TextStyle(
//                 color: corporateBlueDark,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w500)),
//         leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                 color: corporateBlueDark)),
//         backgroundColor: kWhite,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: corporateBlueDark),
//       ),
//       backgroundColor: kWhite,
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: getProportionateWidth(24.0)),
//         children: [
//           // Loan Card
//           const LoanCard(),
//           // Loan Particulars
//           const LoanParticularSection(),

//           SizedBox(height: getProportionateHeight(16)),

//           // Payment History
//           const PaymentHistorySection(),
//         ],
//       ),
//     );
//   }
// }

// class LoanCard extends StatelessWidget {
//   const LoanCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xFFEEEEEE),
//             width: 1.0,
//           ),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Loan Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Bank Icon
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: const Color(0xFFE0E0E0)),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(
//                         Icons.account_balance,
//                         color: Color(0xFF3F51B5),
//                         size: 24,
//                       ),
//                     ),
//                     SizedBox(width: getProportionateWidth(16.0)),

//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "SIDDHESHWARFIN",
//                           style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w800,
//                               color: trendDark),
//                         ),
//                         SizedBox(height: getProportionateHeight(4)),
//                         Text(
//                           "**** 0006",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: trend,
//                           ),
//                         ),
//                         SizedBox(height: getProportionateHeight(8.0)),
//                       ],
//                     )
//                   ],
//                 ),

//                 // Interest Rate
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: getProportionateWidth(12),
//                       vertical: getProportionateHeight(4)),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFEEEEEE),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "%",
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             color: trend,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(width: getProportionateWidth(8.0)),
//                       Text(
//                         "Interest rate: 24% rpa",
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             color: trend,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Right Side
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "Personal Loan",
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: trend,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "Issued on 8 Jun 2024",
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: trendLight,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF66D7B9),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Text(
//                   "Active",
//                   style: TextStyle(
//                     color: kWhite,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LoanParticularSection extends StatelessWidget {
//   const LoanParticularSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xFFEEEEEE),
//             width: 1.0,
//           ),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Loan Particulars",
//             style: TextStyle(
//                 fontSize: 18.sp, fontWeight: FontWeight.w800, color: trendDark),
//           ),
//           SizedBox(height: getProportionateHeight(16.0)),

//           // Top row with Outstanding and Loan Amount
//           Row(
//             children: [
//               // Outstanding
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Outstanding",
//                       style: TextStyle(
//                           fontSize: 14.sp,
//                           color: trendLight,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(height: getProportionateHeight(4.0)),
//                     Text(
//                       "₹ 5,44,500",
//                       style: TextStyle(
//                           fontSize: 18.sp,
//                           color: trendDark,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ],
//                 ),
//               ),

//               // Loan Amount
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Loan Amount",
//                       style: TextStyle(
//                           fontSize: 14.sp,
//                           color: trendLight,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(height: getProportionateHeight(4.0)),
//                     Text(
//                       "₹ 5,44,500",
//                       style: TextStyle(
//                           fontSize: 18.sp,
//                           color: trendDark,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           // Bottom row with EMI Amount and Tenure
//           Row(
//             children: [
//               // EMI Amount
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "EMI Amount",
//                       style: TextStyle(
//                           fontSize: 14.sp,
//                           color: trendLight,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(height: getProportionateHeight(4.0)),
//                     Text(
//                       "Not Available",
//                       style: TextStyle(
//                           fontSize: 18.sp,
//                           color: trendDark,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ],
//                 ),
//               ),

//               // Tenure
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Tenure",
//                       style: TextStyle(
//                           fontSize: 14.sp,
//                           color: trendLight,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(height: getProportionateHeight(4.0)),
//                     Text(
//                       "1 Year",
//                       style: TextStyle(
//                           fontSize: 18.sp,
//                           color: trendDark,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PaymentHistorySection extends StatelessWidget {
//   const PaymentHistorySection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final months = [
//       ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
//       ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
//     ];

//     // Currently paid months (Jan to Apr)
//     final paidMonths = ['Jan', 'Feb', 'Mar', 'Apr'];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Payment History",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: [
//                 Icon(
//                   Icons.chevron_left,
//                   color: Color(0xFF3F51B5),
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   "2025",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         // First row of months
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(
//             months[0].length,
//             (index) => _buildMonthTile(
//                 months[0][index], paidMonths.contains(months[0][index])),
//           ),
//         ),

//         const SizedBox(height: 16),

//         // Second row of months
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(
//             months[1].length,
//             (index) => _buildMonthTile(
//                 months[1][index], paidMonths.contains(months[1][index])),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMonthTile(String month, bool isPaid) {
//     final currentMonth = DateTime.now().month;
//     final monthIndex = [
//           'Jan',
//           'Feb',
//           'Mar',
//           'Apr',
//           'May',
//           'Jun',
//           'Jul',
//           'Aug',
//           'Sep',
//           'Oct',
//           'Nov',
//           'Dec'
//         ].indexOf(month) +
//         1;

//     // Determine if this month is current, completed, or future
//     final isCurrentMonth = monthIndex == currentMonth;
//     final isCompletedMonth = isPaid;
//     final isFutureMonth = monthIndex > currentMonth;

//     Color textColor = isCurrentMonth
//         ? Colors.grey[600]!
//         : isCompletedMonth
//             ? Colors.black
//             : Colors.grey[400]!;

//     return Expanded(
//       child: Column(
//         children: [
//           Text(
//             month,
//             style: TextStyle(
//               fontSize: 16,
//               color: textColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color:
//                   isCompletedMonth ? const Color(0xFFF5F9FF) : Colors.grey[100],
//               borderRadius: BorderRadius.circular(8),
//               border: isCompletedMonth
//                   ? Border.all(color: const Color(0xFFE0E0E0))
//                   : null,
//             ),
//             child: isCompletedMonth
//                 ? const Center(
//                     child: Icon(
//                       Icons.check,
//                       color: Colors.green,
//                       size: 24,
//                     ),
//                   )
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
