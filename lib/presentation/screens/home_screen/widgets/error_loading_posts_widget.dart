import 'package:flutter/material.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

class ErrorLoadingPostsWidget extends StatelessWidget {
  final String errorMsg;
  const ErrorLoadingPostsWidget({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(text: errorMsg),
    );
  }
}
