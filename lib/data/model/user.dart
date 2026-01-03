class UserModel {
  final String userId;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String fullName;
  final String username;
  final String status;

  UserModel({
    required this.userId,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.username,
    required this.status,
  });

  /// FROM JSON (API → APP)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      username: json['username'],
      status: json['status'],
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
