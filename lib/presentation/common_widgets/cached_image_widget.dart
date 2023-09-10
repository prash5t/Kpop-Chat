import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const LinearProgressIndicator(
              color: ColorConstants.unCheckedColorLightTheme,
            ),
        errorWidget: (context, url, error) =>
            Image.asset(AssetPathConstants.kDefaultProfilePic));
  }
}
