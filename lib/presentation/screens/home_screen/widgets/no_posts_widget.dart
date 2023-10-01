import 'package:flutter/material.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

class NoPostsWidget extends StatelessWidget {
  const NoPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CustomText(
      text: "There are no any posts at the moment.",
      isBold: true,
    ));
  }
}
