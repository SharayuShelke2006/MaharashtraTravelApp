import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/clodinary_service.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfileBottomSheet({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileBottomSheet> createState() =>
      _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState
    extends State<EditProfileBottomSheet> {

  final picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController bioController;

  bool loading = false;

  File? profileImageFile;
  File? coverImageFile;

  Uint8List? profileBytes;
  Uint8List? coverBytes;

  String? profileUrl;
  String? coverUrl;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
      text: widget.user["name"] ?? "",
    );

    bioController =
        TextEditingController(
      text: widget.user["bio"] ?? "",
    );

    profileUrl =
        widget.user["profileImage"];

    coverUrl =
        widget.user["coverImage"];
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {

    final image =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    if (kIsWeb) {

      profileBytes =
          await image.readAsBytes();

    } else {

      profileImageFile =
          File(image.path);

    }

    setState(() {});
  }

  Future<void> pickCoverImage() async {

    final image =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    if (kIsWeb) {

      coverBytes =
          await image.readAsBytes();

    } else {

      coverImageFile =
          File(image.path);

    }

    setState(() {});
  }
    Future<void> saveProfile() async {
    setState(() {
      loading = true;
    });

    try {
      // Upload Profile Image
      if (profileImageFile != null || profileBytes != null) {
        profileUrl = await CloudinaryService.uploadImage(
          profileImageFile,
          webBytes: profileBytes,
        );
      }

      // Upload Cover Image
      if (coverImageFile != null || coverBytes != null) {
        coverUrl = await CloudinaryService.uploadImage(
          coverImageFile,
          webBytes: coverBytes,
        );
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(
        {
          "name": nameController.text.trim(),
          "bio": bioController.text.trim(),
          "profileImage": profileUrl ?? "",
          "coverImage": coverUrl ?? "",
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile Updated",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Edit Profile",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 30),
              const SizedBox(height: 10),

Stack(
  clipBehavior: Clip.none,
  children: [

    Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.green.shade100,
        image: coverBytes != null
            ? DecorationImage(
                image: MemoryImage(coverBytes!),
                fit: BoxFit.cover,
              )
            : coverImageFile != null
                ? DecorationImage(
                    image: FileImage(coverImageFile!),
                    fit: BoxFit.cover,
                  )
                : (coverUrl != null &&
                        coverUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(
                          coverUrl!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
      ),
    ),

    Positioned(
      bottom: -35,
      left: 0,
      right: 0,
      child: Center(
        child: CircleAvatar(
          radius: 42,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 38,
            backgroundImage: profileBytes != null
                ? MemoryImage(profileBytes!)
                : profileImageFile != null
                    ? FileImage(profileImageFile!)
                    : (profileUrl != null &&
                            profileUrl!.isNotEmpty)
                        ? NetworkImage(profileUrl!)
                        : null,
            child: profileUrl == null ||
                    profileUrl!.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 40,
                  )
                : null,
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 55),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Change Profile Photo"),
                trailing: const Icon(Icons.chevron_right),
                onTap: pickProfileImage,
              ),

              ListTile(
                leading: const Icon(Icons.landscape),
                title: const Text("Change Cover Photo"),
                trailing: const Icon(Icons.chevron_right),
                onTap: pickCoverImage,
              ),

              const SizedBox(height: 25),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: bioController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Bio",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                  onPressed: loading ? null : saveProfile,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save Changes",
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}