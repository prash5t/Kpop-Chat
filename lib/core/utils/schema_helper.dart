import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kpopchat/business_logic/auth_checker_cubit/auth_checker_cubit.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/local_schema_model.dart';
import 'package:kpopchat/main.dart';

class SchemaHelper {
  Future<String?> getLocalSchema() async {
    String? localSchema;
    try {
      localSchema = await locator<FlutterSecureStorage>()
          .read(key: SharedPrefsKeys.kSchemaKey);
    } catch (e) {
      debugPrint("debug: Catched while reading secure storage.");
      BlocProvider.of<AuthCheckerCubit>(navigatorKey.currentContext!)
          .signOutUser();
    }
    return localSchema;
  }

  ///  To be used to save virtual friends data from network to local schema
  Future<void> saveLocalSchema(
      LocalSchemaModelOfLoggedInUser localSchema) async {
    Map<String, dynamic> localSchemaInJson = await localSchema.toJson();
    await locator<FlutterSecureStorage>().write(
        key: SharedPrefsKeys.kSchemaKey, value: jsonEncode(localSchemaInJson));
  }
}
