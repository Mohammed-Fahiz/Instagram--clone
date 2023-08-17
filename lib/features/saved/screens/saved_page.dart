import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:task1_app/features/saved/Widgets/single_saved_post.dart';

import '../../../Models/mediaModel.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';
import '../../../core/constants/global-variables/global-variables.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  Stream<List<MediaModel>> getSavedPosts(String postId) {
    return FirebaseFirestore.instance
        .collectionGroup(FirebaseConstants.mediaCollections)
        .where("postId", isEqualTo: postId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MediaModel.fromJson(doc.data()))
            .toList());
  }

  callBackFunction() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    callBackFunction();
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 100,
          title: const Text(
            "Saved posts",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: usersModel!.saved.isNotEmpty
            ? GridView.builder(
                itemCount: usersModel!.saved.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  var postId = usersModel!.saved[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                        stream: getSavedPosts(postId),
                        builder: (context, snapshot) {
                          List<MediaModel>? savedPosts = snapshot.data;
                          return SingleSavedPost(
                            savedPost: savedPosts!,
                            callBackFunction: callBackFunction,
                          );
                        }),
                  );
                },
              )
            : Container(
                height: deviceHeight,
                width: deviceWidth,
                color: Colors.white,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Saved is empty!",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ));
  }
}
