import 'package:dockcheck_web/features/home/bloc/pesquisar_cubit.dart';
import 'package:dockcheck_web/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/details/details.dart';
import '../features/home/bloc/pesquisar_state.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/theme.dart';
import 'cadastrar_modal_widget.dart';

class FuncionariosWidget extends StatelessWidget {
  const FuncionariosWidget({
    Key? key,
    required this.listWidget,
  }) : super(key: key);

  final List<Widget> listWidget;

  @override
  Widget build(BuildContext context) {
    context.read<PesquisarCubit>().fetchEmployees();

    return BlocBuilder<PesquisarCubit, PesquisarState>(
      builder: (context, state) {
        if (state is PesquisarLoading) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 300,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PesquisarError) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 300,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CompanyLoaded) {
          return Container(
            color: DockColors.background,
            width: MediaQuery.of(context).size.width - 300,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Funcionários',
                          style: DockTheme.h1.copyWith(
                            color: DockColors.iron100,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Open modal with a text
                            openModal(context, 'Adicionar funcionário', null);
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              color: DockColors.success120,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: DockColors.success120,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: DockColors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Adicionar',
                                    style: DockTheme.h2.copyWith(
                                      color: DockColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: DockColors.danger100,
                            size: 10,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Usuário bloqueado por pendência",
                            overflow: TextOverflow.ellipsis,
                            style: DockTheme.h2.copyWith(
                              color: DockColors.iron80,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Icon(
                            Icons.circle,
                            color: DockColors.success100,
                            size: 10,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Usuário com documentos em dia e aprovado a um projeto",
                            overflow: TextOverflow.ellipsis,
                            style: DockTheme.h2.copyWith(
                              color: DockColors.iron80,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Icon(
                            Icons.circle,
                            color: DockColors.warning110,
                            size: 10,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Usuário atrelado a um projeto pendente de aprovação",
                            overflow: TextOverflow.ellipsis,
                            style: DockTheme.h2.copyWith(
                              color: DockColors.iron80,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Show a text with the number of employees
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Total de funcionários: ${state.companies.values.fold(0, (previousValue, element) => previousValue + element.length)}',
                        style: DockTheme.h2.copyWith(
                          color: DockColors.iron100,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11.5),
                        hintText: DockStrings.pesquisar,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: DockColors.slate100,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: DockColors.slate100,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: DockColors.slate100,
                            width: 1,
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        context.read<PesquisarCubit>().searchEmployee(value);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: state.companies.entries.map((entry) {
                          final companyName = entry.key;
                          final employees = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildCompanyListTile(
                                context, companyName, employees),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Error'));
        }
      },
    );
  }

  Widget _buildCompanyListTile(
      BuildContext context, String companyName, List<Employee> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            companyName + ' (${employees.length} funcionários)',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: DockColors.iron100),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return _buildUserListTile(context, employees[index]);
          },
        ),
      ],
    );
  }

  Widget _buildUserListTile(BuildContext context, Employee employee) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: DockColors.slate100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _openRightSideModal(context, employee);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildLeadingIcon(employee),
                  ),
                  // Title and subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.name, style: DockTheme.h2),
                      Text("${employee.role} - ${employee.thirdCompanyId}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              openModal(context, 'Editar', employee.id);
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: DockColors.iron100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: DockColors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () {
              //show dialog to confirm delete employee
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Excluir funcionário'),
                    content: const Text(
                        'Tem certeza que deseja excluir este funcionário?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<PesquisarCubit>()
                              .removeEmployee(employee);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Excluir'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: DockColors.danger100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: DockColors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openRightSideModal(BuildContext context, Employee employee) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.5, // 50% width of the screen
            child: DetailsView(
                employeeId: employee
                    .id), // Assuming Details widget takes a user as a parameter
          ),
        );
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Makes background transparent
    );
  }

  Widget _buildLeadingIcon(Employee employee) {
    if (employee.isBlocked && !employee.documentsOk) {
      return const Icon(
        Icons.circle,
        color: DockColors.danger100,
        size: 10,
      );
    } else if (employee.documentsOk && !employee.isBlocked) {
      return const Icon(
        Icons.circle,
        color: DockColors.success100,
        size: 10,
      );
    } else {
      return const Icon(
        Icons.circle,
        color: DockColors.warning110,
        size: 10,
      );
    }
  }

  void openModal(BuildContext context, String s, String? id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CadastrarModal(
          s: s,
          id: id,
        );
      },
    );
  }
}
