import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pa;

import '../utils/FirebaseApi/FirebaseApi.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}
File? reelfile;
  bool isVideo = false;

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    isVideo = false;
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    isVideo = false;
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Reels'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final file =
                      await FilePicker.platform.pickFiles(allowMultiple: false);
                  if (file == null) {
                    print("GGGGGGGGGGGGGGGGGGG");
                    return null;
                  }

                  final path = file.files.single.path!;
                  print(path);
                  uploadFile();
                  setState(() {
                    isVideo = true;
                    reelfile = File(path);
                    if(reelfile==null)
                    {
                      print("Reel NULL");
                    }
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future uploadFile() async {
    if (reelfile == null) {
      print("KKKKKKKKKKKKKK");
      return;}
    if (isVideo) {
      print("(9999(((((((((((((");
    }
    final DateTime now = DateTime.now();
    final int millSeconds = now.millisecondsSinceEpoch;
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String storageId =
        (millSeconds.toString() + FirebaseAuth.instance.currentUser!.uid);
    final String today = ('$month-$date');
    final filename = pa.basename(reelfile!.path);
    // final destination =
    //     'posts/video/${FirebaseAuth.instance.currentUser!.uid}/${today}/${storageId}';
    final destination = 'posts/video/${storageId}';

    var response = FirebaseApi.uploadFile(destination, reelfile!);
    print("Here----$response");
  }

  //  void UploadReel() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final DateTime now = DateTime.now();
  //     final int millSeconds = now.millisecondsSinceEpoch;
  //     final String month = now.month.toString();
  //     final String date = now.day.toString();
  //     final String storageId = (millSeconds.toString() + FirebaseAuth.instance.currentUser!.uid);
  //     final String today = ('$month-$date');

  //     final reel = reelfile;
  //     final file = File(reel!.path);

  //      final metadata = SettableMetadata(
  //       contentType: 'video/mp4',
  //       customMetadata: {'picked-file-path': file.path});

  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     Reference ref = storage.ref().child("reels").child("video").child(today).child(storageId);
  //     UploadTask uploadTask;
  //     if(kIsWeb){
  //       uploadTask = ref.putData(await file.readAsBytes(), metadata);
  //     } else {
  //     uploadTask = ref.putFile(File(file.path), metadata);
  //     //print("HERE------------------------"+Future.value(uploadTask));
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("HERE--------------");
  //     //return Future.value(uploadTask);
  //   }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading

    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    print("Here:---$isVideo");
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => isVideo
                      ? uploadFile()
                      : postImage(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
