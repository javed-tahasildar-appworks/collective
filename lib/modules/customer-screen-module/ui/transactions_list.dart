import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Enhanced provider with better data structure
final transactionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      "transaction_id": "#1234567890",
      "date": "2023-10-01",
      "time": "10:00 AM",
      "payment_mode": "UPI",
      "status": "Done",
      "amount": 100,
      "towards": "Savings Account",
      "account_number": "#123456789",
      "customer_name": "Rajesh Kumar",
      "collection_type": "EMI",
    },
    {
      "transaction_id": "#1234567891",
      "date": "2023-10-02",
      "time": "11:00 AM",
      "payment_mode": "Cash",
      "status": "Pending",
      "amount": 200,
      "towards": "Loan Account",
      "account_number": "#987654321",
      "customer_name": "Priya Sharma",
      "collection_type": "Loan",
    },
    {
      "transaction_id": "#1234567892",
      "date": "2023-10-03",
      "time": "12:00 PM",
      "payment_mode": "Cash",
      "status": "Failed",
      "amount": 300,
      "towards": "Savings Account",
      "account_number": "#123456788",
      "customer_name": "Amit Patel",
      "collection_type": "EMI",
    },
    {
      "transaction_id": "#1234567893",
      "date": "2023-10-04",
      "time": "01:00 PM",
      "payment_mode": "UPI",
      "status": "Done",
      "amount": 400,
      "towards": "Loan Account",
      "account_number": "#987654322",
      "customer_name": "Sunita Verma",
      "collection_type": "Deposit",
    },
    {
      "transaction_id": "#1234567894",
      "date": "2023-10-05",
      "time": "02:00 PM",
      "payment_mode": "UPI",
      "status": "Done",
      "amount": 500,
      "towards": "Savings Account",
      "account_number": "#123456787",
      "customer_name": "Ravi Singh",
      "collection_type": "EMI",
    },
  ];
});

class TransactionsList extends ConsumerStatefulWidget {
  static String routeName =
      "/modules/customers-screen-module/transactions_list";

  const TransactionsList({super.key});

