import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
  static const Color divider = Color(0xFFE2E8F0);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color primarySoft = Color(0xFFF0F9FF);
}

/// Payment Receipt Model
class PaymentReceiptData {
  final String clientName;
  final String clientPhoto;
  final double amount;
  final String accountNumber;
  final String paymentMode;
  final DateTime dateTime;
  final String transactionId;
  final String note;
  final String status;

  PaymentReceiptData({
    required this.clientName,
    required this.clientPhoto,
    required this.amount,
    required this.accountNumber,
    required this.paymentMode,
    required this.dateTime,
    required this.transactionId,
    required this.note,
    required this.status,
  });
}

/// Modern Payment Receipt Screen
class PaymentReceiptScreen extends StatefulWidget {
  static String routeName =
      "/modules/collect-screen-module/payment_receipt_screen";

  const PaymentReceiptScreen({super.key});

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Sample receipt data
  final PaymentReceiptData receiptData = PaymentReceiptData(
    clientName: 'Jamna Mobiles',
    clientPhoto:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    amount: 15000,
    accountNumber: '109200111222',
    paymentMode: 'UPI',
    dateTime: DateTime.now(),
    transactionId: 'MYUI7821A-G2-90A',
    note: 'Thanks for the payment!',
    status: 'Completed',
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      log("Arguments: $args");
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    _buildModernAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            _buildReceiptCard(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
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
              icon: const Icon(Icons.close_rounded),
              color: AppColors.textPrimary,
              iconSize: 20.sp,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Payment Receipt',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
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
              onPressed: _shareReceipt,
              icon: const Icon(Icons.share_rounded),
              color: AppColors.primary,
              iconSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.08).round()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildReceiptHeader(),
          _buildStatusBadge(),
          SizedBox(height: 16.h),
          _buildAmountSection(),
          SizedBox(height: 16.h),
          _buildDetailsSection(),
          _buildTransactionId(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildReceiptHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withAlpha((255 * 0.2).round()),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha((255 * 0.1).round()),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 38.r,
              backgroundImage: NetworkImage(receiptData.clientPhoto),
              backgroundColor: AppColors.primarySoft,
              onBackgroundImageError: (_, __) {},
              child: receiptData.clientPhoto.isEmpty
                  ? Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 40.sp,
                    )
                  : null,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            receiptData.clientName,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            'Payment Received',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            receiptData.status,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            'Amount Paid',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withAlpha((255 * 0.8).round()),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '₹${NumberFormat('#,##,###').format(receiptData.amount)}',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              _getPaymentModeIcon() + receiptData.paymentMode,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.account_balance_rounded,
            label: 'Account Number',
            value: receiptData.accountNumber,
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            icon: Icons.access_time_rounded,
            label: 'Date & Time',
            value:
                DateFormat('dd MMM yyyy, hh:mm a').format(receiptData.dateTime),
          ),
          if (receiptData.note.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _buildDetailRow(
              icon: Icons.note_rounded,
              label: 'Note',
              value: receiptData.note,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionId() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.qr_code_rounded,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Transaction ID',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _copyToClipboard(receiptData.transactionId),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.copy_rounded,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              receiptData.transactionId,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextButton.icon(
                onPressed: _downloadReceipt,
                icon: Icon(
                  Icons.download_rounded,
                  color: AppColors.textPrimary,
                  size: 18.sp,
                ),
                label: Text(
                  'Download',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _printReceipt,
              icon: Icon(
                Icons.print_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
              label: Text(
                'Print Receipt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentModeIcon() {
    switch (receiptData.paymentMode.toLowerCase()) {
      case 'upi':
        return '📱 ';
      case 'cash':
        return '💵 ';
      case 'card':
        return '💳 ';
      default:
        return '💰 ';
    }
  }

  void _shareReceipt() {
    HapticFeedback.lightImpact();
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Receipt shared successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _downloadReceipt() {
    HapticFeedback.lightImpact();
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Receipt downloaded successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _printReceipt() {
    HapticFeedback.mediumImpact();
    // Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sending to printer...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    HapticFeedback.selectionClick();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction ID copied to clipboard'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class PaymentReceiptScreen extends StatelessWidget {
//   static String routeName =
//       "/modules/collect-screen-module/payment_receipt_screen";

//   const PaymentReceiptScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (ModalRoute.of(context)!.settings.arguments != null) {
//       final args = ModalRoute.of(context)!.settings.arguments as String;
//       log("Arguments: $args");
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // AppBar section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Icon(Icons.close, size: 24).onClick(
//                   onClick: Navigator.of(context).pop,
//                 ),
//                 const Text(
//                   paymentReceipt,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Icon(Icons.share, size: 24, color: trendDark),
//               ],
//             ).withPadding(EdgeInsets.symmetric(
//                 horizontal: getProportionateWidth(16.0),
//                 vertical: getProportionateHeight(12.0))),

//             Stack(alignment: Alignment.topCenter, children: [
//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Card container
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kWhite,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 1,
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           SizedBox(height: getProportionateHeight(102.0)),
//                           // Amount row
//                           _buildInfoRow(
//                             icon: Icons.currency_rupee,
//                             label: amount,
//                             value: '₹ 500',
//                             valueColor: trendDark,
//                             valueBold: true,
//                           ),

//                           _buildDivider(),

//                           // Bank account row
//                           _buildInfoRow(
//                             icon: Icons.account_balance,
//                             label: accountNumber,
//                             value: '109200111222',
//                             valueBold: true,
//                           ),

//                           // Schedule row
//                           _buildInfoRow(
//                             icon: Icons.calendar_today,
//                             label: 'Payment Mode',
//                             value: 'UPI',
//                           ),

//                           // Hours row
//                           _buildInfoRow(
//                             icon: Icons.access_time,
//                             label: 'Date & Time',
//                             value: '02/10/2023 12:30 PM',
//                           ),

//                           _buildDivider(),

//                           // Note row
//                           _buildInfoRow(
//                             icon: Icons.speaker_notes,
//                             label: 'Note',
//                             value: 'Thanks for the payment!',
//                           ),

//                           const SizedBox(height: 40),

//                           // Barcode
//                           Container(
//                             height: getProportionateHeight(70.0),
//                             width: double.infinity,
//                             decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                     'https://t3.ftcdn.net/jpg/08/30/97/94/360_F_830979462_4TvQQNiRudCw7ou9LUziRl3mYv1hZKQz.jpg'),
//                                 fit: BoxFit.fitWidth,
//                               ),
//                             ),
//                           ).withMargin(EdgeInsets.symmetric(
//                               horizontal: getProportionateWidth(16.0))),

//                           const SizedBox(height: 8),

//                           // Reference code
//                           const Text(
//                             'MYUI7821A-G2-90A',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),

//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ).withPadding(EdgeInsets.symmetric(
//                     horizontal: 16.0.sp, vertical: 64.0.sp)),
//               ),

//               // Avatar
//               Positioned(
//                 top: getProportionateHeight(16.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.lightBlue.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: ClipOval(
//                         child: Center(
//                           child: Image.network(
//                             'https://via.placeholder.com/80',
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: Colors.blue.shade300,
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: getProportionateHeight(16.0)),

//                     // User name
//                     const Text(
//                       'Jamna Mobiles',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]),

//             const Spacer(),

//             Container(
//               width: double.infinity,
//               padding:
//                   EdgeInsets.symmetric(vertical: getProportionateHeight(14.0)),
//               decoration: BoxDecoration(
//                 color: trendDark,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const Center(
//                 child: Text(
//                   print,
//                   style: TextStyle(
//                     color: kWhite,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             )
//                 .withPadding(
//                   EdgeInsets.symmetric(
//                     horizontal: getProportionateWidth(16.0),
//                     vertical: getProportionateHeight(16.0),
//                   ),
//                 )
//                 .onClick(
//                   onClick: () {
//                     // Handle the payment action here
//                   },
//                   borderRadius: BorderRadius.circular(30),
//                   splashColor: Colors.white.withOpacity(0.1),
//                 )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//     Color valueColor = Colors.black,
//     bool valueBold = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 17.sp, color: trend),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(
//                 fontSize: 14.sp, color: trend, fontWeight: FontWeight.w500),
//           ),
//           const Spacer(),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: valueColor,
//               fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return const Divider(
//       height: .5,
//       thickness: 0.5,
//       indent: 20,
//       endIndent: 20,
//       color: Colors.black12,
//     );
//   }
// }


// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// /// Modern color palette
// class AppColors {
//   static const Color primary = Color(0xFF6366F1);
//   static const Color primaryLight = Color(0xFF8B5CF6);
//   static const Color background = Color(0xFFF8FAFC);
//   static const Color cardBackground = Color(0xFFFFFFFF);
//   static const Color textPrimary = Color(0xFF1E293B);
//   static const Color textSecondary = Color(0xFF64748B);
//   static const Color textLight = Color(0xFF94A3B8);
//   static const Color success = Color(0xFF10B981);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color error = Color(0xFFEF4444);
//   static const Color divider = Color(0xFFE2E8F0);
//   static const Color successLight = Color(0xFFD1FAE5);
//   static const Color primarySoft = Color(0xFFF0F9FF);
// }

// /// Payment Receipt Model
// class PaymentReceiptData {
//   final String clientName;
//   final String clientPhoto;
//   final double amount;
//   final String accountNumber;
//   final String paymentMode;
//   final DateTime dateTime;
//   final String transactionId;
//   final String note;
//   final String status;

//   PaymentReceiptData({
//     required this.clientName,
//     required this.clientPhoto,
//     required this.amount,
//     required this.accountNumber,
//     required this.paymentMode,
//     required this.dateTime,
//     required this.transactionId,
//     required this.note,
//     required this.status,
//   });
// }

// /// Compact Payment Receipt Screen - No Scrolling Required
// class PaymentReceiptScreen extends StatefulWidget {
//   static String routeName = "/modules/collect-screen-module/payment_receipt_screen";

//   const PaymentReceiptScreen({super.key});

//   @override
//   State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
// }

// class _PaymentReceiptScreenState extends State<PaymentReceiptScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   // Sample receipt data
//   final PaymentReceiptData receiptData = PaymentReceiptData(
//     clientName: 'Jamna Mobiles',
//     clientPhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
//     amount: 15000,
//     accountNumber: '109200111222',
//     paymentMode: 'UPI',
//     dateTime: DateTime.now(),
//     transactionId: 'MYUI7821A-G2-90A',
//     note: 'Thanks for the payment!',
//     status: 'Completed',
//   );

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (ModalRoute.of(context)!.settings.arguments != null) {
//       final args = ModalRoute.of(context)!.settings.arguments as String;
//       log("Arguments: $args");
//     }

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _slideAnimation.value),
//               child: Opacity(
//                 opacity: _fadeAnimation.value,
//                 child: Column(
//                   children: [
//                     _buildCompactAppBar(),
//                     Expanded(
//                       child: _buildReceiptContent(),
//                     ),
//                     _buildCompactActionButtons(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCompactAppBar() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//       child: Row(
//         children: [
//           Container(
//             width: 40.w,
//             height: 40.h,
//             decoration: BoxDecoration(
//               color: AppColors.cardBackground,
//               borderRadius: BorderRadius.circular(10.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(Icons.close_rounded),
//               color: AppColors.textPrimary,
//               iconSize: 18.sp,
//               padding: EdgeInsets.zero,
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 'Payment Receipt',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: 40.w,
//             height: 40.h,
//             decoration: BoxDecoration(
//               color: AppColors.cardBackground,
//               borderRadius: BorderRadius.circular(10.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               onPressed: _shareReceipt,
//               icon: const Icon(Icons.share_rounded),
//               color: AppColors.primary,
//               iconSize: 18.sp,
//               padding: EdgeInsets.zero,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReceiptContent() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header with Profile and Status
//           Container(
//             padding: EdgeInsets.all(20.w),
//             child: Column(
//               children: [
//                 // Profile and Status Row
//                 Row(
//                   children: [
//                     Container(
//                       width: 60.w,
//                       height: 60.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: AppColors.primary.withOpacity(0.2),
//                           width: 2,
//                         ),
//                       ),
//                       child: CircleAvatar(
//                         radius: 28.r,
//                         backgroundImage: NetworkImage(receiptData.clientPhoto),
//                         backgroundColor: AppColors.primarySoft,
//                         onBackgroundImageError: (_, __) {},
//                         child: receiptData.clientPhoto.isEmpty
//                             ? Icon(
//                                 Icons.person_rounded,
//                                 color: AppColors.primary,
//                                 size: 30.sp,
//                               )
//                             : null,
//                       ),
//                     ),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             receiptData.clientName,
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             'Payment Received',
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                       decoration: BoxDecoration(
//                         color: AppColors.successLight,
//                         borderRadius: BorderRadius.circular(15.r),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 6.w,
//                             height: 6.h,
//                             decoration: const BoxDecoration(
//                               color: AppColors.success,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           SizedBox(width: 6.w),
//                           Text(
//                             receiptData.status,
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.success,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Amount Section
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 20.w),
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [AppColors.primary, AppColors.primaryLight],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Amount Paid',
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.white.withOpacity(0.8),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         '₹${NumberFormat('#,##,###').format(receiptData.amount)}',
//                         style: TextStyle(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Text(
//                     _getPaymentModeIcon() + receiptData.paymentMode,
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 20.h),

//           // Details Grid
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildCompactDetailItem(
//                         Icons.account_balance_rounded,
//                         'Account',
//                         receiptData.accountNumber,
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: _buildCompactDetailItem(
//                         Icons.access_time_rounded,
//                         'Time',
//                         DateFormat('hh:mm a').format(receiptData.dateTime),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 _buildTransactionIdRow(),
//               ],
//             ),
//           ),

//           SizedBox(height: 20.h),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompactDetailItem(IconData icon, String label, String value) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(6.w),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(
//               icon,
//               color: AppColors.primary,
//               size: 14.sp,
//             ),
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: AppColors.textSecondary,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: AppColors.textPrimary,
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionIdRow() {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.divider),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.qr_code_rounded,
//             color: AppColors.textSecondary,
//             size: 16.sp,
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Transaction ID',
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     color: AppColors.textSecondary,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   receiptData.transactionId,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () => _copyToClipboard(receiptData.transactionId),
//             borderRadius: BorderRadius.circular(8.r),
//             child: Padding(
//               padding: EdgeInsets.all(4.w),
//               child: Icon(
//                 Icons.copy_rounded,
//                 color: AppColors.primary,
//                 size: 14.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompactActionButtons() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 48.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14.r),
//                 border: Border.all(color: AppColors.divider),
//               ),
//               child: TextButton.icon(
//                 onPressed: _downloadReceipt,
//                 icon: Icon(
//                   Icons.download_rounded,
//                   color: AppColors.textPrimary,
//                   size: 16.sp,
//                 ),
//                 label: Text(
//                   'Download',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: TextButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14.r),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             flex: 2,
//             child: Container(
//               height: 48.h,
//               child: ElevatedButton.icon(
//                 onPressed: _printReceipt,
//                 icon: Icon(
//                   Icons.print_rounded,
//                   color: Colors.white,
//                   size: 16.sp,
//                 ),
//                 label: Text(
//                   'Print Receipt',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14.r),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getPaymentModeIcon() {
//     switch (receiptData.paymentMode.toLowerCase()) {
//       case 'upi':
//         return '📱 ';
//       case 'cash':
//         return '💵 ';
//       case 'card':
//         return '💳 ';
//       default:
//         return '💰 ';
//     }
//   }

//   void _shareReceipt() {
//     HapticFeedback.lightImpact();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Receipt shared successfully'),
//         backgroundColor: AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }

//   void _downloadReceipt() {
//     HapticFeedback.lightImpact();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Receipt downloaded successfully'),
//         backgroundColor: AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }

//   void _printReceipt() {
//     HapticFeedback.mediumImpact();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Sending to printer...'),
//         backgroundColor: AppColors.primary,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }

//   void _copyToClipboard(String text) {
//     HapticFeedback.selectionClick();
//     Clipboard.setData(ClipboardData(text: text));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Transaction ID copied'),
//         backgroundColor: AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }
// }