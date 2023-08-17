import 'package:flutter/material.dart';
import '../../../Models/userModel.dart';
import '../../auth/controller/auth_controller.dart';

class SingleUserCard extends StatefulWidget {
  final UsersModel user;
  final int inx;
  final List? followList;
  const SingleUserCard(
      {super.key,
      required this.user,
      required this.inx,
      required this.followList});

  @override
  State<SingleUserCard> createState() => _SingleUserCardState();
}

class _SingleUserCardState extends State<SingleUserCard> {
  bool isFollowed = false;
  @override
  void initState() {
    setState(() {
      if (widget.user.followersList.contains(currentUserId)) {
        isFollowed = true;
      } else {
        isFollowed = false;
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${widget.inx + 1}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 5,
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.user.imageUrl.toString()),
            ),
          ],
        ),
        title: Text(widget.user.userName.toString()),
        subtitle: Text(widget.user.userEmail.toString()),
        trailing: TextButton(
            onPressed: () {
              setState(() {
                widget.followList!.contains(currentUserId)
                    ? widget.followList!.remove(currentUserId)
                    : widget.followList!.add(currentUserId);
                isFollowed == false ? isFollowed = true : isFollowed = false;
              });
              var updateFollow =
                  widget.user.copyWith(followersList: widget.followList);
              widget.user.ref!.update(updateFollow.toJson());
            },
            child: Text(isFollowed ? "Unfollow" : "Follow")),
      ),
    );
  }
}
