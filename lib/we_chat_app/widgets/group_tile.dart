
import 'package:chat_app/we_chat_app/pages/chat_page.dart';
import 'package:chat_app/we_chat_app/service/database_service.dart';
import 'package:chat_app/we_chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class GroupTile extends StatefulWidget {
//   final String userName;
//   final String groupId;
//   final String groupName;
//   const GroupTile(
//       {Key? key,
//       required this.groupId,
//       required this.groupName,
//       required this.userName})
//       : super(key: key);
//
//   @override
//   State<GroupTile> createState() => _GroupTileState();
// }
//
// class _GroupTileState extends State<GroupTile> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         nextScreen(
//             context,
//             ChatPage(
//               groupId: widget.groupId,
//               groupName: widget.groupName,
//               userName: widget.userName,
//             ));
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//         child: ListTile(
//           leading: CircleAvatar(
//             radius: 30,
//             backgroundColor: Theme.of(context).primaryColor,
//             child: Text(
//               widget.groupName.substring(0, 1).toUpperCase(),
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.w500),
//             ),
//           ),
//           title: Text(
//             widget.groupName,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             "Join the conversation as ${widget.userName}",
//             style: const TextStyle(fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }
class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  List<String> loggedInUsers = [];

  @override
  void initState() {
    getLoggedInUsers();
    super.initState();
  }

  getLoggedInUsers() async {
    DatabaseService().getLoggedInUsers().then((QuerySnapshot snapshot) {
      List<String> users = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? userName = data["userName"];
          if (userName != null && userName != widget.userName) {
            users.add(userName);
          }
        }
      });
      setState(() {
        loggedInUsers = users;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
          context,
          ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.userName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: loggedInUsers.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Logged-in Users:",
                style: TextStyle(fontSize: 12),
              ),
              Column(
                children: loggedInUsers
                    .map(
                      (user) => Text(
                    user,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
                    .toList(),
              ),
            ],
          )
              : const Text(
            "No logged-in users",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
