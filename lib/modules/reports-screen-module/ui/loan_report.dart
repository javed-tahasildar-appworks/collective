import 'package:collectiv/modules/reports-screen-module/ui/loan_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Modern Color Scheme
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
}

class LoanRecord {
  final String accountNumber;
  final String name;
  final double amount;
  final bool isActive;
  final String? phoneNumber;
  final DateTime? lastPayment;

  LoanRecord({
    required this.accountNumber,
    required this.name,
    required this.amount,
    required this.isActive,
    this.phoneNumber,
    this.lastPayment,
  });
}

// Enhanced sample data
final List<LoanRecord> _allLoanRecords = [
  LoanRecord(
    accountNumber: "LN001234",
    name: "John Smith",
    amount: 25000.00,
    isActive: true,
    phoneNumber: "+91 98765 43210",
    lastPayment: DateTime.now().subtract(const Duration(days: 5)),
  ),
  LoanRecord(
    accountNumber: "LN005678",
    name: "Sarah Johnson",
    amount: 75000.00,
    isActive: true,
    phoneNumber: "+91 98765 43211",
    lastPayment: DateTime.now().subtract(const Duration(days: 12)),
  ),
  LoanRecord(
    accountNumber: "LN009012",
    name: "Michael Brown",
    amount: 15000.00,
    isActive: false,
    phoneNumber: "+91 98765 43212",
    lastPayment: DateTime.now().subtract(const Duration(days: 45)),
  ),
  LoanRecord(
    accountNumber: "LN003456",
    name: "Jessica Williams",
    amount: 50000.00,
    isActive: true,
    phoneNumber: "+91 98765 43213",
    lastPayment: DateTime.now().subtract(const Duration(days: 3)),
  ),
  LoanRecord(
    accountNumber: "LN007890",
    name: "David Lee",
    amount: 30000.00,
    isActive: false,
    phoneNumber: "+91 98765 43214",
    lastPayment: DateTime.now().subtract(const Duration(days: 30)),
  ),
  LoanRecord(
    accountNumber: "LN002345",
    name: "Jennifer Davis",
    amount: 100000.00,
    isActive: true,
    phoneNumber: "+91 98765 43215",
    lastPayment: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

// State management classes remain the same
class SearchState {
  final String query;
  const SearchState({this.query = ''});
  SearchState copyWith({String? query}) {
    return SearchState(query: query ?? this.query);
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());
  void updateSearchQuery(String query) {
    state = state.copyWith(query: query);
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

final loanRecordsProvider = Provider<List<LoanRecord>>((ref) {
  return _allLoanRecords;
});

final filteredLoanRecordsProvider = Provider<List<LoanRecord>>((ref) {
  final searchState = ref.watch(searchProvider);
  final loanRecords = ref.watch(loanRecordsProvider);
  final query = searchState.query.toLowerCase();

  if (query.isEmpty) {
    return loanRecords;
  }

  return loanRecords.where((record) {
    return record.name.toLowerCase().contains(query) ||
        record.accountNumber.toLowerCase().contains(query);
  }).toList();
});

class LoanReport extends ConsumerWidget {
  static const String routeName = "/modules/reports-screen-module/loan_report";

  const LoanReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRecords = ref.watch(filteredLoanRecordsProvider);
    final activeLoans = filteredRecords.where((r) => r.isActive).length;
    final totalAmount =
        filteredRecords.fold<double>(0, (sum, record) => sum + record.amount);

    return Scaffold(
      backgroundColor: AppColors.softGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref),
            _buildSummaryCards(
                activeLoans, filteredRecords.length, totalAmount),
            _buildSearchBar(ref),
            Expanded(child: _buildLoansList(ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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
                  'Loan Reports',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Manage your portfolio',
                  style: TextStyle(
                    fontSize: 12.sp,
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
              Icons.filter_list_rounded,
              color: AppColors.primaryBlue,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
      int activeLoans, int totalLoans, double totalAmount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Active Loans',
              '$activeLoans',
              'of $totalLoans total',
              AppColors.success,
              Icons.trending_up_rounded,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildSummaryCard(
              'Total Amount',
              '₹${(totalAmount / 100000).toStringAsFixed(1)}L',
              'Portfolio value',
              AppColors.primaryBlue,
              Icons.account_balance_wallet_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, String subtitle, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20.w),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: TextField(
        onChanged: (value) {
          ref.read(searchProvider.notifier).updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search loans, names, or account numbers...',
          hintStyle: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textTertiary,
            size: 20.w,
          ),
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoansList(WidgetRef ref) {
    final filteredRecords = ref.watch(filteredLoanRecordsProvider);

    if (filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48.w,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No loan records found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        return _buildLoanCard(record, context);
      },
    );
  }

  Widget _buildLoanCard(LoanRecord record, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
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
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.primaryBlue.withAlpha((255 * 0.7).round()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    record.name.split(' ').map((e) => e[0]).take(2).join(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Name and Account
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'A/C: ${record.accountNumber}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: record.isActive
                      ? AppColors.successLight
                      : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  record.isActive ? 'Active' : 'Closed',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        record.isActive ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Amount and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loan Amount',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹${record.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildActionButton(
                    Icons.phone_rounded,
                    AppColors.success,
                    () {
                      // Handle phone call
                    },
                  ),
                  SizedBox(width: 12.w),
                  _buildActionButton(
                    Icons.arrow_forward_ios_rounded,
                    AppColors.primaryBlue,
                    () {
                      // Navigate to loan details
                      Navigator.pushNamed(context, LoanDetails.routeName,
                          arguments: record);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withAlpha((255 * 0.1).round()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 16.w,
        ),
      ),
    );
  }
}

// import 'package:collectiv/modules/reports-screen-module/ui/loan_details.dart';
// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/search_bar_widget.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class LoanRecord {
//   final String accountNumber;
//   final String name;
//   final double amount;
//   final bool isActive;

//   LoanRecord({
//     required this.accountNumber,
//     required this.name,
//     required this.amount,
//     required this.isActive,
//   });
// }

// // Sample data
// final List<LoanRecord> _allLoanRecords = [
//   LoanRecord(
//     accountNumber: "LN001234",
//     name: "John Smith",
//     amount: 25000.00,
//     isActive: true,
//   ),
//   LoanRecord(
//     accountNumber: "LN005678",
//     name: "Sarah Johnson",
//     amount: 75000.00,
//     isActive: true,
//   ),
//   LoanRecord(
//     accountNumber: "LN009012",
//     name: "Michael Brown",
//     amount: 15000.00,
//     isActive: false,
//   ),
//   LoanRecord(
//     accountNumber: "LN003456",
//     name: "Jessica Williams",
//     amount: 50000.00,
//     isActive: true,
//   ),
//   LoanRecord(
//     accountNumber: "LN007890",
//     name: "David Lee",
//     amount: 30000.00,
//     isActive: false,
//   ),
//   LoanRecord(
//     accountNumber: "LN002345",
//     name: "Jennifer Davis",
//     amount: 100000.00,
//     isActive: true,
//   ),
//   LoanRecord(
//     accountNumber: "LN006789",
//     name: "Robert Wilson",
//     amount: 45000.00,
//     isActive: true,
//   ),
//   LoanRecord(
//     accountNumber: "LN000123",
//     name: "Maria Garcia",
//     amount: 60000.00,
//     isActive: false,
//   ),
// ];

// // State class for the search query
// class SearchState {
//   final String query;

//   const SearchState({this.query = ''});

//   SearchState copyWith({String? query}) {
//     return SearchState(query: query ?? this.query);
//   }
// }

// // Search query state notifier
// class SearchNotifier extends StateNotifier<SearchState> {
//   SearchNotifier() : super(const SearchState());

//   void updateSearchQuery(String query) {
//     state = state.copyWith(query: query);
//   }
// }

// // Providers
// final searchProvider =
//     StateNotifierProvider<SearchNotifier, SearchState>((ref) {
//   return SearchNotifier();
// });

// final loanRecordsProvider = Provider<List<LoanRecord>>((ref) {
//   return _allLoanRecords;
// });

// final filteredLoanRecordsProvider = Provider<List<LoanRecord>>((ref) {
//   final searchState = ref.watch(searchProvider);
//   final loanRecords = ref.watch(loanRecordsProvider);
//   final query = searchState.query.toLowerCase();

//   if (query.isEmpty) {
//     return loanRecords;
//   }

//   return loanRecords.where((record) {
//     return record.name.toLowerCase().contains(query) ||
//         record.accountNumber.toLowerCase().contains(query);
//   }).toList();
// });

// // StatelessWidget implementation of LoanReport using Riverpod
// class LoanReport extends ConsumerWidget {
//   static const String routeName = "/modules/reports-screen-module/loan_report";

//   const LoanReport({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         title: Text(loanReport,
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
//       body: Column(
//         children: [
//           SearchBarWidget(
//             onChanged: (value) {
//               ref.read(searchProvider.notifier).updateSearchQuery(value);
//             },
//           ),
//           _buildLoansList(ref),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoansList(WidgetRef ref) {
//     final filteredRecords = ref.watch(filteredLoanRecordsProvider);

//     return Expanded(
//       child: filteredRecords.isEmpty
//           ? Center(
//               child: Text(
//                 'No loan records found',
//                 style: TextStyle(fontSize: 18.sp),
//               ),
//             )
//           : ListView.separated(
//               itemCount: filteredRecords.length,
//               separatorBuilder: (context, index) => const Divider(
//                 height: 1,
//                 thickness: 1,
//                 indent: 16,
//                 endIndent: 16,
//                 color: dividerColor,
//               ),
//               itemBuilder: (context, index) {
//                 final record = filteredRecords[index];
//                 return ListTile(
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: getProportionateWidth(16.0),
//                     vertical:
//                         getProportionateHeight(8.0), // Added vertical padding
//                   ),
//                   title: IntrinsicHeight(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment:
//                           CrossAxisAlignment.stretch, // Fill available height
//                       children: [
//                         // Left Column (Name & Account Number)
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 record.name,
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: trendDark,
//                                 ),
//                               ),
//                               Text(
//                                 'A/C: ${record.accountNumber}',
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   color: trend,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Right Column (Amount & Status)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '₹${record.amount.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w800,
//                                 color: trendDark,
//                               ),
//                             ),
//                             SizedBox(
//                                 height: getProportionateHeight(
//                                     16)), // Reduced spacing
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: getProportionateWidth(8),
//                                 vertical: getProportionateHeight(
//                                     8), // Reduced padding
//                               ),
//                               decoration: BoxDecoration(
//                                 color: record.isActive
//                                     ? Colors.green.shade100
//                                     : trendLight.withOpacity(0.5),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 record.isActive ? 'Active' : 'Closed',
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   color: record.isActive
//                                       ? Colors.green.shade800
//                                       : trendDark,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   onTap: () => Navigator.pushNamed(
//                     context,
//                     LoanDetails.routeName,
//                     arguments: record,
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
