import 'package:dockcheck_web/features/projects/projects.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/funcionarios_widget.dart';
//import flutter svg
import 'package:flutter_svg/flutter_svg.dart';
import '../login/login.dart';
import 'bloc/pesquisar_cubit.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  bool isAdmin;
  Home({super.key, required this.isAdmin});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedPage = 'funcionarios';
  @override
  Widget build(BuildContext context) {
    context.read<PesquisarCubit>().fetchEmployees();
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 300,
            height: MediaQuery.of(context).size.height,
            color: DockColors.iron100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/svg/logo_web.svg',
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    if (widget.isAdmin) ...[
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedPage = 'projetos';
                          });
                        },
                        child: Container(
                          color: selectedPage == 'projetos'
                              ? DockColors.background
                              : DockColors.iron100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.anchor,
                                  color: selectedPage == 'projetos'
                                      ? DockColors.iron100
                                      : DockColors.background,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Projetos',
                                  overflow: TextOverflow.ellipsis,
                                  style: DockTheme.h2.copyWith(
                                      color: selectedPage == 'projetos'
                                          ? DockColors.iron100
                                          : DockColors.background,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedPage = 'funcionarios';
                        });
                      },
                      child: Container(
                        color: selectedPage == 'funcionarios'
                            ? DockColors.background
                            : DockColors.iron100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline_outlined,
                                color: selectedPage == 'funcionarios'
                                    ? DockColors.iron100
                                    : DockColors.background,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Funcionários',
                                overflow: TextOverflow.ellipsis,
                                style: DockTheme.h2.copyWith(
                                    color: selectedPage == 'funcionarios'
                                        ? DockColors.iron100
                                        : DockColors.background,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedPage = 'dashboard';
                        });
                      },
                      child: Container(
                        color: selectedPage == 'dashboard'
                            ? DockColors.background
                            : DockColors.iron100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                color: selectedPage == 'dashboard'
                                    ? DockColors.iron100
                                    : DockColors.background,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Dashboard',
                                overflow: TextOverflow.ellipsis,
                                style: DockTheme.h2.copyWith(
                                    color: selectedPage == 'dashboard'
                                        ? DockColors.iron100
                                        : DockColors.background,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    */
                  ],
                ),
                //text with version
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: DockColors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Text(
                          'Suporte',
                          style: DockTheme.h2.copyWith(
                            color: DockColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 8.0),
                        child: Text(
                          'Email: lucas.vsc@gmail.com',
                          style: DockTheme.h2.copyWith(
                            color: DockColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Wpp: +55 21 98939-5063',
                          style: DockTheme.h2.copyWith(
                            color: DockColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Divider(
                        color: DockColors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Versão 1.0.0',
                          style: DockTheme.h2.copyWith(
                            color: DockColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.9, 16.0),
                        child: Text(
                          '© 2024 DockCheck. Todos os direitos reservados.',
                          style: DockTheme.h2.copyWith(
                            color: DockColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: DockColors.iron100,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: DockColors.white,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: DockColors.white,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Sair',
                                  overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
          ),
          if (selectedPage == 'funcionarios') ...{
            FuncionariosWidget(
              listWidget: [
                Container(),
              ],
            ),
          } else if (selectedPage == 'projetos') ...{
            const Expanded(child: Projects()),
          }
        ],
      ),
    );
  }
}
