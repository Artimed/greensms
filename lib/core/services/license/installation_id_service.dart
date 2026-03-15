import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class InstallationIdService {
  InstallationIdService(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'installation_id';
  String? _cached;

  Future<String> getOrCreate() async {
    if (_cached != null) return _cached!;
    final existing = await _storage.read(key: _key);
    if (existing != null && existing.isNotEmpty) {
      _cached = existing;
      return existing;
    }
    final newId = const Uuid().v4();
    await _storage.write(key: _key, value: newId);
    _cached = newId;
    return newId;
  }
}
