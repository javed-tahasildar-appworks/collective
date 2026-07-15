// weekly_performance_screen.dart
import 'package:flutter/material.dart';

class WeeklyPerformanceScreen extends StatefulWidget {
  const WeeklyPerformanceScreen({super.key});

  @override
  State<WeeklyPerformanceScreen> createState() =>
      _WeeklyPerformanceScreenState();
}

class _WeeklyPerformanceScreenState extends State<WeeklyPerformanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;

  final List<double> collectionData = [30, 45, 25, 60, 40, 75, 50];
  final List<String> dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _chartAnimationController, curve: Curves.easeOutCubic),
    );
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 16.0 : 8.0),
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isTablet),
          SizedBox(height: isTablet ? 32 : 24),
          _buildChart(isTablet),
          SizedBox(height: isTablet ? 24 : 20),
          _buildLegend(isTablet),
          SizedBox(height: isTablet ? 24 : 20),
          _buildSummaryCards(isTablet),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Performance',
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'March 20 - March 26',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '+8.5%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart(bool isTablet) {
    final chartHeight = isTablet ? 280.0 : 240.0;

    return Container(
      height: chartHeight,
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: AnimatedBuilder(
        animation: _chartAnimation,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      _buildAnimatedBars(chartHeight - (isTablet ? 80 : 70)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: dayLabels
                    .map((day) => Text(
                          day,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildAnimatedBars(double maxHeight) {
    return collectionData.asMap().entries.map((entry) {
      final index = entry.key;
      final collectionValue = entry.value;
      final earningValue = collectionValue * 0.7;
      final maxValue = collectionData.reduce((a, b) => a > b ? a : b);

      final collectionHeight =
          (collectionValue / maxValue * maxHeight * _chartAnimation.value)
              .clamp(8.0, maxHeight);
      final earningHeight =
          (earningValue / maxValue * maxHeight * _chartAnimation.value)
              .clamp(8.0, maxHeight);

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _showBarDetails(index, earningValue, 'Earning'),
                child: Container(
                  width: 10,
                  height: earningHeight,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    _showBarDetails(index, collectionValue, 'Collection'),
                child: Container(
                  width: 10,
                  height: collectionHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLegend(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          const Color(0xFF8B5CF6),
          'Earning',
          '\${(collectionData.reduce((a, b) => a + b) * 0.7).toInt()}K',
          isTablet,
        ),
        SizedBox(width: isTablet ? 32 : 24),
        _buildLegendItem(
          const Color(0xFF3B82F6),
          'Collection',
          '\${collectionData.reduce((a, b) => a + b).toInt()}K',
          isTablet,
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      Color color, String label, String total, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isTablet ? 16 : 14,
          height: isTablet ? 16 : 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              total,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Best Day',
            'Saturday',
            '\$75K',
            const Color(0xFF10B981),
            Icons.star_rounded,
            isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildSummaryCard(
            'Average',
            'Daily',
            '\$46K',
            const Color(0xFF667EEA),
            Icons.analytics_rounded,
            isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String subtitle, String value,
      Color color, IconData icon, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isTablet ? 20 : 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showBarDetails(int dayIndex, double value, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '${dayLabels[dayIndex]} - $type',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\${value.toStringAsFixed(0)}K',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total $type for ${dayLabels[dayIndex]}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF667EEA)),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// import '../../../utils/size_config.dart';

// class WeeklyPerformanceScreen extends StatelessWidget {
//   const WeeklyPerformanceScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildChartCard(),
//         const SizedBox(height: 16),
//         _buildLegend(),
//         SizedBox(height: getProportionateHeight(75)),
//       ],
//     );
//   }

//   Widget _buildChartCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Weekly Performance',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               height: 300,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 100,
//                   minY: 0,
//                   groupsSpace: 12,
//                   barTouchData: BarTouchData(
//                     enabled: true,
//                     touchTooltipData: BarTouchTooltipData(
//                       tooltipBgColor: Colors.white,
//                       tooltipPadding: const EdgeInsets.all(8),
//                       tooltipMargin: 8,
//                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                         final day = [
//                           'Mon',
//                           'Tue',
//                           'Wed',
//                           'Thu',
//                           'Fri',
//                           'Sat',
//                           'Sun'
//                         ][group.x.toInt()];
//                         return BarTooltipItem(
//                           '$day\n',
//                           const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                           children: [
//                             TextSpan(
//                               text:
//                                   'Collection: ${(rod.toY).toStringAsFixed(0)}K\n',
//                               style: TextStyle(
//                                 color: Colors.blue[400],
//                                 fontSize: 12,
//                               ),
//                             ),
//                             TextSpan(
//                               text:
//                                   'Earning: ${(rodIndex == 0 ? rod.toY * 0.7 : rod.toY * 0.8).toStringAsFixed(0)}K',
//                               style: TextStyle(
//                                 color: Colors.purple[400],
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           const days = [
//                             'Mon',
//                             'Tue',
//                             'Wed',
//                             'Thu',
//                             'Fri',
//                             'Sat',
//                             'Sun'
//                           ];
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               days[value.toInt()],
//                               style: const TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           );
//                         },
//                         reservedSize: 36,
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value % 20 == 0) {
//                             return Text(
//                               '${value.toInt()}K',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                               ),
//                             );
//                           }
//                           return const Text('');
//                         },
//                         reservedSize: 36,
//                       ),
//                     ),
//                     rightTitles: const AxisTitles(),
//                     topTitles: const AxisTitles(),
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     drawVerticalLine: false,
//                     horizontalInterval: 20,
//                     getDrawingHorizontalLine: (value) {
//                       return FlLine(
//                         color: Colors.grey[200],
//                         strokeWidth: 1,
//                       );
//                     },
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   barGroups: List.generate(7, (index) {
//                     final collectionValue =
//                         [30, 45, 25, 60, 40, 75, 50][index].toDouble();
//                     final earningValue = collectionValue * 0.7;

//                     return BarChartGroupData(
//                       x: index,
//                       groupVertically: false,
//                       barsSpace: 4,
//                       barRods: [
//                         BarChartRodData(
//                           toY: collectionValue,
//                           color: Colors.blue[400],
//                           width: 12,
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(6),
//                           ),
//                         ),
//                         BarChartRodData(
//                           toY: earningValue,
//                           color: Colors.purple[400],
//                           width: 12,
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(6),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         _buildLegendItem(Colors.purple[400]!, 'Earning'),
//         const SizedBox(width: 16),
//         _buildLegendItem(Colors.blue[400]!, 'Collection'),
//       ],
//     );
//   }

//   Widget _buildLegendItem(Color color, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }
// }
