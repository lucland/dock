import 'package:dockcheck_web/features/projects/bloc/project_details_cubit.dart';
import 'package:dockcheck_web/features/projects/bloc/project_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/details/details.dart';
import '../models/employee.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';

class ProjectDetailsModal extends StatelessWidget {
  //it receives a Project object
  const ProjectDetailsModal({Key? key, required this.project})
      : super(key: key);
  final String project;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
      print(project);
      if (state.project.id != project) {
        context.read<ProjectDetailsCubit>().fetchProjectById(project);

        context.read<ProjectDetailsCubit>().fetchEmployees();
        context.read<ProjectDetailsCubit>().fetchEmployeesUninvited();
      }
      print("details proj");
      print(state.project.id);

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: DockColors.white,
        surfaceTintColor: DockColors.white,
        title: const Text(
            'Equipe do projeto'), // You can make this dynamic as needed
        content: SizedBox(
          width: 900,
          height: MediaQuery.of(context).size.height - 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //text saying "Total: " and the total number of employees
                    Text('Total: ${state.employees.length}',
                        style: DockTheme.h2.copyWith(
                            color: DockColors.iron100,
                            fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () {
                        context
                            .read<ProjectDetailsCubit>()
                            .fetchEmployeesUninvited();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            //return list of employeesUnvited to add to the project and a button to add them to the project
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: DockColors.white,
                              surfaceTintColor: DockColors.white,
                              title: const Text(
                                  'Adicionar funcionários'), // You can make this dynamic as needed
                              content: Container(
                                width: 800,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: DockColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (state.isLoadingUninvited)
                                        const Center(
                                            child: CircularProgressIndicator())
                                      else if (state
                                          .errorMessageUninvited.isNotEmpty)
                                        Column(
                                          children: [
                                            Text(
                                                'Error: ${state.errorMessageUninvited}'),
                                            TextButton(
                                              onPressed: () => context
                                                  .read<ProjectDetailsCubit>()
                                                  .fetchEmployeesUninvited(),
                                              child: const Text(
                                                  'Tentar novamente'),
                                            ),
                                          ],
                                        )
                                      else if (state.employeesUnvited.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              'Nenhum funcionário encontrado'),
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                state.employeesUnvited.length,
                                            itemBuilder: (context, index) {
                                              final employee =
                                                  state.employeesUnvited[index];
                                              return Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  employee.name,
                                                                  style: DockTheme.h2.copyWith(
                                                                      color: DockColors
                                                                          .iron100,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              Text(
                                                                  employee
                                                                      .thirdCompanyId
                                                                      .toString(),
                                                                  style: DockTheme.h2.copyWith(
                                                                      color: DockColors
                                                                          .iron100,
                                                                      fontSize:
                                                                          18)),
                                                            ],
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            context
                                                                .read<
                                                                    ProjectDetailsCubit>()
                                                                .addEmployee(
                                                                    employee
                                                                        .id);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: DockColors
                                                                  .success100,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: const Row(
                                                              children: [
                                                                //plus icon
                                                                Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 16),
                                                    child: Divider(
                                                      color:
                                                          DockColors.slate100,
                                                      thickness: 1,
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK',
                                      style:
                                          TextStyle(color: DockColors.iron100)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: DockColors.success100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //plus icon
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Adicionar funcionário',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(color: DockColors.iron30, thickness: 1),
                ),
                const SizedBox(height: 8),
                //if state.isLoading is true, show a CircularProgressIndicator, if state.errorMessage is not empty, show a Text with the error message and a button to try again, else show a ListView.builder with the employees, if there are no employees, show a Text with a message
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.errorMessage.isNotEmpty)
                  Column(
                    children: [
                      Text('Error: ${state.errorMessage}'),
                      TextButton(
                        onPressed: () => context
                            .read<ProjectDetailsCubit>()
                            .fetchEmployees(),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  )
                else
                  state.employees.isEmpty
                      ? const Text('Nenhum funcionário encontrado')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.employees.length,
                          itemBuilder: (context, index) {
                            final employee = state.employees[index];
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(employee.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: DockTheme.h2.copyWith(
                                                color: DockColors.iron100,
                                                fontWeight: FontWeight.w600)),
                                        Text(employee.thirdCompanyId.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: DockTheme.h2.copyWith(
                                                color: DockColors.iron100,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => _openRightSideModal(
                                            context, employee),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: DockColors.iron100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //plus icon
                                                Icon(
                                                  Icons
                                                      .edit_document, //change to details icon
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Detalhes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      if (employee.isBlocked) ...[
                                        InkWell(
                                          onTap: () => context
                                              .read<ProjectDetailsCubit>()
                                              .approveEmployee(employee.id),
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: DockColors.success100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  //plus icon
                                                  Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Aprovar para o projeto',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Remover funcionário'),
                                              content: const Text(
                                                  'Tem certeza que deseja remover este funcionário do projeto?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Cancelar',
                                                      style: TextStyle(
                                                          color: DockColors
                                                              .iron100)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                            ProjectDetailsCubit>()
                                                        .removeEmployee(
                                                            employee.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                      'Remover do projeto',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: DockColors.danger100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<ProjectDetailsCubit>()
                  .reset(); // Adjust the color as needed
              Navigator.of(context).pop();
            },
            child:
                const Text('OK', style: TextStyle(color: DockColors.iron100)),
          ),
        ],
      );
    });
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
}
