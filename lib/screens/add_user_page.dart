import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {

  TextEditingController nameController = TextEditingController();

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
                controller: nameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
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
                      Navigator.pop(context, <String>[nameController.text]);
                    },
                    child: Text("Submit")
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
