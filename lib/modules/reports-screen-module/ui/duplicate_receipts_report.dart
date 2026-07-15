import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Model class for collection transaction
class CollectionTransactionResponseModel {
  final String? clientPhoto;
  final String? clientId;
  final String? clientName;
  final String? transactionId;
  final String? transactionDate;
  final String? transactionTime;
  final String? paymentMode;
  final String? status;
  final double? amount;
  final String? accountType;
  final String? accountNumber;

  CollectionTransactionResponseModel({
    this.clientPhoto,
    this.clientId,
    this.clientName,
    this.transactionId,
    this.transactionDate,
    this.transactionTime,
    this.paymentMode,
    this.status,
    this.amount,
    this.accountType,
    this.accountNumber,
  });
}

/// Modern color palette
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color pending = Color(0xFF8B5CF6);
  static const Color divider = Color(0xFFE2E8F0);
}

/// Payment mode configuration
enum PaymentMode {
  cash('Cash', Icons.money_rounded, AppColors.success),
  upi('UPI', Icons.qr_code_rounded, AppColors.primary),
  card('Card', Icons.credit_card_rounded, AppColors.warning);

  const PaymentMode(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;

  static PaymentMode fromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'cash':
        return PaymentMode.cash;
      case 'upi':
        return PaymentMode.upi;
      case 'card':
        return PaymentMode.card;
      default:
        return PaymentMode.cash;
    }
  }
}

/// Transaction status configuration
enum TransactionStatus {
  done('Done', AppColors.success),
  pending('Pending', AppColors.warning),
  failed('Failed', AppColors.error);

  const TransactionStatus(this.label, this.color);
  final String label;
  final Color color;

  static TransactionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return TransactionStatus.done;
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}

/// Providers (assuming these exist in your app)
final collectionTransactionsListProvider =
    StateProvider<List<CollectionTransactionResponseModel>>((ref) => []);
final filteredCollectionTransactionsProvider =
    StateProvider<List<CollectionTransactionResponseModel>>((ref) => []);
final collectionTransactionsSearchQueryProvider =
    StateProvider<String>((ref) => '');

/// Modern Duplicate Receipts Report Widget
class DuplicateReceiptsReport extends ConsumerStatefulWidget {
  static String routeName =
      "/modules/reports-screen-module/duplicate_receipts_report";

  const DuplicateReceiptsReport({super.key});

  @override
  ConsumerState<DuplicateReceiptsReport> createState() =>
      _DuplicateReceiptsReportState();
}

