import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// API Service remains the same
class StartupApiService {
  final String baseUrl = 'http://127.0.0.1:5001/api/startups';

  Future<Map<String, dynamic>> submitProfile({
    required String name,
    required String bio,
    required String industry,
    required String details,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'bio': bio,
          'industry': industry,
          'details': details,
        }),
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final decodedData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': decodedData};
      } else {
        return {'success': false, 'message': decodedData['message'] ?? 'Failed to submit profile'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}

// BLoC Events, State, and Implementation remain the same
abstract class ProfileEvent {}

class UpdateName extends ProfileEvent {
  final String name;
  UpdateName(this.name);
}

class UpdateBio extends ProfileEvent {
  final String bio;
  UpdateBio(this.bio);
}

class UpdateIndustry extends ProfileEvent {
  final String industry;
  UpdateIndustry(this.industry);
}

class UpdateDetails extends ProfileEvent {
  final String details;
  UpdateDetails(this.details);
}

class SubmitProfile extends ProfileEvent {}

class ProfileState {
  final String name;
  final String bio;
  final String industry;
  final String details;
  final bool isLoading;
  final String? errorMessage;
  final bool isSubmitted;

  const ProfileState({
    this.name = '',
    this.bio = '',
    this.industry = '',
    this.details = '',
    this.isLoading = false,
    this.errorMessage,
    this.isSubmitted = false,
  });

  ProfileState copyWith({
    String? name,
    String? bio,
    String? industry,
    String? details,
    bool? isLoading,
    Object? errorMessage = const Object(),
    bool? isSubmitted,
  }) {
    return ProfileState(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      industry: industry ?? this.industry,
      details: details ?? this.details,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != const Object() ? errorMessage as String? : this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StartupApiService _apiService = StartupApiService();

  ProfileBloc() : super(const ProfileState()) {
    on<UpdateName>((event, emit) => emit(state.copyWith(name: event.name)));
    on<UpdateBio>((event, emit) => emit(state.copyWith(bio: event.bio)));
    on<UpdateIndustry>((event, emit) => emit(state.copyWith(industry: event.industry)));
    on<UpdateDetails>((event, emit) => emit(state.copyWith(details: event.details)));

    on<SubmitProfile>((event, emit) async {
      if (state.name.isEmpty) {
        emit(state.copyWith(errorMessage: 'Startup name is required', isSubmitted: false));
        return;
      }

      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        final result = await _apiService.submitProfile(
          name: state.name,
          bio: state.bio,
          industry: state.industry,
          details: state.details,
        );

        if (result['success']) {
          emit(state.copyWith(isLoading: false, isSubmitted: true, errorMessage: null));
        } else {
          emit(state.copyWith(isLoading: false, isSubmitted: false, errorMessage: result['message']));
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, isSubmitted: false, errorMessage: 'Failed to submit profile: ${e.toString()}'));
      }
    });
  }
}

// Improved UI Implementation with Gray Theme
class StartupProfileSetupScreen extends StatelessWidget {
  const StartupProfileSetupScreen({super.key});

  // Color constants
  static const Color primaryGray = Color(0xFFE0E0E0);
  static const Color accentGray = Color(0xFFBDBDBD);
  static const Color darkGray = Color(0xFF424242);
  static const Color lightGray = Color(0xFF757575);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color cardColor = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'STARTUP PROFILE',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 1.2,
              color: primaryGray,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state.isSubmitted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile setup completed successfully!'),
                      backgroundColor: Colors.black,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushNamed(context, '/applicationForm');
                    context.read<ProfileBloc>().emit(state.copyWith(isSubmitted: false));
                  });
                }

                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.redAccent.withOpacity(0.7),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.rocket_launch_outlined,
                              size: 40,
                              color: accentGray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: darkGray, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Profile Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGray,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tell us about your startup to help us understand your needs',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildTextField(
                                  context,
                                  'Startup Name',
                                  state.name,
                                  Icons.corporate_fare,
                                      (value) => context.read<ProfileBloc>().add(UpdateName(value)),
                                  required: true
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                  context,
                                  'Bio',
                                  state.bio,
                                  Icons.description_outlined,
                                      (value) => context.read<ProfileBloc>().add(UpdateBio(value)),
                                  maxLines: 3,
                                  hint: 'Brief description of your company'
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                  context,
                                  'Industry',
                                  state.industry,
                                  Icons.category_outlined,
                                      (value) => context.read<ProfileBloc>().add(UpdateIndustry(value)),
                                  hint: 'e.g., Fintech, Health, Education'
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                  context,
                                  'Company Details',
                                  state.details,
                                  Icons.article_outlined,
                                      (value) => context.read<ProfileBloc>().add(UpdateDetails(value)),
                                  maxLines: 4,
                                  hint: 'More details about your product and vision'
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: state.isLoading ? null : () => context.read<ProfileBloc>().add(SubmitProfile()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentGray,
                              foregroundColor: Colors.black,
                              disabledBackgroundColor: accentGray.withOpacity(0.4),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state.isLoading
                                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
                                : const Text(
                              'SUBMIT PROFILE',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Function(String) onChanged,
      {int maxLines = 1, bool required = false, String? hint}
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: accentGray),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: primaryGray,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          style: const TextStyle(color: primaryGray),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: lightGray.withOpacity(0.6)),
            filled: true,
            fillColor: backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: darkGray, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: darkGray, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentGray, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}