abstract class ILocalDatabase {
  Future<bool> isAuthorized();

  Future<void> setToken(String token);

  Future<String?> getToken();
  
  Future<void> removeToken();
}
