import 'package:bigwelt/feature/authentication/screens/login.dart';
import 'package:bigwelt/feature/authentication/screens/phonescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/common.dart';
import '../../home/screens/screens.dart';
import '../controllor/authcontrollor.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(auth_repository: authRepository, ref: ref);
});

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final authController = ref.watch(authControllerProvider);


    Future<void> signUp() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        emailController.clear();
        passwordController.clear();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-Up Failed: $e')),
        );
      }
    }

    Future<void> resetPassword(String email) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send reset email: $e')),
        );
      }
    }

    void showForgotPasswordDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final resetEmailController = TextEditingController();
          return AlertDialog(
            title: const Text('Forgot Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: resetEmailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email address',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final email = resetEmailController.text.trim();
                  if (email.isNotEmpty) {
                    resetPassword(email);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text(' Reset'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:height * 0.2),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.email_outlined, size: MediaQuery.of(context).size.width * 0.05, color: Colors.brown.shade900),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(68, 68, 68, 1),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.lock_outline, size: MediaQuery.of(context).size.width * 0.05, color: Colors.brown.shade900),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    left:width * 0.25,),
                child: Row(
                  children: [
                    Text("Already you've an account? "),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context) => Login(),));
                      },
                        child : Text("LOGIN",style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter email and password')),
                    );
                  } else {
                    signUp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown.shade900,
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03,
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Sign Up', style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.white,
                )),
              ),
              SizedBox(height: height * 0.01),

              GestureDetector(
                onTap: () {
                  showForgotPasswordDialog();
                },
                child: Text('Forgot Password'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Divider(),
              Text('or'),
              InkWell(
                onTap: () {
                  ref.watch(authControllerProvider.notifier).signInWithGoogle(context);
                  print('Google sign-in pressed');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/images/google.png'),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                      Text(
                        'Google',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneScreen()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Icon(Icons.phone, color: Colors.white),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                      Text(
                        'Phone',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
