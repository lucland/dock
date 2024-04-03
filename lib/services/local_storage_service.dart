import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../utils/simple_logger.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  Box? _secureBox;

  LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  // Initialize Hive and open the secureBox
  Future<void> init() async {
    Hive.init('./');
    _secureBox = await Hive.openBox('secureBox');
    SimpleLogger.info("LocalStorageService initialized and secureBox opened");
  }

  Future<void> _ensureBoxIsOpen() async {
    if (_secureBox == null || !_secureBox!.isOpen) {
      _secureBox = await Hive.openBox('secureBox');
    }
  }

  Future<void> saveToken(String token) async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Saving token: $token");
    await _secureBox!.put('jwt_token', token);
  }

  Future<void> deleteToken() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Deleting token");
    await _secureBox!.delete('jwt_token');
  }

  Future<String?> getToken() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Getting token");
    String? token = _secureBox!.get('jwt_token');
    return token;
  }

  Future<void> saveVesselId(String vesselId) async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Saving vesselId: $vesselId");
    await _secureBox!.put('vessel_id', vesselId);
  }

  Future<void> deleteVesselId() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Deleting vesselId");
    await _secureBox!.delete('vessel_id');
  }

  Future<String?> getVesselId() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Getting vesselId");
    String? vesselId = _secureBox!.get('vessel_id');
    return vesselId;
  }

  Future<void> saveUserId(String userId) async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Saving userId: $userId");
    await _secureBox!.put('user_id', userId);
  }

  Future<void> deleteUserId() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Deleting userId");
    await _secureBox!.delete('user_id');
  }

  Future<String> getUserId() async {
    print("getUserId from local storage");
    await _ensureBoxIsOpen();
    SimpleLogger.info("Getting userId");
    String? userId = _secureBox!.get('user_id');
    print(userId);
    return userId ?? '';
  }

  Future<void> saveUsername(String username) async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Saving username: $username");
    await _secureBox!.put('username', username);
  }

  Future<void> deleteUsername() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Deleting username");
    await _secureBox!.delete('username');
  }

  Future<String?> getUsername() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Getting username");
    String? username = _secureBox!.get('username');
    return username;
  }

  Future<void> saveUser(User user) async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Saving user: ${user.toJson()}");
    await _secureBox!.put('user', jsonEncode(user.toJson()));
  }

  Future<void> deleteUser() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Deleting user");
    await _secureBox!.delete('user');
  }

  Future<User?> getUser() async {
    await _ensureBoxIsOpen();
    SimpleLogger.info("Getting user");
    String? userString = _secureBox!.get('user');
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    } else {
      return null;
    }
  }

  Future<void> closeBox() async {
    if (_secureBox != null && _secureBox!.isOpen) {
      await _secureBox!.close();
    }
  }
}
