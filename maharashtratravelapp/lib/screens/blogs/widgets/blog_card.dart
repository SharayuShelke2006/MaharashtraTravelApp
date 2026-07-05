import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/blog_model.dart';

class BlogCard extends StatelessWidget {
  final BlogModel blog;

  final VoidCallback onTap;

  const BlogCard({
    super.key,
    required this.blog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Image.network(
                blog.coverImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: .10),
                      borderRadius:
                          BorderRadius.circular(
                              30),
                    ),
                    child: Text(
                      blog.category,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.person),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Text(
                              blog.authorName,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),

                            Text(
                              DateFormat(
                                      "dd MMM yyyy")
                                  .format(
                                blog.createdAt
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
                      ),

                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [

                      const Icon(
                        Icons.favorite_border,
                        size: 20,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "${blog.likes}",
                      ),

                      const SizedBox(width: 20),

                      const Icon(
                        Icons.mode_comment_outlined,
                        size: 20,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "${blog.comments}",
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      )

                    ],
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}