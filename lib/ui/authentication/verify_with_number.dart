import 'package:firebase_auth/firebase_auth.dart';

import 'package:firestore_database/ui/authentication/verifycode_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class RegisterWithPhoneNumber extends StatefulWidget {
  const RegisterWithPhoneNumber({super.key});

  @override
  State<RegisterWithPhoneNumber> createState() =>
      _RegisterWithPhoneNumberState();
}

class _RegisterWithPhoneNumberState extends State<RegisterWithPhoneNumber> {
  final numberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register With Number")),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: numberController,
            decoration: const InputDecoration(
              hintText: "123-345-567",
              labelText: "Enter Number",
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          RoundedButton(
            loading: loading,
            title: "proceed",
            onTap: (() {
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                  phoneNumber: numberController.text,
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    Utils().toastMessege(e.toString());
                  },
                  codeSent: (String verificationId, int? forceResendingToken) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyCodeScreen(
                                  verificationId: verificationId,
                                )));
                  },
                  codeAutoRetrievalTimeout: (e) {
                    Utils().toastMessege(e.toString());
                    setState(() {
                      loading = false;
                    });
                  });
            }),
          )
        ],
      ),
    );
  }
}
