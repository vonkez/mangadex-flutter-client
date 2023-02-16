import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'kv_storage.dart';

class SecureStorageAdaper implements KVStorage{
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }
}