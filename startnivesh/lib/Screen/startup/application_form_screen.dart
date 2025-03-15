import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'file_upload_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StartupApiService {
  final String baseUrl = 'http://127.0.0.1:5001/api';

  // Submit the application form data
  Future<Map<String, dynamic>> submitApplication(ApplicationFormData data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/startups'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit application: ${response.statusCode}, ${response.body}');
    }
  }

  // Get all startups
  Future<List<dynamic>> getStartups() async {
    final response = await http.get(Uri.parse('$baseUrl/startups'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load startups: ${response.statusCode}');
    }
  }

  // Get a specific startup by ID
  Future<Map<String, dynamic>> getStartupById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/startups/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load startup: ${response.statusCode}');
    }
  }

  // Update a startup application
  Future<Map<String, dynamic>> updateApplication(String id, ApplicationFormData data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/startups/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update application: ${response.statusCode}');
    }
  }

  // Delete a startup application
  Future<void> deleteApplication(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/startups/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete application: ${response.statusCode}');
    }
  }
}

// Model class to represent form data
class ApplicationFormData {
  final String name;
  final String email;
  final String revenueModel;
  final String keyPartners;
  final String targetMarket;
  final String competitors;
  final List<String>? fileUrls; // Optional field for file uploads

  ApplicationFormData({
    required this.name,
    required this.email,
    required this.revenueModel,
    required this.keyPartners,
    required this.targetMarket,
    required this.competitors,
    this.fileUrls,
  });

  // Convert ApplicationFormState to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'revenueModel': revenueModel,
      'keyPartners': keyPartners,
      'targetMarket': targetMarket,
      'competitors': competitors,
      if (fileUrls != null) 'fileUrls': fileUrls,
    };
  }

  // Create ApplicationFormData from ApplicationFormState
  factory ApplicationFormData.fromFormState(ApplicationFormState state, {List<String>? fileUrls}) {
    return ApplicationFormData(
      name: state.name,
      email: state.email,
      revenueModel: state.revenueModel,
      keyPartners: state.keyPartners,
      targetMarket: state.targetMarket,
      competitors: state.competitors,
      fileUrls: fileUrls,
    );
  }
}

// BLoC Events
abstract class ApplicationFormEvent {}
class UpdateBasicInfo extends ApplicationFormEvent {
  final String name;
  final String email;
  UpdateBasicInfo(this.name, this.email);
}
class UpdateBusinessModel extends ApplicationFormEvent {
  final String revenueModel;
  final String keyPartners;
  UpdateBusinessModel(this.revenueModel, this.keyPartners);
}
class UpdateMarketInfo extends ApplicationFormEvent {
  final String targetMarket;
  final String competitors;
  UpdateMarketInfo(this.targetMarket, this.competitors);
}

// BLoC State
class ApplicationFormState {
  final String name;
  final String email;
  final String revenueModel;
  final String keyPartners;
  final String targetMarket;
  final String competitors;

  ApplicationFormState({
    this.name = '',
    this.email = '',
    this.revenueModel = '',
    this.keyPartners = '',
    this.targetMarket = '',
    this.competitors = '',
  });

  ApplicationFormState copyWith({
    String? name,
    String? email,
    String? revenueModel,
    String? keyPartners,
    String? targetMarket,
    String? competitors,
  }) {
    return ApplicationFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      revenueModel: revenueModel ?? this.revenueModel,
      keyPartners: keyPartners ?? this.keyPartners,
      targetMarket: targetMarket ?? this.targetMarket,
      competitors: competitors ?? this.competitors,
    );
  }
}

// BLoC Implementation
class ApplicationFormBloc extends Bloc<ApplicationFormEvent, ApplicationFormState> {
  ApplicationFormBloc() : super(ApplicationFormState()) {
    on<UpdateBasicInfo>((event, emit) =>
        emit(state.copyWith(name: event.name, email: event.email)));
    on<UpdateBusinessModel>((event, emit) =>
        emit(state.copyWith(revenueModel: event.revenueModel, keyPartners: event.keyPartners)));
    on<UpdateMarketInfo>((event, emit) =>
        emit(state.copyWith(targetMarket: event.targetMarket, competitors: event.competitors)));
  }
}

//UI Implementation UI Implementation
class ApplicationFormScreen extends StatelessWidget {
  const ApplicationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplicationFormBloc(),
      child: Scaffold(
        backgroundColor: Colors.black, // ⬅️ Changed to black
        appBar: AppBar(
          title: const Text('Startup Application',
              style: TextStyle(
                color: Colors.white, // ⬅️ Changed to white for better contrast
                fontWeight: FontWeight.bold,
                fontSize: 22,
              )),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white), // ⬅️ Icon color updated
        ),
        body: BlocBuilder<ApplicationFormBloc, ApplicationFormState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tell us about your startup',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // ⬅️ Changed text color to white
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please complete all sections to proceed to the next step',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey, // ⬅️ Adjusted for better readability
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSection(
                      context,
                      'Founder Information',
                      'Let\'s start with the basics',
                      Icons.person,
                      [
                        _buildTextField(context, 'Full Name', state.name, (value) {
                          context.read<ApplicationFormBloc>().add(UpdateBasicInfo(value, state.email));
                        }),
                        _buildTextField(context, 'Email Address', state.email, (value) {
                          context.read<ApplicationFormBloc>().add(UpdateBasicInfo(state.name, value));
                        }),
                      ]
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                      context,
                      'Business Model',
                      'How does your startup make money?',
                      Icons.business,
                      [
                        _buildTextField(context, 'Revenue Model', state.revenueModel, (value) {
                          context.read<ApplicationFormBloc>().add(UpdateBusinessModel(value, state.keyPartners));
                        }, maxLines: 3),
                        _buildTextField(context, 'Key Partners & Stakeholders', state.keyPartners, (value) {
                          context.read<ApplicationFormBloc>().add(UpdateBusinessModel(state.revenueModel, value));
                        }, maxLines: 3),
                      ]
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                      context,
                      'Market Analysis',
                      'Tell us about your market opportunity',
                      Icons.assessment,
                      [
                        _buildTextField(context, 'Target Market & Audience', state.targetMarket, (value) {
                          context.read<ApplicationFormBloc>().add(UpdateMarketInfo(value, state.competitors));
                        }, maxLines: 3),
                        _buildTextField(context, 'Competitors & Alternatives', state.competitors, (value) {
                          context.read<ApplicationFormBloc>().add(UpdateMarketInfo(state.targetMarket, value));
                        }, maxLines: 3),
                      ]
                  ),
                  const SizedBox(height: 30),
                  _buildNextButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Updated _buildSection to match dark mode
  Widget _buildSection(BuildContext context, String title, String subtitle, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900], // ⬅️ Dark background for sections
        borderRadius: BorderRadius.circular(16),
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
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
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
                          color: Colors.white // ⬅️ Adjusted text color
                      )
                  ),
                  Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500
                      )
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

  // Updated text fields for dark mode
  Widget _buildTextField(
      BuildContext context,
      String label,
      String value,
      Function(String) onChanged,
      {int maxLines = 1}
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
              color: Colors.white, // ⬅️ Adjusted text color
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            style: const TextStyle(color: Colors.white), // ⬅️ Text color updated
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.grey.shade800, // ⬅️ Darker field background
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Next button remains unchanged
  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 2,
          minimumSize: const Size(200, 56),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/fileUpload');
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Continue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}