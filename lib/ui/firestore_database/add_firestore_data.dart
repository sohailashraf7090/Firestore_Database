import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';
import 'firestore_list_screen.dart';

class AddFirebaseStoreData extends StatefulWidget {
  const AddFirebaseStoreData({super.key});

  @override
  State<AddFirebaseStoreData> createState() => _AddFirebaseStoreDataState();
}

class _AddFirebaseStoreDataState extends State<AddFirebaseStoreData> {
  final addPostController = TextEditingController();
  bool loading = false;

  final fireStore = FirebaseFirestore.instance.collection('utlize');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" Share FireStore Post Screen")),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: addPostController,
            maxLines: 5,
            decoration: const InputDecoration(
                hintText: "Share Your Thoughts", border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RoundedButton(
            loading: loading,
            title: "Post",
            onTap: () {
              setState(() {
                loading = true;
              });
              String id = DateTime.now().microsecond.toString();
              fireStore.doc(id).set({
                'id': id,
                'title': addPostController.text.toString()
              }).then((value) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessege("has been Post");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FireStoreListScreen()));
              }).onError((error, stackTrace) {
                loading = false;
                Utils().toastMessege(error.toString());
              });
            })
      ]),
    );
  }
}
