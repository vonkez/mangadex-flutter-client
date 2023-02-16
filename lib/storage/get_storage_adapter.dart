import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'kv_storage.dart';

class GetStorageAdapter implements KVStorage{
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<String?> read(String key) async {

  }

  @override
  Future<void> write(String key, String value) async {

  }
}