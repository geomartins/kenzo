class ProfileModel {
  final String firstname;
  final String lastname;
  final String middlename;
  final String email;
  final String role;
  final String department;
  final String coverUrl;

  ProfileModel.fromFirestore(Map<String, dynamic> user)
      : email = user['email'],
        firstname = user['firstname'],
        middlename = user['middlename'],
        lastname = user['lastname'],
        role = user['role'],
        coverUrl = user['cover_url'],
        department = user['department'];

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
