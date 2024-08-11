import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/common/common.dart';
import '../../../model/userModel.dart';
import '../../home/screens/screens.dart';

class OtpScreen extends StatefulWidget {
  final String number;
  final String verificationId;

  const OtpScreen({super.key, required this.number, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';

  void verifyOtp() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      ///' Sign in using the credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      /// Check if user exists in Firestore
      final userDoc = await FirebaseFirestore.instance.
      collection('butomyUsers').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        /// User already exists, navigate to OTP screen again to generate new OTP
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              number: widget.number,
              verificationId: widget.verificationId,
            ),
          ),
        );
      } else {
        /// User is new, add to Firestore
        final userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? '',
          uid: userCredential.user!.uid,
          phoneNumber: userCredential.user!.phoneNumber ?? '',
        );

        await FirebaseFirestore.instance
            .collection('butomyUsers')
            .doc(userModel.uid)
            .set(userModel.toMap());

        /// Navigate to home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
              (route) => false,
        );
      }
    } catch (e) {
      /// If sign in fails, show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect OTP. Please try again.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.07,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.05,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Enter the verification code we just sent to your \n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * 0.03,
                              ),
                            ),
                            TextSpan(
                              text: 'number ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * 0.03,
                              ),
                            ),
                            TextSpan(
                              text: '+91 ****${widget.number.substring(7)} ',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: width * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        child: PinCodeTextField(
                          autoDisposeControllers: false,
                          keyboardType: TextInputType.number,
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            inactiveColor: Colors.black,
                            inactiveFillColor: Colors.white,
                            activeFillColor: Colors.white,
                            disabledColor: Colors.white,
                          ),
                          animationDuration: Duration(milliseconds: 250),
                          backgroundColor: Colors.white,
                          enableActiveFill: true,
                          onChanged: (value) {
                            setState(() {
                              otp = value;
                            });
                          },
                          appContext: context,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Don\'t Get OTP?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: width * 0.03,
                          ),
                        ),
                        TextSpan(
                          text: 'Resend ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: width * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * .25),
                  child: ElevatedButton(
                    onPressed: () async {
                      verifyOtp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(width * 0.5, height * 0.06),
                    ),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
