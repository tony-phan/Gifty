import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gifty/screens/home_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gifty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Gifty'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Center(
            child: Text(
                'Gifty',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
            ),
          ),
          backgroundColor: Colors.amberAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 30,
                child: Image.asset(
                  "assets/images/giftbox.jpg",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  flex: 40,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: emailController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      )
                    ],
                  )
              ),
              Expanded(
                flex: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          ).then((value) {
                            print("Successful login");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage(title: "Gifty")),
                            );
                          }).catchError((onError) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Failed to log in')));
                            print(onError.toString());
                          });
                        },
                        child: const Text("Login"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          ).then((value) {
                            print("Successfully signed up the user");
                            FirebaseFirestore.instance.collection("users").doc(value.user?.uid).set(
                                {
                                  "uid": value.user?.uid,
                                  "email": emailController.text
                                }
                            ).then((value) {
                              print("Added to firestore");
                            }).catchError((onError) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('Failed to add to firestore')));
                              print(onError.toString());
                            });
                          }).catchError((onError) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('Failed to sign up the user')));
                            print(onError.toString());
                          });
                        },
                        child: const Text("Sign Up")
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
