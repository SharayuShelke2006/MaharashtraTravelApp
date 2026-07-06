import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/blog_model.dart';

class DraftCard extends StatelessWidget {
  final BlogModel draft;

  final VoidCallback onTap;

  const DraftCard({
    super.key,
    required this.draft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(bottom: 18),
      elevation: 1,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: Row(
            children: [

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: draft.coverImage.isEmpty
                    ? Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image,
                          size: 40,
                        ),
                      )
                    : Image.network(
                        draft.coverImage,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      draft.title.isEmpty
                          ? "Untitled Draft"
                          : draft.title,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      draft.category.isEmpty
                          ? "No Category"
                          : draft.category,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Last edited ${DateFormat("dd MMM yyyy").format(draft.updatedAt.toDate())}",
                      style:
                          const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}