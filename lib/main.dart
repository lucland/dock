import 'package:dockcheck_web/features/create/bloc/create_cubit.dart';
import 'package:dockcheck_web/features/home/bloc/pesquisar_cubit.dart';
import 'package:dockcheck_web/features/invite/bloc/invite_cubit.dart';
import 'package:dockcheck_web/firebase_options.dart';
import 'package:dockcheck_web/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/details/bloc/details_cubit.dart';
import 'features/home/bloc/cadastrar_cubit.dart';
import 'features/login/bloc/login_cubit.dart';
import 'features/login/login.dart';
import 'features/projects/bloc/project_cubit.dart';
import 'features/projects/bloc/project_details_cubit.dart';
import 'repositories/area_repository.dart';
import 'repositories/authorization_repository.dart';
import 'repositories/beacon_repository.dart';
import 'repositories/company_repository.dart';
import 'repositories/document_repository.dart';
import 'repositories/employee_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/invite_repository.dart';
import 'repositories/login_repository.dart';
import 'repositories/picture_repository.dart';
import 'repositories/project_repository.dart';
import 'repositories/third_company_repository.dart';
import 'repositories/third_project_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/vessel_repository.dart';
import 'services/api_service.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //instantiate firebase storage
  final FirebaseStorage storage = FirebaseStorage.instanceFor(
    bucket: 'gs://dockcheck-prod.appspot.com',
  );

  var localStorageService = LocalStorageService();
  localStorageService.init();
  var apiService = ApiService(localStorageService);

  var loginRepository = LoginRepository(apiService);
  var authorizationRepository = AuthorizationRepository(apiService);
  var companyRepository = CompanyRepository(apiService);
  var eventRepository = EventRepository(apiService, localStorageService);
  var userRepository = UserRepository(apiService, localStorageService);
  var vesselRepository = VesselRepository(apiService);
  var beaconRepository = BeaconRepository(apiService);
  var areaRepository = AreaRepository(apiService);
  var documentRepository = DocumentRepository(apiService);
  var employeeRepository = EmployeeRepository(apiService);
  var inviteRepository = InviteRepository(apiService);
  var pictureRepository = PictureRepository(apiService);
  var thirdCompanyRepository = ThirdCompanyRepository(apiService);
  var thirdProjectRepository = ThirdProjectRepository(apiService);
  var projectRepository = ProjectRepository(apiService);

  var loginCubit =
      LoginCubit(loginRepository, userRepository, localStorageService);
  var pesquisarCUbit = PesquisarCubit(
      employeeRepository, projectRepository, localStorageService);
  var cadastrarCubit = CadastrarCubit(employeeRepository, localStorageService,
      eventRepository, pictureRepository, documentRepository, storage);
  var detailsCubit = DetailsCubit(
      employeeRepository, documentRepository, localStorageService, storage);
  var projectCubit =
      ProjectCubit(projectRepository, localStorageService, storage);
  var inviteCubit = InviteCubit(inviteRepository);
  var createCubit = CreateCubit(userRepository);
  var projectDetailsCubit = ProjectDetailsCubit(
      employeeRepository, projectRepository, localStorageService, storage);

  runApp(
    MultiBlocProvider(
      providers: [
        Provider<LoginRepository>(create: (_) => loginRepository),
        Provider<AuthorizationRepository>(
            create: (_) => authorizationRepository),
        Provider<CompanyRepository>(create: (_) => companyRepository),
        Provider<EventRepository>(create: (_) => eventRepository),
        Provider<UserRepository>(create: (_) => userRepository),
        Provider<VesselRepository>(create: (_) => vesselRepository),
        Provider<ApiService>(create: (_) => apiService),
        Provider<LocalStorageService>(create: (_) => localStorageService),
        BlocProvider<LoginCubit>(create: (_) => loginCubit),
        Provider<BeaconRepository>(create: (_) => beaconRepository),
        Provider<AreaRepository>(create: (_) => areaRepository),
        Provider<DocumentRepository>(create: (_) => documentRepository),
        Provider<EmployeeRepository>(create: (_) => employeeRepository),
        Provider<InviteRepository>(create: (_) => inviteRepository),
        Provider<ProjectRepository>(create: (_) => projectRepository),
        Provider<PictureRepository>(create: (_) => pictureRepository),
        Provider<ThirdCompanyRepository>(create: (_) => thirdCompanyRepository),
        Provider<ThirdProjectRepository>(create: (_) => thirdProjectRepository),
        BlocProvider<PesquisarCubit>(create: (_) => pesquisarCUbit),
        BlocProvider<CadastrarCubit>(create: (_) => cadastrarCubit),
        BlocProvider<DetailsCubit>(create: (_) => detailsCubit),
        BlocProvider<ProjectCubit>(create: (_) => projectCubit),
        BlocProvider<InviteCubit>(create: (_) => inviteCubit),
        BlocProvider<CreateCubit>(create: (_) => createCubit),
        BlocProvider<ProjectDetailsCubit>(create: (_) => projectDetailsCubit),
        Provider(create: (_) => storage),
      ],
      child: MyApp(),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  //check if the user is logged in, if not, show the login page by checking if local storage has a token and a user id saved
  LocalStorageService localStorageService = LocalStorageService();
  bool isLoggedIn() {
    // ignore: unrelated_type_equality_checks
    return localStorageService.getToken() != "" &&
        // ignore: unrelated_type_equality_checks
        localStorageService.getUserId() != "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DockTheme.theme,
      // home: isLoggedIn() ? const Home() : Login(),
      home: Login(),
      //if the
      //home: const Home(),
    );
  }
}
