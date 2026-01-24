class UserModel {
  final String userId;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? username;
  final String? status;

  UserModel({
    required this.userId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.fullName,
    this.username,
    this.status,
  });

  /// FROM JSON (API → APP)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '', // bắt buộc
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fullName: json['fullName'] as String?,
      username: json['username'] as String?,
      status: json['status'] as String?,
    );
  }

  /// TO JSON (APP → API nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'username': username,
      'status': status,
    };
  }
}
