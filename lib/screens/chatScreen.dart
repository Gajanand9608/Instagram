import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/chat/chatInput.dart';
import 'package:instagram_clone_flutter/chat/chatWindowUser.dart';

import '../utils/utils.dart';
import '../widgets/messages.dart';
import '../widgets/new_messages.dart';

class ChatScreen extends StatefulWidget {
  final String uid;
  const ChatScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var userData = {};
  // int postLen = 0;
  // int followers = 0;
  // int following = 0;
  // bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();

      // postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      print("Here are you");
      print(userData);
      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      //   isFollowing = userSnap
      //       .data()!['followers']
      //       .contains(FirebaseAuth.instance.currentUser!.uid);
      //   setState(() {});
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
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(userData['username']),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ChatWindowUser(),
//           Divider(),
//           ChatInput(),
//         ],
//       ),
//     );
//   }
// }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(userData['username']),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        userData['photoUrl'],
                      ),
                    ),
                  ),
                  Text(
                    userData['username'],
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                
            
                ],
              ),
            ),
            Expanded(
              child: Messages(
                uid: userData['uid'],
              ),
            ),
            NewMessage(
              uid: userData['uid'],
            ),
          ],
        ),
      ),
    );
  }
}
