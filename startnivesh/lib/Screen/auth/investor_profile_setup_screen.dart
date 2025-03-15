import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// BLoC Events
abstract class InvestorProfileEvent {}

class UpdateInvestorInfo extends InvestorProfileEvent {
  final String name;
  final String email;
  final String company;
  UpdateInvestorInfo(this.name, this.email, this.company);
}

class UpdateInvestmentPreferences extends InvestorProfileEvent {
  final String sectors;
  final String stagePreference;
  final String investmentRange;
  UpdateInvestmentPreferences(this.sectors, this.stagePreference, this.investmentRange);
}

class UpdateExpectations extends InvestorProfileEvent {
  final String expectedReturns;
  final String investmentTimeline;
  final String exitStrategy;
  UpdateExpectations(this.expectedReturns, this.investmentTimeline, this.exitStrategy);
}

class SubmitInvestorProfile extends InvestorProfileEvent {
  final InvestorProfileState state;
  SubmitInvestorProfile(this.state);
}

// BLoC State
class InvestorProfileState {
  final String name;
  final String email;
  final String company;
  final String sectors;
  final String stagePreference;
  final String investmentRange;
  final String expectedReturns;
  final String investmentTimeline;
  final String exitStrategy;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  InvestorProfileState({
    this.name = '',
    this.email = '',
    this.company = '',
    this.sectors = '',
    this.stagePreference = '',
    this.investmentRange = '',
    this.expectedReturns = '',
    this.investmentTimeline = '',
    this.exitStrategy = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  InvestorProfileState copyWith({
    String? name,
    String? email,
    String? company,
    String? sectors,
    String? stagePreference,
    String? investmentRange,
    String? expectedReturns,
    String? investmentTimeline,
    String? exitStrategy,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return InvestorProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      company: company ?? this.company,
      sectors: sectors ?? this.sectors,
      stagePreference: stagePreference ?? this.stagePreference,
      investmentRange: investmentRange ?? this.investmentRange,
      expectedReturns: expectedReturns ?? this.expectedReturns,
      investmentTimeline: investmentTimeline ?? this.investmentTimeline,
      exitStrategy: exitStrategy ?? this.exitStrategy,
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
      'sectors': sectors,
      'stagePreference': stagePreference,
      'investmentRange': investmentRange,
      'expectedReturns': expectedReturns,
      'investmentTimeline': investmentTimeline,
      'exitStrategy': exitStrategy,
    };
  }
}

// BLoC Implementation
class InvestorProfileBloc extends Bloc<InvestorProfileEvent, InvestorProfileState> {
  InvestorProfileBloc() : super(InvestorProfileState()) {
    on<UpdateInvestorInfo>((event, emit) => emit(state.copyWith(
      name: event.name,
      email: event.email,
      company: event.company,
    )));

    on<UpdateInvestmentPreferences>((event, emit) => emit(state.copyWith(
      sectors: event.sectors,
      stagePreference: event.stagePreference,
      investmentRange: event.investmentRange,
    )));

    on<UpdateExpectations>((event, emit) => emit(state.copyWith(
      expectedReturns: event.expectedReturns,
      investmentTimeline: event.investmentTimeline,
      exitStrategy: event.exitStrategy,
    )));

    on<SubmitInvestorProfile>(_onSubmitProfile);
  }

  Future<void> _onSubmitProfile(
      SubmitInvestorProfile event, Emitter<InvestorProfileState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: '', isSuccess: false));

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5001/api/investor'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.state.toJson()),
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
class InvestorProfileScreen extends StatelessWidget {
  const InvestorProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvestorProfileBloc(),
      child: BlocConsumer<InvestorProfileBloc, InvestorProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to next screen or dashboard
            // Navigator.pushReplacementNamed(context, '/dashboard');
          }

          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Investor Profile',
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
                        'Complete Your Investor Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Help startups understand your investment preferences',
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
                              context.read<InvestorProfileBloc>().add(
                                  UpdateInvestorInfo(
                                      value, state.email, state.company));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Email Address',
                            state.email,
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateInvestorInfo(
                                      state.name, value, state.company));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Company / Firm',
                            state.company,
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateInvestorInfo(
                                      state.name, state.email, value));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Investment Preferences Section
                      _buildSection(
                        context,
                        'Investment Preferences',
                        'What types of startups' ,

                        Icons.trending_up,
                        [
                          _buildTextField(
                            context,
                            'Target Sectors',
                            state.sectors,
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateInvestmentPreferences(
                                      value,
                                      state.stagePreference,
                                      state.investmentRange));
                            },
                            hint: 'E.g., Fintech, Healthcare, AI, SaaS',
                          ),
                          _buildDropdown(
                            context,
                            'Preferred Stage',
                            state.stagePreference,
                            [
                              'Pre-seed',
                              'Seed',
                              'Series A',
                              'Series B',
                              'Series C+',
                              'Any stage'
                            ],
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateInvestmentPreferences(state.sectors,
                                      value ?? '', state.investmentRange));
                            },
                          ),
                          _buildDropdown(
                            context,
                            'Investment Range',
                            state.investmentRange,
                            [
                              '\$25K - \$100K',
                              '\$100K - \$500K',
                              '\$500K - \$1M',
                              '\$1M - \$5M',
                              '\$5M+',
                              'Varies by opportunity'
                            ],
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateInvestmentPreferences(state.sectors,
                                      state.stagePreference, value ?? ''));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Investment Expectations Section
                      _buildSection(
                        context,
                        'Investment Expectations',
                        'Share your investment approach',
                        Icons.assessment,
                        [
                          _buildDropdown(
                            context,
                            'Expected Returns',
                            state.expectedReturns,
                            [
                              '3-5x investment',
                              '5-10x investment',
                              '10x+ investment',
                              'Depends on the opportunity'
                            ],
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateExpectations(
                                      value ?? '',
                                      state.investmentTimeline,
                                      state.exitStrategy));
                            },
                          ),
                          _buildDropdown(
                            context,
                            'Investment Timeline',
                            state.investmentTimeline,
                            [
                              '1-3 years',
                              '3-5 years',
                              '5-7 years',
                              '7+ years',
                              'Flexible'
                            ],
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateExpectations(state.expectedReturns,
                                      value ?? '', state.exitStrategy));
                            },
                          ),
                          _buildTextField(
                            context,
                            'Preferred Exit Strategy',
                            state.exitStrategy,
                                (value) {
                              context.read<InvestorProfileBloc>().add(
                                  UpdateExpectations(state.expectedReturns,
                                      state.investmentTimeline, value));
                            },
                            maxLines: 3,
                            hint: 'E.g., IPO, acquisition, strategic partnership',
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

  Widget _buildSection(BuildContext context, String title, String subtitle, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.green.shade700, size: 24),
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
                      color: Colors.white
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

  Widget _buildTextField(
      BuildContext context,
      String label,
      String value,
      Function(String) onChanged, {
        int maxLines = 1,
        String hint = '',
      }) {
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
        style: const TextStyle(color: Colors.black87),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint.isNotEmpty ? hint : 'Enter $label',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.grey.shade50,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400, width: 2),
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
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.isNotEmpty ? value : null,
                hint: Text('Select $label', style: TextStyle(color: Colors.grey.shade400)),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
                style: const TextStyle(color: Colors.black87, fontSize: 16),
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

  Widget _buildSubmitButton(BuildContext context, InvestorProfileState state) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 2,
          minimumSize: const Size(200, 56),
        ),
        onPressed: () {
          if (state.name.isEmpty || state.email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill in required fields'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          context.read<InvestorProfileBloc>().add(SubmitInvestorProfile(state));
        },
        child: state.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
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