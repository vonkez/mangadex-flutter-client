class LoginData{
  String token;
  String refreshToken;
  String? message;

  LoginData({required this.token, required this.refreshToken, this.message});
}