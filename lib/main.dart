import 'package:flutter/material.dart';

import 'screens/admin_home_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/browse_programs_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/admin_program_manager_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_user_management_screen.dart';
import 'screens/admin_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryBlue = Color(0xFF3157F6);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nextern',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          surface: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/admin-home': (context) => const AdminHomeScreen(),
        '/browse': (context) => const BrowseProgramsScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/admin-program-manager': (context) => const AdminProgramManagerScreen(),
        '/admin-user-management': (context) => const AdminUserManagementScreen(),
        '/admin-profile': (context) => const AdminProfileScreen(),
      },
    );
  }
}