import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


import '../../../Models/mediaModel.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';
import '../../../core/constants/global-variables/global-variables.dart';
import '../../auth/controller/auth_controller.dart';

class UserPostPage extends StatefulWidget {
  final UsersModel user;
  const UserPostPage({super.key, required this.user});

  @override
  State<UserPostPage> createState() => _UserPostPageState();
}

class _UserPostPageState extends State<UserPostPage> {
  final TextEditingController _editDescription = TextEditingController();
  Stream<List<MediaModel>> getCurrentUserPosts() {
    return widget.user.ref!
        .collection(FirebaseConstants.mediaCollections)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MediaModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight * .55,
      width: deviceWidth,
      child: StreamBuilder(
          stream: getCurrentUserPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userPosts = snapshot.data;
              return GridView.builder(
                itemCount: userPosts!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              iconTheme:
                                  const IconThemeData(color: Colors.black),
                            ),
                            body: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: deviceWidth,
                                  height: deviceHeight * .7,
                                  child: InteractiveViewer(
                                    child: Image(
                                      image: NetworkImage(
                                          userPosts[index].postUrl!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    widget.user.userId == currentUserId
                                        ? FloatingActionButton.extended(
                                            elevation: 0,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    92, 75, 153, 1),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: Container(
                                                    child: TextFormField(
                                                      controller:
                                                          _editDescription,
                                                      decoration: InputDecoration(
                                                          hintText: userPosts[
                                                                  index]
                                                              .postDescription),
                                                    ),
                                                  ),
                                                  actions: [
                                                    FloatingActionButton
                                                        .extended(
                                                      elevation: 0,
                                                      onPressed: () {
                                                        var editPost = userPosts[
                                                                index]
                                                            .copyWith(
                                                                postDescription:
                                                                    _editDescription
                                                                        .text);
                                                        userPosts[index]
                                                            .postRef!
                                                            .update(editPost
                                                                .toJson())
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          const snackBar = SnackBar(
                                                              content: Text(
                                                                  "Edit successfull"));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        });
                                                      },
                                                      label: const Text(
                                                          "Save edits"),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            label: const Text("Edit post"),
                                          )
                                        : const SizedBox(),
                                    widget.user.userId == currentUserId
                                        ? FloatingActionButton.extended(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    92, 75, 153, 1),
                                            elevation: 0,
                                            onPressed: () {
                                              userPosts[index]
                                                  .postRef!
                                                  .delete()
                                                  .then((value) {
                                                Navigator.pop(context);
                                                const snackBar = SnackBar(
                                                    content:
                                                        Text("Post deleted"));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              });
                                            },
                                            label: const Text("Delete post"),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: (124 / deviceWidth) * deviceWidth,
                      width: (124 / deviceWidth) * deviceWidth,
                      color: const Color.fromRGBO(248, 246, 244, 1),
                      child: CachedNetworkImage(
                        imageUrl: userPosts[index].postUrl!,
                        fit: BoxFit.fill,
                        height: (124 / deviceHeight) * deviceHeight,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
