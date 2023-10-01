import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/admin_controls/btn_to_autogenerate_post.dart';
import 'package:kpopchat/business_logic/virtual_friends_posts_cubit/virtual_friends_posts_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_posts_cubit/virtual_friends_posts_state.dart';
import 'package:kpopchat/core/constants/google_ads_id.dart';
import 'package:kpopchat/core/utils/admob_services.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
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
  ValueNotifier<BannerAd?> friendProfileScreenBannerAd =
      ValueNotifier<BannerAd?>(null);

  void _loadBannerAd() async {
    friendProfileScreenBannerAd.value = await AdMobServices
        .getBannerAdByGivingAdId(GoogleAdId.friendProfileScreenBannerAdId)
      ..load();
  }

  @override
  void didChangeDependencies() {
    _loadBannerAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    friendProfileScreenBannerAd.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: conversationsScreenAppBar(context, isForPostsScreen: true),
        floatingActionButton: AutoGeneratePostButton(),
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: friendProfileScreenBannerAd,
              builder: (context, value, child) {
                return CommonWidgets.buildBannerAd(value);
              },
            ),
            Expanded(
              child: BlocBuilder<VirtualFriendsPostsCubit,
                  VirtualFriendsPostsState>(
                builder: (context, state) {
                  if (state is PostsLoadedState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<VirtualFriendsPostsCubit>(context)
                            .fetchPosts();
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: widget.scrollController,
                        key: const PageStorageKey<String>('homePage'),
                        itemCount: state.loadedPosts.length,
                        itemBuilder: (context, index) {
                          return state.loadedPosts.isEmpty
                              ? NoPostsWidget()
                              : VirtualFriendPostWidget(
                                  postData: state.loadedPosts[index]);
                        },
                      ),
                    );
                  } else if (state is ErrorLoadingPostsState) {
                    return ErrorLoadingPostsWidget(errorMsg: state.errorMsg);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ));
  }
}
