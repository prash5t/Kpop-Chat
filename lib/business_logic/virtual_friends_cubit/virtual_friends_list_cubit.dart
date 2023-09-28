import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_state.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/data/models/local_schema_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/repository/virtual_friends_repo.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';

class VirtualFriendsListCubit extends Cubit<VirtualFriendsListState> {
  final VirtualFriendsRepo virtualFriendsRepo;
  VirtualFriendsListCubit(this.virtualFriendsRepo)
      : super(VirtualFriendsInitialState());

  LocalSchemaModelOfLoggedInUser? loadedSchemaOfFriends;
  void resetVirtualFriendsListState() {
    emit(VirtualFriendsInitialState());
  }

  void getVirtualFriends() async {
    Either<LocalSchemaModelOfLoggedInUser, FailureModel> response =
        await virtualFriendsRepo.getVirtualFriends();
    response.fold((l) {
      loadedSchemaOfFriends = l;
      emit(VirtualFriendsLoadedState(l));
    }, (r) {
      emit(ErrorLoadingVirtualFriendsState(
          r.message ?? TextConstants.defaultErrorMsg));
    });
  }

  void createVirtualFriend() async {
    VirtualFriendModel friendToCreate = VirtualFriendModel(
        name: "Carlos Flores",
        country: "Mexico",
        city: "Tijuana",
        displayPictureUrl:
            "https://i.ibb.co/hmC6xYp/Screenshot-2023-09-09-at-12-58-09-PM.png",
        profession: "Nurse",
        hobbies: ["Volunteering", "German Beer", "Surfing", "Cycling", "Kpop"]);
    Either<bool, FailureModel> response = await virtualFriendsRepo
        .createVirtualFriend(virtualFriendInfo: friendToCreate);
    response.fold((l) {
      if (l) {
        BlocProvider.of<VirtualFriendsListCubit>(navigatorKey.currentContext!)
            .getVirtualFriends();
        CommonWidgets.customFlushBar(
            navigatorKey.currentContext!, "${friendToCreate.name} is added.");
      }
    }, (r) {
      CommonWidgets.customFlushBar(navigatorKey.currentContext!,
          r.message ?? TextConstants.defaultErrorMsg);
    });
  }
}
