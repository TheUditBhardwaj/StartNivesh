import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// BLoC Events
abstract class MentorProfileEvent {}

class UpdateMentorInfo extends MentorProfileEvent {
  final String name;
  final String email;
  final String company;
  final String position;
  UpdateMentorInfo(this.name, this.email, this.company, this.position);
}

class UpdateExpertise extends MentorProfileEvent {
  final String expertise;
  final String industries;
  final String yearsOfExperience;
  UpdateExpertise(this.expertise, this.industries, this.yearsOfExperience);
}

class UpdateMentoringPreferences extends MentorProfileEvent {
  final String availabilityHours;
  final String mentorshipStyle;
  final String expectationsFromStartups;
  UpdateMentoringPreferences(
      this.availabilityHours, this.mentorshipStyle, this.expectationsFromStartups);
}

class SubmitMentorProfile extends MentorProfileEvent {
  SubmitMentorProfile();
}

// BLoC State
class MentorProfileState {
  final String name;
  final String email;
  final String company;
  final String position;
  final String expertise;
  final String industries;
  final String yearsOfExperience;
  final String availabilityHours;
  final String mentorshipStyle;
  final String expectationsFromStartups;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  MentorProfileState({
    this.name = '',
    this.email = '',
    this.company = '',
    this.position = '',
    this.expertise = '',
    this.industries = '',
    this.yearsOfExperience = '',
    this.availabilityHours = '',
    this.mentorshipStyle = '',
    this.expectationsFromStartups = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  MentorProfileState copyWith({
    String? name,
    String? email,
    String? company,
    String? position,
    String? expertise,
    String? industries,
    String? yearsOfExperience,
    String? availabilityHours,
    String? mentorshipStyle,
    String? expectationsFromStartups,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return MentorProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      company: company ?? this.company,
      position: position ?? this.position,
      expertise: expertise ?? this.expertise,
      industries: industries ?? this.industries,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      availabilityHours: availabilityHours ?? this.availabilityHours,
      mentorshipStyle: mentorshipStyle ?? this.mentorshipStyle,
      expectationsFromStartups:
      expectationsFromStartups ?? this.expectationsFromStartups,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'company': company,
      'position': position,
      'expertise': expertise,
      'industries': industries,
      'yearsOfExperience': yearsOfExperience,
      'availabilityHours': availabilityHours,
      'mentorshipStyle': mentorshipStyle,
      'expectationsFromStartups': expectationsFromStartups,
    };
  }
}

// BLoC Implementation
class MentorProfileBloc extends Bloc<MentorProfileEvent, MentorProfileState> {
  MentorProfileBloc() : super(MentorProfileState()) {
    on<UpdateMentorInfo>((event, emit) => emit(state.copyWith(
      name: event.name,
      email: event.email,
      company: event.company,
      position: event.position,
    )));

    on<UpdateExpertise>((event, emit) => emit(state.copyWith(
      expertise: event.expertise,
      industries: event.industries,
      yearsOfExperience: event.yearsOfExperience,
    )));

    on<UpdateMentoringPreferences>((event, emit) => emit(state.copyWith(
      availabilityHours: event.availabilityHours,
      mentorshipStyle: event.mentorshipStyle,
      expectationsFromStartups: event.expectationsFromStartups,
    )));

    on<SubmitMentorProfile>(_onSubmitProfile);
  }

  Future<void> _onSubmitProfile(
      SubmitMentorProfile event, Emitter<MentorProfileState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: '', isSuccess: false));

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5001/api/mentor'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(state.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to submit profile';
        emit(state.copyWith(
            isSubmitting: false, errorMessage: errorMessage, isSuccess: false));
      }
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Network error: ${e.toString()}',
          isSuccess: false));
    }
  }
}

