// import 'dart:html';

import 'dart:convert';
// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/utils.dart';
import 'message_bubble.dart';

import './message_bubble.dart';

class Messages extends StatefulWidget {
  final String uid;
  const Messages({Key? key, required this.uid}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
// class Messages extends StatefulWidget {
//   @override
//   _MessagesState createState() => _MessagesState();
// }

// class _MessagesState extends State<Messages> {
  // List<QueryDocumentSnapshot> chatDoc = List.from([]);
  String profileid = "";
  String id2 = "";
  // TabController _tabController;
  inputData() async {
    final user = await FirebaseAuth.instance.currentUser;
    print("abcdefghijkl");
    final String? pid = user?.uid;
    print(pid);
    setState(() {
      profileid = pid!;
      id2 = widget.uid;
      print(profileid);
      print("😊😊😊999");
      print(id2);
    });
  }

  @override
  void initState() {
    super.initState();
    inputData();
    // print(profileid);
    // print("😊😊😊999");
    // print(id2);
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser,
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          // .doc(profileid)
          // .collection(id2)
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (!chatSnapshot.hasData) {
          print("No data!!");
          return const Center(child: Text("No Chats😒"));
        } else if (chatSnapshot.connectionState == ConnectionState.waiting) {
          print("Loading");
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(chatSnapshot.data!.docs[0]['text']);
          print("Jai Hind");
          // return Container();
          final chatDocs = chatSnapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == id2,
              ),
              itemCount: chatDocs.length,
              reverse: true,
            ),
          );
        }
      },
    );
  }
}
