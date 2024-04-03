import 'dart:async';

import '../models/project.dart'; // Make sure to import the corresponding model
import '../services/api_service.dart';
import '../utils/simple_logger.dart';

class ProjectRepository {
  final ApiService apiService;

  ProjectRepository(this.apiService);

  Future<Project> createProject(Project project) async {
    try {
      final data = await apiService.post('projects', project.toJson());
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create project: ${e.toString()}');
      return project;
    }
  }

  Future<Project?> getProjectById(String projectId) async {
    try {
      final data = await apiService.get('projects/$projectId');
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get project: ${e.toString()}');
      return null; // Return null as a fallback
    }
  }

  Future<List<Project>> getAllProjects() async {
    SimpleLogger.info('Getting all projects');
    print("Getting all projects");
    try {
      final data = await apiService.get('projects');
      print("Data projects fetched: $data");
      return List<Project>.from(data.map((x) => Project.fromJson(x)));
    } catch (e) {
      print('error: $e');
      SimpleLogger.severe('Failed to get all projects: ${e.toString()}');
      return [];
    }
  }

  Future<Project> updateProject(String projectId, Project project) async {
    try {
      final data =
          await apiService.put('projects/$projectId', project.toJson());
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update project: ${e.toString()}');
      return project;
    }
  }

  Future<bool> deleteProject(String projectId) async {
    try {
      final data = await apiService.delete('projects/$projectId');
      return data['message'] == 'Project deleted successfully';
    } catch (e) {
      SimpleLogger.severe('Failed to delete project: ${e.toString()}');
      return false;
    }
  }

  Future<Project?> addThirdCompanyToProject(
      String projectId, String thirdCompanyId) async {
    try {
      final data = await apiService.post('projects/$projectId/third-company',
          {'third_company_id': thirdCompanyId});
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe(
          'Failed to add third company to project: ${e.toString()}');
      return null;
    }
  }

  Future<List<String>> getApprovedEmployeesOfTheDay(String projectId) async {
    try {
      final data = await apiService.post(
          'projects/$projectId/approved-employees', {'projectId': projectId});
      return List<String>.from(data['approvedItags']);
    } catch (e) {
      SimpleLogger.severe(
          'Failed to get approved employees of the day: ${e.toString()}');
      return [];
    }
  }

  Future<Project?> addAdminToProject(String projectId, String adminId) async {
    try {
      final data = await apiService
          .post('projects/$projectId/admin', {'admin_id': adminId});
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to add admin to project: ${e.toString()}');
      return null;
    }
  }

  Future<Project?> addAreaToProject(String projectId, String areaId) async {
    try {
      final data = await apiService
          .post('projects/$projectId/area', {'area_id': areaId});
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to add area to project: ${e.toString()}');
      return null;
    }
  }

  //get all projects by project.user_id
  Future<List<Project>> getAllProjectsByUserId(String userId) async {
    try {
      print("Getting all projects by user id: $userId");
      final data = await apiService.get('projects/user/$userId');
      print("Data projects fetched: $data");
      return List<Project>.from(data.map((x) => Project.fromJson(x)));
    } catch (e) {
      SimpleLogger.severe('Failed to get all projects: ${e.toString()}');
      return [];
    }
  }

  //add employee to project router.put('/:id/removeEmployee', authenticateJWT, projectController.removeEmployeeFromProject) sending project_id as param and employee_id as body
  Future<Project?> removeEmployeeFromProject(
      String projectId, String employeeId) async {
    try {
      final data = await apiService.put(
          'projects/$projectId/removeEmployee', {'employee_id': employeeId});
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe(
          'Failed to remove employee from project: ${e.toString()}');
      return null;
    }
  }

  //add employee to project router.put('/:id/addEmployee', authenticateJWT, projectController.addEmployeeToProject) sending project_id as param and employee_id as body
  Future<Project?> addEmployeeToProject(
      String projectId, String employeeId) async {
    try {
      final data = await apiService
          .put('projects/$projectId/addEmployee', {'employee_id': employeeId});
      return Project.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to add employee to project: ${e.toString()}');
      return null;
    }
  }
}
