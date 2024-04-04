import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dockcheck_web/repositories/event_repository.dart';
import 'package:dockcheck_web/repositories/picture_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../models/document.dart';
import '../../../models/event.dart';
import '../../../models/employee.dart';
import '../../../models/picture.dart';
import '../../../repositories/document_repository.dart';
import '../../../repositories/employee_repository.dart';
import '../../../services/local_storage_service.dart';
import '../../../utils/simple_logger.dart';
import 'cadastrar_state.dart';

class CadastrarCubit extends Cubit<CadastrarState> {
  final EmployeeRepository employeeRepository;
  final EventRepository eventRepository;
  final PictureRepository pictureRepository;
  final DocumentRepository documentRepository;
  final LocalStorageService localStorageService;
  final FirebaseStorage storage;

  @override
  bool isClosed = false;
  late StreamSubscription scanSubscription;
  bool isStreaming = false;

  CadastrarCubit(
      this.employeeRepository,
      this.localStorageService,
      this.eventRepository,
      this.pictureRepository,
      this.documentRepository,
      this.storage)
      : super(
          CadastrarState(
            numero: 0,
            employee: Employee(
              id: const Uuid().v1(),
              authorizationsId: [],
              name: '',
              thirdCompanyId: '',
              visitorCompany: '',
              role: '',
              number: 0,
              bloodType: 'A+',
              cpf: '',
              email: '',
              area: 'Ambos',
              lastAreaFound: '',
              lastTimeFound: DateTime.now(),
              isBlocked: true,
              documentsOk: false,
              blockReason: '',
              status: '-',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              userId: '-',
            ),
            event: Event(
              id: const Uuid().v4(),
              employeeId: '-',
              timestamp: DateTime.now(),
              projectId: '-',
              action: 0,
              sensorId: '-',
              status: '-',
              beaconId: '-',
            ),
            picture: Picture(
              id: const Uuid().v4(),
              employeeId: '-',
              base64: '',
              docPath: '',
              status: '-',
            ),
            documents: [],
            isLoading: false,
            employeeCreated: false,
            cadastroHabilitado: false,
            nrTypes: [],
            selectedNr: '',
            canCreate: false,
          ),
        );

  Future<String?> get loggedInUser => localStorageService.getUserId();
  String loggedUserId = '';

  //assign the logged in userId to the variable, knowing that it is a Future<String>
  void getLoggedUserId() async {
    loggedUserId = await loggedInUser ?? '';
  }

