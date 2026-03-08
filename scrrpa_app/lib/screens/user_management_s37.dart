import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class UserManagementS37Screen extends StatefulWidget {
  const UserManagementS37Screen({super.key});

  @override
  State<UserManagementS37Screen> createState() => _UserManagementS37ScreenState();
}

class _UserManagementS37ScreenState extends State<UserManagementS37Screen> {
  final List<UserData> users = [
    UserData(name: 'Alex Rivera', email: 'alex.rivera@example.com', role: 'Admin', org: 'Design Systems Inc.', status: 'Active'),
    UserData(name: 'Sarah Jenkins', email: 's.jenkins@globex.org', role: 'Editor', org: 'Globex Corp', status: 'Pending'),
    UserData(name: 'Marcus Thorne', email: 'mthorne@techflow.io', role: 'Viewer', org: 'TechFlow', status: 'Suspended'),
    UserData(name: 'Jordan Lee', email: 'jordan.lee@pixel.co', role: 'Editor', org: 'Pixel Studio', status: 'Active'),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(Icons.group_work, color: primaryColor, size: 28)),
        title: const Text('User Management', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Invite User', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users by name, email or org...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterBtn('Status'),
                      _buildFilterBtn('Role'),
                      _buildFilterBtn('Organization'),
                      TextButton(onPressed: () {}, child: const Text('Clear All', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('NAME / EMAIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 2, child: Text('ROLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                Text('ACTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
          ),
          const Divider(height: 1),

          // User List
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: user.role,
                            icon: const Icon(Icons.expand_more, size: 14),
                            style: const TextStyle(color: Colors.black87, fontSize: 12),
                            onChanged: (v) {},
                            items: ['Admin', 'Editor', 'Viewer'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildStatusBadge(user.status),
                      ),
                      _buildActionBtn(user.status),
                    ],
                  ),
                );
              },
            ),
          ),

          // Pagination
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Showing 1-4 of 24 results', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  children: [
                    OutlinedButton(onPressed: null, style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Previous', style: TextStyle(fontSize: 12))),
                    const SizedBox(width: 8),
                    OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Next', style: TextStyle(fontSize: 12, color: Colors.black))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }

  Widget _buildFilterBtn(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.expand_more, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Colors.black12), backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12)),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.green;
    if (status == 'Pending') color = Colors.orange;
    if (status == 'Suspended') color = Colors.grey;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(String status) {
    if (status == 'Suspended') {
      return TextButton(onPressed: () {}, child: const Text('Activate', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)));
    }
    if (status == 'Pending') {
      return TextButton(onPressed: () {}, child: const Text('Resend', style: TextStyle(color: Color(0xFFEC5B13), fontWeight: FontWeight.bold, fontSize: 11)));
    }
    return TextButton(onPressed: () {}, child: const Text('Suspend', style: TextStyle(color: Color(0xFFEC5B13), fontWeight: FontWeight.bold, fontSize: 11)));
  }
}

class UserData {
  final String name;
  final String email;
  final String role;
  final String org;
  final String status;
  UserData({required this.name, required this.email, required this.role, required this.org, required this.status});
}
