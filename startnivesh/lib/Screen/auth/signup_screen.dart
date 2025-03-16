// import 'package:flutter/material.dart';
// import 'database_service.dart';
// import 'package:startnivesh/main.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   bool _isLoading = false;
//   late DatabaseService _dbService;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeDatabase();
//   }
//
//   Future<void> _initializeDatabase() async {
//     _dbService = await DatabaseService.getInstance();
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleSignup() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         // Check if email already exists
//         final emailExists = await _dbService.emailExists(_emailController.text.trim());
//         if (emailExists) {
//           throw 'Email already registered';
//         }
//
//         // Create new user
//         final user = await _dbService.createUser(
//           _emailController.text.trim(),
//           _passwordController.text,
//           _nameController.text.trim(),
//         );
//
//         if (mounted) {
//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Account created successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//
//           // Navigate to login screen
//           Navigator.pushReplacementNamed(context, '/login');
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(e.toString()),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 40),
//                 TextFormField(
//                   controller: _nameController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Full Name',
//                     labelStyle: const TextStyle(color: Colors.white70),
//                     prefixIcon: const Icon(Icons.person, color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white70),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: const TextStyle(color: Colors.white70),
//                     prefixIcon: const Icon(Icons.email, color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white70),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: const TextStyle(color: Colors.white70),
//                     prefixIcon: const Icon(Icons.lock, color: Colors.white70),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.white70,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white70),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: !_isConfirmPasswordVisible,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Confirm Password',
//                     labelStyle: const TextStyle(color: Colors.white70),
//                     prefixIcon: const Icon(Icons.lock, color: Colors.white70),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.white70,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white70),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _handleSignup,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//                     ),
//                   )
//                       : const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already have an account? ",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/login');
//                       },
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'database_service.dart';
import 'package:startnivesh/main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  late DatabaseService _dbService;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _dbService = await DatabaseService.getInstance();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_agreeToTerms) {
      _showSnackbar('Please accept the Terms and Conditions to continue');
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if email already exists
        final emailExists = await _dbService.emailExists(_emailController.text.trim());
        if (emailExists) {
          throw 'Email already registered';
        }

        // Create new user
        final user = await _dbService.createUser(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          );

          // Navigate to login screen
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        _showSnackbar(e.toString());
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              height: 6,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: const [
                  _TermsSection(
                    title: '1. GENERAL DETAILS',
                    content: 'This software license agreement ("Agreement") is a binding contract between StartNivesh ("Licensor") and the user ("Licensee"). By using StartNivesh software, the Licensee agrees to comply with the terms and conditions outlined in this Agreement. The Agreement takes effect upon first installation or use of the software and remains valid until terminated by either party according to the terms specified in this Agreement.',
                  ),
                  _TermsSection(
                    title: '2. TERMS AND CONDITIONS',
                    content: 'You accept these conditions by using the software. Any offences could lead to legal action. This Agreement may be changed at any moment by StartNivesh. This agreement is between StartNivesh (Licensor) and the Licensee, which may be an individual or a business. It is important to mention the licensee\'s full legal name, address, and phone number. If the Licensee is a business, a designated representative must accept this agreement.',
                  ),
                  _TermsSection(
                    title: '3. TERMS OF THE AGREEMENT',
                    subsections: [
                      _TermsSubsection(
                        title: '3.1 Terms of License',
                        content: 'A non-exclusive, non-transferable, and renewable license to use the app has been provided by StartNivesh to the Licensee. Only the conditions specified in this Agreement may be used with the application. The application cannot be distributed to third parties, rented, leased, or sublicensed by the licensee.',
                      ),
                      _TermsSubsection(
                        title: '3.2 Cost and Charges',
                        content: 'StartNivesh will decide if to give out the license for a one-time payment or a monthly subscription. The license may be terminated for nonpayment of any applicable fees.',
                      ),
                      _TermsSubsection(
                        title: '3.3 Maintenance and Help',
                        content: 'As part of this agreement, StartNivesh could offer software patches, upgrades, and support services. Unless otherwise stated, no refunds will be provided.',
                      ),
                      _TermsSubsection(
                        title: '3.4 Limits on Modification',
                        content: 'The software cannot be altered, decompiled, reconstructed, or changed by the licensee.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '4. IMPORTANT CLAUSES',
                    subsections: [
                      _TermsSubsection(
                        title: '4.1 The Non-Exclusivity Principle',
                        content: 'Since the license is non-exclusive, StartNivesh is free to provide other parties licenses for the app.',
                      ),
                      _TermsSubsection(
                        title: '4.2 Clause of Non-Transferability',
                        content: 'This Agreement may not be sold, transferred by the licensee to any third-party or organization.',
                      ),
                      _TermsSubsection(
                        title: '4.3 Intellectual Property Rights',
                        content: 'StartNivesh retains all rights to the software, trademarks, logos, copyrights, and proprietary technologies. Any unauthorized use, reproduction, or distribution will result in legal action.',
                      ),
                      _TermsSubsection(
                        title: '4.4 Contractual Breach Clause',
                        content: 'The license will be immediately cancelled and the licensee will be responsible for any damages if they violate any of the rules.',
                      ),
                      _TermsSubsection(
                        title: '4.6 Liability Limitation',
                        content: 'StartNivesh denies any responsibility for accidental, important, direct, and indirect damages.',
                      ),
                      _TermsSubsection(
                        title: '4.7 The Termination Clause',
                        content: 'This Agreement may be terminated by StartNivesh at any moment and without prior notice. The app must be deleted and uninstalled by the licensee upon termination.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '5. PRIVACY RULE',
                    subsections: [
                      _TermsSubsection(
                        title: '5.1 Collecting Data',
                        content: 'For the aim of developing accounts and improving services, we collect name, email, company information, and usage data. StartNivesh does not keep sensitive money-related data.',
                      ),
                      _TermsSubsection(
                        title: '5.2 Information Exchange',
                        content: 'Unless mandated by law, we never sell user data or give it to outside parties. Analytics and service enhancement may make use of aggregated, anonymised data.',
                      ),
                      _TermsSubsection(
                        title: '5.3 Safety Procedures',
                        content: 'To safeguard user information, we use secure authentication and encryption. Users are in responsible for keeping their accounts secure.',
                      ),
                      _TermsSubsection(
                        title: '5.4 Removal and Opt-Out',
                        content: 'Users can contact StartNivesh at any moment to seek the cancellation of their account.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '7. ACKNOWLEDGEMENT & ACCEPTANCE',
                    content: 'By clicking "I Agree" or installing the software, you confirm that you have read, understood, and accepted all terms outlined in this Agreement.',
                  ),
                  SizedBox(height: 30),
                  Text(
                    'StartNivesh Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
    appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
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
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    // Header with animation
    TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeOut,
    builder: (context, value, child) {
    return Opacity(
    opacity: value,
    child: Transform.translate(
    offset: Offset(0, 20 * (1 - value)),
    child: child,
    ),
    );
    },
    child: Column(
    children: [
    Text(
    'Create Account',
    style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
    ),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 8),
    Text(
    'Join StartNivesh today',
    style: TextStyle(
    fontSize: 16,
    color: Colors.white60,
    ),
    textAlign: TextAlign.center,
    ),
    ],
    ),
    ),
    const SizedBox(height: 40),

    // Name field
    _buildTextField(
    controller: _nameController,
    label: 'Full Name',
    prefixIcon: Icons.person_outline,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your name';
    }
    return null;
    },
    ),

    const SizedBox(height: 20),

    // Email field
    _buildTextField(
    controller: _emailController,
    label: 'Email',
    prefixIcon: Icons.email_outlined,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
    return 'Please enter a valid email';
    }
    return null;
    },
    ),

    const SizedBox(height: 20),

    // Password field
    _buildTextField(
    controller: _passwordController,
    label: 'Password',
    prefixIcon: Icons.lock_outline,
    obscureText: !_isPasswordVisible,
    suffix: IconButton(
    icon: Icon(
    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
    color: Colors.white60,
    size: 20,
    ),
    onPressed: () {
    setState(() {
    _isPasswordVisible = !_isPasswordVisible;
    });
    },
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
    },
    ),

      const SizedBox(height: 20),

// Confirm password field
      _buildTextField(
        controller: _confirmPasswordController,
        label: 'Confirm Password',
        prefixIcon: Icons.lock_outline,
        obscureText: !_isConfirmPasswordVisible,
        suffix: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.white60,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),

      const SizedBox(height: 30),

// Terms and conditions checkbox
      Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreeToTerms,
              activeColor: const Color(0xFF4E9CF6),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              side: const BorderSide(color: Colors.white30),
              onChanged: (value) {
                setState(() {
                  _agreeToTerms = value ?? false;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _agreeToTerms = !_agreeToTerms;
                });
              },
              child: Text.rich(
                TextSpan(
                  text: 'I agree to the ',
                  style: const TextStyle(color: Colors.white70),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: const TextStyle(
                        color: Color(0xFF4E9CF6),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _showTermsAndConditions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 40),

// Sign up button
      ElevatedButton(
        onPressed: _isLoading ? null : _handleSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          disabledBackgroundColor: const Color(0xFF4E9CF6).withOpacity(0.5),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(height: 24),

// Already have an account link
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(color: Colors.white70),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF4E9CF6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 30),
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
    required IconData prefixIcon,
    Widget? suffix,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(prefixIcon, color: Colors.white60),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      validator: validator,
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String? content;
  final List<_TermsSubsection>? subsections;

  const _TermsSection({
    required this.title,
    this.content,
    this.subsections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (content != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              content!,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        if (subsections != null)
          ...subsections!.map((subsection) => subsection).toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _TermsSubsection extends StatelessWidget {
  final String title;
  final String content;

  const _TermsSubsection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            content,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}