class Organization {
  int id;
  String name;
  String email;
  String website;
  String phoneNumber;
  String remarks;
  String deletedAt;
  String createdAt;
  String updatedAt;

  Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.website,
    required this.phoneNumber,
    required this.remarks,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    website: json['website'],
    phoneNumber: json['phone_number'],
    remarks: json['remarks'],
    deletedAt: json['deleted_at'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}
