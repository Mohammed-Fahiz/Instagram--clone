import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Models/commentModel.dart';
import '../../../Models/mediaModel.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';

class SingleComment extends StatefulWidget {
  final CommentModel postComment;
  final MediaModel post;
  final Function callBackFunction;
  const SingleComment(
      {super.key,
      required this.postComment,
      required this.post,
      required this.callBackFunction});

  @override
  State<SingleComment> createState() => _SingleCommentState();
}

class _SingleCommentState extends State<SingleComment> {
  bool isDeletable = false;

  commentedTime(commentedTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(commentedTime);
    if (difference.inDays >= 1) {
      return DateFormat('MMM d').format(commentedTime);
    } else if (difference.inHours >= 1) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inSeconds <= 59) {
      return "${difference.inSeconds}s ago";
    } else {
      return "just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          widget.postComment.commentOwnerId == usersModel!.userId ||
                  widget.post.userId == usersModel!.userId
              ? isDeletable = true
              : isDeletable = false;
        });
      },
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: widget.postComment.commentOwnerDp.toString(),
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.postComment.commentOwnerName.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.postComment.commentContent.toString()),
            Text(
              commentedTime(widget.postComment.commentedTime),
            ),
          ],
        ),
        trailing: isDeletable
            ? IconButton(
                onPressed: () {
                  widget.post.postRef!
                      .collection(FirebaseConstants.commentCollections)
                      .doc(widget.postComment.commentId)
                      .delete();
                  setState(() {
                    isDeletable = false;
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
