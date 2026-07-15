import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName =
      "/modules/notification-screen-module/notification_screen";

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Unread', 'Collections', 'System'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar
          _buildCustomAppBar(),

          // Filter Tabs
          _buildFilterTabs(),

          // Main Content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildNotificationList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 20.w,
        right: 20.w,
        bottom: 16.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          _buildActionButton(
            icon: Icons.mark_email_read_rounded,
            onTap: () => _markAllAsRead(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    final notifications = _getFilteredNotifications();

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, index);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final isUnread = notification['isUnread'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isUnread
            ? Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isUnread
                ? const Color(0xFF6366F1).withOpacity(0.08)
                : const Color(0x08000000),
            blurRadius: isUnread ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNotificationTap(notification),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification['type']),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: const Color(0xFF1E293B),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6366F1),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          const Spacer(),
                          if (notification['priority'] == 'high')
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'URGENT',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFEF4444),
                                ),
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

  Widget _buildNotificationIcon(String type) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (type) {
      case 'collection':
        icon = Icons.account_balance_wallet_rounded;
        backgroundColor = const Color(0xFF10B981).withOpacity(0.1);
        iconColor = const Color(0xFF10B981);
        break;
      case 'payment':
        icon = Icons.payment_rounded;
        backgroundColor = const Color(0xFF6366F1).withOpacity(0.1);
        iconColor = const Color(0xFF6366F1);
        break;
      case 'reminder':
        icon = Icons.notifications_active_rounded;
        backgroundColor = const Color(0xFFF59E0B).withOpacity(0.1);
        iconColor = const Color(0xFFF59E0B);
        break;
      case 'system':
        icon = Icons.settings_rounded;
        backgroundColor = const Color(0xFF8B5CF6).withOpacity(0.1);
        iconColor = const Color(0xFF8B5CF6);
        break;
      case 'alert':
        icon = Icons.warning_rounded;
        backgroundColor = const Color(0xFFEF4444).withOpacity(0.1);
        iconColor = const Color(0xFFEF4444);
        break;
      default:
        icon = Icons.info_rounded;
        backgroundColor = const Color(0xFF64748B).withOpacity(0.1);
        iconColor = const Color(0xFF64748B);
    }

    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 24.sp,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 60.sp,
              color: const Color(0xFF6366F1),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We\'ll notify you when something\nimportant happens',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    final allNotifications = [
      {
        'id': '1',
        'type': 'collection',
        'title': 'Payment Received',
        'message':
            'Jamna Mobiles has made a payment of ₹5,000 for loan account #12345',
        'time': '2 minutes ago',
        'isUnread': true,
        'priority': 'normal',
        'category': 'Collections',
      },
      {
        'id': '2',
        'type': 'reminder',
        'title': 'Collection Due Today',
        'message':
            'You have 3 collections due today. Visit customers before 6 PM.',
        'time': '1 hour ago',
        'isUnread': true,
        'priority': 'high',
        'category': 'Collections',
      },
      {
        'id': '3',
        'type': 'payment',
        'title': 'Loan Disbursement',
        'message': 'New loan of ₹25,000 has been approved for Rajesh Kumar',
        'time': '3 hours ago',
        'isUnread': false,
        'priority': 'normal',
        'category': 'Collections',
      },
      {
        'id': '4',
        'type': 'alert',
        'title': 'Overdue Payment Alert',
        'message':
            'Suresh Enterprises has missed 2 consecutive payments. Immediate action required.',
        'time': '5 hours ago',
        'isUnread': true,
        'priority': 'high',
        'category': 'Collections',
      },
      {
        'id': '5',
        'type': 'system',
        'title': 'App Update Available',
        'message':
            'Version 2.1.0 is now available with new features and bug fixes.',
        'time': '1 day ago',
        'isUnread': false,
        'priority': 'normal',
        'category': 'System',
      },
      {
        'id': '6',
        'type': 'collection',
        'title': 'Collection Target Met',
        'message':
            'Congratulations! You\'ve achieved 95% of your monthly collection target.',
        'time': '2 days ago',
        'isUnread': false,
        'priority': 'normal',
        'category': 'Collections',
      },
      {
        'id': '7',
        'type': 'reminder',
        'title': 'Weekly Report Due',
        'message':
            'Please submit your weekly collection report by tomorrow 5 PM.',
        'time': '3 days ago',
        'isUnread': false,
        'priority': 'normal',
        'category': 'System',
      },
    ];

    switch (selectedFilter) {
      case 'Unread':
        return allNotifications.where((n) => n['isUnread'] == true).toList();
      case 'Collections':
        return allNotifications
            .where((n) => n['category'] == 'Collections')
            .toList();
      case 'System':
        return allNotifications
            .where((n) => n['category'] == 'System')
            .toList();
      default:
        return allNotifications;
    }
  }

  void _onNotificationTap(Map<String, dynamic> notification) {
    HapticFeedback.lightImpact();

    // Mark as read if unread
    if (notification['isUnread']) {
      setState(() {
        notification['isUnread'] = false;
      });
    }

    // Show notification details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationDetails(notification),
    );
  }

  Widget _buildNotificationDetails(Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildNotificationIcon(notification['type']),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                Text(
                  notification['message'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Center(
                              child: Text(
                                'Dismiss',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _handleNotificationAction(notification);
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Center(
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    // Handle different notification actions based on type
    switch (notification['type']) {
      case 'collection':
        // Navigate to collection details
        break;
      case 'payment':
        // Navigate to payment details
        break;
      case 'reminder':
        // Navigate to reminders/tasks
        break;
      default:
        break;
    }
  }
}
