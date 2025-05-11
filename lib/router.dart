import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Models
import 'models/food_item.dart';
import 'models/order.dart';

// Providers
import 'providers/user_provider.dart';

// Student screens
import 'screens/student/splash_screen.dart';
import 'screens/student/onboarding_screen.dart';
import 'screens/student/auth_screen.dart';
import 'screens/student/home_screen.dart';
import 'screens/student/menu_screen.dart';
import 'screens/student/food_detail_screen.dart';
import 'screens/student/cart_screen.dart';
import 'screens/student/checkout_screen.dart';
import 'screens/student/order_confirmation_screen.dart';
import 'screens/student/order_tracking_screen.dart';
import 'screens/student/profile_screen.dart';
import 'screens/student/order_history_screen.dart';
import 'screens/student/search_screen.dart';

// Admin screens
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/menu_management_screen.dart';
import 'screens/admin/order_management_screen.dart';
import 'screens/admin/analytics_screen.dart';
import 'screens/admin/admin_profile_screen.dart';

// Shell for student tabs
import 'screens/student/main_screen.dart';

// Shell for admin tabs
import 'screens/admin/admin_main_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> _adminShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'adminShell');

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.currentUser;
      final isLoggedIn = user != null;
      final isAdmin = user?.isAdmin ?? false;
      final isOnboardingCompleted = userProvider.isOnboardingCompleted;
      
      final isGoingToLogin = state.uri.path == '/auth';
      final isGoingToOnboarding = state.uri.path == '/onboarding';
      final isGoingToSplash = state.uri.path == '/';
      final isGoingToAdmin = state.uri.path.startsWith('/admin/');
      final isGoingToAdminLogin = state.uri.path == '/admin/login';
      
      // Going to splash screen is always allowed
      if (isGoingToSplash) return null;
      
      // If onboarding is not completed and not going to onboarding, redirect to onboarding
      if (!isOnboardingCompleted && !isGoingToOnboarding) {
        return '/onboarding';
      }

      // For authenticated users
      if (isLoggedIn) {
        // If going to auth or onboarding, redirect to home
        if (isGoingToLogin || isGoingToOnboarding) {
          return '/home';
        }
      } else {
        // For non-authenticated users who have completed onboarding
        if (isOnboardingCompleted && !isGoingToLogin && !isGoingToAdminLogin) {
          return '/auth';
        }
      }
      
      // Handle admin access
      if (isGoingToAdmin) {
        if (!isLoggedIn && !isGoingToAdminLogin) {
          return '/admin/login';
        }
        
        if (isLoggedIn) {
          if (!isAdmin && !isGoingToAdminLogin) {
            // If regular user tries to access admin section, redirect to home
            return '/home';
          }
          
          if (isAdmin && isGoingToAdminLogin) {
            // If admin tries to access login, redirect to dashboard
            return '/admin/dashboard';
          }
        }
      }
      
      return null;
    },
    routes: [
      // Initial routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      
      // Admin login
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      
      // Main student app shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          // Home tab
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'food/:foodId',
                builder: (context, state) {
                  final foodId = state.pathParameters['foodId']!;
                  final foodItem = state.extra as FoodItem?;
                  return FoodDetailScreen(
                    foodId: foodId,
                    foodItem: foodItem,
                  );
                },
              ),
            ],
          ),
          
          // Menu tab
          GoRoute(
            path: '/menu',
            builder: (context, state) => const MenuScreen(),
            routes: [
              GoRoute(
                path: 'food/:foodId',
                builder: (context, state) {
                  final foodId = state.pathParameters['foodId']!;
                  final foodItem = state.extra as FoodItem?;
                  return FoodDetailScreen(
                    foodId: foodId,
                    foodItem: foodItem,
                  );
                },
              ),
            ],
          ),
          
          // Search tab
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
            routes: [
              GoRoute(
                path: 'food/:foodId',
                builder: (context, state) {
                  final foodId = state.pathParameters['foodId']!;
                  final foodItem = state.extra as FoodItem?;
                  return FoodDetailScreen(
                    foodId: foodId,
                    foodItem: foodItem,
                  );
                },
              ),
            ],
          ),
          
          // Cart tab
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
            routes: [
              GoRoute(
                path: 'checkout',
                builder: (context, state) => const CheckoutScreen(),
              ),
            ],
          ),
          
          // Profile tab
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'order-history',
                builder: (context, state) => const OrderHistoryScreen(),
              ),
            ],
          ),
        ],
      ),
      
      // Order confirmation screen (outside the shell)
      GoRoute(
        path: '/order-confirmation/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          final order = state.extra as Order?;
          return OrderConfirmationScreen(
            orderId: orderId,
            order: order,
          );
        },
      ),
      
      // Order tracking screen (outside the shell)
      GoRoute(
        path: '/order-tracking/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          final order = state.extra as Order?;
          return OrderTrackingScreen(
            orderId: orderId,
            order: order,
          );
        },
      ),
      
      // Admin routes with bottom navigation
      ShellRoute(
        navigatorKey: _adminShellNavigatorKey,
        builder: (context, state, child) => AdminMainScreen(child: child),
        routes: [
          // Dashboard tab
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboard(),
          ),
          
          // Menu Management tab
          GoRoute(
            path: '/admin/menu',
            builder: (context, state) => const MenuManagementScreen(),
          ),
          
          // Order Management tab
          GoRoute(
            path: '/admin/orders',
            builder: (context, state) => const OrderManagementScreen(),
          ),
          
          // Analytics tab
          GoRoute(
            path: '/admin/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          
          // Admin Profile tab
          GoRoute(
            path: '/admin/profile',
            builder: (context, state) => const AdminProfileScreen(),
          ),
        ],
      ),
    ],
  );
} 