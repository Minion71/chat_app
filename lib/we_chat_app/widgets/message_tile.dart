import 'package:chat_app/we_chat_app/service/database_service.dart';
import 'package:flutter/material.dart';

// class MessageTile extends StatefulWidget {
//   final String message;
//   final String sender;
//   final bool sentByMe;
//   final bool imageUrl;
//   const MessageTile(
//       {Key? key,
//       required this.message,
//       required this.sender,
//       required this.sentByMe, required this.imageUrl})
//       : super(key: key);
//
//   @override
//   State<MessageTile> createState() => _MessageTileState();
// }
//
// class _MessageTileState extends State<MessageTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//           top: 4,
//           bottom: 4,
//           left: widget.sentByMe ? 0 : 24,
//           right: widget.sentByMe ? 24 : 0),
//       alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: widget.sentByMe
//             ? const EdgeInsets.only(left: 30)
//             : const EdgeInsets.only(right: 30),
//         padding:
//             const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
//         decoration: BoxDecoration(
//             borderRadius: widget.sentByMe
//                 ? const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                     bottomLeft: Radius.circular(20),
//                   )
//                 : const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//             color: widget.sentByMe
//                 ? Theme.of(context).primaryColor
//                 : Colors.grey[700]),
//         child:widget.imageUrl?
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.sender.toUpperCase(),
//               textAlign: TextAlign.start,
//               style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: -0.5),
//             ),
//             const SizedBox(
//               height:8,
//             ),
//       Padding(
//         padding: const EdgeInsets.only(top: 8),
//         child: Image.network(
//           widget.message,
//           height: 200,
//           width: 200,
//           fit: BoxFit.cover,
//         ),
//       ),
//         ]): Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.sender.toUpperCase(),
//               textAlign: TextAlign.start,
//               style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: -0.5),
//             ),
//             const SizedBox(
//               height:8,
//             ),
//             Text(widget.message,
//                 textAlign: TextAlign.start,
//                 style: const TextStyle(fontSize: 16, color: Colors.white))
//           ],
//         ),
//       ),
//     );
//   }
// }
class MessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool sentByMe;

  const MessageTile({
    required this.message,
    required this.sentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: sentByMe ? Theme.of(context).primaryColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            message.isImage
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                    child: Container(
                                        child: Image.network(
                                  message.message ?? " ",
                                  fit: BoxFit.fill,
                                )))),
                        child: Image.network(
                          message.message ?? " ",
                          height: 200,
                          width: 100,
                        )))
                : Text(
                    message.message ?? " ",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}
