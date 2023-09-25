import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/business_logic/chat_cubit/chat_cubit.dart';
import 'package:kpopchat/business_logic/internet_checker_cubit.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/google_ads_id.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/utils/admob_services.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/repository/data_filter_repo.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/widgets/chat_screen_widgets/chat_screen_decorations.dart';

class ChatLoadedScreen extends StatefulWidget {
  final List<ChatMessage> chatHistory;
  final List<ChatUser>? typingUsers;
  final ChatUser loggedInUser;
  final VirtualFriendModel virtualFriendInfo;

  const ChatLoadedScreen(
      {super.key,
      required this.chatHistory,
      required this.loggedInUser,
      required this.virtualFriendInfo,
      this.typingUsers});

  @override
  State<ChatLoadedScreen> createState() => _ChatLoadedScreenState();
}

class _ChatLoadedScreenState extends State<ChatLoadedScreen> {
  ValueNotifier<InterstitialAd?> msgInterstitialAd =
      ValueNotifier<InterstitialAd?>(null);
  TextEditingController userMsgTextFieldController = TextEditingController();

  // DataFilterRepo class is gitignored
  DataFilterRepo filterRepo = DataFilterRepo();

  @override
  void initState() {
    userMsgTextFieldController.text = BlocProvider.of<ChatCubit>(context)
            .userMsgOnTextfield[widget.virtualFriendInfo.id] ??
        "";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: GoogleAdId.msgInterstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => msgInterstitialAd.value = ad,
            onAdFailedToLoad: (LoadAdError error) =>
                msgInterstitialAd.value = null));
  }

  void _showChatInterstitialAd() {
    bool shouldShowAd =
        BlocProvider.of<ChatCubit>(context).shouldShowChatInterstitialAd();
    if (shouldShowAd) {
      AdMobServices.showInterstitialAd(msgInterstitialAd, () {
        _loadInterstitialAd();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashChat(
        inputOptions: InputOptions(
          textController: userMsgTextFieldController,
          onTextChange: (String currentTypedMsg) {
            BlocProvider.of<ChatCubit>(context)
                    .userMsgOnTextfield[widget.virtualFriendInfo.id!] =
                currentTypedMsg;
          },
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          inputDecoration: messageInputDecoration(),
          inputToolbarStyle: messageInputToolbarStyle(),
          inputToolbarPadding: EdgeInsets.all(5.sp),
          inputToolbarMargin:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          alwaysShowSend: true,
        ),
        currentUser: widget.loggedInUser,
        typingUsers: widget.typingUsers,
        messageOptions: chatbotMessageOptionsBuilder(
            context, widget.virtualFriendInfo, widget.loggedInUser),
        onSend: (ChatMessage userNewMsg) async {
          if (userNewMsg.text.trim() != "") {
            final bool internetAvailable =
                await BlocProvider.of<InternetConnectivityCubit>(context)
                    .isInternetConnected();
            if (internetAvailable) {
              filterRepo.filterChat(userNewMsg.text);
              _showChatInterstitialAd();
              increasePropertyCount(AnalyticsConstants.kProperyMsgSentCount, 1);
              BlocProvider.of<ChatCubit>(navigatorKey.currentContext!)
                  .sendNewMsgToFriend(userNewMsg, widget.virtualFriendInfo);
            } else {
              CommonWidgets.customFlushBar(
                  navigatorKey.currentContext!, TextConstants.noInternetMsg);
            }
          }
        },
        messages: widget.chatHistory);
  }
}
