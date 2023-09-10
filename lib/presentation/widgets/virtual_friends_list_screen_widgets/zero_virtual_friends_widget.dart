import 'package:flutter/material.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

class ZeroVirtualFriendsWidget extends StatelessWidget {
  const ZeroVirtualFriendsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CustomText(
      text: "No any virtual friends at the moment",
      isBold: true,
    ));
  }
}
