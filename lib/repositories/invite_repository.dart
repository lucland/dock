import 'dart:async';

import '../models/invite.dart'; // Make sure to import the corresponding model
import '../services/api_service.dart';
import '../utils/simple_logger.dart';

class InviteRepository {
  final ApiService apiService;

  InviteRepository(this.apiService);

  Future<Invite> createInvite(Invite invite) async {
    try {
      final data = await apiService.post('invites', invite.toJson());
      return Invite.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create invite: ${e.toString()}');
      return invite;
    }
  }

  Future<Invite?> getInviteById(String id) async {
    try {
      final data = await apiService.get('invites/$id');
      return Invite.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get invite: ${e.toString()}');
      return null; // Return null as a fallback
    }
  }

  Future<List<Invite>> getAllInvites() async {
    try {
      final data = await apiService.get('invites');
      return (data as List).map((item) => Invite.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get invites: ${e.toString()}');
      return []; // Return an empty list as a fallback
    }
  }

  Future<Invite> updateInvite(String id, Invite invite) async {
    try {
      final data = await apiService.put('invites/$id', invite.toJson());
      return Invite.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update invite: ${e.toString()}');
      return invite;
    }
  }

  //cancelInvite
  Future<bool> cancelInvite(String id) async {
    try {
      final response = await apiService.delete('invites/$id');
      return response['message'] == 'Invite cancelled successfully';
    } catch (e) {
      SimpleLogger.severe('Failed to cancel invite: ${e.toString()}');
      return false;
    }
  }

  //get all invites by invites.project_id
  Future<List<Invite>> getInvitesByProjectId(String projectId) async {
    try {
      final data = await apiService.get('invites/project/$projectId');
      return (data as List).map((item) => Invite.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe(
          'Failed to get invites by project id: ${e.toString()}');
      return [];
    }
  }
}
