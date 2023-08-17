import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task1_app/features/post/widgets/singleComment.dart';
import '../../../Models/commentModel.dart';
import '../../../Models/mediaModel.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';

class CommentPage extends StatefulWidget {
  final MediaModel post;
  const CommentPage({super.key, required this.post});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _comment = TextEditingController();

  Stream<List<CommentModel>> getPostComments() {
    return widget.post.postRef!
        .collection(FirebaseConstants.commentCollections)
        .orderBy("createdTime", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CommentModel.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  callBackFunction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          "Comments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: StreamBuilder(
              stream: getPostComments(),
              builder: (context, snapshot) {
                var postComments = snapshot.data ?? [];
                return postComments == []
                    ? const Center(
                        child: Text(
                          "No comments yet!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return SingleComment(
                            postComment: postComments[index],
                            post: widget.post,
                            callBackFunction: callBackFunction,
                          );
                        },
                        itemCount: postComments.length,
                      );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _comment,
            decoration: InputDecoration(
              hintText: "Add a comment",
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              prefixIcon: CachedNetworkImage(
                imageUrl: usersModel!.imageUrl.toString(),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                ),
                fit: BoxFit.cover,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  var commentData = CommentModel(
                      commentOwnerId: usersModel!.userId,
                      commentContent: _comment.text,
                      commentedTime: DateTime.now(),
                      commentOwnerDp: usersModel!.imageUrl,
                      commentOwnerName: usersModel!.userName);

                  widget.post.postRef!
                      .collection(FirebaseConstants.commentCollections)
                      .add(commentData.toJson())
                      .then((value) {
                    var updateCommentData = commentData.copyWith(
                        commentRef: value, commentId: value.id);
                    widget.post.postRef!
                        .collection(FirebaseConstants.commentCollections)
                        .doc(value.id)
                        .update(updateCommentData.toJson());
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
