import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../realestate/data/models/property_detail.dart';
import 'post_controller.dart';
import 'post_listing_screen.dart';

/// Edit-an-existing-listing entry: seeds the wizard from [detail] then renders
/// the same 4-step flow. Submitting sends `save_real_estate.json` with the id.
class PostEditScreen extends ConsumerStatefulWidget {
  const PostEditScreen({super.key, required this.detail});

  final PropertyDetail detail;

  @override
  ConsumerState<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends ConsumerState<PostEditScreen> {
  @override
  void initState() {
    super.initState();
    // Synchronous field seeding happens immediately; the dynamic-fields fetch
    // resolves shortly after — the step controllers read the seeded values.
    ref.read(postControllerProvider.notifier).loadForEdit(widget.detail);
  }

  @override
  Widget build(BuildContext context) => const PostListingScreen();
}
