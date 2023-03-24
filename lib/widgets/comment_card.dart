import 'package:CTJan/models/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final Comments? data;
  const CommentCard({Key? key, required this.data}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          // CircleAvatar(
          //   backgroundImage: NetworkImage(
          //     widget.snap['profilePic'],
          //   ),
          //   radius: 18,
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Karan',
                          //widget.snap['name'],
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '  ${widget.data!.comment}',
                          style: TextStyle(
                            color: primaryColor,
                          )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      // DateFormat.yMMMd().format(
                        widget.data!.date.toString(),
                      // ),
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   child: const Icon(
          //     Icons.favorite_border_outlined,
          //     size: 16,
          //     color: primaryColor,
          //   ),
          // )
        ],
      ),
    );
  }
}
