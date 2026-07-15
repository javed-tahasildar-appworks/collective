import 'dart:developer';
import 'package:collectiv/modules/reports-screen-module/ui/mini_statement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Modern Color Scheme (consistent with previous screens)
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
  static const Color savingsColor = Color(0xFF10B981);
  static const Color loanColor = Color(0xFF8B5CF6);
}

// Customer Model
class CustomerModel {
  final String clientPhoto;
  final String clientId;
  final String clientName;
  final String lastTransaction;
  final String transactionTime;
  final String transactionDate;
  final String accountType;
  final double balance;

  CustomerModel({
    required this.clientPhoto,
    required this.clientId,
    required this.clientName,
    required this.lastTransaction,
    required this.transactionTime,
    required this.transactionDate,
    required this.accountType,
    required this.balance,
  });
}

// Sample Data
final List<CustomerModel> _allCustomers = [
  CustomerModel(
    clientPhoto:
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150",
    clientId: "#987654321",
    clientName: "John Doe",
    lastTransaction: "Deposit",
    transactionTime: "11:29 AM",
    transactionDate: "10-04-2025",
    accountType: "Savings",
    balance: 25000.00,
  ),
  CustomerModel(
    clientPhoto:
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150",
    clientId: "#987654322",
    clientName: "Jane Smith",
    lastTransaction: "Withdrawal",
    transactionTime: "10:15 AM",
    transactionDate: "10-04-2025",
    accountType: "Savings",
    balance: 18500.00,
  ),
  CustomerModel(
    clientPhoto:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
    clientId: "#987654323",
    clientName: "Alice Johnson",
    lastTransaction: "EMI Payment",
    transactionTime: "09:45 AM",
    transactionDate: "10-04-2025",
    accountType: "Loan",
    balance: 125000.00,
  ),
  CustomerModel(
    clientPhoto:
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150",
    clientId: "#987654324",
    clientName: "Bob Brown",
    lastTransaction: "Deposit",
    transactionTime: "02:30 PM",
    transactionDate: "09-04-2025",
    accountType: "Savings",
    balance: 42000.00,
  ),
  CustomerModel(
    clientPhoto:
        "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150",
    clientId: "#987654325",
    clientName: "Charlie Davis",
    lastTransaction: "Loan Disbursement",
    transactionTime: "01:20 PM",
    transactionDate: "09-04-2025",
    accountType: "Loan",
    balance: 75000.00,
  ),
  CustomerModel(
    clientPhoto:
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
    clientId: "#987654326",
    clientName: "Diana Evans",
    lastTransaction: "Transfer",
    transactionTime: "11:00 AM",
    transactionDate: "09-04-2025",
    accountType: "Savings",
    balance: 31200.00,
  ),
];

// State Management
class SearchState {
  final String query;
  const SearchState({this.query = ''});
  SearchState copyWith({String? query}) =>
      SearchState(query: query ?? this.query);
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());
  void updateQuery(String query) => state = state.copyWith(query: query);
}

// Providers
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
    (ref) => SearchNotifier());
final customerListProvider =
    Provider<List<CustomerModel>>((ref) => _allCustomers);

final filteredCustomersProvider = Provider<List<CustomerModel>>((ref) {
  final customers = ref.watch(customerListProvider);
  final searchState = ref.watch(searchProvider);
  final query = searchState.query.toLowerCase();

  if (query.isEmpty) return customers;

  return customers.where((customer) {
    return customer.clientName.toLowerCase().contains(query) ||
        customer.clientId.toLowerCase().contains(query);
  }).toList();
});

final savingsCustomersProvider = Provider<List<CustomerModel>>((ref) {
  final customers = ref.watch(filteredCustomersProvider);
  return customers.where((c) => c.accountType == "Savings").toList();
});

final loanCustomersProvider = Provider<List<CustomerModel>>((ref) {
  final customers = ref.watch(filteredCustomersProvider);
  return customers.where((c) => c.accountType == "Loan").toList();
});

class MiniCustomerScreen extends ConsumerStatefulWidget {
  static String routeName =
      "/modules/reports-screen-module/ui/mini_customers_screen.dart";

  const MiniCustomerScreen({super.key});

  @override
  ConsumerState<MiniCustomerScreen> createState() => _MiniCustomerScreenState();
}

