import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';

import '../ui/authentication/login_screen.dart';
import '../ui/posts/post_screen.dart';

class FireBaseServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
