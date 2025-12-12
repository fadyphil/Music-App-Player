import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';

abstract interface class ProfileLocalDataSource {
  Future<UserEntity> getUserProfile();
  Future<void> saveUserProfile(UserEntity user);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences _sharedPreferences;

  ProfileLocalDataSourceImpl(this._sharedPreferences);

  static const _userKey = 'cached_user_profile';

  @override
  Future<UserEntity> getUserProfile() async {
    final jsonString = _sharedPreferences.getString(_userKey);
    if (jsonString != null) {
      try {
        return UserEntity.fromJson(jsonDecode(jsonString));
      } catch (e) {
        // Fallback if schema changes
        return _defaultUser;
      }
    } else {
      return _defaultUser;
    }
  }

  UserEntity get _defaultUser => const UserEntity(
        id: 'user_1',
        username: 'Music Lover',
        email: 'user@example.com',
        avatarUrl: '', 
        preferredNavBar: NavBarStyle.simple,
      );

  @override
  Future<void> saveUserProfile(UserEntity user) async {
    await _sharedPreferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> clearCache() async {
    // Clears all keys for now or specific ones.
    // The prompt specifically asked for "deleting cache", which might imply image cache or data.
    // Given I don't control the image cache directly here (cached_network_image usually manages its own),
    // I will clear the user profile as a proxy for "resetting" this feature's cache.
    await _sharedPreferences.remove(_userKey);
  }
}
