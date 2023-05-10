import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'add_firestore_data.dart';

class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({super.key});

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('utlize').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('utlize');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fire-Store")),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Search Here"),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: fireStore,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text("Some Error here");
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final title =
                        snapshot.data!.docs[index]['title'].toString();

                    if (searchController.text.isEmpty) {
                      return Card(
                        child: ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text("Edit"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      myDilougeBox(
                                          title,
                                          snapshot.data!.docs[index]['id']
                                              .toString());
                                    },
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref
                                          .doc(snapshot.data!.docs[index]['id']
                                              .toString())
                                          .delete();
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text("Delete"),
                                  ))
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                      );
                    } else if (title.toLowerCase().contains(
                        searchController.text.toLowerCase().toString())) {
                      return Card(
                        child: ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text("Edit"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      myDilougeBox(
                                          title,
                                          snapshot.data!.docs[index]['id']
                                              .toString());
                                    },
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref
                                          .doc(snapshot.data!.docs[index]['id']
                                              .toString())
                                          .delete();
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text("Delete"),
                                  ))
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            }
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFirebaseStoreData()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> myDilougeBox(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Updatee"),
            content: Container(
              decoration: const BoxDecoration(),
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                controller: editController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .doc(id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
                      Utils().toastMessege("Updtate Done");
                    }).onError((error, stackTrace) {
                      Utils().toastMessege(error.toString());
                    });
                  },
                  child: const Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel"))
            ],
          );
        });
  }
}
