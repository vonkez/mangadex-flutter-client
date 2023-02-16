abstract class KVStorage{
  Future<void> write(String key, String value);
  Future<String?> read(String key);
}