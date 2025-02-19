import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class StartupProfileSetupScreen extends StatefulWidget {
  const StartupProfileSetupScreen({super.key});

  @override
  State<StartupProfileSetupScreen> createState() => _StartupProfileSetupScreenState();
}

class _StartupProfileSetupScreenState extends State<StartupProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _industryController = TextEditingController();
  final _startupDetailsController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Startup Profile Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _nameController,
                  label: 'Startup Name',
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter startup name' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio',
                  maxLines: 3,
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter bio' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _industryController,
                  label: 'Industry',
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter industry' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _startupDetailsController,
                  label: 'Startup Details',
                  maxLines: 4,
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter startup details' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Save profile data
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Complete Setup',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}