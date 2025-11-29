class UserResponse {
  final int id;
  final String fullName;
  final int roleId;
  final int? isKycVerified;
  final bool isVerified;
  final String emailId;
  final String mobileNumber;
  final Role role;

  UserResponse({
    required this.id,
    required this.fullName,
    required this.roleId,
    this.isKycVerified,
    required this.isVerified,
    required this.emailId,
    required this.mobileNumber,
    required this.role,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      roleId: json['roleId'] ?? 0,
      isKycVerified: json.containsKey('isKYCVerified')
          ? json['isKYCVerified'] as int?
          : null,
      isVerified: json['isVerified'] ?? false,
      emailId: json['emailId'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: Role.fromJson(json['role'] ?? {}),
    );
  }
}

class Role {
  final int id;
  final String name;
  final String roleUniqueId;

  Role({required this.id, required this.name, required this.roleUniqueId});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      roleUniqueId: json['roleUniqueId'] ?? '',
    );
  }
}
