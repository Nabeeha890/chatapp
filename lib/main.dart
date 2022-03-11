import 'package:chat_app/.screens/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/firebase.dart';
import 'package:chat_app/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(title: "Nabs' Chat App"),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputField("Email", "Enter Email", widget.emailController),
            const SizedBox(
              height: 20,
            ),
            inputField("Password", "Enter Password", widget.passController,
                isObscureText: true),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential =
                            await FirebaseHelper.signInWithEmailPass(
                                widget.emailController.text,
                                widget.passController.text);
                        if (userCredential.user != null) {
                          var uID = userCredential.user!.uid;
                          var snapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .doc('$uID')
                              .get();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(userCredential)));
                        }
                      } catch (e) {
                        print("User not found");
                      }
                    },
                    child: Text("Sign In")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text("Register")),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  UserCredential? userCredential =
                      await FirebaseHelper.signInWithGoogle(context: context);
                  if (userCredential != null) {
                    var uID = userCredential.user!.uid;
                    var snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc('$uID')
                        .get();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(userCredential)));
                  }
                },
                child: Text("Sign in with Google")),
          ],
        ),
      ),
    );
  }

  Widget inputField(
      String title, String hintText, TextEditingController controller,
      {bool isObscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
              obscureText: isObscureText,
              controller: controller,
              decoration: InputDecoration(hintText: hintText)),
        ],
      ),
    );
  }
}
