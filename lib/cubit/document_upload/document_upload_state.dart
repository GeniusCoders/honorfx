import 'package:honorfx/models/dashboard/document_upload_model.dart';

abstract class DocumentUploadState {}

class DocumentUploadInitial extends DocumentUploadState {}

class DocumentUploadLoading extends DocumentUploadState {}

class DocumentUploadListLoaded extends DocumentUploadState {
  final List<DocumentUpload> documentList;

  DocumentUploadListLoaded({required this.documentList});
}

class DocumentUploadListError extends DocumentUploadState {
  final String message;

  DocumentUploadListError({required this.message});
}

class DocumentUploadSuccess extends DocumentUploadState {
  final String message;

  DocumentUploadSuccess({required this.message});
}

class DocumentUploadError extends DocumentUploadState {
  final String message;

  DocumentUploadError({required this.message});
}
