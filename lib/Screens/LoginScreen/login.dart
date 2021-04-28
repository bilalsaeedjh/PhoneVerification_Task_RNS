import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:phone_auth/Screens/HomeScreen/home.dart';
import 'package:phone_auth/Screens/otp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //Initializing Firebase for app
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
  }

  bool inProgress=true;

  var _number=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDefault();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Login with Phone"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _number,
            maxLength: 10,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              prefix: Padding(
                padding: EdgeInsets.all(4),
                child: Text('+92'),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
           ElevatedButton(
              child: Text("Login"), onPressed: () => Get.to(OTPScreen(_number.text,inProgress))
           )
        ],
      ),
    );
  }
}
