import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:popup_menu/popup_menu.dart';

class MessageBubble extends StatelessWidget {
  // MessageBubble(String chatDoc, String chatDoc2, String chatDoc3, bool bool,
  //  {required ValueKey key}
  //  );

  MessageBubble(
    this.message,
    // this.userName,
    // this.userImage,
    this.isMe,
    // {
    // this.key,
    // }
  );

  // final Key key;
  final String message;
  // final String userName;
  // final String userImage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onLongPress: () {
                print("longPresses");
                showMenu(
                  position: RelativeRect.fromLTRB(90, 50, 30, 80),
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      // value: this._index,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete),
                          Text("Delete"),
                        ],
                      ),
                    )
                  ],
                  context: context,
                );
              },
            //  child: Container(
                // elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: isMe? null:Border.all(color: Colors.white24),
                    color:
                        isMe ? Colors.grey[900]:Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  width: 200,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   userName,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: isMe
                      //         ? Colors.white
                      //         : Theme.of(context).colorScheme.secondary,
                      //   ),
                      // ),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 18,
                          color: isMe
                              ? Colors.white
                              : Colors.white,
                        ),
                        // textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            // ),
          ],
        ),
      ],
    );
  }
}
