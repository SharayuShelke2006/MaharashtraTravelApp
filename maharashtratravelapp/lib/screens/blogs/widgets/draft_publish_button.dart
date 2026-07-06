import 'package:flutter/material.dart';

class DraftPublishButtons extends StatelessWidget {
  final bool loading;
  final VoidCallback onSaveDraft;
  final VoidCallback onPublish;

  const DraftPublishButtons({
    super.key,
    required this.loading,
    required this.onSaveDraft,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: OutlinedButton.icon(
            onPressed: loading ? null : onSaveDraft,
            icon: const Icon(Icons.save_outlined),
            label: const Text("Save Draft"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                55,
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: FilledButton.icon(
            onPressed: loading ? null : onPublish,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.publish),
            label: Text(
              loading
                  ? "Publishing..."
                  : "Publish",
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                55,
              ),
            ),
          ),
        ),
      ],
    );
  }
}