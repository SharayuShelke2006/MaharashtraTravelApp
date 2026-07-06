import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/responsive_scaffold.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_action_tile.dart';
import 'widgets/edit_profile_bottom_sheet.dart';
import 'widgets/saved_place_card.dart';
import 'my_blogs_screen.dart';
import 'drafts_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;


print(uid);
    return ResponsiveScaffold(
      currentIndex: 4,
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
            break;
        }
      },
      child: SafeArea(
        
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user =
                userSnapshot.data!.data() as Map<String, dynamic>?;

            if (user == null) {
              return const Center(
                child: Text("User not found"),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                 ProfileHeader(
  user: user,
  uid: uid,
),

                  const SizedBox(height: 20),

                  /// STATS
                  ProfileStats(
                    uid: uid,
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      "Your Activity",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ProfileActionTile(
                    icon: Icons.bookmark_rounded,
                    title: "Saved Places",
                    subtitle:
                        "Places you've saved for later",
                    color: Colors.green,
                    onTap: () {
                      GoRouter.of(context).go("/saved-places");
                    },
                  ),

                  ProfileActionTile(
                    icon: Icons.favorite_rounded,
                    title: "Liked Blogs",
                    subtitle:
                        "Blogs you've liked",
                    color: Colors.red,
                    onTap: () {
                      GoRouter.of(context).go("/liked-blogs");
                    },
                  ),
                  ProfileActionTile(
  icon: Icons.drafts_rounded,
  title: "Drafts",
  subtitle: "Continue writing unfinished blogs",
  color: Colors.deepPurple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DraftsScreen(),
      ),
    );
  },
),
                  ProfileActionTile(
                    icon: Icons.article_rounded,
                    title: "Your Blogs",
                    subtitle:
                        "Stories you've published",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyBlogsScreen(),
                        ),
                      );
                    },
                  ),

                  ProfileActionTile(
                    icon: Icons.location_on_rounded,
                    title: "Hidden Gems",
                    subtitle:
                        "Places you've contributed",
                    color: Colors.orange,
                    onTap: () {},
                  ),

                  const SizedBox(height: 35),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 55),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}