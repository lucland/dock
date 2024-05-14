import 'package:dockcheck_web/models/employee.dart';
import 'package:dockcheck_web/widgets/image_picker_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../enums/nrs_enum.dart';
import '../features/home/bloc/cadastrar_cubit.dart';
import '../features/home/bloc/cadastrar_state.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/theme.dart';
import 'text_input_widget.dart';

class CadastrarModal extends StatelessWidget {
  final String s;
  final String? id;
  const CadastrarModal({
    super.key,
    required this.s,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    if (id != null && id != '') {
      context.read<CadastrarCubit>().getEmployeeById(id!);
    }
    TextEditingController asoController = TextEditingController();
    TextEditingController nr34Controller = TextEditingController();
    TextEditingController nr35Controller = TextEditingController();
    TextEditingController nr10Controller = TextEditingController();
    TextEditingController nr37Controller = TextEditingController();
    TextEditingController nr38Controller = TextEditingController();
    TextEditingController nr11Controller = TextEditingController();
    TextEditingController nr33Controller = TextEditingController();
    TextEditingController irataN1Controller = TextEditingController();
    TextEditingController irataN2Controller = TextEditingController();
    TextEditingController irataN3Controller = TextEditingController();
    String name = '';
    String email = '';
    String empresa = '';
    String funcao = '';
    String cpf = '';
    String bloodType = 'A+';
    String telephone = '';
    bool isEditing = false;

    return BlocBuilder<CadastrarCubit, CadastrarState>(
      builder: (context, state) {
        if (id != null && id != '') {
          isEditing = true;
        }
        if (state.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (isEditing) {
          name = state.employee.name;
          email = state.employee.email;
          empresa = state.employee.thirdCompanyId;
          funcao = state.employee.role;
          cpf = state.employee.cpf;
          bloodType = state.employee.bloodType;
        }

        // ignore: unnecessary_null_comparison
        if (state.employee.id != '' || state.employee.id != null) {
          name = state.employee.name;
          email = state.employee.email;
          empresa = state.employee.thirdCompanyId;
          funcao = state.employee.role;
          cpf = state.employee.cpf;
          bloodType = state.employee.bloodType;
        }

        Future<void> pickFile(BuildContext context, String type) async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (kDebugMode) {
            print("date pick");
          }
          if (kDebugMode) {
            print(type);
          }
          if (kDebugMode) {
            print(asoController.text);
          }
          if (result != null) {
            final PlatformFile file = result.files.first;
            DateTime? expirationDate = await showDatePicker(
              helpText: "Validade",
              fieldHintText: "Validade",
              fieldLabelText: "Data de validade",
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              //portuguese locale and format
            );
            if (expirationDate != null) {
              switch (type) {
                case "ASO":
                  asoController.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-34":
                  nr34Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-35 - TRABALHO EM ALTURA":
                  nr35Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-10 - SEGURANÇA EM INSTALAÇÕES E SERVIÇOS EM ELETRICIDADE":
                  nr10Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-37 - SEGURANÇA E SAÚDE EM PLATAFORMAS DE PETRÓLEO":
                  nr37Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-38 - SEGURANÇA E SAÚDE NO TRABALHO NAS ATIVIDADES DE LIMPEZA URBANA E MANEJO DE RESÍDUOS SÓLIDOS":
                  nr38Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-11 - TRANSPORTE, MOVIMENTAÇÃO, ARMAZENAGEM E MANUSEIO DE MATERIAIS":
                  nr11Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "NR-33 - SEGURANÇA E SAÚDE NO TRABALHO EM ESPAÇOS CONFINADOS":
                  nr33Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "IRATA N1":
                  irataN1Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "IRATA N2":
                  irataN2Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
                case "IRATA N3":
                  irataN3Controller.text =
                      '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
                  break;
              }
              if (kDebugMode) {
                print(asoController.text);
              }
              if (kDebugMode) {
                print(expirationDate);
              }
              // ignore: use_build_context_synchronously
              context.read<CadastrarCubit>().addDocument(file, expirationDate,
                  type); // Trigger addDocument with the selected file and date
              name = state.employee.name;
              email = state.employee.email;
              empresa = state.employee.thirdCompanyId;
              funcao = state.employee.role;
              cpf = state.employee.cpf;
              bloodType = state.employee.bloodType;
            }
          }
        }

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
                  if (state.isLoading)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: CircularProgressIndicator(),
                    )),
                  if (!state.isLoading) ...[
                    //text warning "Pressione ENTER para salvar as informações após preenchimento de cada campo obrigatório"
                    if (!isEditing)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Pressione ENTER para salvar as informações após preenchimento de cada campo obrigatório',
                          style: DockTheme.h3.copyWith(
                            color: DockColors.danger100,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    TextInputWidget(
                      title: DockStrings.nome,
                      isRequired: true,
                      onSubmit: (text) {
                        context.read<CadastrarCubit>().updateNome(text);
                      },
                      controller: TextEditingController(
                        text: name,
                      ),
                      onChanged: (text) {
                        name = text;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextInputWidget(
                                isRequired: true,
                                title: DockStrings.email,
                                onSubmit: (text) {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateEmail(text);
                                },
                                controller: TextEditingController(
                                  text: email,
                                ),
                                onChanged: (text) {
                                  email = text;
                                },
                              ),
                              TextInputWidget(
                                title: DockStrings.empresa,
                                onSubmit: (text) {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateEmpresa(text);
                                },
                                controller: TextEditingController(
                                  text: empresa,
                                ),
                                onChanged: (text) {
                                  empresa = text;
                                },
                                isRequired: true,
                              ),
                              TextInputWidget(
                                title: DockStrings.funcao,
                                onSubmit: (text) {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateRole(text);
                                },
                                controller: TextEditingController(
                                  text: funcao,
                                ),
                                onChanged: (text) {
                                  funcao = text;
                                },
                                isRequired: true,
                              ),
                              TextInputWidget(
                                title: DockStrings.cpf,
                                onSubmit: (text) {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateCpf(text);
                                },
                                controller: MaskedTextController(
                                  mask: '000.000.000-00',
                                  text: cpf,
                                ),
                                onChanged: (text) {
                                  cpf = text;
                                },
                                keyboardType: TextInputType.number,
                                isRequired: true,
                              ),
                              TextInputWidget(
                                title: 'Telefone',
                                controller: TextEditingController(
                                  text: telephone,
                                ),
                                onSubmit: (text) {
                                  telephone = text;
                                },
                                onChanged: (text) {
                                  telephone = text;
                                },
                                keyboardType: TextInputType.number,
                                isRequired: false,
                              ),
                            ],
                          ),
                        ),
                        if (!isEditing) ...[
                          Flexible(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text('Foto',
                                          style: DockTheme.h2,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        '*',
                                        style: DockTheme.h2.copyWith(
                                            color: DockColors.danger100),
                                      ),
                                    ),
                                  ],
                                ),
                                ImagePickerWidget(
                                    cubit: context.read<CadastrarCubit>()),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Column(
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
                            onChanged: (String? newValue) {
                              bloodType = newValue!;
                            },
                            items: [
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
                    /*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                          child: Text(
                            'Autorização de entrada',
                            overflow: TextOverflow.ellipsis,
                            style: DockTheme.h1.copyWith(
                                color: DockColors.iron80,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateAuthorizationType('Embarcação');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: state.employee.area == 'Embarcação'
                                        ? DockColors.iron100
                                        : DockColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: DockColors.iron100,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Embarcação',
                                        style: TextStyle(
                                            color: state.employee.area ==
                                                    'Embarcação'
                                                ? DockColors.white
                                                : DockColors.iron100)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateAuthorizationType('Dique seco');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: state.employee.area == 'Dique seco'
                                        ? DockColors.iron100
                                        : DockColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: DockColors.iron100,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Dique seco',
                                        style: TextStyle(
                                            color: state.employee.area ==
                                                    'Dique seco'
                                                ? DockColors.white
                                                : DockColors.iron100)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<CadastrarCubit>()
                                      .updateAuthorizationType('Ambos');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: state.employee.area == 'Ambos'
                                        ? DockColors.iron100
                                        : DockColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: DockColors.iron100,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Ambos',
                                        style: TextStyle(
                                            color:
                                                state.employee.area == 'Ambos'
                                                    ? DockColors.white
                                                    : DockColors.iron100)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),*/
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    DockStrings.aso,
                                    style: DockTheme.h2.copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '*',
                                  style: DockTheme.h2.copyWith(
                                      color: DockColors.danger100,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: asoController,
                                          decoration: InputDecoration(
                                            hintText: DockStrings.aso,
                                            suffixIcon: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: DockColors.slate100,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: DockColors.slate100,
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: DockColors.slate100,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            pickFile(context, "ASO");
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: InkWell(
                                          onTap: () => pickFile(context, "ASO"),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: DockColors.slate100,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Icon(
                                                Icons.attach_file,
                                                color: DockColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (state.documents.any(
                                      (document) => document.type == "ASO"))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Documento enviado com sucesso',
                                        style: DockTheme.h3.copyWith(
                                          color: DockColors.success100,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    DockStrings.nr34,
                                    style: DockTheme.h2.copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '*',
                                  style: DockTheme.h2.copyWith(
                                      color: DockColors.danger100,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: nr34Controller,
                                          decoration: InputDecoration(
                                            suffixIcon: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: DockColors.slate100,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            hintText: DockStrings.nr34,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: DockColors.slate100,
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: DockColors.slate100,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          readOnly: true,
                                          onTap: () async {
                                            pickFile(context, "NR-34");
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: InkWell(
                                          onTap: () =>
                                              pickFile(context, "NR-34"),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: DockColors.slate100,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Icon(
                                                Icons.attach_file,
                                                color: DockColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (state.documents.any(
                                      (document) => document.type == "NR-34"))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Documento enviado com sucesso',
                                        style: DockTheme.h3.copyWith(
                                          color: DockColors.success100,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ...state.nrTypes.map((nrType) {
                          //add the proper text editting controller depending on the type of NR
                          TextEditingController controller =
                              TextEditingController();
                          switch (nrType) {
                            case 'NR-35 - TRABALHO EM ALTURA':
                              controller = nr35Controller;
                              break;
                            case 'NR-10 - SEGURANÇA EM INSTALAÇÕES E SERVIÇOS EM ELETRICIDADE':
                              controller = nr10Controller;
                              break;
                            case 'NR-37 - SEGURANÇA E SAÚDE EM PLATAFORMAS DE PETRÓLEO':
                              controller = nr37Controller;
                              break;
                            case 'NR-38 - SEGURANÇA E SAÚDE NO TRABALHO NAS ATIVIDADES DE LIMPEZA URBANA E MANEJO DE RESÍDUOS SÓLIDOS':
                              controller = nr38Controller;
                              break;
                            case 'NR-11 - TRANSPORTE, MOVIMENTAÇÃO, ARMAZENAGEM E MANUSEIO DE MATERIAIS':
                              controller = nr11Controller;
                              break;
                            case 'NR-33 - SEGURANÇA E SAÚDE NO TRABALHO EM ESPAÇOS CONFINADOS':
                              controller = nr33Controller;
                              break;
                            case 'IRATA N1':
                              controller = irataN1Controller;
                              break;
                            case 'IRATA N2':
                              controller = irataN2Controller;
                              break;
                            case 'IRATA N3':
                              controller = irataN3Controller;
                              break;
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nrType,
                                style: DockTheme.h2.copyWith(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: controller,
                                            decoration: InputDecoration(
                                              suffixIcon: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: DockColors.slate100,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                              hintText: nrType,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                  color: DockColors.slate100,
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                  color: DockColors.slate100,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              pickFile(context, nrType);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: InkWell(
                                            onTap: () =>
                                                pickFile(context, nrType),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: DockColors.slate100,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Icon(
                                                  Icons.attach_file,
                                                  color: DockColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (state.documents.any(
                                        (document) => document.type == nrType))
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Documento enviado com sucesso',
                                          style: DockTheme.h3.copyWith(
                                            color: DockColors.success100,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
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
                                    focusColor: DockColors.background,
                                    hoverColor: DockColors.background,
                                    fillColor: DockColors.background,
                                  ),
                                  focusColor: DockColors.white,
                                  value: state.selectedNr == ''
                                      ? null
                                      : state.selectedNr,
                                  onChanged: (String? newValue) {
                                    context
                                        .read<CadastrarCubit>()
                                        .updateSelectedNr(
                                          newValue ?? '',
                                        );
                                  },
                                  items: NrsEnum.nrs
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  onTap: () => state.selectedNr != ''
                                      ? context
                                          .read<CadastrarCubit>()
                                          .addNrType(state.selectedNr)
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: state.selectedNr != ''
                                          ? DockColors.success100
                                          : DockColors.slate100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.add,
                                          color: DockColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CadastrarCubit>().resetState();
              },
              child: const Text('Fechar',
                  style: TextStyle(color: DockColors.danger100)),
            ),
            TextButton(
              onPressed: () async {
                if (isEditing) {
                  Employee employee = state.employee;
                  employee.name = name;
                  employee.email = email;
                  employee.thirdCompanyId = empresa;
                  employee.role = funcao;
                  employee.cpf = cpf;
                  employee.bloodType = bloodType;
                  employee.telephone = telephone;

                  context.read<CadastrarCubit>().updateEmployee(
                        state.employee.id,
                        employee,
                      );
                  //show a snackbar with the message "Employee updated successfully" with a green background and them pop the modal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionário atualizado com sucesso'),
                      backgroundColor: DockColors.success100,
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  if (state.picture.base64 != '' &&
                      state.documents.length >= 2 &&
                      name != '' &&
                      cpf != '' &&
                      email != '' &&
                      funcao != '' &&
                      empresa != '') {
                    context.read<CadastrarCubit>().createEvent(
                          name,
                          cpf,
                          email,
                          funcao,
                          empresa,
                          bloodType,
                          telephone,
                        );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preencha todos os campos obrigatórios'),
                        backgroundColor: DockColors.danger100,
                      ),
                    );
                  }
                }
              },
              child: Text(isEditing ? 'Salvar' : 'Adicionar',
                  style: TextStyle(
                      color: isEditing
                          ? DockColors.iron100
                          : DockColors.success100,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
