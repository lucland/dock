import 'dart:convert';

import 'package:dockcheck_web/features/projects/bloc/project_state.dart';
import 'package:dockcheck_web/models/employee.dart';
import 'package:dockcheck_web/repositories/employee_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../models/document.dart';
import '../../../models/project.dart';
import '../../../repositories/project_repository.dart';
import '../../../services/local_storage_service.dart';
import 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final EmployeeRepository employeeRepository;
  final ProjectRepository projectRepository;
  final LocalStorageService localStorageService;
  final FirebaseStorage storage;

  ProjectDetailsCubit(this.employeeRepository, this.projectRepository,
      this.localStorageService, this.storage)
      : super(ProjectDetailsState(
          project: Project(
            id: '',
            name: '',
            dateStart: DateTime.now(),
            dateEnd: DateTime.now(),
            vesselId: '',
            companyId: '',
            thirdCompaniesId: [],
            adminsId: [],
            employeesId: [],
            areasId: [],
            address: '',
            isDocking: false,
            status: '',
            userId: '',
          ),
        ));
  //retrieve the logged in userId from the local storage.getUserId Future method and set it into a variable
  Future<String?> get loggedInUser => localStorageService.getUserId();
  String loggedUserId = '';

  //assign the logged in userId to the variable, knowing that it is a Future<String>
  void getLoggedUserId() async {
    loggedUserId = await loggedInUser ?? '';
  }

  //fetch project by id from the repository and emit the state with the project
  void fetchProjectById(String projectId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final project = await projectRepository.getProjectById(projectId);
      emit(state.copyWith(project: project, isLoading: false));
      fetchEmployees();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //fetch all projects from the repository and emit the state with the projects
  void fetchEmployees() async {
    emit(state.copyWith(isLoading: true, employees: []));
    try {
      //getEmployeeById for each state.project.employeesId and set the employees in the state.employees
      List<String> ids = state.project.employeesId;
      List<Employee> employees = [];
      for (var id in ids) {
        final employee = await employeeRepository.getEmployeeById(id);
        employees.add(employee);
      }
      emit(state.copyWith(employees: employees, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //approveEmployee method where we update the employee with isBlocked = false
  void approveEmployee(String employeeId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await employeeRepository.approveEmployee(employeeId);
      final employee = await employeeRepository.getEmployeeById(employeeId);
      final employees = state.employees
          .map((e) => e.id == employeeId ? employee : e)
          .toList();
      emit(state.copyWith(employees: employees, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //fetch all employees from repository, subtract the employees already in the project and emit the state with the employees in the state.employeesUnvited
  void fetchEmployeesUninvited() async {
    emit(state.copyWith(isLoadingUninvited: true));
    try {
      final employees = await employeeRepository.getAllEmployees();
      final employeesUninvited = employees
          .where((element) =>
              !state.project.employeesId.contains(element.id) &&
              element.id != loggedUserId)
          .toList();
      emit(state.copyWith(
          employeesUnvited: employeesUninvited, isLoadingUninvited: false));
    } catch (e) {
      emit(state.copyWith(
          isLoadingUninvited: false, errorMessage: e.toString()));
    }
  }

  //add uninvited employee to the project by their id using projectRepository.addEmployee and update the state
  void addEmployee(String employeeId) async {
    emit(state.copyWith(isLoading: true, isLoadingUninvited: true));
    try {
      await projectRepository.addEmployeeToProject(
          state.project.id, employeeId);
      final employee = await employeeRepository.getEmployeeById(employeeId);
      //remove the employee from the uninvited list
      final employeesUninvited = state.employeesUnvited
          .where((element) => element.id != employeeId)
          .toList();
      emit(state.copyWith(
          isLoading: false,
          employeesUnvited: employeesUninvited,
          isLoadingUninvited: false,
          employees: [...state.employees, employee]));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isLoadingUninvited: false));
    }
  }

  void setProject(Project project) {
    emit(state.copyWith(project: project));
  }

  //remove an employee from the project by their id using projectRepository.removeEmployee and update the state
  void removeEmployee(String employeeId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await projectRepository.removeEmployeeFromProject(
          state.project.id, employeeId);
      await employeeRepository.blockEmployee(
          employeeId, 'removed from project');
      emit(state.copyWith(
          project: state.project.copyWith(
              employeesId: state.project.employeesId
                  .where((element) => element != employeeId)
                  .toList())));
      fetchEmployees();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //reset function
  void reset() {
    emit(ProjectDetailsState(
      project: Project(
        id: '',
        name: '',
        dateStart: DateTime.now(),
        dateEnd: DateTime.now(),
        vesselId: '',
        companyId: '',
        thirdCompaniesId: [],
        adminsId: [],
        employeesId: [],
        areasId: [],
        address: '',
        isDocking: false,
        status: '',
        userId: '',
      ),
      employees: [],
      employeesUnvited: [],
    ));
  }
}
