import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// ─── BLoC Events ─────────────────────────────────────────────
abstract class FileUploadEvent {}

class UploadPitchDeck extends FileUploadEvent {
  final File file;
  UploadPitchDeck(this.file);
}

class UploadImage extends FileUploadEvent {
  final File file;
  UploadImage(this.file);
}

class RemoveFile extends FileUploadEvent {
  final File file;
  RemoveFile(this.file);
}

// ─── BLoC State ─────────────────────────────────────────────
class FileUploadState {
  final List<File> pitchDecks;
  final List<File> images;
  final bool isSubmitting;

  FileUploadState({
    this.pitchDecks = const [],
    this.images = const [],
    this.isSubmitting = false,
  });

  FileUploadState copyWith({
    List<File>? pitchDecks,
    List<File>? images,
    bool? isSubmitting,
  }) {
    return FileUploadState(
      pitchDecks: pitchDecks ?? this.pitchDecks,
      images: images ?? this.images,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

// ─── BLoC Implementation ────────────────────────────────────
class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FileUploadBloc() : super(FileUploadState()) {
    on<UploadPitchDeck>((event, emit) {
      emit(state.copyWith(pitchDecks: [...state.pitchDecks, event.file]));
    });
    on<UploadImage>((event, emit) {
      emit(state.copyWith(images: [...state.images, event.file]));
    });
    on<RemoveFile>((event, emit) {
      emit(state.copyWith(
        pitchDecks: state.pitchDecks.where((file) => file != event.file).toList(),
        images: state.images.where((file) => file != event.file).toList(),
      ));
    });
  }
}

// ─── UI Implementation ───────────────────────────────────

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileUploadBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text('Upload Files',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              )
          ),
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add your files',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload your pitch deck and supporting images',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              _buildUploadSection(context, 'Pitch Deck', 'PDF, PPTX, or DOCX files', Icons.insert_drive_file, true),
              const SizedBox(height: 16),
              _buildUploadSection(context, 'Images', 'PNG, JPG, or JPEG files', Icons.image, false),
              const SizedBox(height: 24),
              const Text(
                'Uploaded Files',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildFileList(context),
            ],
          ),
        ),
        bottomNavigationBar: _buildCompleteButtonBar(context),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, String title, String subtitle, IconData icon, bool isPitchDeck) {
    return GestureDetector(
      onTap: () async {
        if (isSubmitting) return; // Prevent actions while submitting

        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: isPitchDeck ? FileType.custom : FileType.image,
          allowedExtensions: isPitchDeck ? ['pdf', 'pptx', 'docx'] : null,
        );
        if (result != null && result.files.single.path != null) {
          File file = File(result.files.single.path!);
          if (isPitchDeck) {
            context.read<FileUploadBloc>().add(UploadPitchDeck(file));
          } else {
            context.read<FileUploadBloc>().add(UploadImage(file));
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPitchDeck
                ? [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)]
                : [const Color(0xFF047857), const Color(0xFF065F46)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isPitchDeck ? Colors.blue.withOpacity(0.2) : Colors.green.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      )
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(BuildContext context) {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
      builder: (context, state) {
        List<File> allFiles = [...state.pitchDecks, ...state.images];

        if (allFiles.isEmpty) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    'No files uploaded yet',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap on the sections above to upload',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: allFiles.length,
            itemBuilder: (context, index) {
              File file = allFiles[index];
              String fileName = file.path.split('/').last;
              bool isPitchDeck = state.pitchDecks.contains(file);

              IconData fileIcon = Icons.image;
              Color iconColor = Colors.green;

              if (fileName.endsWith('.pdf')) {
                fileIcon = Icons.picture_as_pdf;
                iconColor = Colors.red;
              } else if (fileName.endsWith('.pptx')) {
                fileIcon = Icons.slideshow;
                iconColor = Colors.orange;
              } else if (fileName.endsWith('.docx')) {
                fileIcon = Icons.description;
                iconColor = Colors.blue;
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF333333)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(fileIcon, color: iconColor, size: 24),
                  ),
                  title: Text(
                    fileName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    isPitchDeck ? 'Pitch Deck' : 'Image',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () {
                      context.read<FileUploadBloc>().add(RemoveFile(file));
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompleteButtonBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSubmitting
                  ? Colors.grey[700]
                  : const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              elevation: isSubmitting ? 0 : 4,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isSubmitting
                ? null
                : () async {
              setState(() {
                isSubmitting = true;
              });

              await Future.delayed(const Duration(seconds: 2));

              if (mounted) {
                debugPrint("Navigating to CompleteSetupScreen...");
                Navigator.pushReplacementNamed(context, '/completeSetup');
              }
            },
            child: isSubmitting
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'PROCESSING',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            )
                : const Text(
              'COMPLETE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}