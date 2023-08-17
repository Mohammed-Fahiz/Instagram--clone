import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';

class FollowersPage extends StatefulWidget {
  final UsersModel user;
  const FollowersPage({super.key, required this.user});
  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<UsersModel> followersList = [];

  Future<void> getFollowers() async {
    for (var followerId in widget.user.followersList) {
      FirebaseFirestore.instance
          .collection(FirebaseConstants.userCollections)
          .doc(followerId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          followersList.add(UsersModel.fromJson(snapshot.data()!));
        }
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    getFollowers();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: followersList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: widget.user.followersList.length,
              itemBuilder: (context, index) {
                var follower = followersList[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(follower.imageUrl.toString()),
                    ),
                    title: Text(follower.userName.toString()),
                    subtitle: Text(follower.userEmail.toString()),
                  ),
                );
              },
            ),
    );
  }
}
