class LoginModel {
  int residentId;
  String firstname;
  String lastname;
  String username;
  String pasword;
  String email;
  String deviceToken;
  String deviceId;
  bool isLogin;
  int homeId;
  String cardInfo;
  String cardScanPosition;
  bool activeUser;
  String loginDatetime;
  String createDatetime;
  String authToken;

  LoginModel({
    this.residentId,
    this.firstname,
    this.lastname,
    this.username,
    this.pasword,
    this.email,
    this.deviceToken,
    this.deviceId,
    this.isLogin,
    this.homeId,
    this.cardInfo,
    this.cardScanPosition,
    this.activeUser,
    this.loginDatetime,
    this.createDatetime,
    this.authToken,
  });

  factory LoginModel.formJson(dynamic json) {
    return LoginModel(
      residentId: json['resident_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      pasword: json['pasword'],
      email: json['email'],
      deviceToken: json['device_token'],
      deviceId: json['device_id'],
      isLogin: json['is_login'],
      homeId: json['home_id'],
      cardInfo: json['card_info'],
      cardScanPosition: json['card_scan_position'],
      activeUser: json['active_user'],
      loginDatetime: json['login_datetime'],
      createDatetime: json['create_datetime'],
      authToken: json['token'],
    );
  }
}