class _MiniCustomerScreenState extends ConsumerState<MiniCustomerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savingsCustomers = ref.watch(savingsCustomersProvider);
    final loanCustomers = ref.watch(loanCustomersProvider);

    return Scaffold(
      backgroundColor: AppColors.softGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSummaryCards(savingsCustomers.length, loanCustomers.length),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(child: _buildTabBarView(savingsCustomers, loanCustomers)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'Customer Overview',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Manage customer accounts',
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

  Widget _buildSummaryCards(int savingsCount, int loanCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Savings Accounts',
              '$savingsCount',
              'Active customers',
              AppColors.savingsColor,
              Icons.savings_rounded,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildSummaryCard(
              'Loan Accounts',
              '$loanCount',
              'Active borrowers',
              AppColors.loanColor,
              Icons.account_balance_rounded,
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20.w),
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

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: TextField(
        onChanged: (value) =>
            ref.read(searchProvider.notifier).updateQuery(value),
        decoration: InputDecoration(
          hintText: 'Search customers by name or ID...',
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

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textSecondary,
        indicator: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(4.w),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Savings A/C'),
          Tab(text: 'Loan A/C'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(
      List<CustomerModel> savingsCustomers, List<CustomerModel> loanCustomers) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCustomerList(savingsCustomers, AppColors.savingsColor),
        _buildCustomerList(loanCustomers, AppColors.loanColor),
      ],
    );
  }

  Widget _buildCustomerList(List<CustomerModel> customers, Color accentColor) {
    if (customers.isEmpty) {
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
                Icons.people_outline_rounded,
                size: 48.w,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No customers found',
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
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildCustomerCard(customer, accentColor);
      },
    );
  }

  Widget _buildCustomerCard(CustomerModel customer, Color accentColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(customer.clientPhoto),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: accentColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          customer.clientName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          customer.transactionDate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          customer.clientId,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          customer.transactionTime,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
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
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹${_formatAmount(customer.balance)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      customer.lastTransaction,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      log("Client ID: ${customer.clientId}");
                      // Navigate to mini statement
                      Navigator.pushNamed(
                        context,
                        MiniStatement.routeName,
                        arguments: customer.clientId,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryBlue,
                        size: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

// import 'dart:developer';

// import 'package:collectiv/modules/customer-screen-module/models/customer_response_model.dart';
// import 'package:collectiv/modules/customer-screen-module/provider/customer_provider.dart';
// import 'package:collectiv/modules/customer-screen-module/ui/transactions_list.dart';
// import 'package:collectiv/modules/reports-screen-module/ui/mini_statement.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/search_bar_widget.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MiniCustomerScreen extends ConsumerStatefulWidget {
//   static String routeName =
//       "/modules/reports-screen-module/ui/mini_customers_screen.dart";

//   const MiniCustomerScreen({super.key});

//   @override
//   ConsumerState<MiniCustomerScreen> createState() => _CustomerScreenState();
// }

// class _CustomerScreenState extends ConsumerState<MiniCustomerScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
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
//               clientId: "#987654322",
//               clientName: "Jane Smith",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654323",
//               clientName: "Alice Johnson",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654324",
//               clientName: "Bob Brown",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654325",
//               clientName: "Charlie Davis",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654326",
//               clientName: "Diana Evans",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654327",
//               clientName: "Ethan Harris",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654328",
//               clientName: "Fiona Clark",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
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
//               clientId: "#987654322",
//               clientName: "Jane Smith",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654323",
//               clientName: "Alice Johnson",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654324",
//               clientName: "Bob Brown",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654325",
//               clientName: "Charlie Davis",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654326",
//               clientName: "Diana Evans",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654327",
//               clientName: "Ethan Harris",
//               lastTransaction: "Loan A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//           CustomerResponseModel(
//               clientPhoto: clientPhoto,
//               clientId: "#987654328",
//               clientName: "Fiona Clark",
//               lastTransaction: "Savings A/C: \u{20B9}1000.00/-",
//               transactionTime: "11:29 AM",
//               transactionDate: "10-04-2025"),
//         ];
//       });
//     }

//     final filteredCustomer = ref.watch(filteredCustomerProvider);
//     ref.watch(searchQueryProvider);

//     // Split customers into savings and loan accounts
//     final savingsCustomers = filteredCustomer
//         .where((client) => client.lastTransaction.contains("Savings A/C"))
//         .toList();
//     final loanCustomers = filteredCustomer
//         .where((client) => client.lastTransaction.contains("Loan A/C"))
//         .toList();

//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         title: Text(miniStatement,
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
//               ref.read(searchQueryProvider.notifier).state = value;
//               _filterClients(ref);
//             },
//           ),
//           TabBar(
//             controller: _tabController,
//             labelColor: corporateBlueDark,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: corporateBlueDark,
//             tabs: const [
//               Tab(text: 'Savings A/C'),
//               Tab(text: 'Loan A/C'),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // Savings A/C Tab
//                 _buildCustomerList(savingsCustomers),
//                 // Loan A/C Tab
//                 _buildCustomerList(loanCustomers),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomerList(List<CustomerResponseModel> customers) {
//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: customers.length,
//       separatorBuilder: (context, index) => const Divider(
//         height: 1,
//         thickness: 1,
//         indent: 72,
//         endIndent: 16,
//         color: Color(0xFFEEEEEE),
//       ),
//       itemBuilder: (context, index) {
//         final client = customers[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(8),
//             leading: CircleAvatar(
//               radius: 28,
//               backgroundImage: NetworkImage(client.clientPhoto),
//               backgroundColor: Colors.grey[200],
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       client.clientId,
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Text(
//                       client.transactionDate,
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: getProportionateHeight(4.0)),
//                 Text(
//                   client.clientName,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: getProportionateHeight(4.0)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       client.lastTransaction,
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Text(
//                       client.transactionTime,
//                       style: TextStyle(
//                         fontSize: 12.5.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             onTap: () {
//               log("Client ID: ${client.clientId}");
//               Navigator.pushNamed(
//                 context,
//                 MiniStatement.routeName,
//                 arguments: client.clientId,
//               );
//             },
//           ),
//         );
//       },
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
