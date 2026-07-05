import 'package:flutter/material.dart';
import 'edit_profile_bottom_sheet.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> user;
  final String uid;
  const ProfileHeader({
    super.key,
    required this.user,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final coverImage = user["coverImage"] ?? "";
    final profileImage = user["profileImage"] ?? "";
    final name = user["name"] ?? "Traveler";
    final bio = user["bio"] ?? "Add your travel bio";

    return Column(
      children: [

        // ================= COVER IMAGE =================

        Stack(
          clipBehavior: Clip.none,
          children: [

            GestureDetector(
             onTap: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (_) => EditProfileBottomSheet(
      user: user,
    ),
  );
},
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: coverImage.isEmpty
                    ? Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff1B5E20),
                              Color(0xff43A047),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.landscape,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      )
                    : Image.network(
                        coverImage,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                Container(
                          decoration:
                              const BoxDecoration(
                            gradient:
                                LinearGradient(
                              colors: [
                                Color(0xff1B5E20),
                                Color(0xff43A047),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            Positioned(
              right: 15,
              bottom: 15,
              child: CircleAvatar(
                radius: 22,
                backgroundColor:
                    Colors.white,
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (_) => EditProfileBottomSheet(
      user: user,
    ),
  );
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            // ================= PROFILE IMAGE =================

            Positioned(
              bottom: -60,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [

                    CircleAvatar(
                      radius: 63,
                      backgroundColor:
                          Colors.white,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage:
                            profileImage.isEmpty
                                ? null
                                : NetworkImage(
                                    profileImage,
                                  ),
                        child: profileImage.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : null,
                      ),
                    ),

                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Colors.green,
                        child: IconButton(
                          iconSize: 18,
                          color: Colors.white,
                          onPressed: () {
                           showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (_) => EditProfileBottomSheet(
      user: user,
    ),
  );
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 75),

        // ================= NAME =================

        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
                fontWeight:
                    FontWeight.bold,
              ),
        ),

        const SizedBox(height: 12),

        // ================= BIO =================

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Text(
            bio,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ),

        const SizedBox(height: 18),

        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor:
                Colors.green.shade700,
          ),
          onPressed: () {
            // TODO Edit Profile
          },
          icon: const Icon(Icons.edit),
          label: const Text(
            "Edit Profile",
          ),
        ),
      ],
    );
  }
}