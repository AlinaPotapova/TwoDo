class CustomUser {
  final String id;
  final String name;
  final String email;

  CustomUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CustomUser.fromMap(Map<String, dynamic> data, String userId) {
    return CustomUser(
      id: userId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }
}
