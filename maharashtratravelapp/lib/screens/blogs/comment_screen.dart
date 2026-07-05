import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../models/comment_model.dart';
import '../../core/services/blog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsScreen extends StatefulWidget {
  final String blogId;

  const CommentsScreen({
    super.key,
    required this.blogId,
  });

  @override
  State<CommentsScreen> createState() =>
      _CommentsScreenState();
}

class _CommentsScreenState
    extends State<CommentsScreen> {

  final controller =
      TextEditingController();

  final service = BlogService();

  final user =
      FirebaseAuth.instance.currentUser!;

  final uuid = const Uuid();

  Future<void> sendComment() async {

    if (controller.text.trim().isEmpty)
      return;

    final comment = CommentModel(
      id: uuid.v4(),
      userId: user.uid,
      userName:
          user.displayName ??
              "Traveler",
      userPhoto:
          user.photoURL,
      comment:
          controller.text.trim(),
      createdAt:
          Timestamp.now(),
    );

    await service.addComment(
      blogId: widget.blogId,
      comment: comment,
    );

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(
  child: StreamBuilder<List<CommentModel>>(
    stream: service.getComments(
      widget.blogId,
    ),
    builder: (context, snapshot) {

      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final comments = snapshot.data!;

      if (comments.isEmpty) {
        return const Center(
          child: Text(
            "Be the first to comment ✨",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: comments.length,
        itemBuilder: (context, index) {

          final comment = comments[index];

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 18,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      comment.userPhoto != null
                          ? NetworkImage(
                              comment.userPhoto!,
                            )
                          : null,
                  child: comment.userPhoto == null
                      ? const Icon(
                          Icons.person,
                        )
                      : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          Text(
                            comment.userName,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            timeAgo(
                              comment.createdAt
                                  .toDate(),
                            ),
                            style:
                                const TextStyle(
                              color:
                                  Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        comment.comment,
                        style:
                            const TextStyle(
                          fontSize: 15,
                        ),
                      ),

                    ],
                  ),
                ),

                if (comment.userId ==
                    user.uid)

                  PopupMenuButton(

                    itemBuilder: (_) => [

                      const PopupMenuItem(
                        value: "delete",
                        child:
                            Text("Delete"),
                      ),

                    ],

                    onSelected: (value)
                    async {

                      if (value ==
                          "delete") {

                        await service
                            .deleteComment(
                          blogId:
                              widget.blogId,
                          commentId:
                              comment.id,
                        );

                      }
                    },
                  ),

              ],
            ),
          );
        },
      );
    },
  ),
),
SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(15),
    child: Row(
      children: [

        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 4,
            decoration:
                InputDecoration(
              hintText:
                  "Write a comment...",
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        30),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        CircleAvatar(
          radius: 26,
          child: IconButton(
            onPressed:
                sendComment,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ),

      ],
    ),
  ),
),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {

    final diff =
        DateTime.now().difference(date);

    if (diff.inSeconds < 60) {
      return "now";
    }

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours}h";
    }

    if (diff.inDays < 30) {
      return "${diff.inDays}d";
    }

    return "${date.day}/${date.month}";
  }
}