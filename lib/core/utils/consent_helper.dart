import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Re-displays the AdMob/UMP consent form on user demand. Wired from the
/// "Privacy choices" entry in the menu.
///
/// With Ad-unit-deployment ENABLED in the AdMob console, AdMob serves the
/// initial consent form automatically on first ad load. This function
/// handles the **revocation entry point** — required by IAB TCF + Play
/// policy when the auto-deploy flow is on.
///
/// We refresh the consent info first (in case the user changed jurisdiction
/// or AdMob updated the message), then show the form unconditionally so the
/// user can change or revoke their previous choice.
Future<void> showPrivacyChoices() async {
  final ConsentRequestParameters params = ConsentRequestParameters();
  ConsentInformation.instance.requestConsentInfoUpdate(
    params,
    () async {
      await ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) {
          debugPrint(
              'consent form error: ${error.errorCode} ${error.message}');
        }
      });
    },
    (FormError error) {
      debugPrint(
          'consent info update error: ${error.errorCode} ${error.message}');
    },
  );
}
