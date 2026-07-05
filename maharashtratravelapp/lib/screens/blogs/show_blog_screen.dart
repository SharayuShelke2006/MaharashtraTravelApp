import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/responsive_scaffold.dart';
import '../../models/blog_model.dart';
import '../../core/services/blog_service.dart';
import 'widgets/blog_card.dart';
import 'blog_detail_screen.dart';
import 'create_blog_screen.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key});

  final BlogService service =
      BlogService();

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentIndex: 3,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/explore');
            break;
          case 2:
            context.go('/hidden-gems');
            break;
          case 3:
            context.go('/blogs');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateBlogScreen(),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text(
          "Write",
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<List<BlogModel>>(
          stream: service.getBlogs(),
          builder: (context, snapshot) {
                      if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.menu_book_rounded,
                    size: 90,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "No Travel Stories Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Be the first one to share\nan amazing experience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CreateBlogScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Write Story",
                    ),
                  ),

                ],
              ),
            );
          }

          final blogs = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [

              const Text(
                "Travel Stories",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Read experiences from fellow travellers",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                decoration: InputDecoration(
                  hintText:
                      "Search blogs...",
                  prefixIcon:
                      const Icon(Icons.search),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ...blogs.map(
                (blog) => BlogCard(
                  blog: blog,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BlogDetailScreen(
                          blogId: blog.id,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 80),

            ],
          );
        },
      ),
    ),
  );
}
}