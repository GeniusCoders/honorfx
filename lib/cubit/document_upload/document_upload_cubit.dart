import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/document_upload/document_upload_state.dart';
import 'package:honorfx/models/dashboard/document_upload_model.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  final DashboardRepo _dashboardRepo;

  DocumentUploadCubit({required DashboardRepo dashboardRepo})
    : _dashboardRepo = dashboardRepo,
      super(DocumentUploadInitial());

  Future<void> getDocumentUploadList() async {
    emit(DocumentUploadLoading());
    try {
      final result = await _dashboardRepo.getDocumentUploadList();
      result.fold(
        (error) => emit(
          DocumentUploadListError(
            message: error.message ?? 'Failed to load documents',
          ),
        ),
        (response) {
          if (response.status == 200) {
            emit(DocumentUploadListLoaded(documentList: response.data ?? []));
          } else {
            emit(
              DocumentUploadListError(
                message: response.msg ?? 'Failed to load documents',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(DocumentUploadListError(message: e.toString()));
    }
  }

  Future<void> uploadDocuments(UploadDocumentModel model) async {
    emit(DocumentUploadLoading());
    try {
      final result = await _dashboardRepo.uploadDocuments(model: model);
      result.fold(
        (error) => emit(
          DocumentUploadError(
            message: error.message ?? 'Failed to upload documents',
          ),
        ),
        (response) {
          if (response.status == 200) {
            emit(
              DocumentUploadSuccess(
                message: response.msg ?? 'Documents uploaded successfully',
              ),
            );
            // Refresh the list after successful upload
            getDocumentUploadList();
          } else {
            emit(
              DocumentUploadError(
                message: response.msg ?? 'Failed to upload documents',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(DocumentUploadError(message: e.toString()));
    }
  }
}
