import 'dart:convert';

import '../models/authorization.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  UserRepository(this.apiService, this.localStorageService);

  Future<User> createUser(User user) async {
    try {
      final data = await apiService.postUser('users/create', user.toJson());
      print('data: $data');
      //await localStorageService.insertOrUpdate(
      //  'users', User.fromJson(data).toJson(), 'id');
      return User.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create user: ${e.toString()}');
      user.status = 'pending_creation';
      print(e.toString());
      //await localStorageService.insertOrUpdate('users', user.toJson(), 'id');
      return user;
    }
  }

  Future<User> getUser(String id) async {
    final data = await apiService.get('users/$id');
    return User.fromJson(data);
  }

  Future<bool> getValidITag(String itag) async {
    try {
      await apiService.get('users/itag/$itag');
      return true;
    } catch (e) {
      SimpleLogger.severe('iTag not valid: ${e.toString()}');
      return false;
    }
  }

  Future<User> updateUser(String id, User user) async {
    final data = await apiService.put('users/$id', user.toJson());
    return User.fromJson(data);
  }

  Future<void> deleteUser(String id) async {
    await apiService.delete('users/$id');
  }

  Future<List<User>> getAllUsers({int limit = 1000, int offset = 0}) async {
    final data = await apiService.get('users?limit=$limit&offset=$offset');
    print(data.toString());
    List<User> usuarios =
        (data as List).map((item) => User.fromJson(item)).toList();
    print(usuarios[0]);

    SimpleLogger.severe('user: ${usuarios[0]}');
    return (data).map((item) => User.fromJson(item)).toList();
  }

  // Get User Authorizations
  Future<List<Authorization>> getUserAuthorizations(String userId) async {
    final data = await apiService.get('users/$userId/authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

  // Check Username Availability
  Future<bool> checkUsername(String username) async {
    final data =
        await apiService.post('users/checkUsername', {'username': username});
    return data['message'] == 'Username available';
  }

  // Search Users
  Future<List<User>> searchUsers(String searchTerm,
      {int page = 1, int pageSize = 10}) async {
    const String apiUrl = 'http://172.20.255.223:3000/api/v1/users/search';
    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: {
      'searchTerm': searchTerm,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return (data['users'] as List)
            .map((item) => User.fromJson(item))
            .toList(); // Returns the JSON response as a Map
      } else {
        print('Failed to load users');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Get Last User Number
  Future<int> getLastUserNumber() async {
    final data = await apiService.getWithoutToken('users/getNextUserNumber');
    return int.parse(data.toString());
  }

  // Get Valid Users by Vessel ID
  Future<List<String>> getValidUsersByVesselID(String vesselId) async {
    final data = await apiService.get('users/valids/$vesselId');
    return List<String>.from(data);
  }

  //getUsersIdsFromServer returns a list of user ids
  Future<List<String>> getUsersIdsFromServer() async {
    final data = await apiService.get('users/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<User> getUserByBeacon(String id) async {
    final data = await apiService.get('users/user/rfid/$id');
    return User.fromJson(data);
  }
}

/*
import 'dart:async';

import '../models/user.dart'; // Make sure to import the corresponding model
import '../services/api_service.dart';
import '../utils/simple_logger.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      final data = await apiService.post('users', userData);
      return User.fromJson(data['user']);
    } catch (e) {
      SimpleLogger.severe('Failed to create user: ${e.toString()}');
      return null; // Return null as a fallback
    }
  }

  Future<User> getUserById(String userId) async {
    try {
      final data = await apiService.get('users/$userId');
      return User.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get user: ${e.toString()}');
      return null;
    }
  }

  Future<User> updateUser(String userId, Map<String, dynamic> updateData) async {
    try {
      final data = await apiService.put('users/$userId', updateData);
      return User.fromJson(data['user']);
    } catch (e) {
      SimpleLogger.severe('Failed to update user: ${e.toString()}');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final data = await apiService.get('users');
      return List<User>.from(data.map((x) => User.fromJson(x)));
    } catch (e) {
      SimpleLogger.severe('Failed to get all users: ${e.toString()}');
      return [];
    }
  }

  Future<List<User>> searchUsers(String searchTerm) async {
    try {
      final data = await apiService.get('users/search?searchTerm=$searchTerm');
      return List<User>.from(data.map((x) => User.fromJson(x)));
    } catch (e) {
      SimpleLogger.severe('Failed to search users: ${e.toString()}');
      return [];
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      await apiService.put('users/$userId/block');
      SimpleLogger.info('User blocked successfully');
    } catch (e) {
      SimpleLogger.severe('Failed to block user: ${e.toString()}');
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      await apiService.put('users/$userId/unblock');
      SimpleLogger.info('User unblocked successfully');
    } catch (e) {
      SimpleLogger.severe('Failed to unblock user: ${e.toString()}');
    }
  }
}

 */