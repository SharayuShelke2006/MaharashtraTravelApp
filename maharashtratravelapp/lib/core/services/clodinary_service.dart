import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // 👈 kIsWeb check karne ke liye zaroori hai
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static String cloudName = dotenv.get("CLOUDINARY_CLOUD_NAME");
  static String uploadPreset = dotenv.get("CLOUDINARY_UPLOAD_PRESET");

  // 🎯 Changes: file ko nullable banaya aur webBytes parameter add kiya
  static Future<String?> uploadImage(File? file, {Uint8List? webBytes}) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url);
    request.fields['upload_preset'] = uploadPreset;

    // 🎯 Web aur Mobile ke liye alag-alag checks
    if (kIsWeb && webBytes != null) {
      // 🌐 For Web: Upload using memory bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          webBytes,
          filename: 'upload.jpg',
        ),
      );
    } else if (file != null) {
      // 📱 For Mobile: Upload using file path
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
    } else {
      return null; // Dono hi khali hain toh kuch mat karo
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);

    if (response.statusCode == 200) {
      return data["secure_url"];
    } else {
      return null;
    }
  }
}