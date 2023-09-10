import 'package:flutter/material.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData leadingIcon;
  final Function() onTap;
  const CustomListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CustomText(
        text: title,
        textColor: titleColor,
        isBold: true,
      ),
      leading: Icon(
        leadingIcon,
        color: titleColor,
      ),
      onTap: onTap,
    );
  }
}
