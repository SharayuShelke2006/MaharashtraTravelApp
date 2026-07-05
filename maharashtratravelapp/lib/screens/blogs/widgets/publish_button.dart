import 'package:flutter/material.dart';

class PublishButton
    extends StatelessWidget {
  final bool loading;

  final VoidCallback onPressed;

  const PublishButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Publish Story",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
      ),
    );
  }
}