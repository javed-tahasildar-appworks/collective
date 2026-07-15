import 'dart:developer';
import 'package:collectiv/modules/customer-screen-module/ui/transactions_list.dart';
import 'package:collectiv/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Mock model for customer data
class CustomerModel {
  final String clientPhoto;
  final String clientId;
  final String clientName;
  final String lastTransaction;
  final String transactionTime;
  final String transactionDate;
  final String accountType;
  final double amount;
  final bool isOverdue;

  CustomerModel({
    required this.clientPhoto,
    required this.clientId,
    required this.clientName,
    required this.lastTransaction,
    required this.transactionTime,
    required this.transactionDate,
    required this.accountType,
    required this.amount,
    this.isOverdue = false,
  });
}

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CustomerModel> _allCustomers = [];
  List<CustomerModel> _filteredCustomers = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _initializeCustomers();
    _filteredCustomers = _allCustomers;
  }

  void _initializeCustomers() {
    _allCustomers = [
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12345',
        clientName: 'Rajesh Kumar',
        lastTransaction: 'Loan Payment',
        transactionTime: '10:30 AM',
        transactionDate: '15 Jan 2025',
        accountType: 'Loan',
        amount: 5000.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12346',
        clientName: 'Priya Sharma',
        lastTransaction: 'Savings Deposit',
        transactionTime: '02:45 PM',
        transactionDate: '14 Jan 2025',
        accountType: 'Savings',
        amount: 2500.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12347',
        clientName: 'Mohammed Ali',
        lastTransaction: 'EMI Payment',
        transactionTime: '09:15 AM',
        transactionDate: '12 Jan 2025',
        accountType: 'Loan',
        amount: 3200.00,
        isOverdue: true,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12348',
        clientName: 'Sunita Devi',
        lastTransaction: 'Savings Withdrawal',
        transactionTime: '04:20 PM',
        transactionDate: '11 Jan 2025',
        accountType: 'Savings',
        amount: 1800.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12349',
        clientName: 'Amit Patel',
        lastTransaction: 'Loan Payment',
        transactionTime: '11:45 AM',
        transactionDate: '10 Jan 2025',
        accountType: 'Loan',
        amount: 4500.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12350',
        clientName: 'Kavita Singh',
        lastTransaction: 'Fixed Deposit',
        transactionTime: '03:30 PM',
        transactionDate: '09 Jan 2025',
        accountType: 'FD',
        amount: 10000.00,
        isOverdue: false,
      ),
      // New entries
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12351',
        clientName: 'Deepak Joshi',
        lastTransaction: 'Loan Payment',
        transactionTime: '01:00 PM',
        transactionDate: '08 Jan 2025',
        accountType: 'Loan',
        amount: 3900.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12352',
        clientName: 'Meena Verma',
        lastTransaction: 'Savings Deposit',
        transactionTime: '11:15 AM',
        transactionDate: '07 Jan 2025',
        accountType: 'Savings',
        amount: 3000.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12353',
        clientName: 'Naveen Reddy',
        lastTransaction: 'EMI Missed',
        transactionTime: '10:05 AM',
        transactionDate: '06 Jan 2025',
        accountType: 'Loan',
        amount: 4700.00,
        isOverdue: true,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12354',
        clientName: 'Sneha Iyer',
        lastTransaction: 'FD Withdrawal',
        transactionTime: '03:00 PM',
        transactionDate: '05 Jan 2025',
        accountType: 'FD',
        amount: 12000.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12355',
        clientName: 'Ravi Deshmukh',
        lastTransaction: 'Loan Payment',
        transactionTime: '05:15 PM',
        transactionDate: '04 Jan 2025',
        accountType: 'Loan',
        amount: 4100.00,
        isOverdue: false,
      ),
      CustomerModel(
        clientPhoto: 'https://via.placeholder.com/100',
        clientId: '#12356',
        clientName: 'Anjali Gupta',
        lastTransaction: 'Savings Deposit',
        transactionTime: '09:45 AM',
        transactionDate: '03 Jan 2025',
        accountType: 'Savings',
        amount: 2200.00,
        isOverdue: false,
      ),
    ];
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = _allCustomers;
      } else {
        _filteredCustomers = _allCustomers.where((customer) {
          final nameMatch =
              customer.clientName.toLowerCase().contains(query.toLowerCase());
          final idMatch =
              customer.clientId.toLowerCase().contains(query.toLowerCase());
          return nameMatch || idMatch;
        }).toList();
      }
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      List<CustomerModel> baseList = _searchController.text.isEmpty
          ? _allCustomers
          : _allCustomers.where((customer) {
              final nameMatch = customer.clientName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
              final idMatch = customer.clientId
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
              return nameMatch || idMatch;
            }).toList();

      switch (filter) {
        case 'Overdue':
          _filteredCustomers =
              baseList.where((customer) => customer.isOverdue).toList();
          break;
        case 'Loan':
          _filteredCustomers = baseList
              .where((customer) => customer.accountType == 'Loan')
              .toList();
          break;
        case 'Savings':
          _filteredCustomers = baseList
              .where((customer) => customer.accountType == 'Savings')
              .toList();
          break;
        default:
          _filteredCustomers = baseList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterChips(),
            _buildCustomerStats(),
            Expanded(child: _buildCustomerList()),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterCustomers,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF374151),
          ),
          decoration: InputDecoration(
            hintText: 'Search customers...',
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF9CA3AF),
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _filterCustomers('');
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Overdue', 'Loan', 'Savings'];

    return Container(
      height: 44, // Match chip height, reduce vertical space
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _applyFilter(filter),
              child: Container(
                height: 40, // Chip height
                constraints: const BoxConstraints(minWidth: 60),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20), // Remove vertical padding
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFE5E7EB),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerStats() {
    final totalCustomers = _allCustomers.length;
    final overdueCustomers = _allCustomers.where((c) => c.isOverdue).length;
    final totalAmount =
        _allCustomers.fold<double>(0, (sum, customer) => sum + customer.amount);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Customers',
              totalCustomers.toString(),
              Icons.people_outline,
              const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Overdue',
              overdueCustomers.toString(),
              Icons.warning_outlined,
              const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Total Amount',
              '₹${(totalAmount / 1000).toStringAsFixed(0)}K',
              Icons.account_balance_wallet_outlined,
              const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList() {
    if (_filteredCustomers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = _filteredCustomers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCustomerCard(customer),
        );
      },
    );
  }

  Widget _buildCustomerCard(CustomerModel customer) {
    return GestureDetector(
      onTap: () {
        log('Selected customer: ${customer.clientName}');
        // Navigate to customer details
        log("Client ID: ${customer.clientId}");
        Navigator.pushNamed(
          context,
          TransactionsList.routeName,
          arguments: customer.clientId,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: customer.isOverdue
              ? Border.all(color: const Color(0xFFEF4444).withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(customer.clientName),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(customer.clientName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (customer.isOverdue)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer.clientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        customer.transactionDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        customer.clientId,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getAccountTypeColor(customer.accountType)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          customer.accountType,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _getAccountTypeColor(customer.accountType),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer.lastTransaction,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '₹${customer.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF9CA3AF),
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No customers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    // return FloatingActionButton(
    //   heroTag: 'uniqueTAG',
    //   onPressed: () {
    //     log('Add new customer');
    //     // Show add customer dialog or navigate to add customer screen
    //   },
    //   backgroundColor: const Color(0xFF6366F1), // Use a solid color
    //   child: const Icon(
    //     Icons.add_rounded,
    //     color: Colors.white,
    //     size: 28,
    //   ),
    // );
    return Padding(
      padding: EdgeInsets.only(bottom: 100.h),
      child: FloatingActionButton(
        heroTag: 'unique-fab-tag',
        onPressed: () => log("Add New Customer..."),
        backgroundColor: const Color(0xFF6366F1),
        tooltip: "Add New Customer",
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 28.w,
        ),
      ),
    );
  }

  // Widget _buildFloatingActionButton() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF6366F1).withOpacity(0.3),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: FloatingActionButton(
  //       onPressed: () {
  //         log('Add new customer');
  //         // Show add customer dialog or navigate to add customer screen
  //       },
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       child: const Icon(
  //         Icons.add_rounded,
  //         color: Colors.white,
  //         size: 28,
  //       ),
  //     ),
  //   );
  // }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  List<Color> _getGradientColors(String name) {
    final colors = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      [const Color(0xFF10B981), const Color(0xFF059669)],
      [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      [const Color(0xFFEF4444), const Color(0xFFDC2626)],
      [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
      [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
    ];
    return colors[name.hashCode % colors.length];
  }

  Color _getAccountTypeColor(String accountType) {
    switch (accountType) {
      case 'Loan':
        return const Color(0xFFEF4444);
      case 'Savings':
        return const Color(0xFF10B981);
      case 'FD':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


// import 'dart:developer';

// import 'package:collectiv/modules/customer-screen-module/models/customer_response_model.dart';
// import 'package:collectiv/modules/customer-screen-module/provider/customer_provider.dart';
// import 'package:collectiv/modules/customer-screen-module/ui/transactions_list.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/search_bar_widget.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomerScreen extends ConsumerWidget {
//   const CustomerScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Initialize the client list once
//     final customerList = ref.watch(customerListProvider);
//     if (customerList.isEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(customerListProvider.notifier).state = [
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "John Doe",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "Jane Smith",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "Alice Johnson",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "Bob Brown",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "John Doe",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),

//           // Add all your other clients here...
//         ];
//         ref.read(filteredCustomerProvider.notifier).state = [
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "John Doe",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "Jane Smith",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "Alice Johnson",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "Bob Brown",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654321",
//               clientName: "John Doe",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
          
//         ];
//       });
//     }

//     final filteredCustomer = ref.watch(filteredCustomerProvider);
//     ref.watch(searchQueryProvider);

//     return Scaffold(
//       backgroundColor: kWhite,
//       body: SafeArea(
//         child: Column(
//           children: [
//             SearchBarWidget(
//               onChanged: (value) {
//                 ref.read(searchQueryProvider.notifier).state = value;
//                 _filterClients(ref);
//               },
//             ),
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: filteredCustomer.length,
//                 separatorBuilder: (context, index) => const Divider(
//                   height: 1,
//                   thickness: 1,
//                   indent: 72,
//                   endIndent: 16,
//                   color: Color(0xFFEEEEEE),
//                 ),
//                 itemBuilder: (context, index) {
//                   final client = filteredCustomer[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(8),
//                       leading: CircleAvatar(
//                         radius: 28,
//                         backgroundImage: NetworkImage(client.clientPhoto),
//                         backgroundColor: Colors.grey[200],
//                       ),
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 client.clientId,
//                                 style: TextStyle(
//                                   fontSize: 12.5.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 client.transactionDate,
//                                 style: TextStyle(
//                                   fontSize: 12.5.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: getProportionateHeight(4.0)),
//                           Text(
//                             client.clientName,
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           SizedBox(height: getProportionateHeight(4.0)),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 client.lastTransaction,
//                                 style: TextStyle(
//                                   fontSize: 12.5.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 client.transactionTime,
//                                 style: TextStyle(
//                                   fontSize: 12.5.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         log("Client ID: ${client.clientId}");
//                         Navigator.pushNamed(
//                           context,
//                           TransactionsList.routeName,
//                           arguments: client.clientId,
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(bottom: getProportionateHeight(50.0)),
//         child: FloatingActionButton(
//           heroTag: 'unique-fab-tag',
//           child: const Icon(
//             Icons.add,
//             color: corporateBlueDark,
//           ),
//           onPressed: () => log("Add New Customer..."),
//         ),
//       ),
//     );
//   }

//   void _filterClients(WidgetRef ref) {
//     final query = ref.read(searchQueryProvider).toLowerCase();
//     final clients = ref.read(customerListProvider);

//     ref.read(filteredCustomerProvider.notifier).state = clients.where((client) {
//       final nameMatch = client.clientName.toLowerCase().contains(query);
//       final idMatch = client.clientId.toLowerCase().contains(query);
//       return nameMatch || idMatch;
//     }).toList();
//   }
// }
