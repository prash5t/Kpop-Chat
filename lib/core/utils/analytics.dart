import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:uuid/uuid.dart';

Future<void> logEventInAnalytics(String eventName,
    {Map<String, dynamic>? parameters}) async {
  // log to firebase analytics
  locator<FirebaseAnalytics>()
      .logEvent(name: eventName, parameters: parameters);

  // log to mixpanel
  locator<Mixpanel>().track(eventName, properties: parameters);

  debugPrint("Log event: $eventName");
}

Future<void> setUserIdInAnalytics(UserModel? loggedInUser) async {
  if (loggedInUser != null) {
    // set user id in firebase analytics
    locator<FirebaseAnalytics>().setUserId(id: loggedInUser.userId);

    // set user id in mixpanel
    Mixpanel mp = locator<Mixpanel>();
    mp.identify(loggedInUser.userId ?? const Uuid().v1());
    mp.getPeople().set("\$name", loggedInUser.displayName);
    mp.getPeople().set("\$email", loggedInUser.email);
    mp.getPeople().set("\$avatar", loggedInUser.photoURL);

    debugPrint("Set user id to analytics");
  }
}

Future<void> setUserPropertiesInAnalytics(
    String propertyKey, String propertyValue) async {
  // set user properties in firebase analytics
  locator<FirebaseAnalytics>()
      .setUserProperty(name: propertyKey, value: propertyValue);

  // set user properties in mixpanel
  locator<Mixpanel>().getPeople().set("\$$propertyKey", propertyValue);
  debugPrint("Set user properties, $propertyKey: $propertyValue");
}

Future<void> increasePropertyCount(
    String propertyKey, double increaseBy) async {
  // in mixpanel
  locator<Mixpanel>().getPeople().increment(propertyKey, increaseBy);
  debugPrint("Increased property count");
}