  void fetchNumero() async {
    if (!isClosed) {
      try {
        var numero = await employeeRepository.getLastEmployeeNumber();
        //parse the numero string to int

        final employee = state.employee.copyWith(number: numero + 1);
        if (!isClosed) {
          emit(state.copyWith(
              employee: employee, isLoading: false, numero: numero + 1));
        }
      } catch (e) {
        SimpleLogger.warning('Error during data synchronization: $e');
        print(e.toString());
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ));
        }
      }
    }
  }

  //updateAuthorizationType updating employee.area
  void updateAuthorizationType(String authorizationType) {
    final employee = state.employee.copyWith(area: authorizationType);
    bool canCreate = state.picture.base64.isNotEmpty &&
        state.documents.length >= 2 &&
        state.employee.cpf.isNotEmpty &&
        state.employee.name.isNotEmpty &&
        state.employee.email.isNotEmpty &&
        state.employee.thirdCompanyId.isNotEmpty;
    state.employee.role.isNotEmpty;
    emit(state.copyWith(employee: employee));
    //  checkCadastroHabilitado();
  }

  void addNrType(String nrType) {
    //if nrtype is not in the list, add it
    if (state.nrTypes.contains(nrType)) {
      return;
    }
    final updatedNrTypes = List<String>.from(state.nrTypes)..add(nrType);
    emit(state.copyWith(nrTypes: updatedNrTypes));
  }

  void removeNrType(String nrType) {
    final updatedNrTypes = List<String>.from(state.nrTypes)..remove(nrType);
    emit(state.copyWith(nrTypes: updatedNrTypes));
  }

  void updateSelectedNr(String nrType) {
    emit(state.copyWith(selectedNr: nrType));
  }

  void addDocument(
      PlatformFile file, DateTime expirationDate, String type) async {
    emit(state.copyWith(isLoading: true));
    String docId = const Uuid().v4();
//send the file to the firebase storage
    try {
      final ref = storage.ref().child("documents/$docId/$type");
      //transform the PlatformFile to a File and upload it to the firebase storage
      await ref.putData(file.bytes!);
    } on FirebaseException catch (e) {
      print(e.toString());
      print(e.message.toString());
      print(e.code.toString());
      SimpleLogger.warning('Error cadastrar_cubit addDocument: $e');
      if (!isClosed) {
        emit(state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
        ));
      }
    }

    final updatedDocuments = List<Document>.from(state.documents)
      ..add(Document(
        id: docId,
        type: type,
        employeeId: state.employee.id,
        expirationDate: expirationDate,
        path: 'documents/$docId',
        status: 'pending',
      ));
    bool canCreate = state.picture.base64.isNotEmpty &&
        state.documents.length > 1 &&
        state.employee.cpf.isNotEmpty &&
        state.employee.name.isNotEmpty &&
        state.employee.name.isNotEmpty &&
        state.employee.email.isNotEmpty &&
        state.employee.thirdCompanyId.isNotEmpty;
    state.employee.role.isNotEmpty;

    emit(state.copyWith(documents: updatedDocuments, isLoading: false));
    // checkCadastroHabilitado();
  }

  Future<void> pickImage() async {
    Employee employee = state.employee;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
      compressionQuality: 90,
    );

    //receive the bytes of the image, convert it to base64 and update the state
    if (result != null) {
      Uint8List bytes = result.files.first.bytes!;
      String base64Image = base64Encode(bytes);
      final picture = state.picture.copyWith(base64: base64Image);
      bool canCreate = state.documents.length >= 2 &&
          state.employee.cpf.isNotEmpty &&
          state.employee.name.isNotEmpty &&
          state.employee.email.isNotEmpty &&
          state.employee.thirdCompanyId.isNotEmpty;
      state.employee.role.isNotEmpty;
      emit(state.copyWith(
          picture: picture, employee: employee, canCreate: canCreate));
    }
    //  checkCadastroHabilitado();
  }

  //add third company name to the employee
  void addThirdCompany(String thirdCompany) {
    final employee = state.employee.copyWith(thirdCompanyId: thirdCompany);
    bool canCreate = state.picture.base64.isNotEmpty &&
        state.documents.length >= 2 &&
        state.employee.cpf.isNotEmpty &&
        state.employee.name.isNotEmpty &&
        state.employee.email.isNotEmpty &&
        state.employee.role.isNotEmpty;
    emit(state.copyWith(employee: employee, canCreate: canCreate));
    // checkCadastroHabilitado();
  }

  void removeImage() {
    final picture = state.picture.copyWith(base64: '');

    emit(state.copyWith(picture: picture, canCreate: false));
  }

  void updateBloodType(String bloodType) {
    final employee = state.employee.copyWith(bloodType: bloodType);
    if (!isClosed) {
      emit(state.copyWith(employee: employee));
      //  checkCadastroHabilitado();
    }
  }

  void updateNome(String nome) {
    final employee = state.employee.copyWith(name: nome, status: 'created');
    if (!isClosed) {
      bool canCreate = state.picture.base64.isNotEmpty &&
          state.documents.length >= 2 &&
          state.employee.cpf.isNotEmpty &&
          state.employee.role.isNotEmpty &&
          state.employee.email.isNotEmpty &&
          state.employee.thirdCompanyId.isNotEmpty;
      emit(state.copyWith(employee: employee, canCreate: canCreate));
      // checkCadastroHabilitado();
    }
  }

  //updateEmail, updateCpf and updateRole follow the same pattern
  void updateEmail(String email) {
    final employee = state.employee.copyWith(email: email);
    if (!isClosed) {
      bool canCreate = state.picture.base64.isNotEmpty &&
          state.documents.length >= 2 &&
          state.employee.cpf.isNotEmpty &&
          state.employee.name.isNotEmpty &&
          state.employee.role.isNotEmpty &&
          state.employee.thirdCompanyId.isNotEmpty;
      emit(state.copyWith(employee: employee, canCreate: canCreate));
      //  checkCadastroHabilitado();
    }
  }

  void updateCpf(String cpf) {
    final employee = state.employee.copyWith(cpf: cpf);
    if (!isClosed) {
      bool canCreate = state.picture.base64.isNotEmpty &&
          state.documents.length >= 2 &&
          state.employee.role.isNotEmpty &&
          state.employee.name.isNotEmpty &&
          state.employee.email.isNotEmpty &&
          state.employee.thirdCompanyId.isNotEmpty;
      emit(state.copyWith(employee: employee, canCreate: canCreate));
      //  checkCadastroHabilitado();
    }
  }

  void updateRole(String role) {
    final employee = state.employee.copyWith(role: role);
    if (!isClosed) {
      bool canCreate = state.picture.base64.isNotEmpty &&
          state.documents.length >= 2 &&
          state.employee.cpf.isNotEmpty &&
          state.employee.name.isNotEmpty &&
          state.employee.email.isNotEmpty &&
          state.employee.thirdCompanyId.isNotEmpty;
      emit(state.copyWith(employee: employee, canCreate: canCreate));
      // checkCadastroHabilitado();
    }
  }

  void updateEmpresa(String empresa) {
    final employee = state.employee.copyWith(thirdCompanyId: empresa);
    if (!isClosed) {
      bool canCreate = state.picture.base64.isNotEmpty &&
          state.documents.length >= 2 &&
          state.employee.cpf.isNotEmpty &&
          state.employee.name.isNotEmpty &&
          state.employee.role.isNotEmpty &&
          state.employee.email.isNotEmpty;
      emit(state.copyWith(employee: employee, canCreate: canCreate));
      // checkCadastroHabilitado();
    }
  }
  // Similarly, other update methods follow the same pattern

  void resetState() {
    if (!isClosed) {
      emit(state.copyWith(
        employee: Employee(
          id: const Uuid().v1(),
          authorizationsId: [""],
          name: '',
          thirdCompanyId: '',
          visitorCompany: '',
          role: '',
          number: 0,
          bloodType: 'A+',
          cpf: '',
          email: '',
          area: 'Ambos',
          lastAreaFound: '',
          lastTimeFound: DateTime.now(),
          isBlocked: true,
          documentsOk: false,
          blockReason: '',
          status: '-',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userId: '-',
        ),
        event: Event(
          id: const Uuid().v4(),
          employeeId: '-',
          timestamp: DateTime.now(),
          projectId: '-',
          action: 0,
          sensorId: '-',
          status: '-',
          beaconId: '-',
        ),
        isLoading: false,
        employeeCreated: false,
        cadastroHabilitado: false,
        nrTypes: [],
        documents: [],
        picture: Picture(
          id: const Uuid().v4(),
          employeeId: '-',
          base64: '',
          docPath: '',
          status: '-',
        ),
        selectedNr: '',
      ));
    }
  }

  void createEvent(String name, String cpf, String email, String funcao,
      String empresa, String bloodType) async {
    fetchNumero();
    final event = state.event.copyWith(
      employeeId: state.employee.id,
      timestamp: DateTime.now(),
      projectId: '1',
      action: 1,
      sensorId: '1',
      status: 'created',
      beaconId: '1',
    );

    if (!isClosed) {
      emit(state.copyWith(
        employee: state.employee.copyWith(
          name: name,
          cpf: cpf,
          email: email,
          role: funcao,
          thirdCompanyId: empresa,
          bloodType: bloodType,
        ),
        event: event,
      ));
    }
    try {
      //await eventRepository.createEvent(event);
      print('Event created');
      SimpleLogger.info('Event created');
      if (!isClosed) {
        createPicture();
      }
    } catch (e) {
      print(e.toString());
      SimpleLogger.warning('Error cadastrar_cubit createEvent: $e');
      if (!isClosed) {
        emit(state.copyWith(
          errorMessage: e.toString(),
        ));
      }
    }
  }

