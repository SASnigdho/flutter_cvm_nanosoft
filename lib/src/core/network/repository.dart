import '../database/local_storage.dart';
import 'dio_client.dart';

class Repository {
  DioClient? _apiClient;

  Repository({DioClient? apiClient}) {
    _apiClient = apiClient ?? DioClient();
  }

  DioClient get apiClient => _apiClient!;

  final localStorage = LocalStorage();
}
