
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:md_fclient/ui/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  final bool firstPage;
  const Login({Key? key, this.firstPage = true}) : super(key: key);

  InputDecoration? getUsernameDecoration() {
    if (LoginController.to.usernameError.value) {
      return const InputDecoration(
        errorText: 'Username must be at least 1 characters',
        border: OutlineInputBorder(),
        labelText: 'Username',
      );
    } else {
      return const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Username',
      );
    }
  }

  InputDecoration? getPasswordDecoration() {
    if (LoginController.to.passwordError.value) {
      return const InputDecoration(
        errorText: 'Password must be at least 8 characters',
        border: OutlineInputBorder(),
        labelText: 'Password',
      );
    } else {
      return const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx((){
        if(LoginController.to.loggingIn.value){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(child: CircularProgressIndicator()),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              "assets/md_logo.svg",
              fit: BoxFit.contain,
              height: 100,
            ),
            SvgPicture.asset(
              "assets/md_text.svg",
              fit: BoxFit.contain,
              height: 60,
              color: const Color.fromRGBO(232, 230, 227, 1),
            ),
            Offstage(
              offstage: LoginController.to.error.isEmpty,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 6),
                child: Text(LoginController.to.error.value, style: TextStyle(color: Colors.red, fontSize: 16),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20),
              child: TextField(
                maxLength: 64,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: LoginController.to.usernameController,
                textInputAction: TextInputAction.next,
                //onChanged: (v)=> LoginController.to.username.value = v,
                decoration: getUsernameDecoration(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10),
              child: TextField(
                maxLength: 1024,

                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: LoginController.to.passwordController,
                //onChanged: (v)=> LoginController.to.password.value = v,
                onSubmitted: (v) => LoginController.to.login(!firstPage),
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: getPasswordDecoration(),
              ),
            ),
            /*Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 0),
                child: Obx(()=>CheckboxListTile(
                  title: const Text('Remember me'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  shape: ContinuousRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(15))),
                  value: LoginController.to.rememberMe.value,
                  onChanged: (v)=> LoginController.to.rememberMe.value = v!,
                ),
                )),*/
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
              child: SizedBox(
                  height: 50,
                  child: ElevatedButton(onPressed: ()=>LoginController.to.login(!firstPage), child: Text("Login"))
              ),
            ),
            TextButton(
                onPressed: ()=> LoginController.to.loginAsGuest(),
                child: const Text('Continue as a guest', style: TextStyle(fontSize: 18),)
            ),
            const Spacer(),
            TextButton(onPressed: ()=> launch('https://mangadex.org/account/signup'), child: const Text('Create an account', style: TextStyle(fontSize: 18),))
          ],
        );
      })
    );
  }
}