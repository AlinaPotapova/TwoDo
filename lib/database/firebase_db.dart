import 'package:firebase_database/firebase_database.dart';

class FirebaseDB {
  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference getUserRef(String userId) {
    return database.ref('users/$userId');
  }

  void createUserProfile(User user) {
    try {
      database.ref('users/${user.id}').set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromMap(Map<String, dynamic> data, String userId) {
    return User(
      id: userId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }
}
