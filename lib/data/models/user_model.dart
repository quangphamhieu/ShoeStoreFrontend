import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String fullName,
    required String phone,
    String? email,
    required int gender,
    required String roleName,
    required String statusName,
    int? storeId,
    required DateTime createdAt,
  }) : super(
          id: id,
          fullName: fullName,
          phone: phone,
          email: email,
          gender: gender,
          roleName: roleName,
          statusName: statusName,
          storeId: storeId,
          createdAt: createdAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        fullName: json["fullName"],
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        roleName: json["roleName"],
        statusName: json["statusName"],
        storeId: json["storeId"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
}

/// ---------- LOGIN RESPONSE ----------
class LoginResponse {
  final int userId;
  final String fullName;
  final String roleName;
  final String token;

  LoginResponse({
    required this.userId,
    required this.fullName,
    required this.roleName,
    required this.token,
  });
}

class LoginResponseModel extends LoginResponse {
  LoginResponseModel({
    required int userId,
    required String fullName,
    required String roleName,
    required String token,
  }) : super(
          userId: userId,
          fullName: fullName,
          roleName: roleName,
          token: token,
        );

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        userId: json["userId"],
        fullName: json["fullName"],
        roleName: json["roleName"],
        token: json["token"],
      );
}
