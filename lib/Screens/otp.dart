import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'HomeScreen/home.dart';
import 'LoginScreen/login.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  bool inProgress;
  OTPScreen(this.phoneNumber,this.inProgress);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  String _verificationCode;

  final TextEditingController _pinPutController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );


  _verifyMyPhoneNumber() async {
    //This handler will only be called on Android devices which support automatic SMS code resolution.
    await auth.verifyPhoneNumber(
        phoneNumber: '+92${this.widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              //Change state and move to next Screen
              setState(() {
                this.widget.inProgress=false;
              });
              Get.off(Home());
            }
          });
        },


        //In case, if Some error occured at Firebase then
        verificationFailed: (FirebaseAuthException e) {

          //Change state and Go back with a prompt
          setState(() {
            this.widget.inProgress=false;
          });
          Fluttertoast.showToast(
              msg: "Error: $e",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 12.0);
          Get.back(); //Go back to previious screen
        },


        codeSent: (String verficationID, int resendToken) {
          debugPrint("Code is sent from Server, Soon you will recieve it");
          //Change state and Let user to enter the code when received
          setState(() {
            this.widget.inProgress=false;
          });
          Fluttertoast.showToast(
              msg: "Please wait, You will soon receive the code!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 12.0);
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          debugPrint("This device has not automatically resolved an SMS message within a certain Timeframe");
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }
  //TIMER Code
  Timer _timer;
  int _start = 65;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          //Please Try Again
          Fluttertoast.showToast(
              msg: "Please Try Again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);

          Get.off(Login());

          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyMyPhoneNumber();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    bool inProg=this.widget.inProgress;

    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Accessing..."),
        centerTitle: true,
      ),
      body: inProg?Center(
        child: CircularProgressIndicator(),
      ):Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +92-${widget.phoneNumber}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      debugPrint("Successfully Authenticated by phone");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  Fluttertoast.showToast(
                      msg: "Invalid OTP",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
            ),
          ),
          Text("$_start"),

        ],
      )
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

}

