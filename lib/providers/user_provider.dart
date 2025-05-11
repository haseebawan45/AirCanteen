import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/mock_data.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isOnboardingCompleted = false;

  User? get currentUser => _currentUser;
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isAuthenticated => _currentUser != null;

  UserProvider() {
    _loadUserFromPrefs();
    _loadOnboardingStatus();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        _currentUser = User.fromJson(jsonDecode(userJson));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user from prefs: $e');
    }
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
      notifyListeners();
    } catch (e) {
      print('Error loading onboarding status: $e');
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingCompleted', true);
      _isOnboardingCompleted = true;
      notifyListeners();
    } catch (e) {
      print('Error saving onboarding status: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // In a real app, this would be an API call
      // For demo, we'll check if the user is admin or student
      if (email.toLowerCase().contains('admin')) {
        _currentUser = MockData.getAdminUser();
      } else {
        _currentUser = MockData.getCurrentUser();
      }
      
      // Save to prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(_currentUser!.toJson()));
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _currentUser = null;
      
      // Clear from prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      // In a real app, this would be an API call
      // For demo, just create a new user
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final user = User(
        id: userId,
        name: name,
        email: email,
      );
      
      _currentUser = user;
      
      // Save to prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Register error: $e');
      rethrow;
    }
  }

  // Add method to check if a food item is in the user's favorites
  bool isFavorite(String foodItemId) {
    if (_currentUser == null) return false;
    return _currentUser!.favoriteItems.contains(foodItemId);
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? avatar,
  }) async {
    if (_currentUser == null) return;
    
    try {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        avatar: avatar,
      );
      
      _currentUser = updatedUser;
      
      // Save to prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(updatedUser.toJson()));
      
      notifyListeners();
    } catch (e) {
      print('Update profile error: $e');
    }
  }

  void toggleFavorite(String foodItemId) {
    if (_currentUser == null) return;
    
    final favoriteItems = List<String>.from(_currentUser!.favoriteItems);
    if (favoriteItems.contains(foodItemId)) {
      favoriteItems.remove(foodItemId);
    } else {
      favoriteItems.add(foodItemId);
    }
    
    _currentUser = _currentUser!.copyWith(
      favoriteItems: favoriteItems,
    );
    
    // Save to prefs
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user', jsonEncode(_currentUser!.toJson()));
    });
    
    notifyListeners();
  }

  void addDeliveryAddress(String address) {
    if (_currentUser == null) return;
    
    final addresses = List<String>.from(_currentUser!.deliveryAddresses);
    if (!addresses.contains(address)) {
      addresses.add(address);
    }
    
    _currentUser = _currentUser!.copyWith(
      deliveryAddresses: addresses,
    );
    
    // Save to prefs
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user', jsonEncode(_currentUser!.toJson()));
    });
    
    notifyListeners();
  }

  void removeDeliveryAddress(String address) {
    if (_currentUser == null) return;
    
    final addresses = List<String>.from(_currentUser!.deliveryAddresses);
    addresses.remove(address);
    
    _currentUser = _currentUser!.copyWith(
      deliveryAddresses: addresses,
    );
    
    // Save to prefs
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user', jsonEncode(_currentUser!.toJson()));
    });
    
    notifyListeners();
  }
} 