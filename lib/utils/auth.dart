import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:md_fclient/models/login_data.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/utils/extensions.dart';



class Auth extends GetxController {
  static Auth get to => Get.find();

  final api = Mangadex();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var guest = false.obs;
  var loggedIn = false.obs;
  var username = "";
  var password = "";
  var sessionToken = "";
  var refreshToken = "";
  DateTime sessionExpiry = DateTime.fromMillisecondsSinceEpoch(1);
  DateTime refreshExpiry = DateTime.fromMillisecondsSinceEpoch(1);

  Auth._internal();

  /// Main const
  static Future<Auth> init() async {
    print("Auth init");
    Auth auth = Auth._internal();
    await auth.loadState();
    return auth;
  }

  Future<void> loadState() async {
    username= (await storage.read(key: 'username')) ?? "";
    password = (await storage.read(key: 'password')) ?? "";
    sessionToken = (await storage.read(key: 'sessionToken')) ?? "";
    refreshToken = (await storage.read(key: 'refreshToken')) ?? "";
    guest.value = (await storage.read(key: 'guest'))?.parseBool() ?? false;


    var sessionExpiryRaw = await storage.read(key: 'sessionExpiry');
    var refreshExpiryRaw = await storage.read(key: 'refreshExpiry');
    if(sessionExpiryRaw != null) {
      sessionExpiry = DateTime.fromMillisecondsSinceEpoch(int.parse(sessionExpiryRaw));
    }
    if(refreshExpiryRaw != null) {
      refreshExpiry = DateTime.fromMillisecondsSinceEpoch(int.parse(refreshExpiryRaw));
    }

    print(username);
    print(password);
    print(sessionToken);
    print(refreshToken);
    if (sessionToken.isNotEmpty) {

      loggedIn.value = true;
    }
  }

  Future<void> saveState() async {
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'sessionToken', value: sessionToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'sessionExpiry', value: sessionExpiry.millisecondsSinceEpoch.toString());
    await storage.write(key: 'refreshExpiry', value: refreshExpiry.millisecondsSinceEpoch.toString());

  }

  Future<bool> login(String username, String password) async {
    var loginData = await api.login(username, password);
    this.username = username;
    this.password = password;
    sessionToken = loginData.token;
    refreshToken = loginData.refreshToken;
    loggedIn.value = true;
    sessionExpiry = DateTime.now().add(const Duration(minutes: 14));
    refreshExpiry = DateTime.now().add(const Duration(days: 27));
    saveState();
    return true;
  }

  /// Don't call this without logging in
  Future<String> getSessionToken() async {
    if (!loggedIn.value){
      throw Exception("Can't get session token without logging in");
    }
    try {
      if (isRefreshExpired()) {
        var loginData = await api.login(username, password);
        sessionToken = loginData.token;
        refreshToken = loginData.refreshToken;
        sessionExpiry = DateTime.now().add(const Duration(minutes: 14));
        refreshExpiry = DateTime.now().add(const Duration(days: 27));
        saveState();
      }
      else if (isSessionExpired()) {
        var loginData = await api.refreshToken(refreshToken);
        sessionToken = loginData.token;
        refreshToken = loginData.refreshToken;
        sessionExpiry = DateTime.now().add(const Duration(minutes: 14));
        refreshExpiry = DateTime.now().add(const Duration(days: 27));
        saveState();

      }
    } catch (e) {
      print("Can't refresh the session token. Logging out.");
      print(e);
      logout();
      throw Exception("Can't refresh the session token. Logging out.");
    }
    return sessionToken;
  }

  Future<void> loginAsGuest() async {
    guest.value = true;
    loggedIn.value = false;
    await storage.write(key: "guest", value: "true");
  }

  Future<void> logout() async {
    loggedIn.value = false;
    guest.value = false;
    sessionToken = "";
    refreshToken = "";
    await storage.delete(key: "guest");
    await storage.delete(key: 'sessionToken');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'password');
  }

  bool isSessionExpired() {
    return DateTime.now().isAfter(sessionExpiry);
  }

  bool isRefreshExpired() {
    return DateTime.now().isAfter(refreshExpiry);
  }

}