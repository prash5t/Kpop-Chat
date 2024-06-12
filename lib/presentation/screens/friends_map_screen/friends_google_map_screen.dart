// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:kpopchat/business_logic/real_users_cubit/real_users_cubit.dart';
// import 'package:kpopchat/business_logic/virtual_friends_list_cubit/virtual_friends_list_cubit.dart';
// import 'package:kpopchat/core/constants/analytics_constants.dart';
// import 'package:kpopchat/core/constants/color_constants.dart';
// import 'package:kpopchat/core/utils/analytics.dart';
// import 'package:kpopchat/core/utils/get_geo_location_of_user.dart';
// import 'package:kpopchat/core/utils/service_locator.dart';
// import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
// import 'package:kpopchat/data/models/lat_long_model.dart';
// import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
// import 'package:kpopchat/data/models/user_model.dart';
// import 'package:kpopchat/data/repository/real_users_repo.dart';
// import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';
// import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
// import 'package:kpopchat/presentation/screens/friends_map_screen/widgets/real_user_market_widget.dart';
// import 'package:kpopchat/presentation/widgets/chat_screen_widgets/online_status_widget.dart';

// import 'package:location/location.dart';
// import 'package:popup/popup.dart';

// class FriendsGoogleMapScreen extends StatefulWidget {
//   const FriendsGoogleMapScreen({super.key});

//   @override
//   State<FriendsGoogleMapScreen> createState() => _FriendsGoogleMapScreenState();
// }

// class _FriendsGoogleMapScreenState extends State<FriendsGoogleMapScreen> {
//   List<SchemaVirtualFriendModel>? virtualFriends;
//   ValueNotifier<List<UserModel>> realUsers = ValueNotifier<List<UserModel>>([]);
//   ValueNotifier<LatLongAndZoom?> locationOfFocusPointOnMap =
//       ValueNotifier<LatLongAndZoom?>(null);
//   ValueNotifier<bool> fetchingLocation = ValueNotifier<bool>(false);

//   ValueNotifier<UserModel?> loggedInUserData =
//       ValueNotifier<UserModel?>(SharedPrefsHelper.getUserProfile());

//   GoogleMapController? mapController;

//   void _onMapCreated(GoogleMapController controller) =>
//       mapController = controller;

//   @override
//   void initState() {
//     virtualFriends = BlocProvider.of<VirtualFriendsListCubit>(context)
//         .loadedSchemaOfFriends
//         ?.virtualFriends;

//     realUsers.value = BlocProvider.of<RealUsersCubit>(context).loadedRealUsers;

//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   Set<Marker> getVirtualFriendsMarker() {
//     Set<Marker> markers = <Marker>{};
//     for (SchemaVirtualFriendModel friendInfo in virtualFriends!) {
//       if (friendInfo.info?.latLong != null) {
//         markers.add(Marker(
//           markerId: MarkerId(friendInfo.info?.name ?? "marker_id"),
//           position: LatLng(friendInfo.info?.latLong?.lat ?? -33.8688,
//               friendInfo.info?.latLong?.long ?? 151.2093),
//           draggable: true,
//         ));
//       }
//     }
//     for (UserModel realUser in realUsers.value) {
//       if (realUser.latLong != null) {
//         markers.add(
//           Marker(
//               markerId: MarkerId(realUser.userId ?? "marker_id"),
//               position: LatLng(realUser.latLong?.lat ?? -33.8688,
//                   realUser.latLong?.long ?? 151.2093),
//               draggable: true),
//         );
//       }
//     }
//     return markers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _buildFloatingWidgets(context),
//       body: Stack(
//         children: [
//           ValueListenableBuilder(
//             valueListenable: loggedInUserData,
//             builder: (context, updatedUserData, child) {
//               CameraPosition userPosition = CameraPosition(
//                   target: LatLng(updatedUserData?.latLong?.lat ?? -33.8688,
//                       updatedUserData?.latLong?.long ?? 151.2093));
//               return GoogleMap(
//                 markers: getVirtualFriendsMarker(),
//                 initialCameraPosition: userPosition,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 mapType: MapType.normal,
//                 zoomGesturesEnabled: true,
//                 zoomControlsEnabled: false,
//                 onMapCreated: _onMapCreated,
//               );
//             },
//           ),
//           _buildLoadingOverlayWidget()
//         ],
//       ),
//     );
//   }

//   Container _buildFloatingWidgets(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.onSecondary,
//           borderRadius: BorderRadius.circular(4)),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(
//                   Icons.my_location_sharp,
//                 ),
//                 color: Theme.of(context).primaryColor,
//                 onPressed: () async {
//                   logEventInAnalytics(
//                       AnalyticsConstants.kClickedPreciseLocation);
//                   await positionCameraOnGoogleMap(18);
//                 },
//               ),
//               CustomText(text: "Live"),
//               SizedBox(
//                 height: 2,
//               )
//             ],
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ValueListenableBuilder(
//                 valueListenable: loggedInUserData,
//                 builder: (context, updatedUserData, child) {
//                   return CupertinoCheckbox(
//                       value: updatedUserData?.anonymizeLocation ?? true,
//                       onChanged: (value) async {
//                         logEventInAnalytics(
//                             AnalyticsConstants.kClickedGhostMode);
//                         loggedInUserData.value!.anonymizeLocation = value;
//                       });
//                 },
//               ),
//               CustomText(text: "Ghost Mode")
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> positionCameraOnGoogleMap(double zoom) async {
//     fetchingLocation.value = true;
//     LocationData? currentUserLocation = await getUserLocationData();
//     fetchingLocation.value = false;
//     if (currentUserLocation != null) {
//       loggedInUserData.value?.latLong = LatLong(
//           lat: currentUserLocation.latitude,
//           long: currentUserLocation.longitude);
//       locationOfFocusPointOnMap.value = LatLongAndZoom(
//           zoom: zoom,
//           latLong: LatLong(
//               lat: currentUserLocation.latitude,
//               long: currentUserLocation.longitude));

//       mapController?.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//               zoom: zoom,
//               target: LatLng(currentUserLocation.latitude!,
//                   currentUserLocation.longitude!))));

//       await locator<RealUsersRepo>()
//           .updateUserLocationAndGhostModeStatus(loggedInUserData.value!);
//     }
//   }

//   ValueListenableBuilder<bool> _buildLoadingOverlayWidget() {
//     return ValueListenableBuilder(
//       valueListenable: fetchingLocation,
//       builder: (context, fetchingLoc, child) {
//         return fetchingLoc
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : const SizedBox();
//       },
//     );
//   }
// }