// UI Implementation
class MentorProfileScreen extends StatelessWidget {
  const MentorProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorProfileBloc(),
      child: BlocBuilder<MentorProfileBloc, MentorProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Mentor Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              backgroundColor: Colors.black,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complete Your Mentor Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Share your expertise and help guide startups to success',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Personal Information Section
                      _buildSection(
                        context,
                        'Personal Information',
                        'Tell us about yourself',
                        Icons.person,
                        [
                          _buildTextField(
                            context,
                            'Full Name',
                            state.name,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentorInfo(value, state.email,
                                      state.company, state.position));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Email Address',
                            state.email,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentorInfo(state.name, value,
                                      state.company, state.position));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Company / Organization',
                            state.company,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentorInfo(state.name, state.email,
                                      value, state.position));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Position / Role',
                            state.position,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentorInfo(state.name, state.email,
                                      state.company, value));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Expertise Section
                      _buildSection(
                        context,
                        'Areas of Expertise',
                        'What are your strongest skills',
                        Icons.lightbulb,
                        [
                          _buildTextField(
                            context,
                            'Primary Expertise',
                            state.expertise,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateExpertise(value, state.industries,
                                      state.yearsOfExperience));
                            },
                            hint: 'E.g., Product Management, Marketing, Engineering',
                          ),
                          _buildTextField(
                            context,
                            'Industry Experience',
                            state.industries,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateExpertise(state.expertise, value,
                                      state.yearsOfExperience));
                            },
                            hint: 'E.g., Fintech, Healthcare, E-commerce',
                          ),
                          _buildDropdown(
                            context,
                            'Years of Experience',
                            state.yearsOfExperience,
                            [
                              '1-3 years',
                              '3-5 years',
                              '5-10 years',
                              '10-15 years',
                              '15+ years'
                            ],
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateExpertise(state.expertise,
                                      state.industries, value ?? ''));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Mentoring Preferences Section
                      _buildSection(
                        context,
                        'Mentoring Preferences',
                        'How you prefer to mentor startups',
                        Icons.groups,
                        [
                          _buildDropdown(
                            context,
                            'Weekly Availability',
                            state.availabilityHours,
                            [
                              '1-2 hours',
                              '3-5 hours',
                              '5-10 hours',
                              'Flexible'
                            ],
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentoringPreferences(
                                      value ?? '',
                                      state.mentorshipStyle,
                                      state.expectationsFromStartups));
                            },
                          ),
                          _buildDropdown(
                            context,
                            'Mentorship Style',
                            state.mentorshipStyle,
                            [
                              'Hands-on coaching',
                              'Advisory role',
                              'Subject matter expert',
                              'Networking facilitator',
                              'Balanced approach'
                            ],
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentoringPreferences(
                                      state.availabilityHours,
                                      value ?? '',
                                      state.expectationsFromStartups));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Expectations from Startups',
                            state.expectationsFromStartups,
                                (value) {
                              context.read<MentorProfileBloc>().add(
                                  UpdateMentoringPreferences(
                                      state.availabilityHours,
                                      state.mentorshipStyle,
                                      value));
                            },
                            maxLines: 3,
                            hint:
                            'E.g., Clear goals, openness to feedback, prepared meetings',
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildSubmitButton(context, state),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                if (state.isSubmitting)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String subtitle,
      IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.indigo.shade400, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, String value,
      Function(String) onChanged,
      {int maxLines = 1, String hint = ''}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: value,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint.isNotEmpty ? hint : 'Enter $label',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade800,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: onChanged,
      ),
    ],
    ),
    );
  }

  Widget _buildDropdown(
      BuildContext context,
      String label,
      String value,
      List<String> options,
      Function(String?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.isNotEmpty ? value : null,
                hint: Text('Select $label', style: TextStyle(color: Colors.grey.shade600)),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                dropdownColor: Colors.grey.shade800,
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, MentorProfileState state) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 2,
          minimumSize: const Size(200, 56),
        ),
        onPressed: state.isSubmitting ? null : () {
          // Direct navigation to completeSetup screen without waiting for submission
          Navigator.pushNamed(context, '/completeSetup');

          // Optionally submit data in background if needed
          context.read<MentorProfileBloc>().add(SubmitMentorProfile());
        },
        child: state.isSubmitting
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Submit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.check_circle_outline, size: 20),
          ],
        ),
      ),
    );
  }
}