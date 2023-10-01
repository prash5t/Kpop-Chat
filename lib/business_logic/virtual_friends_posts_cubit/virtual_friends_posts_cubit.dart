import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/virtual_friends_posts_cubit/virtual_friends_posts_state.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/data/repository/virtual_friends_repo.dart';

class VirtualFriendsPostsCubit extends Cubit<VirtualFriendsPostsState> {
  final VirtualFriendsRepo friendsRepo;
  VirtualFriendsPostsCubit(this.friendsRepo) : super(InitialPostsState());

  void fetchPosts() async {
    emit(InitialPostsState());
    final response = await friendsRepo.getVirtualFriendsPosts();
    response.fold((l) {
      emit(PostsLoadedState(loadedPosts: l));
    }, (r) {
      emit(ErrorLoadingPostsState(
          errorMsg: r.message ?? TextConstants.defaultErrorMsg));
    });
  }
}
