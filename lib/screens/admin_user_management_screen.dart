import 'package:flutter/material.dart';
import 'admin_user_profile_screen.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  int _selectedIndex = 2;
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, dynamic>> _allUsers = [
    {'name': 'Jane Doe', 'email': 'jane.doe@example.com', 'enrolled': 3, 'status': 'Active'},
    {'name': 'Alex Smith', 'email': 'alex.smith@example.com', 'enrolled': 1, 'status': 'Active'},
    {'name': 'Michael Scott', 'email': 'michael@dunder.com', 'enrolled': 2, 'status': 'Inactive'},
    {'name': 'Dwight Schrute', 'email': 'dwight@dunder.com', 'enrolled': 4, 'status': 'Active'},
    {'name': 'Jim Halpert', 'email': 'jim@dunder.com', 'enrolled': 1, 'status': 'At Risk'},
  ];

  List<Map<String, dynamic>> _filteredUsers = [];
  String _selectedStatusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.from(_allUsers);
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final matchesQuery = user['name'].toLowerCase().contains(query) || 
                             user['email'].toLowerCase().contains(query);
                             
        final matchesStatus = _selectedStatusFilter == 'All' || 
                              user['status'] == _selectedStatusFilter;
                              
        return matchesQuery && matchesStatus;
      }).toList();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter Users', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Text('Status', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['All', 'Active', 'Inactive', 'At Risk'].map((status) {
                        final isSelected = _selectedStatusFilter == status;
                        return ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() => _selectedStatusFilter = status);
                              _applyFilters();
                            }
                          },
                          selectedColor: _primaryBlue.withOpacity(0.2),
                          labelStyle: TextStyle(color: isSelected ? _primaryBlue : _textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Close Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showUserOptions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Options for ${user['name']}', style: const TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: _primaryBlue),
                title: const Text('View Full Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUserProfileScreen(user: user)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_reset, color: Colors.orange),
                title: const Text('Reset Password'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent to ${user['email']}')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Suspend Account', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Suspend Account?'),
                      content: Text('Are you sure you want to suspend ${user['name']}? They will not be able to log in.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account suspended.')));
                          },
                          child: const Text('Suspend', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('User Management', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: _textSecondary),
                      filled: true,
                      fillColor: _background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryBlue, width: 2)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _selectedStatusFilter != 'All' ? _primaryBlue.withOpacity(0.1) : _background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _selectedStatusFilter != 'All' ? _primaryBlue : Colors.transparent),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune, color: _selectedStatusFilter != 'All' ? _primaryBlue : _textPrimary),
                    onPressed: _showFilterModal,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),

          // User List
          Expanded(
            child: _filteredUsers.isEmpty 
              ? const Center(child: Text('No users found matching filters.', style: TextStyle(color: _textSecondary)))
              : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                
                Color statusColor;
                if (user['status'] == 'Active') statusColor = Colors.green;
                else if (user['status'] == 'At Risk') statusColor = Colors.orange;
                else statusColor = Colors.red;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: _primaryBlue.withOpacity(0.1),
                        child: Text(
                          user['name'].substring(0, 1),
                          style: const TextStyle(color: _primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['name'], style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(user['email'], style: const TextStyle(color: _textSecondary, fontSize: 13)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    user['status'],
                                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.library_books, size: 14, color: _textSecondary),
                                const SizedBox(width: 4),
                                Text('${user['enrolled']} Programs', style: const TextStyle(color: _textSecondary, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: _textSecondary),
                        onPressed: () => _showUserOptions(user),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == _selectedIndex) return;
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/admin-home');
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed('/admin-program-manager');
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed('/admin-profile');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryBlue,
        unselectedItemColor: const Color(0xFF8A94A4),
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Programs'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
