import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/real_users_cubit/real_users_state.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/repository/real_users_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealUsersCubit extends Cubit<RealUsersState> {
  final RealUsersRepo realUsersRepo;
  RealUsersCubit(this.realUsersRepo) : super(RealUsersInitialState());

  List<UserModel> loadedRealUsers = [];
  void fetchRealUsers() async {
    final response = await realUsersRepo.fetchRealUsersData();
    response.fold((l) {
      // separate logged in user data with other real users
      UserModel loggedInUserRecord = SharedPrefsHelper.getUserProfile()!;

      for (UserModel realUser in l) {
        if (realUser.userId != loggedInUserRecord.userId) {
          loadedRealUsers.add(realUser);
        } else {
          locator<SharedPreferences>().setString(
              SharedPrefsKeys.kUserProfile, jsonEncode(realUser.toJson()));
        }
      }
      emit(RealUsersLoadedState(loadedRealUsers));
    }, (r) {
      emit(ErrorLoadingRealUsersState(
          r.message ?? TextConstants.defaultErrorMsg));
    });
  }
}
