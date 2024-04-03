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
    super.key,
    required this.listWidget,
  });

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
              ));
        } else if (state is PesquisarError) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 300,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PesquisarLoaded) {
          List<Employee> displayEmployees = state.employees;
          print(displayEmployees.length + 1);
          if (context.read<PesquisarCubit>().isSearching) {
            displayEmployees = displayEmployees
                .where((employee) => employee.name.toLowerCase().contains(
                    context.read<PesquisarCubit>().searchQuery.toLowerCase()))
                .toList();
          }

          return Container(
            color: DockColors.background,
            width: MediaQuery.of(context).size.width - 300,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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
                            //open modal with a text
                            openModal(context, 'Adicionar funcionário');
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
                                        color: DockColors.white, fontSize: 16),
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
                                fontWeight: FontWeight.w400),
                          ),
                        ],
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: ListView.builder(
                                itemCount: displayEmployees.length,
                                itemBuilder: (context, index) {
                                  Employee employee = displayEmployees[index];
                                  return _buildUserListTile(context, employee);
                                },
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildUserListTile(BuildContext context, Employee employee) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: DockColors.slate100,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        trailing:
            const Icon(Icons.chevron_right_rounded, color: DockColors.slate100),
        title: Text(employee.name, style: DockTheme.h2),
        titleAlignment: ListTileTitleAlignment.center,
        dense: true,
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        leading: _buildLeadingIcon(employee),
        subtitle: Text(employee.cpf.toString()),
        onTap: () {
          _openRightSideModal(context, employee);
        },
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

  void openModal(BuildContext context, String s) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CadastrarModal(
          s: s,
        );
      },
    );
  }
}
