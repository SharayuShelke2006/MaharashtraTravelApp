import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; 

import '../../core/services/clodinary_service.dart';

class HiddenGemFormScreen extends StatefulWidget {
  const HiddenGemFormScreen({super.key});

  @override
  State<HiddenGemFormScreen> createState() => _HiddenGemFormScreenState();
}

class _HiddenGemFormScreenState extends State<HiddenGemFormScreen> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();
  
  // 🎯 Category ke liye controller hatakar hum ab direct String variable use karenge
  String? selectedCategory; 

  // Categories ki list (Aap isme apne mutabik changes kar sakti hain)
  // 🎯 Exact categories from your UI chips
final List<String> categories = [
  "Fort",
  "Beach",
  "Hill Station",
  "Waterfall",
  "Temple",
  "Wildlife",
  "City",
  "Cave",
];
  
  final mapsLinkController = TextEditingController(); 
  final latController = TextEditingController();
  final lngController = TextEditingController();

  File? imageFile;       
  Uint8List? webImage;   
  String? imageUrl;
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    addressController.dispose();
    mapsLinkController.dispose(); 
    latController.dispose(); 
    lngController.dispose();
    super.dispose();
  }

  Future<void> _openGoogleMaps() async {
    final Uri url = Uri.parse('https://maps.google.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Google Maps open nahi ho saka');
    }
  }

  void _extractCoordinatesFromLink(String text) {
    if (text.isEmpty) return;
    RegExp regExp = RegExp(r'([+-]?\d+\.\d+)\s*,\s*([+-]?\d+\.\d+)');
    Match? match = regExp.firstMatch(text);

    if (match != null) {
      setState(() {
        latController.text = match.group(1)!;
        lngController.text = match.group(2)!;
      });
    } else {
      List<String> parts = text.split(',');
      if (parts.length == 2) {
        double? lat = double.tryParse(parts[0].trim());
        double? lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          setState(() {
            latController.text = lat.toString();
            lngController.text = lng.toString();
          });
        }
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        if (kIsWeb) {
          final bytes = await picked.readAsBytes();
          setState(() {
            webImage = bytes;
            imageFile = File(picked.path); 
          });
        } else {
          setState(() {
            imageFile = File(picked.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image select karne mein dikkat hui: $e")),
      );
    }
  }

  Future<void> uploadImageToCloudinary() async {
    if (imageFile == null && webImage == null) return;
    try {
      imageUrl = await CloudinaryService.uploadImage(imageFile, webBytes: webImage);
    } catch (e) {
      throw Exception("Cloudinary upload failed: $e");
    }
  }

  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position pos = await Geolocator.getCurrentPosition();

      setState(() {
        latController.text = pos.latitude.toString();
        lngController.text = pos.longitude.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location nahi mil saki: $e")),
      );
    }
  }

  Future<void> saveGem() async {
    // Validation mein selectedCategory ko bhi check karenge
    if (nameController.text.isEmpty || 
        selectedCategory == null ||
        (imageFile == null && webImage == null) || 
        latController.text.isEmpty || 
        lngController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kripya saare fields aur coordinates zaroor bharein!")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await uploadImageToCloudinary();

      if (imageUrl == null) {
        throw Exception("Image URL nahi mila!");
      }

      double? lat = double.tryParse(latController.text);
      double? lng = double.tryParse(lngController.text);

      await FirebaseFirestore.instance.collection("hidden_gems").add({
        "name": nameController.text,
        "description": descController.text,
        "address": addressController.text,
        "category": selectedCategory, // 👈 Dropdown se chuni hui value save hogi
        "coverImage": imageUrl,
        "latitude": lat ?? 0.0,
        "longitude": lng ?? 0.0,
        "rating": 0,
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save karne mein error aaya: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Hidden Gem")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Place Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            const SizedBox(height: 16),

            // 🎯 NEW CATEGORY DROPDOWN WIDGET
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: const Text("Select Category"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // IMAGE PICKER
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: (kIsWeb ? webImage == null : imageFile == null)
                    ? const Center(child: Text("Tap to pick image"))
                    : (kIsWeb 
                        ? Image.memory(webImage!, fit: BoxFit.cover) 
                        : Image.file(imageFile!, fit: BoxFit.cover)), 
              ),
            ),
            const SizedBox(height: 20),

            // LOCATION INPUT SECTION
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Location Setup",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  
                  OutlinedButton.icon(
                    onPressed: _openGoogleMaps,
                    icon: const Icon(Icons.map, color: Colors.green),
                    label: const Text("Open Google Maps", style: TextStyle(color: Colors.green)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: mapsLinkController,
                    onChanged: _extractCoordinatesFromLink, 
                    decoration: InputDecoration(
                      labelText: "Google Maps Link or Coordinates",
                      hintText: "Paste browser URL or direct '19.0760, 72.8777'",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.link, color: Colors.blue),
                      helperText: "💡 Tip: Please copy the full link from your browser's address bar. Mobile 'Share Links' are not supported.",
                      helperMaxLines: 2,
                      helperStyle: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: latController,
                          decoration: const InputDecoration(
                            labelText: "Extracted Latitude",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: lngController,
                          decoration: const InputDecoration(
                            labelText: "Extracted Longitude",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  TextButton.icon(
                    onPressed: getLocation,
                    icon: const Icon(Icons.my_location, size: 18),
                    label: const Text("Or use my current location"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : saveGem,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save Hidden Gem"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}