import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:phone_auth/Screens/HomeScreen/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseAuth auth = FirebaseAuth.instance;
  var _number=TextEditingController();
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
          /*TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.12);
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              Get.to(Home());
            },
            child: Text('Login'),
          )*/
           ElevatedButton(
              child: Text("Login"), /*onPressed: () => Get.to(Home())*/
              onPressed:(){

              }
           )
        ],
      ),
    );
  }
}
