import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
import 'package:collectiv/modules/reports-screen-module/models/collection_transaction_response_model.dart';
import 'package:collectiv/modules/reports-screen-module/provider/reports_provider.dart';
import 'package:collectiv/utils/app_extensions.dart';
import 'package:collectiv/utils/color_constants.dart';
import 'package:collectiv/utils/search_bar_widget.dart';
import 'package:collectiv/utils/size_config.dart';
import 'package:collectiv/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TotalCollectionReport extends ConsumerWidget {
  static String routeName =
      "/modules/reports-screen-module/total_collection_report";

  const TotalCollectionReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the client list once
    final collectionTransactionsList =
        ref.watch(collectionTransactionsListProvider);
    if (collectionTransactionsList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(collectionTransactionsListProvider.notifier).state = [
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
            clientId: "987654325",
            clientName: "Amit Ray",
            transactionId: "1234567894",
            transactionDate: "27-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "Cash",
            status: "Pending",
            amount: 5000,
            accountType: "Savings A/C",
            accountNumber: "1234567894",
          ),
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
            clientId: "987654326",
            clientName: "Vishal Kumar",
            transactionId: "1234567895",
            transactionDate: "26-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "UPI",
            status: "Done",
            amount: 6000,
            accountType: "Loan A/C",
            accountNumber: "1234567895",
          ),
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
            clientId: "987654327",
            clientName: "Priya Sharma",
            transactionId: "1234567896",
            transactionDate: "26-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "Cash",
            status: "Failed",
            amount: 7000,
            accountType: "Savings A/C",
            accountNumber: "1234567896",
          ),
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
            clientId: "987654328",
            clientName: "Rahul Verma",
            transactionId: "1234567897",
            transactionDate: "26-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "UPI",
            status: "Done",
            amount: 8000,
            accountType: "Loan A/C",
            accountNumber: "1234567897",
          ),
        ];
        ref.read(filteredCollectionTransactionsProvider.notifier).state = [
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
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
            clientPhoto: clientPhoto,
            clientId: "987654325",
            clientName: "Amit Ray",
            transactionId: "1234567894",
            transactionDate: "27-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "Cash",
            status: "Pending",
            amount: 5000,
            accountType: "Savings A/C",
            accountNumber: "1234567894",
          ),
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
            clientId: "987654326",
            clientName: "Vishal Kumar",
            transactionId: "1234567895",
            transactionDate: "26-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "UPI",
            status: "Done",
            amount: 6000,
            accountType: "Loan A/C",
            accountNumber: "1234567895",
          ),
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
            clientId: "987654327",
            clientName: "Priya Sharma",
            transactionId: "1234567896",
            transactionDate: "26-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "Cash",
            status: "Failed",
            amount: 7000,
            accountType: "Savings A/C",
            accountNumber: "1234567896",
          ),
          CollectionTransactionResponseModel(
            clientPhoto: clientPhoto,
            clientId: "987654328",
            clientName: "Rahul Verma",
            transactionId: "1234567897",
            transactionDate: "26-04-2025",
            transactionTime: "11:29 AM",
            paymentMode: "UPI",
            status: "Done",
            amount: 8000,
            accountType: "Loan A/C",
            accountNumber: "1234567897",
          ),
        ];
      });
    }

    final filteredCollectionTransactions =
        ref.watch(filteredCollectionTransactionsProvider);
    ref.watch(collectionTransactionsSearchQueryProvider);

    // Group transactions by date
    final Map<String, List<CollectionTransactionResponseModel>>
        groupedTransactions = {};

    for (var transaction in filteredCollectionTransactions) {
      final date = transaction.transactionDate ?? "";
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    // Sort dates in descending order (newest first)
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => _compareDates(b, a));

    // Calculate total collection
    final totalAmount = filteredCollectionTransactions.fold<double>(
      0.0,
      (sum, transaction) => sum + (transaction.amount ?? 0),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 175.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.9 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1E293B),
                  size: 20,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Collection Report',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((255 * 0.2).round()),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  Colors.white.withAlpha((255 * 0.3).round()),
                            ),
                          ),
                          child: Text(
                            'Total: ₹${totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildModernSearchBar(ref),
            ),
          ),

          // Transactions List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (sortedDates.isEmpty) {
                  return _buildEmptyState();
                }

                final dateEntries = <MapEntry<String, dynamic>>[];
                for (final date in sortedDates) {
                  dateEntries.add(MapEntry(date, date)); // Date header
                  for (final transaction in groupedTransactions[date]!) {
                    dateEntries.add(MapEntry(date, transaction)); // Transaction
                  }
                }

                if (index >= dateEntries.length) return null;

                final entry = dateEntries[index];
                final item = entry.value;

                if (item is String) {
                  return _buildModernDateHeader(item);
                } else {
                  final transaction =
                      item as CollectionTransactionResponseModel;
                  return _buildModernTransactionCard(context, transaction);
                }
              },
              childCount: sortedDates.isEmpty
                  ? 1
                  : sortedDates.fold<int>(
                      0,
                      (count, date) =>
                          count + 1 + groupedTransactions[date]!.length,
                    ),
            ),
          ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: 25.h),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSearchBar(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          ref.read(collectionTransactionsSearchQueryProvider.notifier).state =
              value;
          _filterClients(ref);
        },
        decoration: InputDecoration(
          hintText: 'Search by name or account...',
          hintStyle: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF667EEA),
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildModernDateHeader(String dateStr) {
    String formattedDate = dateStr;

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
        formattedDate = "Today";
      } else if (compareDate == yesterdayDate) {
        formattedDate = "Yesterday";
      } else {
        formattedDate = DateFormat("dd MMM yyyy").format(date);
      }
    } catch (e) {
      // Keep original if parsing fails
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTransactionCard(
      BuildContext context, CollectionTransactionResponseModel transaction) {
    final statusColor = _getStatusColor(transaction.status ?? "");
    final statusBgColor = _getStatusBackgroundColor(transaction.status ?? "");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(
              context,
              PaymentReceiptScreen.routeName,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF667EEA)
                                .withAlpha((0.1 * 255).round()),
                            const Color(0xFF764BA2)
                                .withAlpha((0.1 * 255).round()),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF667EEA)
                              .withAlpha((0.2 * 255).round()),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          transaction.clientPhoto ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF667EEA)
                                        .withAlpha((0.1 * 255).round()),
                                    const Color(0xFF764BA2)
                                        .withAlpha((0.1 * 255).round()),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Color(0xFF667EEA),
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  transaction.clientName ?? "",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E293B),
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  transaction.status ?? "",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "A/C ${transaction.accountNumber}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${transaction.amount}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPaymentModeColor(
                                      transaction.paymentMode ?? "")
                                  .withAlpha((0.1 * 255).round()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              transaction.paymentMode ?? "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: _getPaymentModeColor(
                                    transaction.paymentMode ?? ""),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.transactionTime ?? "",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
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
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withAlpha((0.1 * 255).round()),
                  const Color(0xFF764BA2).withAlpha((0.1 * 255).round()),
                ],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: Color(0xFF667EEA),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return const Color(0xFF059669);
      case 'pending':
        return const Color(0xFFD97706);
      case 'failed':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return const Color(0xFF059669).withAlpha((0.1 * 255).round());
      case 'pending':
        return const Color(0xFFD97706).withAlpha((0.1 * 255).round());
      case 'failed':
        return const Color(0xFFDC2626).withAlpha((0.1 * 255).round());
      default:
        return const Color(0xFF64748B).withAlpha((0.1 * 255).round());
    }
  }

  Color _getPaymentModeColor(String paymentMode) {
    switch (paymentMode.toLowerCase()) {
      case 'upi':
        return const Color(0xFF7C3AED);
      case 'cash':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF0F766E);
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

  void _filterClients(WidgetRef ref) {
    final query =
        ref.read(collectionTransactionsSearchQueryProvider).toLowerCase();
    final clients = ref.read(collectionTransactionsListProvider);

    ref.read(filteredCollectionTransactionsProvider.notifier).state =
        clients.where((transaction) {
      final nameMatch = transaction.clientName!.toLowerCase().contains(query);
      final idMatch = transaction.clientId!.toLowerCase().contains(query);
      final accountMatch =
          transaction.accountNumber!.toLowerCase().contains(query);
      return nameMatch || idMatch || accountMatch;
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

// class TotalCollectionReport extends ConsumerWidget {
//   static String routeName =
//       "/modules/reports-screen-module/total_collection_report";

//   const TotalCollectionReport({super.key});

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
//         title: Text(collectionReport,
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
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
//                     Text.rich(TextSpan(
//                       text: "${transaction.accountType} : ",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                         color: dividentLight,
//                       ),
//                       children: <InlineSpan>[
//                         TextSpan(
//                           text: "${transaction.amount}/-",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w900,
//                             color: wealthyGreen,
//                           ),
//                         ),
//                       ],
//                     )),
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
