import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        userProvider.logout();
                        Navigator.pop(context);
                        context.go('/auth');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  // Profile picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                      image: user.avatar != null
                          ? DecorationImage(
                              image: NetworkImage(user.avatar!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: user.avatar == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // User name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // User email
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Edit profile button
                  OutlinedButton.icon(
                    onPressed: () {
                      _showEditProfileDialog(context, user);
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Profile sections
            _buildProfileSection(
              context,
              title: 'Account',
              items: [
                ProfileMenuItem(
                  icon: Icons.history,
                  title: 'Order History',
                  onTap: () {
                    context.push('/profile/order-history');
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  onTap: () {
                    _showFavoritesDialog(context, user);
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.location_on,
                  title: 'Delivery Addresses',
                  onTap: () {
                    _showAddressesDialog(context, user);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Settings section
            _buildProfileSection(
              context,
              title: 'Settings',
              items: [
                ProfileMenuItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    // Navigate to notifications settings
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    // Navigate to language settings
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.lock,
                  title: 'Privacy',
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Help & Support section
            _buildProfileSection(
              context,
              title: 'Help & Support',
              items: [
                ProfileMenuItem(
                  icon: Icons.help,
                  title: 'Help Center',
                  onTap: () {
                    // Navigate to help center
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.message,
                  title: 'Contact Us',
                  onTap: () {
                    // Navigate to contact page
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.info,
                  title: 'About',
                  onTap: () {
                    // Show about dialog
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context, {
    required String title,
    required List<ProfileMenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Section items
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) => _buildMenuItem(context, item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, ProfileMenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update user profile
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.updateProfile(
                name: nameController.text,
                phoneNumber: phoneController.text,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context, User user) {
    if (user.favoriteItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have no favorite items yet.'),
        ),
      );
      return;
    }
    
    // In a real app, you would fetch the actual food items using the IDs
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Favorite Items'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: user.favoriteItems.length,
            itemBuilder: (context, index) {
              final itemId = user.favoriteItems[index];
              // This is a placeholder. In a real app, you would show actual items
              return ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text('Item #${itemId}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Remove from favorites
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    userProvider.toggleFavorite(itemId);
                    Navigator.pop(context);
                    _showFavoritesDialog(context, userProvider.currentUser!);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddressesDialog(BuildContext context, User user) {
    final newAddressController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delivery Addresses'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              // Add new address
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newAddressController,
                      decoration: const InputDecoration(
                        labelText: 'New Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                    onPressed: () {
                      if (newAddressController.text.isNotEmpty) {
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        userProvider.addDeliveryAddress(newAddressController.text);
                        newAddressController.clear();
                        Navigator.pop(context);
                        _showAddressesDialog(context, userProvider.currentUser!);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Address list
              Expanded(
                child: ListView.builder(
                  itemCount: user.deliveryAddresses.length,
                  itemBuilder: (context, index) {
                    final address = user.deliveryAddresses[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on, color: AppTheme.primaryColor),
                      title: Text(address),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Remove address
                          final userProvider = Provider.of<UserProvider>(context, listen: false);
                          userProvider.removeDeliveryAddress(address);
                          Navigator.pop(context);
                          _showAddressesDialog(context, userProvider.currentUser!);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'AirCanteen',
        applicationVersion: '1.0.0',
        applicationIcon: const Icon(
          Icons.restaurant_menu,
          size: 48,
          color: AppTheme.primaryColor,
        ),
        children: [
          const Text(
            'AirCanteen is a campus food delivery app that connects students with campus food services.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '© 2023 AirCanteen. All rights reserved.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
} 