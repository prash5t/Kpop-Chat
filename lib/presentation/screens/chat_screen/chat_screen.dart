import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/chat_cubit/chat_cubit.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/widgets/chat_screen_widgets/chat_screen_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final VirtualFriendModel virtualFriend;
  const ChatScreen({super.key, required this.virtualFriend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatCubit chatCubit =
      BlocProvider.of<ChatCubit>(navigatorKey.currentContext!);
  @override
  void initState() {
    // when chat screen is opened, we set chat screen open as true
    chatCubit.chatScreenOpen[widget.virtualFriend.id!] = true;
    chatCubit.loadChatHistory(widget.virtualFriend);
    super.initState();
  }

  @override
  void dispose() {
    // when chat screen is disposed, we set chat screen open as false
    chatCubit.chatScreenOpen[widget.virtualFriend.id!] = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VirtualFriendModel virtualFriend = widget.virtualFriend;
    return Scaffold(
      appBar: chatScreenAppBar(context, virtualFriend),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return const Center(child: CircularProgressIndicator());
        },

        /// FYI: to prevent building if states are for other user
        /// example: if user is in chatting screen with Ram
        /// Chatting screen with Shyam's state should not update state in
        /// chatting screen with Ram where user currently is in
        buildWhen: (previousState, state) {
          if ((state is ChatLoadedState &&
                  state.virtualFriendId != virtualFriend.id) ||
              (state is ChatLoadingState &&
                  state.virtualFriendId != virtualFriend.id) ||
              (state is FriendTypingState &&
                  state.virtualFriendId != virtualFriend.id)) {
            return false;
          } else if (state is ErrorReceivingBotMsgState) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}
