
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../model/userModel.dart';
import '../../home/screens/screens.dart';
import '../repository/authRepository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  return AuthRepository(firestore: firestore, auth: auth, googleSignIn: googleSignIn);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository auth_repository, required Ref ref})
      : _authRepository = auth_repository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    
      final res = await _authRepository.signInWithGoogle();
      state= false;
      res.fold((l) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l.failure),
          duration: Duration(seconds: 5),
        ));
      }, (r) {
        
          _ref.read(userProvider.notifier).update((state) => r);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

      });
  }
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}

final userProvider = StateProvider<UserModel?>((ref) => null);
