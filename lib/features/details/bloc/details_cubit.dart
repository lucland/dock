import 'package:dockcheck_web/models/employee.dart';
import 'package:dockcheck_web/repositories/document_repository.dart';
import 'package:dockcheck_web/repositories/employee_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/document.dart';
import '../../../services/local_storage_service.dart';
import '../../../utils/simple_logger.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final EmployeeRepository employeeRepository;
  final DocumentRepository documentsRepository; // Added DocumentsRepository
  final LocalStorageService localStorageService;
  final FirebaseStorage storage;

  DetailsCubit(this.employeeRepository, this.documentsRepository,
      this.localStorageService, this.storage)
      : super(DetailsInitial());

  Future<void> getEmployeeAndDocuments(String employeeId) async {
    try {
      emit(DetailsLoading());
      Employee employee = await employeeRepository.getEmployeeById(employeeId);
      List<Document> documents =
          await documentsRepository.getDocumentByEmployeeId(employeeId);

      List<String> urls = [];
      // Fetch the documents from Firebase Storage
      if (documents.isEmpty) {
        emit(DetailsLoaded(employee, documents));
        return;
      }
      for (var document in documents) {
        try {
          final url = await storage
              .ref()
              .child("documents/${document.id}/${document.type}")
              .getDownloadURL();
          urls.add(url);
          document.path = url;
        } catch (e) {
          emit(DetailsError('Failed to fetch user or documents: $e'));
          SimpleLogger.warning('Failed to fetch document: $e');
        }
      }

      emit(DetailsLoaded(employee, documents, urls: urls));
    } catch (e) {
      SimpleLogger.warning('Error fetching user or documents: $e');
      emit(DetailsError('Failed to fetch user or documents: $e'));
    }
  }
}
