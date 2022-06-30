// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/usermodel.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Future<String> getAvatarUrl() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profilepic/${loggedInUser.profilePic}');
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    print(url);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: Container(
                    width: MediaQuery.of(context).size.width - 150,
                    height: 35,
                    child: Center(
                        child: Text(
                      "MeetMeFit",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ))),
              ),
              SizedBox(
                  height: 150,
                  child: FutureBuilder(
                    future: getAvatarUrl(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Container(
                          width: 100,
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(
                            snapshot.data!,
                          )));
                    },
                  )),
              SizedBox(height: 15),
              Text(
                "${loggedInUser.name}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all()),
                child: Text("${loggedInUser.about}",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                    "*                  *\n*                  *\n*                  *\n************\n*                  *\n*                  *\n*                  *"),
              ),
              SizedBox(
                height: 45,
              ),
              ActionChip(
                  label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
