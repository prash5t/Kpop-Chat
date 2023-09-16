// using in message inputing text field of chat screen
import 'package:dart_emoji/dart_emoji.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/decoration_constants.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/main.dart';
import 'custom_msg_avatar_widget.dart';

// using in message inputing text field of chat screen
InputDecoration messageInputDecoration() {
  return defaultInputDecoration(
      fillColor: Colors.transparent,
      hintStyle: TextStyle(
          color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold),
      hintText: TextConstants.writeYourMsgHint);
}

// using in message inputing toolbar of chat screen
BoxDecoration messageInputToolbarStyle() {
  return BoxDecoration(
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onSecondary,
    borderRadius: BorderRadius.circular(30.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 4.r,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

// box decoration of message (either send by user or by bot)
BoxDecoration messageBoxDecoration(bool isMsgOfUser, String msg) {
  return defaultMessageDecoration(
    color: EmojiUtil.hasOnlyEmojis(msg)
        ? Colors.transparent
        : isMsgOfUser
            ? ColorConstants.primaryColor
            : Theme.of(navigatorKey.currentContext!).colorScheme.onTertiary,
    borderTopLeft: DecorationConstants.borderRadiusOfBubbleMsg,
    borderTopRight:
        isMsgOfUser ? 0 : DecorationConstants.borderRadiusOfBubbleMsg,
    borderBottomLeft:
        isMsgOfUser ? DecorationConstants.borderRadiusOfBubbleMsg : 0,
    borderBottomRight: DecorationConstants.borderRadiusOfBubbleMsg,
  );
}

// used to customize message style and message box decoration
MessageOptions chatbotMessageOptionsBuilder(
    BuildContext context, VirtualFriendModel virtualFriend, ChatUser user) {
  return MessageOptions(
    messagePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    marginSameAuthor: EdgeInsets.only(top: 8.h),
    marginDifferentAuthor: EdgeInsets.only(top: 35.h),
    avatarBuilder: (chatUser, onPressAvatar, onLongPressAvatar) {
      return CustomMsgAvatarWidget(
          context: context, virtualFriend: virtualFriend);
      // return DefaultAvatar(
      //   user: widget.bot,
      //   size: 30.r,
      //   fallbackImage: AssetImage(ImagePaths.defaultDP),
      //   onPressAvatar: (chatUser) {
      //     Navigator.pushNamed(context, AppRoutes.botProfileScreen,
      //         arguments: BotProfileScreenModel(
      //             schemaBotModel: widget.schemaBotModel,
      //             isChoosingBot: false));
      //   },
      // );
    },
    showTime: true,
    timeFormat: DateFormat.jm(),
    // FYI: textColor is color of text of other users in chat bubble
    // if messageTextBuilder property is commented, below two properites to be used
    textColor: Theme.of(context).colorScheme.primaryContainer,
    currentUserTextColor: Colors.white,
    // messageTextBuilder: (message, previousMessage, nextMessage) {
    //   bool isMsgOfUser = message.user.id == widget.user.id;
    //   return Text(
    //     message.text,
    //     style: messageStyle(isMsgOfUser, message.text),
    //   );
    // },
    messageDecorationBuilder: (message, previousMessage, nextMessage) {
      bool isMsgOfUser = message.user.id == user.id;
      return messageBoxDecoration(isMsgOfUser, message.text);
    },
  );
}
