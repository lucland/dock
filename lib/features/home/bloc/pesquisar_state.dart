import 'package:dockcheck_web/models/employee.dart';
import 'package:dockcheck_web/models/project.dart';

abstract class PesquisarState {}

class PesquisarInitial extends PesquisarState {}

class PesquisarLoading extends PesquisarState {}

class PesquisarLoaded extends PesquisarState {
  final List<Employee> employees;
  final bool isAdmin;
  PesquisarLoaded(this.employees, this.isAdmin);
}

//add state for employee loaded
class EmployeeLoaded extends PesquisarState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
}

class CompanyLoaded extends PesquisarState {
  final Map<String, List<Employee>> companies;
  CompanyLoaded(this.companies);
}

class PesquisarError extends PesquisarState {
  final String message;
  PesquisarError(this.message);
}
