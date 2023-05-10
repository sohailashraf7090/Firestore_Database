import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';
import '../posts/post_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final codeController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("verification")),
      body: Column(
        children: [
          TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: "6 didit Code",
              labelText: "Enter  Code",
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          RoundedButton(
            loading: loading,
            title: "Submit",
            onTap: (() async {
              setState(() {
                loading = true;
              });
              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: codeController.text.toString());

              try {
                await auth.signInWithCredential(credential);
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostScreen()));
              } catch (e) {
                setState(() {
                  loading = false;
                  Utils().toastMessege(e.toString());
                });
              }
            }),
          )
        ],
      ),
    );
  }
}
