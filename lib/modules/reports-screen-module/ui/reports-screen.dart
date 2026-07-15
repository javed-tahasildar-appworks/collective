import 'package:collectiv/modules/reports-screen-module/ui/commission_earned_report.dart';
import 'package:collectiv/modules/reports-screen-module/ui/duplicate_receipts_report.dart';
import 'package:collectiv/modules/reports-screen-module/ui/loan_report.dart';
import 'package:collectiv/modules/reports-screen-module/ui/mini_customers_screen.dart';
import 'package:collectiv/modules/reports-screen-module/ui/total_collection_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Models should typically be in a separate file, but kept here for simplicity
class ReportItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color backgroundColor;
  final String routeName;
  final String? value;
  final String? trend;

  const ReportItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.backgroundColor,
    required this.routeName,
    this.value,
    this.trend,
  });
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final List<Animation<double>> _cardAnimations;

  static final _reports = [
    ReportItem(
      title: 'Total Collection',
      subtitle: 'Daily collection summary',
      icon: Icons.account_balance_wallet_outlined,
      primaryColor: const Color(0xFF6366F1),
      backgroundColor: const Color(0xFFF0F4FF),
      routeName: TotalCollectionReport.routeName,
      value: '₹45,280',
      trend: '+12%',
    ),
    ReportItem(
      title: 'Commission Earned',
      subtitle: 'Your earnings overview',
      icon: Icons.trending_up_outlined,
      primaryColor: const Color(0xFF10B981),
      backgroundColor: const Color(0xFFECFDF5),
      routeName: CommissionEarned.routeName,
      value: '₹3,620',
      trend: '+8%',
    ),
    ReportItem(
      title: 'Duplicate Receipts',
      subtitle: 'Receipt verification',
      icon: Icons.content_copy_outlined,
      primaryColor: const Color(0xFFF59E0B),
      backgroundColor: const Color(0xFFFEFBF2),
      routeName: DuplicateReceiptsReport.routeName,
      value: '3',
      trend: '0%',
    ),
    const ReportItem(
      title: 'Loan Report',
      subtitle: 'Loan status & details',
      icon: Icons.credit_score_outlined,
      primaryColor: Color(0xFFEF4444),
      backgroundColor: Color(0xFFFEF2F2),
      routeName: LoanReport.routeName,
      value: '₹1.2L',
      trend: '-2%',
    ),
    ReportItem(
      title: 'Customer Analytics',
      subtitle: 'Customer insights',
      icon: Icons.people_outline,
      primaryColor: const Color(0xFF8B5CF6),
      backgroundColor: const Color(0xFFF5F3FF),
      routeName: MiniCustomerScreen.routeName,
      value: '127',
      trend: '+5%',
    ),
    const ReportItem(
      title: 'Performance',
      subtitle: 'Monthly performance',
      icon: Icons.bar_chart_outlined,
      primaryColor: Color(0xFF06B6D4),
      backgroundColor: Color(0xFFECFEFF),
      routeName: '/performance-report',
      value: '94%',
      trend: '+3%',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    ); // <-- Remove status listener that disposes controller

    _cardAnimations = List.generate(
      _reports.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            (0.6 + (index * 0.1)).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildQuickStats(context),
            Expanded(child: _buildReportsGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track your performance and insights',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildHeaderButton(
                context,
                Icons.calendar_today_outlined,
                onTap: () => _showDateRangePicker(context),
              ),
              const SizedBox(width: 12),
              _buildHeaderButton(
                context,
                Icons.file_download_outlined,
                onTap: () => _showExportOptions(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(BuildContext context, IconData icon,
      {required VoidCallback onTap}) {
    return Semantics(
      button: true,
      label: icon == Icons.calendar_today_outlined
          ? 'Select date range'
          : 'Export options',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6B7280),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  context,
                  'Today\'s Collection',
                  '₹12,450',
                  '+15%',
                  Icons.today_outlined,
                  const Color(0xFF10B981),
                ),
              ),
              SizedBox(width: isWide ? 24 : 16),
              Expanded(
                child: _buildQuickStatCard(
                  context,
                  'This Month',
                  '₹3.2L',
                  '+8%',
                  Icons.calendar_month_outlined,
                  const Color(0xFF6366F1),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickStatCard(
    BuildContext context,
    String title,
    String value,
    String trend,
    IconData icon,
    Color color,
  ) {
    final isPositive = trend.startsWith('+');

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          final childAspectRatio = constraints.maxWidth > 600 ? 1.0 : 0.85;

          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _reports.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _cardAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _cardAnimations[index].value,
                    child: Opacity(
                      opacity: _cardAnimations[index].value,
                      child: _buildReportCard(context, _reports[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, ReportItem report) {
    return Semantics(
      button: true,
      label: '${report.title}, ${report.subtitle}',
      child: GestureDetector(
        onTap: () => _navigateToReport(report.routeName),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: report.primaryColor.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: report.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      report.icon,
                      color: report.primaryColor,
                      size: 24,
                    ),
                  ),
                  if (report.trend != null && report.trend!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getTrendColor(report.trend!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        report.trend!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getTrendColor(report.trend!),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              if (report.value != null && report.value!.isNotEmpty) ...[
                Text(
                  report.value!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                report.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                report.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTrendColor(String trend) {
    if (trend.startsWith('+')) {
      return const Color(0xFF10B981);
    } else if (trend.startsWith('-')) {
      return const Color(0xFFEF4444);
    }
    return const Color(0xFF6B7280);
  }

  void _navigateToReport(String routeName) {
    // Navigation implementation would go here
    debugPrint('Navigating to $routeName');
    Navigator.pushNamed(context, routeName);
  }

  void _showDateRangePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DateRangePickerContent(
        onDateRangeSelected: (range) {
          // Handle date range selection
          debugPrint('Selected range: $range');
        },
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExportOptionsContent(
        onExportSelected: (option) {
          // Handle export option selection
          debugPrint('Selected export option: $option');
        },
      ),
    );
  }
}

class _DateRangePickerContent extends StatelessWidget {
  final ValueChanged<String> onDateRangeSelected;

  const _DateRangePickerContent({required this.onDateRangeSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Date Range',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildDateRangeOption(context, 'Today', isSelected: true),
                  _buildDateRangeOption(context, 'This Week'),
                  _buildDateRangeOption(context, 'This Month'),
                  _buildDateRangeOption(context, 'Custom Range'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeOption(BuildContext context, String title,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          onDateRangeSelected(title);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6366F1).withOpacity(0.1)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF374151),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportOptionsContent extends StatelessWidget {
  final ValueChanged<String> onExportSelected;

  const _ExportOptionsContent({required this.onExportSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Export Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 32),
          _buildExportOption(
              context, 'Export as PDF', Icons.picture_as_pdf_outlined),
          _buildExportOption(
              context, 'Export as Excel', Icons.table_chart_outlined),
          _buildExportOption(context, 'Share Report', Icons.share_outlined),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExportOption(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          onExportSelected(title);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF6B7280), size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:collectiv/modules/reports-screen-module/ui/commission_earned_report.dart';
// import 'package:collectiv/modules/reports-screen-module/ui/duplicate_receipts_report.dart';
// import 'package:collectiv/modules/reports-screen-module/ui/loan_report.dart';
// import 'package:collectiv/modules/reports-screen-module/ui/mini_customers_screen.dart';
// import 'package:collectiv/modules/reports-screen-module/ui/total_collection_report.dart';
// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: GridView.builder(
//         itemCount: reportsList.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // 2 columns
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 1, // Square tiles
//         ),
//         itemBuilder: (context, index) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Image.asset(
//               reportsList[index],
//               fit: BoxFit.fill,
//             ),
//           ).onClick(onClick: () {
//             // Handle the click event here
//             // For example, navigate to a detailed report screen

//             switch (index) {
//               case 0:
//                 Navigator.pushNamed(
//                   context,
//                   TotalCollectionReport.routeName,
//                 );

//                 break;
//               case 1:
//                 Navigator.pushNamed(
//                   context,
//                   CommissionEarned.routeName,
//                 );

//                 break;
//               case 2:
//                 Navigator.pushNamed(
//                   context,
//                   DuplicateReceiptsReport.routeName,
//                 );

//                 break;
//               case 3:
//                 Navigator.pushNamed(
//                   context,
//                   LoanReport.routeName,
//                 );

//                 break;
//               case 4:
//                 Navigator.pushNamed(
//                   context,
//                   MiniCustomerScreen.routeName,
//                 );

//                 break;

//               default:
//             }
//           });
//         },
//       ),
//     );
//   }
// }
