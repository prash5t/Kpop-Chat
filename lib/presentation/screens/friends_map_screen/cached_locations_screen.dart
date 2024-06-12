import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/business_logic/cache_maps_cubit/cache_maps_cubit.dart';
import 'package:kpopchat/business_logic/cache_maps_cubit/cache_maps_state.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/common_utils.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/lat_long_name_model.dart';
import 'package:kpopchat/presentation/common_widgets/common_decorations.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachedLocationScreen extends StatefulWidget {
  const CachedLocationScreen({super.key});

  @override
  State<CachedLocationScreen> createState() => _CachedLocationScreenState();
}

class _CachedLocationScreenState extends State<CachedLocationScreen> {
  ValueNotifier<List<String>> cachedLocations = ValueNotifier<List<String>>([]);

  @override
  void initState() {
    _fetchLocationFromLocalCache();
    super.initState();
  }

  void _fetchLocationFromLocalCache() {
    List<String> localCache = locator<SharedPreferences>()
            .getStringList(SharedPrefsKeys.kCachedLocations) ??
        [];
    cachedLocations.value = localCache;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CacheMapsCubit, CacheMapsState>(
      listener: (context, state) {
        if (state is CacheFailureState) {
          CommonWidgets.customFlushBar(context, state.msg);
        }
      },
      child: Scaffold(
        floatingActionButton: Container(
          decoration: CommonDecoration.floatingActionBoxDec(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_location_alt_outlined,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.cacheNewLocationScreen);
                    },
                  ),
                  CustomText(text: TextConstants.cacheNew),
                  SizedBox(
                    height: 2,
                  )
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: CustomText(text: TextConstants.cachedLocations),
        ),
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentlyCachingLocationWidget(),
            _buildLocallyCachedLocationsWidget()
          ],
        ),
      ),
    );
  }

  BlocConsumer<CacheMapsCubit, CacheMapsState>
      _buildLocallyCachedLocationsWidget() {
    return BlocConsumer<CacheMapsCubit, CacheMapsState>(
      listener: (context, state) {
        if (state is CacheSuccesState) {
          _fetchLocationFromLocalCache();
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: cachedLocations,
          builder: (context, updatedCache, child) {
            return updatedCache.isEmpty
                ? const Center(
                    child: CustomText(text: TextConstants.emptyCache),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomText(
                          text: TextConstants.cachedLocations,
                          isBold: true,
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: updatedCache.length,
                        itemBuilder: (context, index) {
                          String cachedLoc = updatedCache[index];
                          LatLongNameModel cached =
                              LatLongNameModel.fromJson(jsonDecode(cachedLoc));
                          return Column(
                            children: [
                              ListTile(
                                title: CustomText(text: cached.name),
                                trailing: CustomText(
                                    text:
                                        "${(cached.sizeKB / 1000).toStringAsFixed(2)} MB"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text:
                                            "Lat: ${cached.latlng.latitude}, Long: ${cached.latlng.longitude}"),
                                    CustomText(
                                        text:
                                            "Radius: ${cached.radiusKm.toStringAsFixed(2)} Km")
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
          },
        );
      },
    );
  }

  BlocBuilder<CacheMapsCubit, CacheMapsState>
      _buildCurrentlyCachingLocationWidget() {
    return BlocBuilder<CacheMapsCubit, CacheMapsState>(
      builder: (context, state) {
        if (state is CachingState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                20.verticalSpace,
                LinearPercentIndicator(
                  lineHeight: 7.h,
                  backgroundColor: Theme.of(context).primaryColor,
                  progressColor: ColorConstants.primaryColorPink,
                  padding: EdgeInsets.zero,
                  barRadius: Radius.circular(4.r),
                  percent: CommonUtils.getIndicatorPosition(
                      reachedNum:
                          state.downloadProgress?.cachedTiles.toDouble() ?? 0,
                      maxNum:
                          state.downloadProgress?.maxTiles.toDouble() ?? 100,
                      percentageRange: 1),
                  widgetIndicator: Image.asset(
                    AssetPathConstants.kMedalPNG,
                    width: 17.w,
                    height: 17.h,
                  ),
                ),
                CustomText(
                    text:
                        "Lat: ${state.cachingLocation.latitude}, Long: ${state.cachingLocation.longitude}"),
                CustomText(
                    text: "Total Tiles: ${state.downloadProgress?.maxTiles}"),
                CustomText(
                    text:
                        "Cached Tiles: ${state.downloadProgress?.cachedTiles}"),
                CustomText(
                    text:
                        "Cached Size: ${((state.downloadProgress?.cachedSize ?? 0) / 1000).toStringAsFixed(2)} MB"),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
