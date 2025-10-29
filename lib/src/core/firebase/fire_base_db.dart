import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'models/user_model.dart';

class FirebaseDb {
  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseDb({fb_auth.FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? fb_auth.FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  // Sign up with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? dob,
  }) async {
    // Create auth user
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) throw Exception('Failed to create user');

    // Create user profile
    final userData = UserModel(
      id: uid,
      name: name,
      email: email,
      phone: phone,
      dob: dob,
      favProducts: [],
      createdAt: DateTime.now(),
    );

    // Save to Firestore
    await _firestore.collection('users').doc(uid).set(userData.toJson());

    return userData;
  }

  // Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) throw Exception('Failed to get user ID');

    // Get user profile
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('User profile not found');
    }

    return UserModel.fromJson(uid, doc.data()!);
  }

  // Get current user profile
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromJson(user.uid, doc.data()!);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update user profile
  Future<UserModel> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('users').doc(userId).update(data);

    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('Failed to update profile');
    }

    return UserModel.fromJson(userId, doc.data()!);
  }
}
