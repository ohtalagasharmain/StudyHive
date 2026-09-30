import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../database/db.dart';
import '../models/user.dart';

class AuthController {
  final _db = Database();

  String get _jwtSecret {
    final secret = Platform.environment['JWT_SECRET'];

    if (secret == null || secret.isEmpty) {
      throw StateError(
        'JWT_SECRET environment variable is not configured.',
      );
    }

    return secret;
  }

  Router get router {
    final router = Router();

    router.post('/signup', _signupHandler);
    router.post('/login', _loginHandler);

    return router;
  }

  Future<Response> _signupHandler(Request request) async {
    try {
      final body = await request.readAsString();

      if (body.isEmpty) {
        return _jsonResponse(
          400,
          {'error': 'Request body is required'},
        );
      }

      final payload = jsonDecode(body);

      if (payload is! Map<String, dynamic>) {
        return _jsonResponse(
          400,
          {'error': 'Invalid request body'},
        );
      }

      final email = payload['email'];
      final password = payload['password'];
      final fullName = payload['fullName'];

      if (email is! String ||
          password is! String ||
          fullName is! String) {
        return _jsonResponse(
          400,
          {
            'error':
            'Email, password, and fullName are required',
          },
        );
      }

      final normalizedEmail = email.trim().toLowerCase();
      final normalizedName = fullName.trim();

      if (normalizedEmail.isEmpty ||
          normalizedName.isEmpty ||
          password.isEmpty) {
        return _jsonResponse(
          400,
          {
            'error':
            'Email, password, and fullName cannot be empty',
          },
        );
      }

      if (password.length < 8) {
        return _jsonResponse(
          400,
          {
            'error':
            'Password must be at least 8 characters long',
          },
        );
      }

      if (_db.findUserByEmail(normalizedEmail) != null) {
        return _jsonResponse(
          409,
          {'error': 'User already exists'},
        );
      }

      final passwordHash = BCrypt.hashpw(
        password,
        BCrypt.gensalt(),
      );

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: normalizedEmail,
        fullName: normalizedName,
        passwordHash: passwordHash,
      );

      _db.addUser(newUser);

      return _jsonResponse(
        201,
        {
          'message': 'User registered successfully',
          'user': newUser.toJson(),
        },
      );
    } catch (_) {
      return _jsonResponse(
        400,
        {'error': 'Invalid request'},
      );
    }
  }

  Future<Response> _loginHandler(Request request) async {
    try {
      final body = await request.readAsString();

      if (body.isEmpty) {
        return _jsonResponse(
          400,
          {'error': 'Request body is required'},
        );
      }

      final payload = jsonDecode(body);

      if (payload is! Map<String, dynamic>) {
        return _jsonResponse(
          400,
          {'error': 'Invalid request body'},
        );
      }

      final email = payload['email'];
      final password = payload['password'];

      if (email is! String || password is! String) {
        return _jsonResponse(
          400,
          {'error': 'Email and password are required'},
        );
      }

      final normalizedEmail = email.trim().toLowerCase();

      final user = _db.findUserByEmail(normalizedEmail);

      if (user == null ||
          !BCrypt.checkpw(password, user.passwordHash)) {
        return _jsonResponse(
          401,
          {'error': 'Invalid credentials'},
        );
      }

      final now = DateTime.now().toUtc();

      final expiry = now.add(
        const Duration(hours: 1),
      );

      final jwt = JWT(
        {
          'sub': user.id,
          'email': user.email,
          'exp': expiry.millisecondsSinceEpoch ~/ 1000,
        },
        issuer: 'studyhive',
      );

      final token = jwt.sign(
        SecretKey(_jwtSecret),
      );

      return _jsonResponse(
        200,
        {
          'message': 'Login successful',
          'user': user.toJson(),
          'token': token,
        },
      );
    } catch (_) {
      return _jsonResponse(
        401,
        {'error': 'Invalid credentials'},
      );
    }
  }

  Response _jsonResponse(
      int statusCode,
      Map<String, dynamic> data,
      ) {
    return Response(
      statusCode,
      body: jsonEncode(data),
      headers: {
        'content-type': 'application/json',
      },
    );
  }
}