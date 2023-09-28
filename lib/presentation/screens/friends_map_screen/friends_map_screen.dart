import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';
import 'package:kpopchat/presentation/widgets/chat_screen_widgets/online_status_widger.dart';
import 'package:latlong2/latlong.dart';
import 'package:popup/popup.dart';

class FriendsMapScreen extends StatefulWidget {
  const FriendsMapScreen({super.key});

  @override
  State<FriendsMapScreen> createState() => _FriendsMapScreenState();
}

class _FriendsMapScreenState extends State<FriendsMapScreen> {
  MapController friendsMapController = MapController();
  List<SchemaVirtualFriendModel>? virtualFriends;

  @override
  void didChangeDependencies() {
    virtualFriends = BlocProvider.of<VirtualFriendsListCubit>(context)
        .loadedSchemaOfFriends
        ?.virtualFriends;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: Colors.grey),
          ),
          child: Icon(
            Icons.people_outline,
            size: 40,
          ),
        ),
        onPressed: () {},
        backgroundColor: Colors.transparent,
      ),
      body: FlutterMap(
        options: MapOptions(
            center: LatLng(virtualFriends![3].info!.latLong!.lat!,
                virtualFriends![3].info!.latLong!.long!),
            zoom: 2,
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
                    )
            ],
          )
        ],
      ),
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
