import 'package:flutter/material.dart';

class AddGiftPage extends StatefulWidget {
  const AddGiftPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AddGiftPageState createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {

  TextEditingController giftController = TextEditingController();

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
          mainAxisAlignment: MainAxisAlignment.center, // vertical allignment
          crossAxisAlignment: CrossAxisAlignment.center, // horizontal allignment
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: giftController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add A Gift',
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
                      Navigator.pop(context, <String>[giftController.text]);
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
