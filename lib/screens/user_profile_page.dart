import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gifty/screens/add_gift_page.dart';
import 'package:gifty/screens/add_notes_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key, required this.title, required this.docId}) : super(key: key);

  final String title;
  final String docId;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  late DocumentSnapshot userData;
  List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      _loadUserData();
      print("Build Completed");
    });
  }

  void _loadUserData() async {
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").doc(widget.docId).get()
        .then((querySnapshot) {
          userData = querySnapshot;
          setState(() {}); // refresh the list view
          print("Successfully loaded user data");
    }).catchError((error) {
      print("Failed to load user data");
      print(error);
    });
  }

  void _AddNote(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const AddNotesPage(title: "Add A Note")),
    );

    var newNote = [result[0]];
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").doc(widget.docId).update(
        {
          "notes": FieldValue.arrayUnion(newNote)
        }
    ).then((value) {
      print("Successfully added a new note");
      _loadUserData();
    }).catchError((error) {
      print("Failed to add a new note");
      print(error);
    });
  }

  void _AddGift(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const AddGiftPage(title: "Add A Gift")),
    );

    var newGift = [result[0]];
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").doc(widget.docId).update(
        {
          "gifts": FieldValue.arrayUnion(newGift)
        }
    ).then((value) {
      print("Successfully added a new gift");
      _loadUserData();
    }).catchError((error) {
      print("Failed to add a new gift");
      print(error);
    });
  }

  void _deleteGift(int index) async {
    var giftToDelete = [(userData['gifts'])[index]];
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").doc(widget.docId).update(
        {
          "gifts": FieldValue.arrayRemove(giftToDelete)
        }
    ).then((value) {
      print("Successfully deleted the gift");
      _loadUserData();
    }).catchError((error) {
      print("Failed to delete the gift");
      print(error);
    });
  }

  void _deleteNote(int index) async {
    var noteToDelete = [(userData['notes'])[index]];
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("People").doc(widget.docId).update(
        {
          "notes": FieldValue.arrayRemove(noteToDelete)
        }
    ).then((value) {
      print("Successfully deleted the note");
      _loadUserData();
    }).catchError((error) {
      print("Failed to delete the note");
      print(error);
    });
  }

  Widget _giftItem(index) {
    final item = (userData['gifts'])[index];
    return Dismissible(
      key: Key(item),
      onDismissed: (direction) {
        setState(() {
          _deleteGift(index);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$item dismissed')));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Container(
          height: 50,
          color: Colors.amber[colorCodes[index % colorCodes.length]],
          child: Center(child: Text((userData['gifts'])[index])),
        ),
      ),
    );
  }

  Widget _noteItem(index) {
    final item = (userData['notes'])[index];
    return Dismissible(
      key: Key(item),
      onDismissed: (direction) {
        setState(() {
          _deleteNote(index);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$item dismissed')));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Container(
          height: 50,
          color: Colors.amber[colorCodes[index % colorCodes.length]],
          child: Center(child: Text((userData['notes'])[index])),
        ),
      ),
    );
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
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            const Text("Gift Ideas"),
            Expanded(
                flex: 40,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: userData['gifts'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return _giftItem(index);
                    }
                )
            ),
            const Text("Notes"),
            Expanded(
                flex: 40,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: userData['notes'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return _noteItem(index);
                    }
                )
            ),
            Expanded(
                flex: 20,
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
                          _AddGift(context);
                        },
                        child: const Text("Add A Gift")
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          _AddNote(context);
                        },
                        child: const Text("Add A Note")
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