class _DuplicateReceiptsReportState
    extends ConsumerState<DuplicateReceiptsReport>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeData() {
    final sampleData = [
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1494790108755-2616b332c1cd?w=150",
        clientId: "987654329",
        clientName: "Sneha Gupta",
        transactionId: "1234567898",
        transactionDate: "30-04-2025",
        transactionTime: "11:29 AM",
        paymentMode: "Cash",
        status: "Pending",
        amount: 9000,
        accountType: "Savings A/C",
        accountNumber: "1234567898",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        clientId: "987654321",
        clientName: "John Doe",
        transactionId: "1234567890",
        transactionDate: "29-04-2025",
        transactionTime: "11:29 AM",
        paymentMode: "UPI",
        status: "Done",
        amount: 1000,
        accountType: "Savings A/C",
        accountNumber: "1234567890",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
        clientId: "987654322",
        clientName: "Jane Smith",
        transactionId: "1234567891",
        transactionDate: "28-04-2025",
        transactionTime: "11:29 AM",
        paymentMode: "Cash",
        status: "Pending",
        amount: 2000,
        accountType: "Loan A/C",
        accountNumber: "1234567891",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1489980557514-251d61e3eeb6?w=150",
        clientId: "987654323",
        clientName: "Alice Johnson",
        transactionId: "1234567892",
        transactionDate: "28-04-2025",
        transactionTime: "11:29 AM",
        paymentMode: "UPI",
        status: "Failed",
        amount: 3000,
        accountType: "Savings A/C",
        accountNumber: "1234567892",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150",
        clientId: "987654324",
        clientName: "Bob Brown",
        transactionId: "1234567893",
        transactionDate: "27-04-2025",
        transactionTime: "11:29 AM",
        paymentMode: "UPI",
        status: "Done",
        amount: 4000,
        accountType: "Loan A/C",
        accountNumber: "1234567893",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1603415526960-f7e0328d9d0f?w=150",
        clientId: "987654325",
        clientName: "Ravi Mehta",
        transactionId: "1234567894",
        transactionDate: "01-05-2025",
        transactionTime: "10:15 AM",
        paymentMode: "Bank Transfer",
        status: "Done",
        amount: 7500,
        accountType: "Savings A/C",
        accountNumber: "1234567894",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150",
        clientId: "987654326",
        clientName: "Meera Sharma",
        transactionId: "1234567895",
        transactionDate: "01-05-2025",
        transactionTime: "09:45 AM",
        paymentMode: "UPI",
        status: "Pending",
        amount: 1500,
        accountType: "Loan A/C",
        accountNumber: "1234567895",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=150",
        clientId: "987654327",
        clientName: "Kevin Patel",
        transactionId: "1234567896",
        transactionDate: "30-04-2025",
        transactionTime: "03:20 PM",
        paymentMode: "Cash",
        status: "Done",
        amount: 500,
        accountType: "Savings A/C",
        accountNumber: "1234567896",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1552058544-f2b08422138a?w=150",
        clientId: "987654328",
        clientName: "Nikita Arora",
        transactionId: "1234567897",
        transactionDate: "29-04-2025",
        transactionTime: "01:10 PM",
        paymentMode: "Cash",
        status: "Failed",
        amount: 3500,
        accountType: "Loan A/C",
        accountNumber: "1234567897",
      ),
      CollectionTransactionResponseModel(
        clientPhoto:
            "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=150",
        clientId: "987654330",
        clientName: "Amit Verma",
        transactionId: "1234567899",
        transactionDate: "28-04-2025",
        transactionTime: "05:00 PM",
        paymentMode: "UPI",
        status: "Done",
        amount: 8000,
        accountType: "Savings A/C",
        accountNumber: "1234567899",
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(collectionTransactionsListProvider.notifier).state = sampleData;
      ref.read(filteredCollectionTransactionsProvider.notifier).state =
          sampleData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions =
        ref.watch(filteredCollectionTransactionsProvider);

    // Group transactions by date
    final groupedTransactions =
        <String, List<CollectionTransactionResponseModel>>{};
    for (var transaction in filteredTransactions) {
      final date = transaction.transactionDate ?? "";
      groupedTransactions.putIfAbsent(date, () => []).add(transaction);
    }

    // Sort dates in descending order
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => _compareDates(b, a));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildModernAppBar(),
              _buildSearchSection(),
              _buildStatsCard(filteredTransactions),
              Expanded(
                child: _buildTransactionsList(groupedTransactions, sortedDates),
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
              color: AppColors.cardBackground,
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
              color: AppColors.textPrimary,
              iconSize: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Duplicate receipts report',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
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

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(collectionTransactionsSearchQueryProvider.notifier).state =
              value;
          _filterTransactions();
        },
        decoration: InputDecoration(
          hintText: 'Search by name or client ID',
          hintStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(
                            collectionTransactionsSearchQueryProvider.notifier)
                        .state = '';
                    _filterTransactions();
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppColors.textLight,
                    size: 20.sp,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      List<CollectionTransactionResponseModel> transactions) {
    final totalAmount =
        transactions.fold<double>(0, (sum, t) => sum + (t.amount ?? 0));
    final completedCount =
        transactions.where((t) => t.status?.toLowerCase() == 'done').length;
    final pendingCount =
        transactions.where((t) => t.status?.toLowerCase() == 'pending').length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha((255 * 0.3).round()),
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
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withAlpha((255 * 0.8).round()),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '₹${NumberFormat('#,##,###').format(totalAmount)}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$completedCount Done',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$pendingCount Pending',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
    Map<String, List<CollectionTransactionResponseModel>> groupedTransactions,
    List<String> sortedDates,
  ) {
    if (groupedTransactions.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final transactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date),
            ...transactions
                .map((transaction) => _buildTransactionCard(transaction)),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String dateStr) {
    String formattedDate = _formatDateHeader(dateStr);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(CollectionTransactionResponseModel transaction) {
    final paymentMode =
        PaymentMode.fromString(transaction.paymentMode ?? 'cash');
    final status =
        TransactionStatus.fromString(transaction.status ?? 'pending');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.04).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          PaymentReceiptScreen.routeName,
        ),
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24.r,
                    backgroundImage:
                        NetworkImage(transaction.clientPhoto ?? ''),
                    backgroundColor: AppColors.background,
                    onBackgroundImageError: (_, __) {},
                    child: transaction.clientPhoto == null
                        ? Icon(
                            Icons.person_rounded,
                            color: AppColors.textLight,
                            size: 24.sp,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transaction.clientName ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color:
                                  status.color.withAlpha((255 * 0.1).round()),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              status.label,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: status.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'A/C: ${transaction.accountNumber}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: paymentMode.color
                                .withAlpha((255 * 0.1).round()),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            paymentMode.icon,
                            color: paymentMode.color,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              paymentMode.label,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              transaction.transactionTime ?? '',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${NumberFormat('#,##,###').format(transaction.amount ?? 0)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        transaction.accountType ?? '',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((255 * 0.1).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 48.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No transactions found',
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

  String _formatDateHeader(String dateStr) {
    try {
      final dateFormat = DateFormat("dd-MM-yyyy");
      final date = dateFormat.parse(dateStr);
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      final todayDate = DateTime(today.year, today.month, today.day);
      final yesterdayDate =
          DateTime(yesterday.year, yesterday.month, yesterday.day);
      final compareDate = DateTime(date.year, date.month, date.day);

      if (compareDate == todayDate) {
        return "Today";
      } else if (compareDate == yesterdayDate) {
        return "Yesterday";
      } else {
        return DateFormat("dd MMM yyyy").format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }

  int _compareDates(String date1, String date2) {
    if (date1.isEmpty || date2.isEmpty) return 0;
    try {
      final format = DateFormat("dd-MM-yyyy");
      final d1 = format.parse(date1);
      final d2 = format.parse(date2);
      return d1.compareTo(d2);
    } catch (e) {
      return 0;
    }
  }

  void _filterTransactions() {
    final query =
        ref.read(collectionTransactionsSearchQueryProvider).toLowerCase();
    final allTransactions = ref.read(collectionTransactionsListProvider);

    ref.read(filteredCollectionTransactionsProvider.notifier).state =
        allTransactions.where((transaction) {
      final nameMatch =
          transaction.clientName?.toLowerCase().contains(query) ?? false;
      final idMatch =
          transaction.clientId?.toLowerCase().contains(query) ?? false;
      return nameMatch || idMatch;
    }).toList();
  }
}

// import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
// import 'package:collectiv/modules/reports-screen-module/models/collection_transaction_response_model.dart';
// import 'package:collectiv/modules/reports-screen-module/provider/reports_provider.dart';
// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/search_bar_widget.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// class DuplicateReceiptsReport extends ConsumerWidget {
//   static String routeName =
//       "/modules/reports-screen-module/duplicate_receipts_report";

//   const DuplicateReceiptsReport({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Initialize the client list once
//     final collectionTransactionsList =
//         ref.watch(collectionTransactionsListProvider);
//     if (collectionTransactionsList.isEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(collectionTransactionsListProvider.notifier).state = [
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654329",
//             clientName: "Sneha Gupta",
//             transactionId: "1234567898",
//             transactionDate: "30-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Pending",
//             amount: 9000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567898",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654321",
//             clientName: "John Doe",
//             transactionId: "1234567890",
//             transactionDate: "29-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 1000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567890",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654322",
//             clientName: "Jane Smith",
//             transactionId: "1234567891",
//             transactionDate: "28-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Pending",
//             amount: 2000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567891",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654323",
//             clientName: "Alice Johnson",
//             transactionId: "1234567892",
//             transactionDate: "28-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Failed",
//             amount: 3000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567892",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654324",
//             clientName: "Bob Brown",
//             transactionId: "1234567893",
//             transactionDate: "27-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 4000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567893",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654325",
//             clientName: "Amit Ray",
//             transactionId: "1234567894",
//             transactionDate: "27-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Pending",
//             amount: 5000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567894",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654326",
//             clientName: "Vishal Kumar",
//             transactionId: "1234567895",
//             transactionDate: "26-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 6000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567895",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654327",
//             clientName: "Priya Sharma",
//             transactionId: "1234567896",
//             transactionDate: "26-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Failed",
//             amount: 7000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567896",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654328",
//             clientName: "Rahul Verma",
//             transactionId: "1234567897",
//             transactionDate: "26-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 8000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567897",
//           ),
//         ];
//         ref.read(filteredCollectionTransactionsProvider.notifier).state = [
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654329",
//             clientName: "Sneha Gupta",
//             transactionId: "1234567898",
//             transactionDate: "30-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Pending",
//             amount: 9000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567898",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654321",
//             clientName: "John Doe",
//             transactionId: "1234567890",
//             transactionDate: "29-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 1000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567890",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654322",
//             clientName: "Jane Smith",
//             transactionId: "1234567891",
//             transactionDate: "28-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Pending",
//             amount: 2000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567891",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654323",
//             clientName: "Alice Johnson",
//             transactionId: "1234567892",
//             transactionDate: "28-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Failed",
//             amount: 3000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567892",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654324",
//             clientName: "Bob Brown",
//             transactionId: "1234567893",
//             transactionDate: "27-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 4000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567893",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654325",
//             clientName: "Amit Ray",
//             transactionId: "1234567894",
//             transactionDate: "27-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Pending",
//             amount: 5000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567894",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654326",
//             clientName: "Vishal Kumar",
//             transactionId: "1234567895",
//             transactionDate: "26-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 6000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567895",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654327",
//             clientName: "Priya Sharma",
//             transactionId: "1234567896",
//             transactionDate: "26-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "Cash",
//             status: "Failed",
//             amount: 7000,
//             accountType: "Savings A/C",
//             accountNumber: "1234567896",
//           ),
//           CollectionTransactionResponseModel(
//             clientPhoto: clientPhoto,
//             clientId: "987654328",
//             clientName: "Rahul Verma",
//             transactionId: "1234567897",
//             transactionDate: "26-04-2025",
//             transactionTime: "11:29 AM",
//             paymentMode: "UPI",
//             status: "Done",
//             amount: 8000,
//             accountType: "Loan A/C",
//             accountNumber: "1234567897",
//           ),
//         ];
//       });
//     }

//     final filteredCollectionTransactions =
//         ref.watch(filteredCollectionTransactionsProvider);
//     ref.watch(collectionTransactionsSearchQueryProvider);

//     // Group transactions by date
//     final Map<String, List<CollectionTransactionResponseModel>>
//         groupedTransactions = {};

//     for (var transaction in filteredCollectionTransactions) {
//       final date = transaction.transactionDate ?? "";
//       if (!groupedTransactions.containsKey(date)) {
//         groupedTransactions[date] = [];
//       }
//       groupedTransactions[date]!.add(transaction);
//     }

//     // Sort dates in descending order (newest first)
//     final sortedDates = groupedTransactions.keys.toList()
//       ..sort((a, b) => _compareDates(b, a)); // Reverse order for newest first

//     // Create a flat list of items (dates + transactions)
//     final flattenedItems = <dynamic>[];
//     for (final date in sortedDates) {
//       flattenedItems.add(date); // Add the date header
//       flattenedItems.addAll(
//           groupedTransactions[date]!); // Add all transactions for this date
//     }

//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         title: Text(duplicateReceipts,
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
//       body: SafeArea(
//         child: Column(
//           children: [
//             SearchBarWidget(
//               onChanged: (value) {
//                 ref
//                     .read(collectionTransactionsSearchQueryProvider.notifier)
//                     .state = value;
//                 _filterClients(ref);
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: flattenedItems.length,
//                 itemBuilder: (context, index) {
//                   final item = flattenedItems[index];

//                   // If this item is a date string, render a date header
//                   if (item is String) {
//                     return _buildDateHeader(item);
//                   }

//                   // Otherwise, render a transaction item
//                   final transaction =
//                       item as CollectionTransactionResponseModel;
//                   return _buildTransactionItem(context, transaction);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Parse DD-MM-YYYY format dates for comparison
//   int _compareDates(String date1, String date2) {
//     if (date1.isEmpty || date2.isEmpty) return 0;

//     try {
//       final format = DateFormat("dd-MM-yyyy");
//       final d1 = format.parse(date1);
//       final d2 = format.parse(date2);
//       return d1.compareTo(d2);
//     } catch (e) {
//       return 0;
//     }
//   }

//   Widget _buildDateHeader(String dateStr) {
//     String formattedDate = dateStr;

//     try {
//       // Parse date from DD-MM-YYYY format
//       final dateFormat = DateFormat("dd-MM-yyyy");
//       final date = dateFormat.parse(dateStr);

//       // Get today and yesterday
//       final today = DateTime.now();
//       final yesterday = DateTime.now().subtract(const Duration(days: 1));

//       // Format dates for comparison (ignoring time)
//       final todayDate = DateTime(today.year, today.month, today.day);
//       final yesterdayDate =
//           DateTime(yesterday.year, yesterday.month, yesterday.day);
//       final compareDate = DateTime(date.year, date.month, date.day);

//       // Display as "Today", "Yesterday", or formatted date
//       if (compareDate == todayDate) {
//         formattedDate = "Today";
//       } else if (compareDate == yesterdayDate) {
//         formattedDate = "Yesterday";
//       } else {
//         formattedDate = DateFormat("dd MMM yyyy").format(date);
//       }
//     } catch (e) {
//       // Keep original if parsing fails
//     }

//     return SizedBox(
//       width: double.infinity,
//       child: Align(
//         alignment: Alignment.topLeft,
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: getProportionateWidth(8.0),
//             vertical: getProportionateHeight(3.0),
//           ),
//           child: Text(
//             formattedDate,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w300,
//               color: trend,
//             ),
//           ),
//         ),
//       ),
//     ).withMargin(
//       EdgeInsets.symmetric(
//         vertical: getProportionateHeight(8.0),
//         horizontal: getProportionateWidth(16.0),
//       ),
//     );
//   }

//   Widget _buildTransactionItem(
//       BuildContext context, CollectionTransactionResponseModel transaction) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(8),
//             leading: CircleAvatar(
//               radius: 28,
//               backgroundImage: NetworkImage(transaction.clientPhoto ?? ""),
//               backgroundColor: Colors.grey[200],
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "A/C No : ${transaction.accountNumber}",
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w600,
//                         color: trend,
//                       ),
//                     ),
//                     Text(
//                       transaction.transactionTime ?? "",
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w600,
//                         color: trendLight,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: getProportionateHeight(4.0)),
//                 Text(
//                   transaction.clientName ?? "",
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: trend,
//                   ),
//                 ),
//                 SizedBox(height: getProportionateHeight(4.0)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${transaction.accountType} : ${transaction.amount}/-",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w800,
//                         color: trend,
//                       ),
//                     ),
//                     Text(
//                       transaction.paymentMode ?? "",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w700,
//                         color: corporateBlue,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             onTap: () {
//               Navigator.pushNamed(
//                 context,
//                 PaymentReceiptScreen.routeName,
//               );
//             },
//           ),
//         ),
//         const Divider(
//           height: 1,
//           thickness: 1,
//           indent: 72,
//           endIndent: 16,
//           color: dividerColor,
//         ),
//       ],
//     );
//   }

//   void _filterClients(WidgetRef ref) {
//     final query =
//         ref.read(collectionTransactionsSearchQueryProvider).toLowerCase();
//     final clients = ref.read(collectionTransactionsListProvider);

//     ref.read(filteredCollectionTransactionsProvider.notifier).state =
//         clients.where((transaction) {
//       final nameMatch = transaction.clientName!.toLowerCase().contains(query);
//       final idMatch = transaction.clientId!.toLowerCase().contains(query);
//       return nameMatch || idMatch;
//     }).toList();
//   }
// }
