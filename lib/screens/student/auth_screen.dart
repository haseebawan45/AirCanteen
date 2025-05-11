import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      bool success;
      
      // Make sure previous user is logged out
      await userProvider.logout();
      
      if (_isLogin) {
        success = await userProvider.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await userProvider.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      
      if (success && mounted) {
        // Check if admin login was attempted through student login screen
        final user = userProvider.currentUser;
        if (user != null && user.isAdmin) {
          // Navigate to admin dashboard
          context.go('/admin/dashboard');
        } else {
          // Navigate to home screen for students
          context.go('/home');
        }
      }
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication failed: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo and app name
                Center(
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 80,
                    color: AppTheme.primaryColor,
                  ),
                ).animate()
                  .fadeIn(duration: 600.ms)
                  .scale(delay: 200.ms, duration: 400.ms),
                
                const SizedBox(height: 24),
                
                Text(
                  'AirCanteen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ).animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms),
                
                const SizedBox(height: 8),
                
                Text(
                  _isLogin ? 'Welcome back!' : 'Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ).animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms),
                
                const SizedBox(height: 40),
                
                // Auth form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name field (only for signup)
                      if (!_isLogin)
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ).animate()
                          .fadeIn(delay: 700.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0, delay: 700.ms, duration: 500.ms),
                      
                      if (!_isLogin) const SizedBox(height: 16),
                      
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ).animate()
                        .fadeIn(delay: 800.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 500.ms),
                      
                      const SizedBox(height: 16),
                      
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!_isLogin && value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ).animate()
                        .fadeIn(delay: 900.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, delay: 900.ms, duration: 500.ms),
                      
                      const SizedBox(height: 24),
                      
                      // Submit button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isLogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ).animate()
                        .fadeIn(delay: 1000.ms, duration: 500.ms),
                      
                      const SizedBox(height: 16),
                      
                      // Admin login shortcut (for demo purposes)
                      TextButton(
                        onPressed: () {
                          _emailController.text = 'admin@aircanteen.com';
                          _passwordController.text = 'admin123';
                        },
                        child: Text(
                          'Admin Login (Demo)',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Toggle between login and signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin
                                ? 'Don\'t have an account?'
                                : 'Already have an account?',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          TextButton(
                            onPressed: _toggleAuthMode,
                            child: Text(
                              _isLogin ? 'Sign Up' : 'Login',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
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
} 