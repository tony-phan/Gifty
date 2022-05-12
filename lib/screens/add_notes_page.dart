import 'package:flutter/material.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AddNotesPageState createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {

  TextEditingController noteController = TextEditingController();

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
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: noteController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add A Note',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      Navigator.pop(context, <String>[noteController.text]);
                    },
                    child: Text("Submit")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
