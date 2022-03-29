import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class NewMessage extends StatefulWidget {
  final String uid;
  const NewMessage({Key? key, required this.uid}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  Uint8List? _image;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  String profileid = "";
  inputData() async {
    final user = await FirebaseAuth.instance.currentUser;
    // print("abcdefghijkl");
    final String? pid = user?.uid;
    print(pid);
    setState(() {
      profileid = pid!;
      print(profileid);
      print("**********");
      print(userData['uid']);
    });
  }

// @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.clear();
//     super.dispose();
//   }
  // @override
  // void initState() {
  //   super.initState();
  //   inputData();
  // }
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    print("**Here??");
    FirebaseFirestore.instance.collection('chats')
        // .doc(profileid)
        // // .doc(userData['uid'])
        // .collection(userData['uid'])
        // // .doc()
        .add({
      'text': _enteredMessage,
      'createdAt': DateTime.now(),
      'userId': userData['uid'],
      'sender': userData['uid'],
      'username': userData['username'],
      'userImage': userData['photoUrl'],
      'chatId': userData[''],
    });
    print("yaha dekho" + userData['uid']);
    print(":::::::::::::::::::::");
    print(_enteredMessage);
    _controller.clear();
    _enteredMessage="";
  }

  @override
  void initState() {
    super.initState();
    getData();
    inputData();
  }

  bool isLoading = false;
  var userData = {};

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo_camera,
            ),
            color: Colors.blue,
            iconSize: 35,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Message...', border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          _enteredMessage.length == 0
              ? IconButton(
                  icon: Icon(
                    Icons.mic_none_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          _enteredMessage.length == 0
              ? IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          _enteredMessage.length == 0
              ? IconButton(
                  icon: Icon(
                    Icons.attachment,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          // IconButton(
          //   color: Theme.of(context).primaryColor,
          //   icon: Icon(
          //     Icons.send,
          //     color: Colors.white,
          //   ),

          //   onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          // ),
          _enteredMessage.length > 0
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  // onPressed: () {
                  //   _enteredMessage.trim().isEmpty ? null : _sendMessage();
                  //   setState(() {
                  //     _enteredMessage="";
                  //   });
                  // },
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  child: const Text('Send'),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }
}
