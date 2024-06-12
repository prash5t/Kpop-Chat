import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class FmtcCubit extends Cubit {
  FmtcCubit() : super(null) {
    getStore();
  }

  FMTCStore? fmtcStore;

  void getStore() async {
    // List<FMTCStore> stores = await FMTCRoot.stats.storesAvailable;
    // debugPrint("debugCache: storesCount: ${stores.length}");
    // for (FMTCStore store in stores) {
    //   debugPrint(
    //       "debugCache: storeName: ${store.storeName}, storeStats ${store.stats.toString()}");
    //   fmtcStore = store;
    // }
    await FMTCStore('aprashantz').manage.create();
    fmtcStore = FMTCStore('aprashantz');
  }
}
