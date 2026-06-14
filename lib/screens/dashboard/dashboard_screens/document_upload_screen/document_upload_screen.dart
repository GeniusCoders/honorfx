import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/constant/base_url.dart';
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
  String? _poaPath;

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
            case 'poa':
              _poaPath = file.path;
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
    if (_poaPath != null && !_hasExistingDocument('poa')) {
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
      poiBack: null, // Not using back variants for honorfx
      poa: !_hasExistingDocument('poa') ? _poaPath : null,
      poaBack: null, // Not using back variants for honorfx
    );

    context.read<DocumentUploadCubit>().uploadDocuments(model);
  }

  DocumentUpload? _getExistingDocument(String documentType) {
    try {
      // Map the document types to match API response
      String apiDocumentType = documentType;

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
              _poaPath = null;
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
        SizedBox(height: 8.h),
        Text(
          'Please upload the required documents for verification',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        SizedBox(height: 24.h),

        // POI
        _buildDocumentUploadCard(
          title: 'Proof of Identity (POI)',
          documentType: 'poi',
          selectedPath: _poiPath,
          isApproved: _isDocumentApproved('poi'),
          isPending: _isDocumentPending('poi'),
          hasExisting: _hasExistingDocument('poi'),
          existingDocument: _getExistingDocument('poi'),
        ),
        SizedBox(height: 16.h),

        // POA
        _buildDocumentUploadCard(
          title: 'Proof of Address (POA)',
          documentType: 'poa',
          selectedPath: _poaPath,
          isApproved: _isDocumentApproved('poa'),
          isPending: _isDocumentPending('poa'),
          hasExisting: _hasExistingDocument('poa'),
          existingDocument: _getExistingDocument('poa'),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadCard({
    required String title,
    required String documentType,
    required String? selectedPath,
    required bool isApproved,
    required bool isPending,
    required bool hasExisting,
    required DocumentUpload? existingDocument,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              isApproved
                  ? Colors.green.withOpacity(0.3)
                  : isPending
                  ? Colors.orange.withOpacity(0.3)
                  : AppColors.grey.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              if (isApproved)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Approved',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else if (isPending)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),

          if (hasExisting && existingDocument?.filePath != null)
            // Show existing document (approved or pending)
            _buildExistingDocumentView(existingDocument!, isPending: isPending)
          else
            // Show upload area
            _buildUploadArea(
              documentType,
              selectedPath,
              isDisabled: hasExisting,
            ),

          SizedBox(height: 12.h),
          Text(
            'Supported formats: JPEG, JPG, PNG, PDF.',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingDocumentView(
    DocumentUpload document, {
    bool isPending = false,
  }) {
    final imageUrl = '${BaseUrl.domain}/${document.filePath}';
    print(imageUrl);

    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color:
              isPending
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.green.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          },
          errorBuilder:
              (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description,
                      size: 32.sp,
                      color: isPending ? Colors.orange : Colors.green,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isPending ? 'Document Pending' : 'Document Uploaded',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isPending ? Colors.orange : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildUploadArea(
    String documentType,
    String? selectedPath, {
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : () => _selectFile(documentType),
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade200 : AppColors.greyBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child:
            selectedPath != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    selectedPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 32.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'File Selected',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 24.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Drag & drop files or Browse',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildUploadButton() {
    bool allDocumentsUploaded =
        _hasExistingDocument('poi') && _hasExistingDocument('poa');
    if (!allDocumentsUploaded) {
      return Button(
        title: 'UPLOAD FILES',

        onPressed: allDocumentsUploaded ? () {} : _uploadDocuments,
        backgroundColor: AppColors.secondary,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
