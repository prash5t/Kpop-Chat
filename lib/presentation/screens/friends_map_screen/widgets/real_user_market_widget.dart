import 'package:flutter/material.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';
import 'package:kpopchat/presentation/widgets/chat_screen_widgets/online_status_widget.dart';
import 'package:popup/popup.dart';

Container _buildMarkerWidget(UserModel realUser) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: 3, color: ColorConstants.primaryColorPink),
    ),
    child: realUser.anonymizeLocation ?? false
        ? CircleAvatar(
            backgroundImage: AssetImage(AssetPathConstants.kDefaultProfilePic),
            radius: 100,
          )
        : CachedCircleAvatar(
            imageUrl: realUser.photoURL!,
            radius: 100,
          ),
  );
}

Builder buildRealUserMarker(UserModel realUser) {
  return Builder(builder: (context) {
    return GestureDetector(
      onTap: () {
        showPopup(
            arrowColor: Colors.white,
            barrierColor: Colors.transparent,
            context: context,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Material(
              elevation: 5,
              child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  // color: Colors.transparent,
                ),
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Text(realUser.anonymizeLocation ?? false
                        ? "Anonymous"
                        : realUser.displayName!),
                    RecentlyActiveWidget()
                  ],
                ),
              ),
            ));
      },
      child: _buildMarkerWidget(realUser),
    );
  });
}
