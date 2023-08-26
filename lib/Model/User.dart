class User {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String email;
  String username;
  String password;
  String remarks;
  String emailVerifiedAt;
  String userVerifiedAt;
  String suspendedAt;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    required this.remarks,
    required this.emailVerifiedAt,
    required this.userVerifiedAt,
    required this.suspendedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    firstName: json['first_name'],
    middleName: json['middle_name'],
    lastName: json['last_name'],
    email: json['email'],
    username: json['username'],
    password: json['password'],
    remarks: json['remarks'],
    emailVerifiedAt: json['email_verified_at'],
    userVerifiedAt: json['user_verified_at'],
    suspendedAt: json['suspended_at'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}
