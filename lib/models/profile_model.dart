class ProfileModel {
  final String firstname;
  final String lastname;
  final String middlename;
  final String email;
  final String role;
  final String department;
  final bool approved;
  final String coverUrl;

  ProfileModel.fromFirestore(Map<String, dynamic> user)
      : email = user['email'],
        firstname = user['firstname'],
        middlename = user['middlename'],
        lastname = user['lastname'],
        role = user['role'],
        approved = user['approved'],
        coverUrl = user['cover_url'] ?? 'https://agropark.ng/ticket-logo.png',
        department = user['department'] ?? 'unknown';

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "department": department,
      "role": role,
      "firstname": firstname,
      "middlename": middlename,
      "lastname": lastname,
    };
  }
}
