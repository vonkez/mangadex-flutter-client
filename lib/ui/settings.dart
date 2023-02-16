
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/ui/login.dart';
import 'package:md_fclient/ui/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/auth.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(()=>buildAccountTile()),
        Text("Settings"),
        Divider(),
        SwitchListTile(title: Text("some setting"),value: true, onChanged: (x){}),
        SwitchListTile(title: Text("some setting"),value: true, onChanged: (x){}),
        SwitchListTile(title: Text("some setting"),value: true, onChanged: (x){}),
        Divider(),
        SwitchListTile(title: Text("some setting"),value: true, onChanged: (x){}),
        OutlinedButton(onPressed: () async {
          var r = await Mangadex().getFollowedManga();
          r.forEach((element) {print(element.toString());});
        }, child: Text("Test button 1")),
        Divider(),

        // ListTile(title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold),), trailing: const Icon(Icons.logout), onTap: (){}),
      ],
    );
  }

  Widget buildAccountTile(){
    if(Auth.to.loggedIn.value){
      return ListTile(
          title: Text(LoginController.to.usernameController.value.text),
          subtitle: const Text('Tap to logout'),
          onTap: () => Get.defaultDialog(
              title: "Logout",
              onCancel: () => null,
              onConfirm: () {
                //LoginController.to.loggedIn.value = false;
                LoginController.to.logout();
                Get.back();
              },
              middleText: "You are going to logout."
          ),
          leading: const Icon(Icons.account_circle, size: 45,)
      );
    }else {
      return ListTile(
          title: const Text('Guest'),
          subtitle: const Text('Tap to login'),
          onTap: () {
            Auth.to.logout();
            Get.to(Login(firstPage: false));
          },
          leading: const Icon(Icons.account_circle, size: 45,)
      );
    }
  }
}