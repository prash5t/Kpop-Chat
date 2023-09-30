abstract class RemoteConfigRepo {
  /// method to get user info like location, internet provided based in user's public IP address
  Future<void> getUserInfoFromIP();
}
