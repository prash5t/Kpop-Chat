import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/virtual_friends_posts_cubit/virtual_friends_posts_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_posts_cubit/virtual_friends_posts_state.dart';
import 'package:kpopchat/presentation/screens/home_screen/widgets/error_loading_posts_widget.dart';
import 'package:kpopchat/presentation/screens/home_screen/widgets/no_posts_widget.dart';
import 'package:kpopchat/presentation/screens/home_screen/widgets/post_widget.dart';
import 'package:kpopchat/presentation/widgets/virtual_friends_list_screen_widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const HomeScreen({super.key, required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: conversationsScreenAppBar(context, isForPostsScreen: true),
        body: BlocBuilder<VirtualFriendsPostsCubit, VirtualFriendsPostsState>(
          builder: (context, state) {
            if (state is PostsLoadedState) {
              return ListView.builder(
                controller: widget.scrollController,
                key: const PageStorageKey<String>('homePage'),
                itemCount: state.loadedPosts.length,
                itemBuilder: (context, index) {
                  return state.loadedPosts.isEmpty
                      ? NoPostsWidget()
                      : VirtualFriendPostWidget(
                          postData: state.loadedPosts[index]);
                },
              );
            } else if (state is ErrorLoadingPostsState) {
              return ErrorLoadingPostsWidget(errorMsg: state.errorMsg);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
