import 'package:collectiv/modules/app_bottom_nav.dart';
import 'package:collectiv/modules/collect-screen-module/ui/collection_input.dart';
import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
import 'package:collectiv/modules/customer-screen-module/ui/transactions_list.dart';
import 'package:collectiv/modules/notification-screen-module/ui/notifications_screen.dart';
import 'package:collectiv/modules/qr-code-scanner-module/qr_code_scanner.dart';
import 'package:collectiv/modules/reports-screen-module/ui/commission_earned_report.dart';
import 'package:collectiv/modules/reports-screen-module/ui/duplicate_receipts_report.dart';
import 'package:collectiv/modules/reports-screen-module/ui/loan_details.dart';
import 'package:collectiv/modules/reports-screen-module/ui/loan_report.dart';
import 'package:collectiv/modules/reports-screen-module/ui/mini_customers_screen.dart';
import 'package:collectiv/modules/reports-screen-module/ui/mini_statement.dart';
import 'package:collectiv/modules/reports-screen-module/ui/total_collection_report.dart';
import 'package:flutter/material.dart';

import 'modules/home-screen-module/ui/home_screen.dart';
import 'modules/login-module/ui/login_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
  HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
  AppBottomNav.routeName: (BuildContext context) => const AppBottomNav(),
  CollectionInput.routeName: (BuildContext context) => const CollectionInput(),
  PaymentReceiptScreen.routeName: (BuildContext context) =>
      const PaymentReceiptScreen(),
  TransactionsList.routeName: (BuildContext context) =>
      const TransactionsList(),
  TotalCollectionReport.routeName: (BuildContext context) =>
      const TotalCollectionReport(),
  CommissionEarned.routeName: (BuildContext context) =>
      const CommissionEarned(),
  DuplicateReceiptsReport.routeName: (BuildContext context) =>
      const DuplicateReceiptsReport(),
  LoanReport.routeName: (BuildContext context) => const LoanReport(),
  LoanDetails.routeName: (BuildContext context) => const LoanDetails(),
  MiniCustomerScreen.routeName: (BuildContext context) =>
      const MiniCustomerScreen(),
  MiniStatement.routeName: (BuildContext context) => const MiniStatement(),
  QRCodeScannerScreen.routeName: (BuildContext context) =>
      const QRCodeScannerScreen(),
  NotificationScreen.routeName: (BuildContext context) =>
      const NotificationScreen(),
};
