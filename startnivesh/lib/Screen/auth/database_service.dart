import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Db? _db;

  // Singleton pattern
  static Future<DatabaseService> getInstance() async {
    _instance ??= DatabaseService();

    if (_db == null || !_db!.isConnected) {
      _db = await Db.create('mongodb://localhost:27017/');
      await _db!.open();
    }

    return _instance!;
  }

  // Hash password
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // User login
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final users = _db!.collection('users');

      // Hash the password before querying
      final hashedPassword = _hashPassword(password);

      // Find user with matching email and password
      final user = await users.findOne(where
          .eq('email', email)
          .eq('password', hashedPassword)
      );

      if (user != null) {
        // Remove sensitive data before returning
        user.remove('password');
        return user;
      }

      return null;
    } catch (e) {
      print('Login error: $e');
      throw 'An error occurred during login';
    }
  }

  // Create new user
  Future<Map<String, dynamic>> createUser(String email, String password, String name) async {
    try {
      final users = _db!.collection('users');

      // Check if email already exists
      final existingUser = await users.findOne(where.eq('email', email));
      if (existingUser != null) {
        throw 'Email already registered';
      }

      // Hash password before storing
      final hashedPassword = _hashPassword(password);

      // Create user document
      final user = {
        'email': email,
        'password': hashedPassword,
        'name': name,
        'createdAt': DateTime.now(),
      };

      await users.insert(user);

      // Remove password before returning
      user.remove('password');
      return user;
    } catch (e) {
      print('Create user error: $e');
      throw 'An error occurred while creating user';
    }
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    try {
      final users = _db!.collection('users');
      final user = await users.findOne(where.eq('email', email));
      return user != null;
    } catch (e) {
      print('Email check error: $e');
      throw 'An error occurred while checking email';
    }
  }
}