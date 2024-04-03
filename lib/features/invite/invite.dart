import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/invite.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/text_input_widget.dart';
import 'bloc/invite_cubit.dart';
import 'bloc/invite_state.dart';

class InviteWidget extends StatelessWidget {
  final String projectId;

  InviteWidget({Key? key, required this.projectId}) : super(key: key);

  final emailController = TextEditingController();
  final companyNameController = TextEditingController();

  void _showInviteModal(BuildContext context) {
    print("getAllInvites");
    print(projectId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DockColors.white,
          surfaceTintColor: DockColors.white,
          content: BlocProvider.value(
            value: BlocProvider.of<InviteCubit>(context)
              ..getAllInvites(projectId),
            child: BlocBuilder<InviteCubit, InviteState>(
              builder: (context, state) {
                final isSendButtonEnabled = emailController.text.isNotEmpty &&
                    companyNameController.text.isNotEmpty &&
                    state.isEmailValid;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Convidar empresa parceira',
                      style: DockTheme.h1.copyWith(
                        color: DockColors.iron100,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextInputWidget(
                      title: 'Nome da empresa',
                      isRequired: true,
                      controller: companyNameController,
                      isEnabled: state.isInputEnabled,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextInputWidget(
                            title: 'Email',
                            isRequired: true,
                            isEnabled: state.isInputEnabled,
                            isError: !state.isEmailValid,
                            errorMessage: 'Por favor, insira um email válido',
                            controller: emailController,
                            onChanged: (text) {
                              context.read<InviteCubit>().validateEmail(text);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0),
                          child: InkWell(
                            onTap: isSendButtonEnabled
                                ? () {
                                    context.read<InviteCubit>().sendInvite(
                                        emailController.text,
                                        companyNameController.text,
                                        projectId);
                                    emailController.clear();
                                    companyNameController.clear();
                                  }
                                : null,
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  width: 2,
                                  color: isSendButtonEnabled
                                      ? DockColors.iron100
                                      : Colors.grey,
                                ),
                                color: isSendButtonEnabled
                                    ? DockColors.iron100
                                    : Colors.grey,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Convites:',
                      style: DockTheme.h2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: 800,
                        color:
                            DockColors.background, // Different background color
                        child: state.invites.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: ListBody(
                                    children: state.invites
                                        .map((invite) =>
                                            _buildInviteTile(invite, context))
                                        .toList(),
                                  ),
                                ),
                              )
                            : Center(child: Text('Nenhuma empresa convidada')),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showInviteModal(context),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: DockColors.iron100,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.work_rounded,
                color: DockColors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'Convidar empresas',
                style: DockTheme.h3.copyWith(
                    color: DockColors.white, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //list tile widget
  Widget _buildInviteTile(Invite invite, BuildContext context) {
    String statusEmail = '';

    if (invite.sent && !invite.viewed && !invite.accepted) {
      statusEmail = 'Enviado';
    } else if (!invite.sent) {
      statusEmail = 'Pendente';
    } else if (invite.sent && invite.viewed && !invite.accepted) {
      statusEmail = 'Visualizado';
    } else if (invite.sent && invite.accepted) {
      statusEmail = 'Aceito';
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(invite.thirdCompanyName,
                      style: DockTheme.body2.copyWith(
                        color: DockColors.iron100,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(statusEmail,
                      style: DockTheme.body.copyWith(
                        fontSize: 16,
                        color: statusEmail == 'Aceito'
                            ? DockColors.success100
                            : DockColors.iron100,
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0, right: 8.0),
              child: InkWell(
                onTap: () {
                  context.read<InviteCubit>().resendInvite(
                      invite.email, invite.thirdCompanyName, projectId);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: DockColors.iron100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.send_rounded,
                            color: DockColors.white,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Reenviar',
                            overflow: TextOverflow.ellipsis,
                            style: DockTheme.body.copyWith(
                                color: DockColors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            color: DockColors.iron100,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
