import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/constants/firebaseConstants/firebaseConstants.dart';
import '../../../core/failure.dart';
import '../../../model/userModel.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })   : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseCollections.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    print('111111111111111111111');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(Failure(failure: 'Sign in aborted by user'));
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        final userModel = UserModel(
          name: userCredential.user!.displayName ?? '',
          profilePic: userCredential.user!.photoURL ?? '',
          uid: userCredential.user!.uid,
          phoneNumber: userCredential.user!.phoneNumber??'',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        return right(userModel);
      } else {
        final userModel = await getUserData(userCredential.user!.uid).first;
        return right(userModel);
      }
    } on FirebaseException catch (e) {
      return left(Failure(failure: e.message ?? 'An error occurred'));
    } catch (e) {
      print('0000000000000000000000');
      print(e.toString());
      return left(Failure(failure: e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) =>
        UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
