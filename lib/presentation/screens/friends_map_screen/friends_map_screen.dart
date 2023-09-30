import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kpopchat/business_logic/real_users_cubit/real_users_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/core/utils/get_geo_location_of_user.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/lat_long_model.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/repository/real_users_repo.dart';
import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/screens/friends_map_screen/widgets/real_user_market_widget.dart';
import 'package:kpopchat/presentation/widgets/chat_screen_widgets/online_status_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:popup/popup.dart';

class FriendsMapScreen extends StatefulWidget {
  const FriendsMapScreen({super.key});

  @override
  State<FriendsMapScreen> createState() => _FriendsMapScreenState();
}

class _FriendsMapScreenState extends State<FriendsMapScreen> {
  MapController friendsMapController = MapController();
  List<SchemaVirtualFriendModel>? virtualFriends;
  ValueNotifier<List<UserModel>> realUsers = ValueNotifier<List<UserModel>>([]);
  ValueNotifier<LatLongAndZoom?> locationOfFocusPointOnMap =
      ValueNotifier<LatLongAndZoom?>(null);
  ValueNotifier<bool> fetchingLocation = ValueNotifier<bool>(false);

  ValueNotifier<UserModel?> loggedInUserData =
      ValueNotifier<UserModel?>(SharedPrefsHelper.getUserProfile());

  @override
  void initState() {
    virtualFriends = BlocProvider.of<VirtualFriendsListCubit>(context)
        .loadedSchemaOfFriends
        ?.virtualFriends;

    realUsers.value = BlocProvider.of<RealUsersCubit>(context).loadedRealUsers;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    locationOfFocusPointOnMap.value = LatLongAndZoom(
        zoom: 2,
        latLong: LatLong(
            lat: virtualFriends![3].info!.latLong!.lat!,
            long: virtualFriends![3].info!.latLong!.long!));
    positionCameraOnMap(3);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _buildFloatingWidgets(context),
        body: ValueListenableBuilder(
          valueListenable: locationOfFocusPointOnMap,
          builder: (context, newFocusPoint, child) {
            return Stack(
              children: [
                _buildMapWidget(newFocusPoint),
                _buildLoadingOverlayWidget()
              ],
            );
          },
        ));
  }

  Container _buildFloatingWidgets(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.my_location_sharp,
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  logEventInAnalytics(
                      AnalyticsConstants.kClickedPreciseLocation);
                  await positionCameraOnMap(20);
                },
              ),
              CustomText(text: "Live"),
              SizedBox(
                height: 2,
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: loggedInUserData,
                builder: (context, updatedUserData, child) {
                  return CupertinoCheckbox(
                      value: updatedUserData?.anonymizeLocation ?? true,
                      onChanged: (value) async {
                        logEventInAnalytics(
                            AnalyticsConstants.kClickedGhostMode);
                        loggedInUserData.value!.anonymizeLocation = value;
                        await positionCameraOnMap(20);
                        // TODO: replace setstate
                        setState(() {});
                      });
                },
              ),
              CustomText(text: "Ghost Mode")
            ],
          ),
        ],
      ),
    );
  }

  FlutterMap _buildMapWidget(LatLongAndZoom? newFocusPoint) {
    return FlutterMap(
      options: MapOptions(
          interactiveFlags: InteractiveFlag.doubleTapZoom |
              InteractiveFlag.drag |
              InteractiveFlag.pinchMove |
              InteractiveFlag.pinchZoom,
          center:
              LatLng(newFocusPoint!.latLong!.lat!, newFocusPoint.latLong!.lat!),
          zoom: newFocusPoint.zoom!,
          minZoom: 2,
          maxZoom: 17,
          keepAlive: true),
      mapController: friendsMapController,
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            // Virtual users markers
            if (virtualFriends != null)
              for (SchemaVirtualFriendModel friendInfo in virtualFriends!)
                if (friendInfo.info?.latLong != null)
                  Marker(
                    rotate: false,
                    point: LatLng(friendInfo.info!.latLong!.lat!,
                        friendInfo.info!.latLong!.long!),
                    builder: (context) {
                      return _buildMarker(friendInfo);
                    },
                  ),
            // Real users markers
            if (realUsers.value.isNotEmpty)
              for (UserModel realUser in realUsers.value)
                if (realUser.latLong != null)
                  Marker(
                      rotate: false,
                      point: LatLng(
                          realUser.latLong!.lat!, realUser.latLong!.long!),
                      builder: (context) {
                        return buildRealUserMarker(realUser);
                      }),

            // Logged in user marker
            if (newFocusPoint.latLong != null)
              Marker(
                  rotate: false,
                  point: LatLng(newFocusPoint.latLong!.lat!,
                      newFocusPoint.latLong!.long!),
                  builder: (context) {
                    return ValueListenableBuilder(
                      valueListenable: loggedInUserData,
                      builder: (context, updatedUserData, child) {
                        return buildRealUserMarker(updatedUserData!);
                      },
                    );
                  })
          ],
        )
      ],
    );
  }

  Future<void> positionCameraOnMap(double zoom) async {
    fetchingLocation.value = true;
    LocationData? currentUserLocation = await getUserLocationData();
    fetchingLocation.value = false;
    if (currentUserLocation != null) {
      loggedInUserData.value?.latLong = LatLong(
          lat: currentUserLocation.latitude,
          long: currentUserLocation.longitude);
      locationOfFocusPointOnMap.value = LatLongAndZoom(
          zoom: zoom,
          latLong: LatLong(
              lat: currentUserLocation.latitude,
              long: currentUserLocation.longitude));

      friendsMapController.move(
        LatLng(currentUserLocation.latitude!, currentUserLocation.longitude!),
        zoom,
      );
      await locator<RealUsersRepo>()
          .updateUserLocationAndGhostModeStatus(loggedInUserData.value!);
    }
  }

  ValueListenableBuilder<bool> _buildLoadingOverlayWidget() {
    return ValueListenableBuilder(
      valueListenable: fetchingLocation,
      builder: (context, fetchingLoc, child) {
        return fetchingLoc
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox();
      },
    );
  }

  Container _buildMarkerWidget(SchemaVirtualFriendModel friendInfo) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3, color: ColorConstants.successColor),
      ),
      child: CachedCircleAvatar(
        imageUrl: friendInfo.info!.displayPictureUrl!,
        radius: 100,
      ),
    );
  }

  Builder _buildMarker(SchemaVirtualFriendModel friendInfo) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          logEventInAnalytics(
              AnalyticsConstants.kClickedVirtualFriendMapMarker);
          showPopup(
              arrowColor: Colors.white,
              barrierColor: Colors.transparent,
              context: context,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                elevation: 5,
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Text(friendInfo.info!.name!),
                      OnlineStatusWidget()
                    ],
                  ),
                ),
              ));
        },
        child: _buildMarkerWidget(friendInfo),
      );
    });
  }
}
