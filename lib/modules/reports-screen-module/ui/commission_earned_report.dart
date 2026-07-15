import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Enum representing account types
enum AccountType {
  saving('Savings', Icons.savings_outlined, Color(0xFF4CAF50)),
  loan('Loan', Icons.account_balance_outlined, Color(0xFF2196F3));

  final String display;
  final IconData icon;
  final Color color;
  const AccountType(this.display, this.icon, this.color);
}

/// Model class for an individual commission entry
class CommissionEntry {
  final String name;
  final double amount;
  final AccountType accountType;
  final double commission;

  CommissionEntry({
    required this.name,
    required this.amount,
    required this.accountType,
    required this.commission,
  });
}

/// Model class for a day's commission data
class DailyCommission {
  final String date;
  final double totalCommission;
  final List<CommissionEntry> entries;

  DailyCommission({
    required this.date,
    required this.totalCommission,
    required this.entries,
  });
}

/// Modern redesigned Commission Earned Widget
class CommissionEarned extends StatefulWidget {
  static String routeName =
      "/modules/reports-screen-module/commission-earned-report";

  const CommissionEarned({super.key});

  @override
  State<CommissionEarned> createState() => _CommissionEarnedState();
}

class _CommissionEarnedState extends State<CommissionEarned>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Modern color palette
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  // Sample data for demonstration
  final List<DailyCommission> _commissionData = [
    DailyCommission(
      date: "30 Apr 2025",
      totalCommission: 1200,
      entries: [
        CommissionEntry(
          name: "Rajesh Kumar",
          amount: 50000,
          accountType: AccountType.loan,
          commission: 800,
        ),
        CommissionEntry(
          name: "Priya Sharma",
          amount: 25000,
          accountType: AccountType.saving,
          commission: 400,
        ),
      ],
    ),
    DailyCommission(
      date: "29 Apr 2025",
      totalCommission: 2100,
      entries: [
        CommissionEntry(
          name: "Amit Singh",
          amount: 75000,
          accountType: AccountType.loan,
          commission: 1200,
        ),
        CommissionEntry(
          name: "Neha Patel",
          amount: 15000,
          accountType: AccountType.saving,
          commission: 300,
        ),
        CommissionEntry(
          name: "Vijay Gupta",
          amount: 30000,
          accountType: AccountType.loan,
          commission: 600,
        ),
      ],
    ),
    DailyCommission(
      date: "28 Apr 2025",
      totalCommission: 1050,
      entries: [
        CommissionEntry(
          name: "Sunita Verma",
          amount: 40000,
          accountType: AccountType.loan,
          commission: 700,
        ),
        CommissionEntry(
          name: "Anil Kapoor",
          amount: 20000,
          accountType: AccountType.saving,
          commission: 350,
        ),
      ],
    ),
    DailyCommission(
      date: "27 Apr 2025",
      totalCommission: 1500,
      entries: [
        CommissionEntry(
          name: "Ravi Mehta",
          amount: 60000,
          accountType: AccountType.loan,
          commission: 900,
        ),
        CommissionEntry(
          name: "Sita Devi",
          amount: 30000,
          accountType: AccountType.saving,
          commission: 600,
        ),
      ],
    ),
    DailyCommission(
      date: "26 Apr 2025",
      totalCommission: 800,
      entries: [
        CommissionEntry(
          name: "Kiran Joshi",
          amount: 20000,
          accountType: AccountType.loan,
          commission: 500,
        ),
        CommissionEntry(
          name: "Raj Kumar",
          amount: 15000,
          accountType: AccountType.saving,
          commission: 300,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Format currency as Indian Rupees
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Get trend data and icon
  Map<String, dynamic> _getTrendData(int index) {
    if (index >= _commissionData.length - 1) {
      return {'icon': null, 'color': textSecondary, 'percentage': null};
    }

    final double today = _commissionData[index].totalCommission;
    final double yesterday = _commissionData[index + 1].totalCommission;
    final double percentage = ((today - yesterday) / yesterday * 100);

    if (today > yesterday) {
      return {
        'icon': Icons.trending_up_rounded,
        'color': successColor,
        'percentage': '+${percentage.toStringAsFixed(1)}%'
      };
    } else if (today < yesterday) {
      return {
        'icon': Icons.trending_down_rounded,
        'color': errorColor,
        'percentage': '${percentage.toStringAsFixed(1)}%'
      };
    } else {
      return {
        'icon': Icons.trending_flat_rounded,
        'color': textSecondary,
        'percentage': '0.0%'
      };
    }
  }

  /// Calculate total commission for summary
  double get _totalCommission {
    return _commissionData.fold(0.0, (sum, day) => sum + day.totalCommission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Modern App Bar
              _buildModernAppBar(),

              // Summary Card
              _buildSummaryCard(),

              // Commission List
              Expanded(
                child: _buildCommissionList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.05).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: textPrimary,
              iconSize: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commission Report',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                Text(
                  'Track your earnings',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha((255 * 0.3).round()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withAlpha((255 * 0.8).round()),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _formatCurrency(_totalCommission),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Last ${_commissionData.length} days',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withAlpha((255 * 0.7).round()),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: _commissionData.length,
      itemBuilder: (context, index) {
        final dailyCommission = _commissionData[index];
        final trendData = _getTrendData(index);

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((255 * 0.05).round()),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              expansionTileTheme: const ExpansionTileThemeData(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
              ),
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.all(20.w),
              childrenPadding: EdgeInsets.only(bottom: 20.h),
              title: _buildDayHeader(dailyCommission, trendData),
              children: [
                _buildCommissionEntries(dailyCommission.entries),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayHeader(
      DailyCommission dailyCommission, Map<String, dynamic> trendData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dailyCommission.date,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            if (trendData['icon'] != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: trendData['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendData['icon'],
                      color: trendData['color'],
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      trendData['percentage'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: trendData['color'],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          _formatCurrency(dailyCommission.totalCommission),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '${dailyCommission.entries.length} transactions',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommissionEntries(List<CommissionEntry> entries) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: entries.map((entry) => _buildEntryCard(entry)).toList(),
      ),
    );
  }

  Widget _buildEntryCard(CommissionEntry entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: entry.accountType.color.withAlpha((255 * 0.2).round()),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: entry.accountType.color.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  entry.accountType.icon,
                  color: entry.accountType.color,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      entry.accountType.display,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: entry.accountType.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(entry.commission),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: successColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Commission',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatCurrency(entry.amount),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// /// Enum representing account types
// enum AccountType {
//   saving('Saving A/C'),
//   loan('Loan A/C');

//   final String display;
//   const AccountType(this.display);
// }

// /// Model class for an individual commission entry
// class CommissionEntry {
//   final String name;
//   final double amount;
//   final AccountType accountType;
//   final double commission;

//   CommissionEntry({
//     required this.name,
//     required this.amount,
//     required this.accountType,
//     required this.commission,
//   });
// }

// /// Model class for a day's commission data
// class DailyCommission {
//   final String date; // String format "30 Apr 2025"
//   final double totalCommission;
//   final List<CommissionEntry> entries;

//   DailyCommission({
//     required this.date,
//     required this.totalCommission,
//     required this.entries,
//   });
// }

// /// Widget that displays a list of daily commissions in an expandable format
// class CommissionEarned extends StatelessWidget {
//   static String routeName =
//       "/modules/reports-screen-module/commission-earned-report";

//   CommissionEarned({super.key});

//   // Sample data for demonstration
//   final List<DailyCommission> _commissionData = [
//     DailyCommission(
//       date: "30 Apr 2025",
//       totalCommission: 1200,
//       entries: [
//         CommissionEntry(
//           name: "Rajesh Kumar",
//           amount: 50000,
//           accountType: AccountType.loan,
//           commission: 800,
//         ),
//         CommissionEntry(
//           name: "Priya Sharma",
//           amount: 25000,
//           accountType: AccountType.saving,
//           commission: 400,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "29 Apr 2025",
//       totalCommission: 2100,
//       entries: [
//         CommissionEntry(
//           name: "Amit Singh",
//           amount: 75000,
//           accountType: AccountType.loan,
//           commission: 1200,
//         ),
//         CommissionEntry(
//           name: "Neha Patel",
//           amount: 15000,
//           accountType: AccountType.saving,
//           commission: 300,
//         ),
//         CommissionEntry(
//           name: "Vijay Gupta",
//           amount: 30000,
//           accountType: AccountType.loan,
//           commission: 600,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "28 Apr 2025",
//       totalCommission: 1050,
//       entries: [
//         CommissionEntry(
//           name: "Sunita Verma",
//           amount: 40000,
//           accountType: AccountType.loan,
//           commission: 700,
//         ),
//         CommissionEntry(
//           name: "Anil Kapoor",
//           amount: 20000,
//           accountType: AccountType.saving,
//           commission: 350,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "27 Apr 2025",
//       totalCommission: 1500,
//       entries: [
//         CommissionEntry(
//           name: "Ravi Mehta",
//           amount: 60000,
//           accountType: AccountType.loan,
//           commission: 900,
//         ),
//         CommissionEntry(
//           name: "Sita Devi",
//           amount: 30000,
//           accountType: AccountType.saving,
//           commission: 600,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "26 Apr 2025",
//       totalCommission: 800,
//       entries: [
//         CommissionEntry(
//           name: "Kiran Joshi",
//           amount: 20000,
//           accountType: AccountType.loan,
//           commission: 500,
//         ),
//         CommissionEntry(
//           name: "Raj Kumar",
//           amount: 15000,
//           accountType: AccountType.saving,
//           commission: 300,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "25 Apr 2025",
//       totalCommission: 800,
//       entries: [
//         CommissionEntry(
//           name: "Pooja Agarwal",
//           amount: 30000,
//           accountType: AccountType.loan,
//           commission: 600,
//         ),
//         CommissionEntry(
//           name: "Ajay Singh",
//           amount: 10000,
//           accountType: AccountType.saving,
//           commission: 200,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "24 Apr 2025",
//       totalCommission: 1100,
//       entries: [
//         CommissionEntry(
//           name: "Deepak Sharma",
//           amount: 70000,
//           accountType: AccountType.loan,
//           commission: 900,
//         ),
//         CommissionEntry(
//           name: "Suman Gupta",
//           amount: 20000,
//           accountType: AccountType.saving,
//           commission: 200,
//         ),
//       ],
//     ),
//     DailyCommission(
//       date: "23 Apr 2025",
//       totalCommission: 1300,
//       entries: [
//         CommissionEntry(
//           name: "Ramesh Yadav",
//           amount: 80000,
//           accountType: AccountType.loan,
//           commission: 1000,
//         ),
//         CommissionEntry(
//           name: "Geeta Rani",
//           amount: 30000,
//           accountType: AccountType.saving,
//           commission: 300,
//         ),
//       ],
//     ),
//   ];

//   /// Format currency as Indian Rupees
//   String _formatCurrency(double amount) {
//     final formatter = NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     );
//     return '${formatter.format(amount)}/–';
//   }

//   /// Determine trend direction by comparing today's commission with yesterday's
//   Widget _getTrendIcon(int index) {
//     // Skip comparison for the last item as there's no previous day to compare
//     if (index >= _commissionData.length - 1) {
//       return const SizedBox.shrink();
//     }

//     final double today = _commissionData[index].totalCommission;
//     final double yesterday = _commissionData[index + 1].totalCommission;

//     if (today > yesterday) {
//       return Icon(
//         Icons.trending_up,
//         color: Colors.green.shade700,
//         size: 20,
//       );
//     } else if (today < yesterday) {
//       return Icon(
//         Icons.trending_down,
//         color: Colors.red.shade700,
//         size: 20,
//       );
//     } else {
//       return Icon(
//         Icons.trending_flat,
//         color: Colors.grey.shade600,
//         size: 20,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(commissionReport,
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
//       backgroundColor: kBackground,
//       body: ListView.builder(
//         padding: EdgeInsets.symmetric(
//             vertical: getProportionateHeight(16.0),
//             horizontal: getProportionateWidth(16.0)),
//         itemCount: _commissionData.length,
//         itemBuilder: (context, index) {
//           final dailyCommission = _commissionData[index];

//           return Card(
//             color: kWhite,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             margin: EdgeInsets.only(bottom: getProportionateHeight(16.0)),
//             elevation: 2,
//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 dividerColor: Colors.transparent, // Remove the divider
//               ),
//               child: ExpansionTile(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       dailyCommission.date,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w300,
//                         color: trend,
//                       ),
//                     ).withMargin(
//                       EdgeInsets.only(bottom: getProportionateHeight(16.0)),
//                     ),

//                     // Total commission amount
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             _formatCurrency(dailyCommission.totalCommission),
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w600,
//                               color: investmentDark,
//                             ),
//                           ),
//                         ),

//                         // Trend icon
//                         _getTrendIcon(index).withMargin(
//                           EdgeInsets.symmetric(
//                               horizontal: getProportionateWidth(16.0)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                     itemCount: dailyCommission.entries.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemBuilder: (context, entryIndex) {
//                       final entry = dailyCommission.entries[entryIndex];

//                       return Card(
//                         elevation: 5,
//                         color: kWhite,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildDetailRow(
//                                 context: context,
//                                 label: 'Name:',
//                                 value: entry.name,
//                               ),
//                               const SizedBox(height: 8),
//                               _buildDetailRow(
//                                 context: context,
//                                 label: 'Amount:',
//                                 value: _formatCurrency(entry.amount),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildDetailRow(
//                                 context: context,
//                                 label: 'A/C Type:',
//                                 value: entry.accountType.display,
//                               ),
//                               const SizedBox(height: 8),
//                               _buildDetailRow(
//                                 context: context,
//                                 label: 'Commission:',
//                                 value: _formatCurrency(entry.commission),
//                                 valueStyle: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: theme.colorScheme.primary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// Helper method to build consistent detail rows
//   Widget _buildDetailRow({
//     required BuildContext context,
//     required String label,
//     required String value,
//     TextStyle? valueStyle,
//   }) {
//     final theme = Theme.of(context);

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 100,
//           child: Text(
//             label,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: valueStyle ?? theme.textTheme.bodyMedium,
//           ),
//         ),
//       ],
//     );
//   }
// }
