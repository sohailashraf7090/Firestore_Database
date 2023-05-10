import 'package:firebase_auth/firebase_auth.dart';

import 'package:firestore_database/ui/authentication/signup_screen.dart';
import 'package:firestore_database/ui/authentication/verify_with_number.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';
import '../posts/post_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Fire Store Login Screen"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your email",
                        labelText: "Email",
                      ),
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Enter your email";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_open),
                          hintText: "Enter your password",
                          labelText: "password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your password";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: RoundedButton(
                loading: loading,
                title: "Login",
                onTap: (() {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    _auth
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text.toString())
                        .then((value) {
                      Utils().toastMessege(value.user!.email.toString());
                      Utils().toastMessege("Login Successfully");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostScreen()));
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      debugPrint(error.toString());
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessege(error.toString());
                    });
                  }
                }),
              )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("Sign up"))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegisterWithPhoneNumber()));
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: const Center(
                      child: Text(
                    "Register with phone number",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ]),
      ),
    );
  }
}