  @override
  ConsumerState<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends ConsumerState<TransactionsList> {
  String selectedFilter = "All";
  final List<String> filters = ["All", "Done", "Pending", "Failed"];

  @override
  Widget build(BuildContext context) {
    final allTransactions = ref.watch(transactionsProvider);
    final filteredTransactions = selectedFilter == "All"
        ? allTransactions
        : allTransactions.where((t) => t['status'] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSummaryCards(allTransactions),
            _buildFilterTabs(),
            Expanded(
              child: _buildTransactionsList(filteredTransactions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Collection History",
                  style: TextStyle(
                    fontSize: 18.h,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "Track your collection activities",
                  style: TextStyle(
                    fontSize: 12.h,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFF1F5F9),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const Icon(
          //     Icons.filter_list_rounded,
          //     size: 20,
          //     color: Color(0xFF475569),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<Map<String, dynamic>> transactions) {
    final totalAmount =
        transactions.fold<double>(0, (sum, t) => sum + (t['amount'] as num));
    final completedCount =
        transactions.where((t) => t['status'] == 'Done').length;
    final pendingCount =
        transactions.where((t) => t['status'] == 'Pending').length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              "Total Amount",
              "₹${totalAmount.toStringAsFixed(0)}",
              Icons.account_balance_wallet_rounded,
              const Color(0xFF3B82F6),
              const Color(0xFFEFF6FF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              "Completed",
              completedCount.toString(),
              Icons.check_circle_rounded,
              const Color(0xFF10B981),
              const Color(0xFFECFDF5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              "Pending",
              pendingCount.toString(),
              Icons.schedule_rounded,
              const Color(0xFFF59E0B),
              const Color(0xFFFEF3C7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon,
      Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedFilter = filter),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionsList(List<Map<String, dynamic>> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final status = transaction['status'] as String;
    final isCompleted = status == "Done";
    final isPending = status == "Pending";
    final isFailed = status == "Failed";

    Color statusColor = const Color(0xFF10B981);
    Color statusBgColor = const Color(0xFFECFDF5);
    IconData statusIcon = Icons.check_circle_rounded;

    if (isPending) {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
      statusIcon = Icons.schedule_rounded;
    } else if (isFailed) {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
      statusIcon = Icons.cancel_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigate to receipt screen
          Navigator.pushNamed(context, PaymentReceiptScreen.routeName,
              arguments: transaction["transaction_id"]);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${transaction['date']} • ${transaction['time']}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      transaction['payment_mode'] == 'UPI'
                          ? Icons.qr_code_2_rounded
                          : Icons.payments_rounded,
                      color: const Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['customer_name'] ?? 'Customer',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${transaction['collection_type']} • ${transaction['towards']}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          transaction['account_number'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${transaction['amount']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: transaction['payment_mode'] == 'UPI'
                              ? const Color(0xFFEFF6FF)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          transaction['payment_mode'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: transaction['payment_mode'] == 'UPI'
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Enhanced provider with better data structure
// final transactionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
//   return [
//     {
//       "transaction_id": "#1234567890",
//       "date": "2023-10-01",
//       "time": "10:00 AM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 100,
//       "towards": "Savings Account",
//       "account_number": "#123456789",
//       "customer_name": "Rajesh Kumar",
//       "collection_type": "EMI",
//     },
//     {
//       "transaction_id": "#1234567891",
//       "date": "2023-10-02",
//       "time": "11:00 AM",
//       "payment_mode": "Cash",
//       "status": "Pending",
//       "amount": 200,
//       "towards": "Loan Account",
//       "account_number": "#987654321",
//       "customer_name": "Priya Sharma",
//       "collection_type": "Loan",
//     },
//     {
//       "transaction_id": "#1234567892",
//       "date": "2023-10-03",
//       "time": "12:00 PM",
//       "payment_mode": "Cash",
//       "status": "Failed",
//       "amount": 300,
//       "towards": "Savings Account",
//       "account_number": "#123456788",
//       "customer_name": "Amit Patel",
//       "collection_type": "EMI",
//     },
//     {
//       "transaction_id": "#1234567893",
//       "date": "2023-10-04",
//       "time": "01:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 400,
//       "towards": "Loan Account",
//       "account_number": "#987654322",
//       "customer_name": "Sunita Verma",
//       "collection_type": "Deposit",
//     },
//     {
//       "transaction_id": "#1234567894",
//       "date": "2023-10-05",
//       "time": "02:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 500,
//       "towards": "Savings Account",
//       "account_number": "#123456787",
//       "customer_name": "Ravi Singh",
//       "collection_type": "EMI",
//     },
//   ];
// });

// class TransactionsList extends ConsumerStatefulWidget {
//   static String routeName =
//       "/modules/customers-screen-module/transactions_list";

//   const TransactionsList({super.key});

//   @override
//   ConsumerState<TransactionsList> createState() => _TransactionsListState();
// }

// class _TransactionsListState extends ConsumerState<TransactionsList> {
//   String selectedFilter = "All";
//   final List<String> filters = ["All", "Done", "Pending", "Failed"];

//   @override
//   Widget build(BuildContext context) {
//     final allTransactions = ref.watch(transactionsProvider);
//     final filteredTransactions = selectedFilter == "All"
//         ? allTransactions
//         : allTransactions.where((t) => t['status'] == selectedFilter).toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             _buildSummaryCards(allTransactions),
//             _buildFilterTabs(),
//             Expanded(
//               child: _buildTransactionsList(filteredTransactions),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x0A000000),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//               color: const Color(0xFF475569),
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Collection History",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF0F172A),
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 Text(
//                   "Track your collection activities",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF64748B),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.filter_list_rounded,
//               size: 20,
//               color: Color(0xFF475569),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCards(List<Map<String, dynamic>> transactions) {
//     final totalAmount =
//         transactions.fold<double>(0, (sum, t) => sum + (t['amount'] as num));
//     final completedCount =
//         transactions.where((t) => t['status'] == 'Done').length;
//     final pendingCount =
//         transactions.where((t) => t['status'] == 'Pending').length;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildSummaryCard(
//               "Total Amount",
//               "₹${totalAmount.toStringAsFixed(0)}",
//               Icons.account_balance_wallet_rounded,
//               const Color(0xFF3B82F6),
//               const Color(0xFFEFF6FF),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildSummaryCard(
//               "Completed",
//               completedCount.toString(),
//               Icons.check_circle_rounded,
//               const Color(0xFF10B981),
//               const Color(0xFFECFDF5),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildSummaryCard(
//               "Pending",
//               pendingCount.toString(),
//               Icons.schedule_rounded,
//               const Color(0xFFF59E0B),
//               const Color(0xFFFEF3C7),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCard(String title, String value, IconData icon,
//       Color iconColor, Color bgColor) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF000000).withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: bgColor,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: iconColor, size: 20),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF64748B),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterTabs() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: filters.map((filter) {
//           final isSelected = selectedFilter == filter;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => selectedFilter = filter),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color:
//                       isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   filter,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isSelected ? Colors.white : const Color(0xFF64748B),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildTransactionsList(List<Map<String, dynamic>> transactions) {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       itemCount: transactions.length,
//       itemBuilder: (context, index) {
//         final transaction = transactions[index];
//         return _buildTransactionCard(transaction);
//       },
//     );
//   }

//   Widget _buildTransactionCard(Map<String, dynamic> transaction) {
//     final status = transaction['status'] as String;
//     final isCompleted = status == "Done";
//     final isPending = status == "Pending";
//     final isFailed = status == "Failed";

//     Color statusColor = const Color(0xFF10B981);
//     Color statusBgColor = const Color(0xFFECFDF5);
//     IconData statusIcon = Icons.check_circle_rounded;

//     if (isPending) {
//       statusColor = const Color(0xFFF59E0B);
//       statusBgColor = const Color(0xFFFEF3C7);
//       statusIcon = Icons.schedule_rounded;
//     } else if (isFailed) {
//       statusColor = const Color(0xFFEF4444);
//       statusBgColor = const Color(0xFFFEF2F2);
//       statusIcon = Icons.cancel_rounded;
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF000000).withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () {
//             // Navigate to receipt screen
//             // Navigator.pushNamed(context, PaymentReceiptScreen.routeName, arguments: transaction["transaction_id"]);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: statusBgColor,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(statusIcon, size: 14, color: statusColor),
//                           const SizedBox(width: 4),
//                           Text(
//                             status,
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: statusColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       "${transaction['date']} • ${transaction['time']}",
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF94A3B8),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF1F5F9),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         transaction['payment_mode'] == 'UPI'
//                             ? Icons.qr_code_2_rounded
//                             : Icons.payments_rounded,
//                         color: const Color(0xFF3B82F6),
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             transaction['customer_name'] ?? 'Customer',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF0F172A),
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             "${transaction['collection_type']} • ${transaction['towards']}",
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Color(0xFF64748B),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             transaction['account_number'],
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFF94A3B8),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "₹${transaction['amount']}",
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF0F172A),
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: transaction['payment_mode'] == 'UPI'
//                                 ? const Color(0xFFEFF6FF)
//                                 : const Color(0xFFF0FDF4),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             transaction['payment_mode'],
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                               color: transaction['payment_mode'] == 'UPI'
//                                   ? const Color(0xFF3B82F6)
//                                   : const Color(0xFF16A34A),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// // Riverpod provider for transactions
// final transactionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
//   return [
//     {
//       "transaction_id": "#1234567890",
//       "date": "2023-10-01",
//       "time": "10:00 AM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 100,
//       "towards": "Savings Account",
//       "account_number": "#123456789",
//     },
//     {
//       "transaction_id": "#1234567891",
//       "date": "2023-10-02",
//       "time": "11:00 AM",
//       "payment_mode": "Cash",
//       "status": "Pending",
//       "amount": 200,
//       "towards": "Loan Account",
//       "account_number": "#987654321",
//     },
//     {
//       "transaction_id": "#1234567892",
//       "date": "2023-10-03",
//       "time": "12:00 PM",
//       "payment_mode": "Cash",
//       "status": "Failed",
//       "amount": 300,
//       "towards": "Savings Account",
//       "account_number": "#123456788",
//     },
//     {
//       "transaction_id": "#1234567893",
//       "date": "2023-10-04",
//       "time": "01:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 400,
//       "towards": "Loan Account",
//       "account_number": "#987654322",
//     },
//     {
//       "transaction_id": "#1234567894",
//       "date": "2023-10-05",
//       "time": "02:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 500,
//       "towards": "Savings Account",
//       "account_number": "#123456787",
//     },
//     {
//       "transaction_id": "#1234567895",
//       "date": "2023-10-06",
//       "time": "03:00 PM",
//       "payment_mode": "Cash",
//       "status": "Pending",
//       "amount": 600,
//       "towards": "Loan Account",
//       "account_number": "#987654323",
//     },
//     {
//       "transaction_id": "#1234567896",
//       "date": "2023-10-07",
//       "time": "04:00 PM",
//       "payment_mode": "Cash",
//       "status": "Failed",
//       "amount": 700,
//       "towards": "Savings Account",
//       "account_number": "#123456786",
//     },
//     {
//       "transaction_id": "#1234567897",
//       "date": "2023-10-08",
//       "time": "05:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 800,
//       "towards": "Loan Account",
//       "account_number": "#987654324",
//     },
//     {
//       "transaction_id": "#1234567898",
//       "date": "2023-10-09",
//       "time": "06:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 900,
//       "towards": "Savings Account",
//       "account_number": "#123456785",
//     },
//     {
//       "transaction_id": "#1234567899",
//       "date": "2023-10-10",
//       "time": "07:00 PM",
//       "payment_mode": "Cash",
//       "status": "Pending",
//       "amount": 1000,
//       "towards": "Loan Account",
//       "account_number": "#987654325",
//     },
//     {
//       "transaction_id": "#1234567800",
//       "date": "2023-10-11",
//       "time": "08:00 PM",
//       "payment_mode": "Cash",
//       "status": "Failed",
//       "amount": 1100,
//       "towards": "Savings Account",
//       "account_number": "#123456784",
//     },
//     {
//       "transaction_id": "#1234567801",
//       "date": "2023-10-12",
//       "time": "09:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 1200,
//       "towards": "Loan Account",
//       "account_number": "#987654326",
//     },
//     {
//       "transaction_id": "#1234567802",
//       "date": "2023-10-13",
//       "time": "10:00 PM",
//       "payment_mode": "UPI",
//       "status": "Done",
//       "amount": 1300,
//       "towards": "Savings Account",
//       "account_number": "#123456783",
//     },
//     {
//       "transaction_id": "#1234567803",
//       "date": "2023-10-14",
//       "time": "11:00 PM",
//       "payment_mode": "Cash",
//       "status": "Pending",
//       "amount": 1400,
//       "towards": "Loan Account",
//       "account_number": "#987654327",
//     },
//   ];
// });

// class TransactionsList extends ConsumerWidget {
//   static String routeName =
//       "/modules/customers-screen-module/transactions_list";

//   const TransactionsList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final transactions = ref.watch(transactionsProvider);

//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         title: const Text("Transactions History"),
//         backgroundColor: kWhite,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: transactions.length,
//         itemBuilder: (context, index) {
//           final transaction = transactions[index];
//           final isCompleted = transaction['status'] == "Done";
//           final isPending = transaction['status'] == "Pending";

//           return Card(
//             color: kWhite,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${transaction['date']}",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: trendLight,
//                       ),
//                     ),
//                     Text(
//                       "${transaction['time']}",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: trendLight,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: getProportionateHeight(16.0)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Towards",
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w600,
//                         color: trendLight,
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           transaction['towards'],
//                           style: TextStyle(
//                             fontSize: 12.5.sp,
//                             fontWeight: FontWeight.w600,
//                             color: trend,
//                           ),
//                         ),
//                         Text(
//                           transaction['account_number'],
//                           style: TextStyle(
//                             fontSize: 12.5.sp,
//                             fontWeight: FontWeight.w600,
//                             color: trend,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: getProportionateHeight(16.0)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: getProportionateWidth(12.0),
//                         vertical: getProportionateHeight(8.0),
//                       ),
//                       decoration: BoxDecoration(
//                         color: isCompleted
//                             ? Colors.green.withOpacity(0.2)
//                             : isPending
//                                 ? Colors.orange.withOpacity(0.2)
//                                 : Colors.red.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         transaction['status'],
//                         style: TextStyle(
//                           color: isCompleted
//                               ? Colors.green
//                               : isPending
//                                   ? Colors.orange
//                                   : Colors.red,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "${transaction['payment_mode']}",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w800,
//                             color: corporateBlueDark,
//                           ),
//                         ).withMargin(
//                           EdgeInsets.only(
//                             right: getProportionateWidth(
//                                 transaction['payment_mode'] == "UPI"
//                                     ? getProportionateWidth(8.0)
//                                     : 0.0),
//                           ),
//                         ),
//                         SizedBox(width: getProportionateWidth(16.0)),
//                         Text(
//                           "Amount \u{20B9}${transaction['amount'].toString()}",
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ).withMargin(
//               EdgeInsets.only(
//                 left: getProportionateWidth(16.0),
//                 top: getProportionateHeight(16.0),
//                 right: getProportionateWidth(16.0),
//                 bottom: getProportionateHeight(8.0),
//               ),
//             ),
//           )
//               .withMargin(
//             EdgeInsets.only(
//               top: getProportionateHeight(8.0),
//               bottom: getProportionateHeight(8.0),
//             ),
//           )
//               .onClick(onClick: () {
//             Navigator.pushNamed(
//               context,
//               PaymentReceiptScreen.routeName,
//               arguments: transaction["transaction_id"],
//             );
//           });
//         },
//       ),
//     );
//   }
// }
