import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/business_logic/cache_maps_cubit/cache_maps_cubit.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

class CacheNewLocationScreen extends StatefulWidget {
  const CacheNewLocationScreen({super.key});

  @override
  State<CacheNewLocationScreen> createState() => _CacheNewLocationScreenState();
}

class _CacheNewLocationScreenState extends State<CacheNewLocationScreen> {
  TextEditingController placeController = TextEditingController();
  ValueNotifier<double> radius = ValueNotifier<double>(1);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: placeController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(hintText: TextConstants.placeName),
              ),
              20.verticalSpace,
              ValueListenableBuilder(
                valueListenable: radius,
                builder: (context, updatedRadius, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text:
                              "Radius: ${updatedRadius.toStringAsFixed(2)}Km"),
                      Slider(
                          inactiveColor: ColorConstants.primaryColorPink,
                          activeColor: ColorConstants.primaryColor,
                          min: 1,
                          max: 10,
                          label: "Radius Range",
                          value: updatedRadius,
                          onChanged: (double value) {
                            radius.value = value;
                          }),
                    ],
                  );
                },
              ),
              20.verticalSpace,
              ElevatedButton(
                  onPressed: () async {
                    if (placeController.text.trim().isNotEmpty) {
                      BlocProvider.of<CacheMapsCubit>(context)
                          .cacheMapViaPlaceName(
                              placeController.text.trim(), radius.value);
                      Navigator.of(context).pop();
                    }
                  },
                  child: CustomText(text: "Download Map"))
            ],
          ),
        ),
      ),
    );
  }
}
