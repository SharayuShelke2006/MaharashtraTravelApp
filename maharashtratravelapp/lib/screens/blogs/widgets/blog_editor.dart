import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'; // 👈 Extension package import kiya

class BlogEditor extends StatelessWidget {
  final QuillController controller;

  const BlogEditor({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        placeholder:
            "Share your travel experience... Tell people what makes this place special.",
        
        // 🔽 CRITICAL FIX: Editor ko default web/mobile image embeds paint karne ki standard instructions di hain
        embedBuilders: FlutterQuillEmbeds.editorBuilders(),
      ),
    );
  }
}