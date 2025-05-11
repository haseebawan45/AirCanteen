enum UserRole { student, admin }

class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatar;
  final UserRole role;
  final List<String> favoriteItems;
  final List<String> deliveryAddresses;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatar,
    this.role = UserRole.student,
    this.favoriteItems = const [],
    this.deliveryAddresses = const [],
  });

  // Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  // Create a copy of this user with given fields replaced with new values
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? avatar,
    UserRole? role,
    List<String>? favoriteItems,
    List<String>? deliveryAddresses,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      deliveryAddresses: deliveryAddresses ?? this.deliveryAddresses,
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'role': role.index,
      'favoriteItems': favoriteItems,
      'deliveryAddresses': deliveryAddresses,
    };
  }

  // Create from JSON (for future API integration)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
      role: UserRole.values[json['role'] ?? 0],
      favoriteItems: List<String>.from(json['favoriteItems'] ?? []),
      deliveryAddresses: List<String>.from(json['deliveryAddresses'] ?? []),
    );
  }
} 