import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Models/mediaModel.dart';
import '../../../Models/userModel.dart';
import '../../../core/constants/global-variables/global-variables.dart';

class SingleSavedPost extends StatefulWidget {
  List<MediaModel> savedPost;
  Function callBackFunction;
  SingleSavedPost(
      {super.key, required this.savedPost, required this.callBackFunction});

  @override
  State<SingleSavedPost> createState() => _SingleSavedPostState();
}

class _SingleSavedPostState extends State<SingleSavedPost> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Wrap(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.savedPost[0].userName.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * .5,
                        width: deviceWidth * .8,
                        child: CachedNetworkImage(
                          imageUrl: widget.savedPost[0].postUrl.toString(),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.savedPost[0].userName} : ${widget.savedPost[0].postDescription}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            backgroundColor: const Color.fromRGBO(183, 4, 4, 1),
                            elevation: 0,
                            onPressed: () {
                              usersModel!.saved
                                  .remove(widget.savedPost[0].postId);
                              var updateData = usersModel!
                                  .copyWith(saved: usersModel!.saved);
                              usersModel!.ref!
                                  .update(updateData.toJson())
                                  .then((value) {
                                widget.callBackFunction();
                                Navigator.pop(context);
                              });
                            },
                            label: const Text("Unsave post"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        color: Colors.white,
        child: CachedNetworkImage(
          imageUrl: widget.savedPost[0].postUrl.toString(),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
