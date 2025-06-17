import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:honorfx/cubit/document_upload/document_upload_cubit.dart';
import 'package:honorfx/cubit/document_upload/document_upload_state.dart';
import 'package:honorfx/models/dashboard/document_upload_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/buttons/button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({Key? key}) : super(key: key);

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();

  String? _poiPath;
  String? _poiBackPath;
  String? _poaPath;
  String? _poaBackPath;

  List<DocumentUpload> _existingDocuments = [];

  @override
  void initState() {
    super.initState();
    context.read<DocumentUploadCubit>().getDocumentUploadList();
  }

  Future<void> _selectFile(String documentType) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          switch (documentType) {
            case 'poi':
              _poiPath = file.path;
              break;
            case 'poi_back':
              _poiBackPath = file.path;
              break;
            case 'poa':
              _poaPath = file.path;
              break;
            case 'poa_back':
              _poaBackPath = file.path;
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(message: 'Error selecting file', isError: true),
      );
    }
  }

  void _uploadDocuments() {
    // Check if at least one document is selected and not already uploaded
    bool hasNewDocuments = false;

    if (_poiPath != null && !_hasExistingDocument('poi')) {
      hasNewDocuments = true;
    }
    if (_poiBackPath != null && !_hasExistingDocument('poi_back')) {
      hasNewDocuments = true;
    }
    if (_poaPath != null && !_hasExistingDocument('poa')) {
      hasNewDocuments = true;
    }
    if (_poaBackPath != null && !_hasExistingDocument('poa_back')) {
      hasNewDocuments = true;
    }

    if (!hasNewDocuments) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(
          message: 'Please select at least one new document to upload',
          isError: true,
        ),
      );
      return;
    }

    final model = UploadDocumentModel(
      poi: !_hasExistingDocument('poi') ? _poiPath : null,
      poiBack: !_hasExistingDocument('poi_back') ? _poiBackPath : null,
      poa: !_hasExistingDocument('poa') ? _poaPath : null,
      poaBack: !_hasExistingDocument('poa_back') ? _poaBackPath : null,
    );

    context.read<DocumentUploadCubit>().uploadDocuments(model);
  }

  DocumentUpload? _getExistingDocument(String documentType) {
    try {
      // Map the document types to match API response
      String apiDocumentType = documentType;
      if (documentType == 'poi_back') {
        apiDocumentType = 'poiback';
      } else if (documentType == 'poa_back') {
        apiDocumentType = 'poaback';
      }

      return _existingDocuments.firstWhere(
        (doc) =>
            doc.documentType.toLowerCase() == apiDocumentType.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  bool _isDocumentApproved(String documentType) {
    final doc = _getExistingDocument(documentType);
    return doc?.isApproved ?? false;
  }

  bool _isDocumentPending(String documentType) {
    final doc = _getExistingDocument(documentType);
    return doc?.status == '0';
  }

  bool _hasExistingDocument(String documentType) {
    return _getExistingDocument(documentType) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Document Upload'),
      body: BlocListener<DocumentUploadCubit, DocumentUploadState>(
        listener: (context, state) {
          if (state is DocumentUploadSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(buildSnackBar(message: state.message));
            // Clear selected files after successful upload
            setState(() {
              _poiPath = null;
              _poiBackPath = null;
              _poaPath = null;
              _poaBackPath = null;
            });
          } else if (state is DocumentUploadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(message: state.message, isError: true),
            );
          } else if (state is DocumentUploadListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(message: state.message, isError: true),
            );
          } else if (state is DocumentUploadListLoaded) {
            setState(() {
              _existingDocuments = state.documentList;
            });
          }
        },
        child: BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is DocumentUploadLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDocumentUploadSection(),
                    SizedBox(height: 32.h),
                    _buildUploadButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Upload',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 24.h),
        _buildDocumentUploadCard('Proof of Identity (Front)', 'poi', _poiPath),
        SizedBox(height: 16.h),
        _buildDocumentUploadCard(
          'Proof of Identity (Back)',
          'poi_back',
          _poiBackPath,
        ),
        SizedBox(height: 16.h),
        _buildDocumentUploadCard('Proof of Address (Front)', 'poa', _poaPath),
        SizedBox(height: 16.h),
        _buildDocumentUploadCard(
          'Proof of Address (Back)',
          'poa_back',
          _poaBackPath,
        ),
      ],
    );
  }

  Widget _buildDocumentUploadCard(
    String title,
    String documentType,
    String? selectedFile,
  ) {
    final isApproved = _isDocumentApproved(documentType);
    final isPending = _isDocumentPending(documentType);
    final hasDocument = _hasExistingDocument(documentType);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              if (hasDocument)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isApproved
                            ? Colors.green.withOpacity(0.1)
                            : isPending
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    isApproved
                        ? 'Approved'
                        : isPending
                        ? 'Pending'
                        : 'Rejected',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          isApproved
                              ? Colors.green
                              : isPending
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          if (!hasDocument)
            Button(
              title: selectedFile != null ? 'File Selected' : 'Select Document',
              onPressed: () {
                if (selectedFile == null) {
                  _selectFile(documentType);
                }
              },
              backgroundColor:
                  selectedFile != null ? AppColors.grey : AppColors.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Button(
      title: 'Upload Documents',
      onPressed: _uploadDocuments,
      backgroundColor: AppColors.primary,
    );
  }
}
