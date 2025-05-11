import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'AirCanteen',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
              useMaterial3: true,
              scaffoldBackgroundColor: AppTheme.backgroundColor,
              fontFamily: 'Poppins',
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        }
      ),
    );
  }
}
