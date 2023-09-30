import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_state.dart';
import 'package:kpopchat/core/utils/initializer.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/screens/virtual_friends_list_screen/virtual_friends_loaded_screen.dart';

class VirtualFriendsListScreen extends StatefulWidget {
  final ScrollController scrollController;
  const VirtualFriendsListScreen({super.key, required this.scrollController});

  @override
  State<VirtualFriendsListScreen> createState() =>
      _VirtualFriendsListScreenState();
}

class _VirtualFriendsListScreenState extends State<VirtualFriendsListScreen> {
  @override
  void initState() {
    BlocProvider.of<VirtualFriendsListCubit>(context).getVirtualFriends();
    RequiredInitializations.initializeFirebaseRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VirtualFriendsListCubit, VirtualFriendsListState>(
        builder: (context, state) {
          if (state is VirtualFriendsLoadedState) {
            return VirtualFriendsLoadedScreen(
                virtualFriends:
                    state.localSchemaModelOfLoggedInUser.virtualFriends!,
                scrollController: widget.scrollController);
          } else if (state is ErrorLoadingVirtualFriendsState) {
            return Material(
                child: Center(child: CustomText(text: state.errorMsg)));
          }
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        listener: ((context, state) {}));
  }
}
