import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/common/common.dart';
import 'otpscreen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  bool isLoading = false;
  TextEditingController phoneNumber = TextEditingController();

  Future<void> sendOtp({required BuildContext context}) async {
    if (phoneNumber.text.isNotEmpty && phoneNumber.text.length == 10) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          verificationCompleted: (phoneAuthCredential) {},
          verificationFailed: (error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Verification failed. Please try again.'),
              duration: Duration(seconds: 5),
            ));
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(number: phoneNumber.text, verificationId: verificationId),
              ),
            );
            // Save the verificationId for later use (e.g., in the OTP screen)
            // provider.otp = verificationId;
            setState(() {
              isLoading = false;
            });
          },
          codeAutoRetrievalTimeout: (verificationId) {},
          phoneNumber: "+91${phoneNumber.text}",
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error sending OTP. Please try again.'),
          duration: Duration(seconds: 5),
        ));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please check the mobile number'),
        duration: Duration(seconds: 5),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: width,
          child: Padding(
            padding: EdgeInsets.only(left: width * .2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(
                    //   "assets/logingsvg.svg",
                    //   height: MediaQuery.of(context).size.height * 0.2,
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Phone Number",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.05,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      width: width * 0.6,
                      height: 50.0, // Set the desired height
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Set the border color
                        borderRadius: BorderRadius.circular(8.0), // Optional: Set the border radius
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: width * .04,),
                        child: TextFormField(
                          controller: phoneNumber,

                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter the phone number',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                isLoading
                    ? Center(
                    child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    await sendOtp(context: context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(
                      width * 0.6,
                      MediaQuery.of(context).size.height * 0.06,
                    ),
                  ),
                  child: Text(
                    'Get OTP',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
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
