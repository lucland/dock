import 'package:dockcheck_web/features/create/bloc/create_cubit.dart';
import 'package:dockcheck_web/features/home/bloc/cadastrar_cubit.dart';
import 'package:dockcheck_web/features/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';
import '../../widgets/text_input_widget.dart';
import '../home/home.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DockColors.background,
        body: BlocListener<CreateCubit, CreateState>(
          listener: (context, state) {
            if (state.canLogin) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erro ao criar usuário, tentar novamente'),
                  backgroundColor: DockColors.danger100,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  color: DockColors.iron100,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Image.asset('assets/svg/logo_dock_check.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: DockColors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          width: 700,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextInputWidget(
                                    title: 'Nome',
                                    keyboardType: TextInputType.text,
                                    controller: _nameController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                  ),
                                  TextInputWidget(
                                    title: 'Empresa',
                                    keyboardType: TextInputType.text,
                                    controller: _empresaController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                  ),
                                  TextInputWidget(
                                    title: 'CPF / CNPJ',
                                    keyboardType: TextInputType.number,
                                    controller: _cpfController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                  ),
                                  TextInputWidget(
                                    title: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                  ),
                                  TextInputWidget(
                                    title: 'Cargo',
                                    keyboardType: TextInputType.text,
                                    controller: _roleController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                  ),
                                  TextInputWidget(
                                    title: 'Usuário',
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _usernameController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                  ),
                                  TextInputWidget(
                                    title: 'Senha',
                                    keyboardType: TextInputType.text,
                                    controller: _passwordController,
                                    onChanged: (value) {
                                      // Chama validateForm a cada atualização de campo
                                      BlocProvider.of<CreateCubit>(context)
                                          .validateForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        empresa: _empresaController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        role: _roleController.text,
                                      );
                                    },
                                    isPassword: true,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child:
                                          BlocBuilder<CreateCubit, CreateState>(
                                              builder: (context, state) {
                                        return InkWell(
                                          onTap: state.isFormValid &&
                                                  !state.isLoading
                                              ? () {
                                                  BlocProvider.of<CreateCubit>(
                                                          context)
                                                      .createUser(
                                                    name: _nameController.text,
                                                    email:
                                                        _emailController.text,
                                                    cpf: _cpfController.text,
                                                    empresa:
                                                        _empresaController.text,
                                                    username:
                                                        _usernameController
                                                            .text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    role: _roleController.text,
                                                  );
                                                }
                                              : null,
                                          child: Container(
                                            width: 784,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: state.isFormValid &&
                                                      !state.isLoading
                                                  ? DockColors.iron100
                                                  : Colors.grey,
                                            ),
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              "Cadastrar",
                                              overflow: TextOverflow.ellipsis,
                                              style: DockTheme.headLine
                                                  .copyWith(
                                                      color: DockColors.white),
                                            ),
                                          ),
                                        );
                                      })),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
