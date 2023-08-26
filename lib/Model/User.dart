class User {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String email;
  String username;
  String firebaseUid;
  String remarks;
  String emailVerifiedAt;
  String userVerifiedAt;
  String suspendedAt;
  String deletedAt;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.firebaseUid,
    required this.remarks,
    required this.emailVerifiedAt,
    required this.userVerifiedAt,
    required this.suspendedAt,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0,
    firstName: json['first_name'] ?? '',
    middleName: json['middle_name'] ?? '',
    lastName: json['last_name'] ?? '',
    email: json['email'] ?? '',
    username: json['username'] ?? '',
    remarks: json['remarks'] ?? '',
    firebaseUid: json['firebase_uid'] ?? '',
    emailVerifiedAt: json['email_verified_at'] ?? '',
    userVerifiedAt: json['user_verified_at'] ?? '',
    suspendedAt: json['suspended_at'] ?? '',
    deletedAt: json['deleted_at'] ?? '',
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );

  @override
  String toString() {
    return '''
    {
      "id": $id,
      "first_name": "$firstName",
      "middle_name": "${middleName ?? ''}",
      "last_name": "$lastName",
      "email": "$email",
      "username": "$username",
      "firebase_uid": "${firebaseUid ?? ''}",
      "remarks": "$remarks",
      "email_verified_at": "$emailVerifiedAt",
      "user_verified_at": "$userVerifiedAt",
      "suspended_at": "$suspendedAt",
      "deleted_at": "$deletedAt",
      "created_at": "$createdAt",
      "updated_at": "$updatedAt"
    }
  ''';
  }

  String fullName() {
    return '$firstName ${middleName != '' ? '$middleName ' : ''}$lastName';
  }
}
