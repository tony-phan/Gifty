import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gifty/screens/user_profile_page.dart';

import 'add_user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<QueryDocumentSnapshot> people = [];
  List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      _loadPeopleData();
      print("Build Completed");
    });
  }

  void _loadPeopleData() async {
    people.clear();

    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        people.add(element);
      });
      setState(() {}); // refresh the list view
      print("Successfully loaded people data");
    }).catchError((error) {
      print("Failed to load people data");
      print(error);
    });
  }

   void _deletePerson(String docId) async {
     FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").doc(docId).delete()
         .then((value) {
           print("Successfully deleted person");
           _loadPeopleData();
     }).catchError((error) {
       print("Failed to delete person");
       print(error);
     });
   }

   void _addPerson(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const AddUserPage(title: "Add A Person")),
    );

    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").add(
      {
        "gifts": [],
        "notes": [],
        "name": result[0]
      }
    ).then((value) {
      print("Successfully added a new person");
      _loadPeopleData();
    }).catchError((error) {
      print("Failed to add a new person");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
              ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 25,
              child: Image.asset(
                "assets/images/giftbox.jpg",
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 50,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: people.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = (people[index])['name'];
                    return Dismissible(
                      key: Key(item),
                      onDismissed: (direction) {
                        setState(() {
                          _deletePerson(people[index].id);
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('$item dismissed')));
                      },
                      background: Container(
                        color: Colors.red,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserProfilePage(title: (people[index])['name'], docId: people[index].id)),
                          );
                        },
                        title: Container(
                          height: 50,
                          color: Colors.amber[colorCodes[index]],
                          child: Center(child: Text((people[index])['name'])),
                        ),
                      ),
                    );
                  }
              ),
            ),
            Expanded(
              flex: 25,
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
                          _addPerson(context);
                        },
                        child: const Text("Add A Person")
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Logout")
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
