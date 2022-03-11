import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/.screens/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  final UserCredential userCredential;
  //final DocumentSnapshot snapshot;
  const HomePage(this.userCredential);
}

class _HomePageState extends State<HomePage> {
  TextEditingController newTextController = TextEditingController();
  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');
  CollectionReference usersData =
      FirebaseFirestore.instance.collection('messages');

  User? currentUser = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 196, 38, 135),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
