import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    final username = user?.displayName ??
        user?.email?.split("@").first ??
        "Traveler";

    final isDesktop =
        MediaQuery.of(context).size.width >= 900;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        isDesktop ? 40 : 25,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ================= MOBILE HEADER =================

          if (!isDesktop) ...[
            Row(
              children: [

                Image.asset(
                  "assets/images/logo.png",
                  height: 42,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Hello,",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),

                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),

                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: uid == null
                      ? null
                      : FirebaseFirestore.instance.collection('users').doc(uid).get(),
                  builder: (context, snapshot) {
                    final profileImage = snapshot.data?.data()?['profileImage']?.toString().trim();
                    final fallbackPhoto = user?.photoURL?.trim();
                    final imageUrl = (profileImage != null && profileImage.isNotEmpty)
                        ? profileImage
                        : (fallbackPhoto != null && fallbackPhoto.isNotEmpty)
                            ? fallbackPhoto
                            : null;

                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary 
                          .withOpacity(.15),
                      backgroundImage: imageUrl != null &&
                              (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl == null || !(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))
                          ? Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                    );
                  },
                ),

              ],
            ),

            const SizedBox(height: 35),
          ],

          // ================= HERO =================

          Text(
            "Explore",
            style: Theme.of(context)
                .textTheme
                .headlineLarge,
          ),

          const SizedBox(height: 4),

          Text(
            "Maharashtra",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: isDesktop ? 650 : double.infinity,
            child: Text(
              "Discover forts, beaches, hidden gems and unforgettable travel experiences across Maharashtra.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),

          const SizedBox(height: 12),

        ],
      ),
    );
  }
}