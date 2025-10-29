import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/auth_model.dart';
import 'auth_state.dart';
import 'package:basket_ball_conuter/src/models/user.dart' as app_user;

class AuthCubit extends Cubit<AuthState> {
  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthCubit({fb_auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _auth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance,
      super(const AuthState());

  void toggleAuthMode() {
    emit(state.copyWith(isLogin: !state.isLogin));
  }

  Future<void> login(LoginRequest request) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      final uid = cred.user?.uid;
      if (uid == null) {
        throw Exception('Failed to obtain user id after sign-in');
      }

      // Fetch profile from Firestore
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        throw Exception('User profile not found');
      }

      final data = doc.data()!;
      final user = app_user.User.fromMap(data, uid);

      emit(state.copyWith(status: AuthStatus.success, user: user, error: null));
    } on fb_auth.FirebaseAuthException catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, error: e.message ?? e.code),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signUp(SignUpRequest request) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    try {
      // Create Firebase Auth user
      final cred = await _auth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      final uid = cred.user?.uid;
      if (uid == null) throw Exception('Failed to create user');

      // Save profile to Firestore
      final profile = {
        'fullName': request.fullName,
        'email': request.email,
        'phone': request.phone,
        'dob': request.dob != null ? Timestamp.fromDate(request.dob!) : null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(uid).set(profile);

      final user = app_user.User(
        id: uid,
        fullName: request.fullName,
        email: request.email,
        phone: request.phone,
        dob: request.dob,
      );

      emit(state.copyWith(status: AuthStatus.success, user: user, error: null));
    } on fb_auth.FirebaseAuthException catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, error: e.message ?? e.code),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  void resetError() {
    emit(state.copyWith(status: AuthStatus.initial, error: null));
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(state.copyWith(status: AuthStatus.success, error: null));
    } on fb_auth.FirebaseAuthException catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, error: e.message ?? e.code),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(const AuthState());
  }

  Future<void> loadCurrentUser() async {
    final current = _auth.currentUser;
    if (current == null) {
      emit(state.copyWith(status: AuthStatus.initial, user: null));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final uid = current.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        emit(
          state.copyWith(status: AuthStatus.error, error: 'Profile not found'),
        );
        return;
      }
      final data = doc.data()!;
      final user = app_user.User.fromMap(data, uid);
      emit(state.copyWith(status: AuthStatus.success, user: user, error: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }
}
