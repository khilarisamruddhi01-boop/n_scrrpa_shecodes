import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// 🔵 ADMIN Bottom Navigation
// Screens: Dashboard, Users, Suppliers, Audit, Settings
// ─────────────────────────────────────────────────────────────
class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  const AdminBottomNav({super.key, required this.currentIndex});

  static const Color _primary = Color(0xFF1E3A5F);

  static const List<String> _routes = [
    '/admin_dashboard_s36',
    '/user_management_s37',
    '/supplier_approvals_s38',
    '/audit_logs_s42',
    '/system_health_s41',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: _primary.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.dashboard_rounded, 'Dashboard'),
              _buildItem(context, 1, Icons.group_rounded, 'Users'),
              _buildItem(context, 2, Icons.verified_user_rounded, 'Approvals'),
              _buildItem(context, 3, Icons.policy_rounded, 'Audit'),
              _buildItem(context, 4, Icons.monitor_heart_rounded, 'Health'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon, String label) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, _routes[index]);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? _primary : Colors.grey.shade400, size: 22),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _primary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 🟢 CUSTOMER / ORGANIZATION Bottom Navigation
// Screens: Home, Risk, Orders, Suppliers, Settings
// ─────────────────────────────────────────────────────────────
class CustomerBottomNav extends StatelessWidget {
  final int currentIndex;
  const CustomerBottomNav({super.key, required this.currentIndex});

  static const Color _primary = Color(0xFF1E3A5F);
  static const Color _accent = Color(0xFF2E7D32);

  static const List<String> _routes = [
    '/customer_dashboard_s17',
    '/report_viewer_s35',
    '/customer_orders_s21',
    '/supplier_search_s18',
    '/settings_s44',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: _primary.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.dashboard_rounded, 'Home'),
              _buildItem(context, 1, Icons.analytics_rounded, 'Risks'),
              _buildItem(context, 2, Icons.local_shipping_rounded, 'Orders'),
              _buildItem(context, 3, Icons.groups_rounded, 'Suppliers'),
              _buildItem(context, 4, Icons.settings_rounded, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon, String label) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, _routes[index]);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _accent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? _accent : Colors.grey.shade400, size: 22),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 🟠 SUPPLIER Bottom Navigation
// Screens: Dashboard, Orders, Shipments, Analytics, Profile
// ─────────────────────────────────────────────────────────────
class SupplierBottomNav extends StatelessWidget {
  final int currentIndex;
  const SupplierBottomNav({super.key, required this.currentIndex});

  static const Color _primary = Color(0xFFEC5B13);
  static const Color _dark = Color(0xFF1E3A5F);

  static const List<String> _routes = [
    '/supplier_dashboard_s08',
    '/supplier_orders_s09',
    '/shipment_tracking_s12',
    '/supplier_analytics_s23',
    '/supplier_profile_s19',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _dark,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.dashboard_rounded, 'Home'),
              _buildItem(context, 1, Icons.assignment_rounded, 'Orders'),
              _buildItem(context, 2, Icons.local_shipping_rounded, 'Shipments'),
              _buildItem(context, 3, Icons.insights_rounded, 'Analytics'),
              _buildItem(context, 4, Icons.account_circle_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon, String label) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, _routes[index]);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _primary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? _primary : Colors.white54, size: 22),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _primary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
