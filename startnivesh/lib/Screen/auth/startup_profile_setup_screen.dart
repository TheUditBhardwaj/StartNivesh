import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// API Service
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

// BLoC Events
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

// BLoC State
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

// BLoC Implementation
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

// UI Implementation
class StartupProfileSetupScreen extends StatelessWidget {
  const StartupProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Startup Profile Setup'),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state.isSubmitted) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pushNamed(context, '/applicationForm');
                      context.read<ProfileBloc>().emit(state.copyWith(isSubmitted: false));
                    });
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.business,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTextField(context, 'Startup Name', state.name, (value) => context.read<ProfileBloc>().add(UpdateName(value)), required: true),
                        const SizedBox(height: 20),
                        _buildTextField(context, 'Bio', state.bio, (value) => context.read<ProfileBloc>().add(UpdateBio(value)), maxLines: 3),
                        const SizedBox(height: 20),
                        _buildTextField(context, 'Industry', state.industry, (value) => context.read<ProfileBloc>().add(UpdateIndustry(value))),
                        const SizedBox(height: 20),
                        _buildTextField(context, 'Startup Details', state.details, (value) => context.read<ProfileBloc>().add(UpdateDetails(value)), maxLines: 4),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.isLoading ? null : () => context.read<ProfileBloc>().add(SubmitProfile()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state.isLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black))
                                : const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, String value, Function(String) onChanged, {int maxLines = 1, bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}