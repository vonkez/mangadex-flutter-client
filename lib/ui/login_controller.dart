import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:md_fclient/models/login_data.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/utils/extensions.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:path_provider/path_provider.dart' as pp;

import '../main.dart';
import '../network/api_base.dart';
import '../utils/auth.dart';


class LoginController extends GetxController {
  static LoginController get to => Get.find();


  var error = "".obs;
  var usernameError = false.obs;
  var passwordError = false.obs;
  var loggingIn = false.obs;
  var rememberMe = false.obs;

  var usernameController = TextEditingController(text: Auth.to.username);
  var passwordController = TextEditingController(text: Auth.to.password);
  DateTime sessionExpiry = DateTime.fromMillisecondsSinceEpoch(1);
  DateTime refreshExpiry = DateTime.fromMillisecondsSinceEpoch(1);

  @override
  void onInit() async {
    print("oninit login controller");

    super.onInit();
    print("oninit login end");
  }



  bool checkInputs(){
    if(usernameController.value.text.length<1) {
      usernameError.value = true;
    }else{
      usernameError.value = false;
    }
    if(passwordController.value.text.length<8) {
      passwordError.value = true;
    } else {
      passwordError.value = false;
    }
    if(usernameError.value||passwordError.value){
      return false;
    }else {
      return true;
    }
  }


  Future<void> login(bool silent) async{
    print(usernameController.value.text);
    print(passwordController.value.text);
    error.value = "";
    if (!checkInputs()) {
      return;
    }
    loggingIn.value = true;
    try{
      var success = await Auth.to.login(usernameController.value.text, passwordController.value.text);
      loggingIn.value = false;
      error.value = "";

      if (silent) {
        Get.back();
      }else {
        Get.off(MyHomePage(title: 'MangaDex',));
      }
    }
    catch (e) {
      loggingIn.value = false;
      error.value = e.toString();
    }
  }

  void loginAsGuest() async {
    await Auth.to.loginAsGuest();
    Get.off(MyHomePage(title: 'MangaDex',));
  }

  void logout() async {
    await Auth.to.logout();
    //passwordController.value.text = "";
  }


}