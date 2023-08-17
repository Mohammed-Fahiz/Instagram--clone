import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task1_app/core/constants/images/asset_images.dart';

import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';
import '../../auth/controller/auth_controller.dart';

class FollowingPage extends StatefulWidget {
  final Function callBackFunction;
  final int followingLength;
  final UsersModel user;
  const FollowingPage(
      {super.key,
      required this.callBackFunction,
      required this.followingLength,
      required this.user});
  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  Stream<List<UsersModel>> getFollowing() {
    return FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollections)
        .where('followers', arrayContains: widget.user.userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => UsersModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Color appBarBg = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getFollowing(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var following = snapshot.data;
            return following!.isEmpty
                ? Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Image(
                            image:
                                AssetImage(AssetImageConstants.noFollowingImg),
                          ),
                        ),
                        widget.user.userId == currentUserId
                            ? const Text(
                                "You are not following anyone!🗿",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )
                            : Text(
                                "${widget.user.userName} are not following anyone!🗿",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: following.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                following[index].imageUrl.toString()),
                          ),
                          title: Text(
                            following[index].userName.toString(),
                          ),
                          subtitle: Text(following[index].userEmail.toString()),
                          trailing: widget.user.userId == currentUserId
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      following[index]
                                          .followersList
                                          .remove(currentUserId);
                                      var updateFollowing = following[index]
                                          .copyWith(
                                              followersList: following[index]
                                                  .followersList);
                                      following[index]
                                          .ref!
                                          .update(updateFollowing.toJson());
                                      widget.callBackFunction(
                                          widget.followingLength);
                                    });
                                  },
                                  child: const Text("Unfollow"))
                              : null,
                        ),
                      );
                    },
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
