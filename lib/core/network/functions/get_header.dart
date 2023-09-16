import 'package:kpopchat/core/constants/network_constants.dart';

Map<String, String> getHeader({
  bool requiresAuthorization = true,
}) {
  return {
    "Content-Type": "application/json",
    if (requiresAuthorization)
      "Authorization": "Bearer ${NetworkConstants.edenAIKey}",
  };
}
