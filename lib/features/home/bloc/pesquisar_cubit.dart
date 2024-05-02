import 'package:dockcheck_web/models/employee.dart';
import 'package:dockcheck_web/models/project.dart';
import 'package:dockcheck_web/models/user.dart';
import 'package:dockcheck_web/repositories/employee_repository.dart';
import 'package:dockcheck_web/repositories/project_repository.dart';
import 'package:dockcheck_web/services/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/simple_logger.dart';
import 'pesquisar_state.dart';

class PesquisarCubit extends Cubit<PesquisarState> {
  final EmployeeRepository employeeRepository;
  final ProjectRepository projectRepository;
  final LocalStorageService localStorageService;
  List<Employee> allEmployee = [];
  List<Employee> filteredEmployee = [];
  bool isSearching = false;
  String searchQuery = '';

  @override
  bool isClosed = false;

  PesquisarCubit(
      this.employeeRepository, this.projectRepository, this.localStorageService)
      : super(PesquisarInitial());

  Future<String?> get loggedInUser => localStorageService.getUserId();
  String loggedUserId = '';

  //assign the logged in userId to the variable, knowing that it is a Future<String>
  void getLoggedUserId() async {
    loggedUserId = await loggedInUser ?? '';
  }

  void removeEmployee(Employee employee) async {
    try {
      emit(PesquisarLoading());
      await employeeRepository.removeEmployee(employee.id);
      allEmployee.remove(employee);
      _applySearchFilter();
    } catch (e) {
      emit(PesquisarError("Failed to remove employee: $e"));
    }
  }

  Future<void> fetchEmployees() async {
    try {
      emit(PesquisarLoading());

      String userId = await localStorageService.getUserId();
      List<Employee> allEmployees =
          await employeeRepository.getEmployeesByUserId(userId);

      // Group employees by thirdCompanyId
      Map<String, List<Employee>> companies = {};
      allEmployees.forEach((employee) {
        if (!companies.containsKey(employee.thirdCompanyId)) {
          companies[employee.thirdCompanyId] = [];
        }
        companies[employee.thirdCompanyId]!.add(employee);
      });

      emit(CompanyLoaded(companies));
    } catch (e) {
      emit(PesquisarError("Failed to fetch employees: $e"));
    }
  }

  Future<void> searchEmployee(String query) async {
    try {
      if (!isClosed) {
        emit(PesquisarLoading());
      }

      searchQuery = query;
      isSearching = true;

      // Verifica se já carregou os usuários do banco de dados
      if (allEmployee.isEmpty) {
        String userId = await localStorageService.getUserId();
        allEmployee = await employeeRepository.getEmployeesByUserId(userId);
      }

      // Filter employees by name or thirdCompanyId
      filteredEmployee = allEmployee
          .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()) ||
              employee.thirdCompanyId
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      // Group employees by thirdCompanyId
      Map<String, List<Employee>> companies = {};
      filteredEmployee.forEach((employee) {
        if (!companies.containsKey(employee.thirdCompanyId)) {
          companies[employee.thirdCompanyId] = [];
        }
        companies[employee.thirdCompanyId]!.add(employee);
      });

      emit(CompanyLoaded(companies));
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      if (!isClosed) {
        emit(PesquisarError("Erro ao buscar funcionário $e"));
      }
    }
  }

  void _applySearchFilter() async {
    filteredEmployee = allEmployee
        .where((employee) =>
            employee.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    String userId = await localStorageService.getUserId();
    print(userId);
    User? logged = await localStorageService.getUser();
    bool isAd = true;
    if (logged != null && logged.number == 0) {
      isAd = false;
    }

    emit(PesquisarLoaded(filteredEmployee, isAd));
  }

  @override
  Future<void> close() async {
    if (!isClosed) {
      isClosed = true;
      await super.close();
    }
  }
}
