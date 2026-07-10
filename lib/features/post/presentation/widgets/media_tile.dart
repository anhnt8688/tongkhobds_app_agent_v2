import 'package:flutter/material.dart';

/// A square media thumbnail with a remove button in the corner (v1: rounded-16
/// thumbnail + red `cancel` icon top-right).
class MediaTile extends StatelessWidget {
  const MediaTile({super.key, required this.child, required this.onRemove});
  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: child,
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.cancel, size: 20, color: Color(0xFFFF3B30)),
          ),
        ),
      ],
    );
  }
}
