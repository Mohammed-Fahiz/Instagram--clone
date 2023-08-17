import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task1_app/core/constants/Color/pallete.dart';

import 'package:intl/intl.dart';

import '../../../Models/mediaModel.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/Firebase/firebase_constants.dart';
import '../../../core/constants/global-variables/global-variables.dart';
import '../../auth/controller/auth_controller.dart';
import '../../post/screens/postCommentPage.dart';

class SinglePostContainer extends StatefulWidget {
  final MediaModel post;
  const SinglePostContainer({super.key, required this.post});

  @override
  State<SinglePostContainer> createState() => _SinglePostContainerState();
}

class _SinglePostContainerState extends State<SinglePostContainer> {
  bool isLiked = false;
  bool isSaved = false;
  int commentLength = 0;
  getCommentLength() async {
    var query = widget.post.postRef!
        .collection(FirebaseConstants.commentCollections)
        .count();
    var queryLength = await query.query.count().get();
    commentLength = queryLength.count;
    if (mounted) {
      setState(() {});
    }
  }

  likeFunction() async {
    setState(() {
      widget.post.likesList!.contains(currentUserId)
          ? widget.post.likesList!.remove(currentUserId)
          : widget.post.likesList!.add(currentUserId);
      widget.post.likesList!.contains(currentUserId)
          ? isLiked = true
          : isLiked = false;
    });

    var likeData = widget.post.copyWith(likesList: widget.post.likesList);
    widget.post.postRef!.update(likeData.toJson());
  }

  postSave() {
    setState(() {
      usersModel!.saved.contains(widget.post.postId)
          ? usersModel!.saved.remove(widget.post.postId)
          : usersModel!.saved.add(widget.post.postId);
      usersModel!.saved.contains(widget.post.postId)
          ? isSaved = true
          : isSaved = false;
    });

    var updateSaved = usersModel!.copyWith(saved: usersModel!.saved);
    usersModel!.ref!.update(updateSaved.toJson());
  }

  postedTime(postedTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(postedTime);
    if (difference.inDays >= 1) {
      return DateFormat('MMM d').format(postedTime);
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
  void initState() {
    getCommentLength();
    setState(() {
      widget.post.likesList!.contains(currentUserId)
          ? isLiked = true
          : isLiked = false;
      usersModel!.saved.contains(widget.post.postId)
          ? isSaved = true
          : isSaved = false;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: deviceWidth,
          height: (54 / deviceHeight) * deviceHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    radius: (16 / deviceWidth) * deviceWidth,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.userName.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Text("Kerala,India"),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            likeFunction();
          },
          child: SizedBox(
            height: deviceWidth,
            width: deviceWidth,
            child: CachedNetworkImage(
              imageUrl: widget.post.postUrl.toString(),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: deviceWidth,
          height: (147 / deviceHeight) * deviceHeight,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          likeFunction();
                        },
                        icon: isLiked
                            ? const Icon(
                                FontAwesomeIcons.solidHeart,
                                size: 30,
                                color: Colors.red,
                              )
                            : const Icon(
                                FontAwesomeIcons.heart,
                                size: 30,
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (context) {
                              return CommentPage(
                                post: widget.post,
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          FontAwesomeIcons.comment,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.paperplane_fill,
                            size: 30),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        postSave();
                      },
                      icon: isSaved
                          ? const Icon(
                              CupertinoIcons.bookmark_fill,
                              size: 30,
                            )
                          : const Icon(CupertinoIcons.bookmark, size: 30))
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${widget.post.likesList!.length} likes",
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Text("Posted ${postedTime(widget.post.uploadedTime)}"),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  commentLength == 0
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  CommentPage(post: widget.post),
                            );
                          },
                          child: Text(
                            "View all $commentLength comments",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: (345 / deviceWidth) * deviceWidth,
                    height: (36 / deviceHeight) * deviceHeight,
                    child: Row(
                      children: [
                        Text(
                          widget.post.userName.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              color: Pallete.secondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.post.postDescription.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
