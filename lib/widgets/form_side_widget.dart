import 'package:dockcheck_web/enums/nrs_enum.dart';
import 'package:dockcheck_web/features/home/bloc/pesquisar_cubit.dart';
import 'package:dockcheck_web/widgets/calendar_picker_widget.dart';
import 'package:dockcheck_web/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/home/bloc/pesquisar_state.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/theme.dart';

class FormSide extends StatelessWidget {
  const FormSide({
    super.key,
    required this.listWidget,
  });

  final List<Widget> listWidget;

  @override
  Widget build(BuildContext context) {
    context.read<UserCubit>().fetchUsers();

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 300,
              child: const Center(
                child: CircularProgressIndicator(),
              ));
        } else if (state is UserError) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 300,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is UserLoaded) {
          List<User> displayedUsers = state.users;

          if (context.read<UserCubit>().isSearching) {
            displayedUsers = displayedUsers
                .where((user) => user.name.toLowerCase().contains(
                    context.read<UserCubit>().searchQuery.toLowerCase()))
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
                            "Usuário com documentos em dia e atrelado a um projeto",
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
                            "Usuário com documentos em dia e sem atrelamento a um projeto",
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
                        suffixIcon: GestureDetector(
                          onTap: () {
                            //context.read<UserCubit>().fetchUsers()
                          },
                          child: const Icon(Icons.search_rounded),
                        ),
                      ),
                      onSubmitted: (value) {
                        // context.read<UserCubit>().searchUsers(value);
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
                                itemCount: displayedUsers.length,
                                itemBuilder: (context, index) {
                                  User user = displayedUsers[index];
                                  return _buildUserListTile(context, user);
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

  Widget _buildUserListTile(BuildContext context, User user) {
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
        title: Text(user.name, style: DockTheme.h2),
        titleAlignment: ListTileTitleAlignment.center,
        dense: true,
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        leading: _buildLeadingIcon(user),
        subtitle: Text(user.cpf.toString()),
        onTap: () {
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Details(user: user),
            ),
          );*/
        },
      ),
    );
  }

  Widget _buildLeadingIcon(User user) {
    if (user.isBlocked) {
      return const Icon(
        Icons.circle,
        color: DockColors.danger100,
        size: 10,
      );
    } else if (user.isOnboarded) {
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
    final nrTypeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: DockColors.white,
          surfaceTintColor: DockColors.white,
          title: Text(s),
          content: SizedBox(
            width: 800,
            height: MediaQuery.of(context).size.height - 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextInputWidget(
                    title: DockStrings.nome,
                    isRequired: true,
                    controller: TextEditingController(
                      text: '',
                    ),
                    onChanged: (text) {},
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextInputWidget(
                          isRequired: true,
                          title: DockStrings.email,
                          controller: TextEditingController(
                            text: '',
                          ),
                          onChanged: (text) {},
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tipo sanguíneo', style: DockTheme.h2),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 16, bottom: 8),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 11.5),
                                  hintText: 'Tipo Sanguíneo',
                                  border: OutlineInputBorder(
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
                                value: 'A+',
                                onChanged: (String? newValue) {},
                                items: [
                                  '',
                                  'A+',
                                  'A-',
                                  'B+',
                                  'B-',
                                  'AB+',
                                  'AB-',
                                  'O+',
                                  'O-',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextInputWidget(
                          title: DockStrings.funcao,
                          controller: TextEditingController(
                            text: '',
                          ),
                          onChanged: (text) {},
                          isRequired: true,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextInputWidget(
                          title: DockStrings.empresa,
                          keyboardType: TextInputType.text,
                          controller: TextEditingController(
                            text: '',
                          ),
                          onChanged: (text) {},
                          isRequired: true,
                        ),
                      ),
                    ],
                  ),
                  //divider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                        child: Text(
                          'Documentos',
                          overflow: TextOverflow.ellipsis,
                          style: DockTheme.h1.copyWith(
                              color: DockColors.iron80,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      CalendarPickerWidget(
                        showAttachmentIcon: true,
                        title: DockStrings.aso,
                        isRequired: true,
                        controller: TextEditingController(),
                        onChanged: (time) {},
                      ),
                      CalendarPickerWidget(
                        showAttachmentIcon: true,
                        title: DockStrings.nr34,
                        isRequired: true,
                        controller: TextEditingController(),
                        onChanged: (time) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 11.5),
                            hintText: 'Adicionar NR',
                            border: OutlineInputBorder(
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
                          value: NrsEnum.nrs[0],
                          onChanged: (String? newValue) {
                            //add a new calendar picker with selected NR and a remove button
                          },
                          items: NrsEnum.nrs
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: SizedBox(
                                  width: 600,
                                  child: Text(value,
                                      overflow: TextOverflow.ellipsis)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar',
                  style: TextStyle(color: DockColors.danger100)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}
