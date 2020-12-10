class ProfileModel {
  final String email;
  final String role;
  final String department;
  final String coverUrl;

  ProfileModel.fromFirestore(Map<String, dynamic> user)
      : email = user['email'],
        role = user['role'],
        coverUrl = user['cover_url'],
        department = user['department'];
}