//create picture with PictureRepository passing state.picture
  Future<void> createPicture() async {
    if (state.picture.base64.isEmpty || state.picture.base64 == '-') {
      if (!isClosed) {
        createDocuments();
      }
    } else {
      if (!isClosed) {
        emit(state.copyWith(
            picture: state.picture
                .copyWith(status: 'created', employeeId: state.employee.id)));
        try {
          await pictureRepository.createEmployeePicture(state.picture);
          print(documentRepository);
          SimpleLogger.info('Picture created');
          if (!isClosed) {
            createDocuments();
          }
        } catch (e) {
          print(e.toString());
          SimpleLogger.warning('Error cadastrar_cubit createPicture: $e');
          if (!isClosed) {
            emit(state.copyWith(
              errorMessage: e.toString(),
            ));
          }
        }
      }
    }
  }

  //create documents, for each Document in state.documents, create a document with DocumentRepository passing the document
  Future<void> createDocuments() async {
    print("createDocuments");
    if (state.documents.isEmpty) {
      if (!isClosed) {
        createEmployee();
      }
    }
    if (!isClosed) {
      for (var document in state.documents) {
        try {
          print('Creating document');
          await documentRepository.createDocument(document);
          SimpleLogger.info('Document created');
        } catch (e) {
          print(e.toString());
          SimpleLogger.warning('Error cadastrar_cubit createDocuments: $e');
          if (!isClosed) {
            emit(state.copyWith(
              errorMessage: e.toString(),
            ));
          }
        }
      }
      if (!isClosed) {
        createEmployee();
      }
    }
  }

  Future<void> createEmployee() async {
    String userId = await localStorageService.getUserId();
    var numero = await employeeRepository.getLastEmployeeNumber();
    print(numero);
    //if there are any expiring date of any document that is before today, turn a boolean false
    bool isExpired = state.documents.any((element) =>
        element.expirationDate.isBefore(DateTime.now()) ||
        element.expirationDate.isAtSameMomentAs(DateTime.now()));
    //parse the numero string to int
    if (!isClosed) {
      final employee = state.employee.copyWith(
          documentsOk: !isExpired,
          userId: userId,
          isBlocked: true,
          number: numero + 1,
          status: 'created');
      emit(state.copyWith(employee: employee));
      try {
        await employeeRepository.createEmployee(state.employee);
        SimpleLogger.info('Employee created');
        print('Employee created');
        //clear the state
        resetState();
        emit(state.copyWith(employeeCreated: true));
      } catch (e) {
        SimpleLogger.warning('Error cadastrar_cubit createEmployee: $e');
        print(e.toString());
        if (!isClosed) {
          emit(state.copyWith(
            errorMessage: e.toString(),
          ));
        }
      }
    }
  }

  Future<void> checkCadastroHabilitado(
    String name,
    String cpf,
    String email,
    String funcao,
    String empresa,
  ) async {
    final employee = state.employee.copyWith(
        name: name,
        cpf: cpf,
        email: email,
        role: funcao,
        thirdCompanyId: empresa);
    emit(state.copyWith(employee: employee, isLoading: true));
    bool canCreate = state.picture.base64.isNotEmpty &&
        state.documents.length >= 2 &&
        state.employee.cpf.isNotEmpty &&
        state.employee.name.isNotEmpty &&
        state.employee.role.isNotEmpty &&
        state.employee.thirdCompanyId.isNotEmpty &&
        state.employee.email.isNotEmpty;
    emit(state.copyWith(canCreate: canCreate, isLoading: false));
  }

  bool userChecksPassed() {
    return state.employee.name.isNotEmpty &&
        state.employee.role.isNotEmpty &&
        state.employee.thirdCompanyId.isNotEmpty &&
        state.employee.area.isNotEmpty;
  }

  bool visitorChecksPassed() {
    return state.employee.name.isNotEmpty &&
        state.employee.visitorCompany.isNotEmpty;
  }

  // Closing the cubit
  @override
  Future<void> close() {
    if (isStreaming) {
      scanSubscription.cancel();
    }
    return super.close();
  }
}
