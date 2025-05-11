import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class AdminMainScreen extends StatefulWidget {
  final Widget child;

  const AdminMainScreen({
    super.key,
    required this.child,
  });

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the active route
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/admin/dashboard')) {
      _currentIndex = 0;
    } else if (location.startsWith('/admin/menu')) {
      _currentIndex = 1;
    } else if (location.startsWith('/admin/orders')) {
      _currentIndex = 2;
    } else if (location.startsWith('/admin/analytics')) {
      _currentIndex = 3;
    } else if (location.startsWith('/admin/profile')) {
      _currentIndex = 4;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/admin/dashboard');
              break;
            case 1:
              context.go('/admin/menu');
              break;
            case 2:
              context.go('/admin/orders');
              break;
            case 3:
              context.go('/admin/analytics');
              break;
            case 4:
              context.go('/admin/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 