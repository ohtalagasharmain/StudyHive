import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authorization = request.headers['authorization'];

      // No Authorization header
      if (authorization == null || authorization.isEmpty) {
        return Response(
          401,
          body: 'Authentication required',
        );
      }

      // Expected format:
      // Authorization: Bearer <token>
      if (!authorization.startsWith('Bearer ')) {
        return Response(
          401,
          body: 'Invalid authorization format',
        );
      }

      final token = authorization.substring(7).trim();

      if (token.isEmpty) {
        return Response(
          401,
          body: 'Authentication token is missing',
        );
      }

      final secret = Platform.environment['JWT_SECRET'];

      if (secret == null || secret.isEmpty) {
        return Response.internalServerError(
          body: 'JWT secret is not configured',
        );
      }

      try {
        final jwt = JWT.verify(
          token,
          SecretKey(secret),
        );

        final payload = jwt.payload;

        if (payload is! Map) {
          return Response(
            401,
            body: 'Invalid token payload',
          );
        }

        final userId = payload['sub'];

        if (userId == null || userId.toString().isEmpty) {
          return Response(
            401,
            body: 'Invalid authentication token',
          );
        }

        // Pass the authenticated user's ID to the controller.
        final authenticatedRequest = request.change(
          context: {
            'userId': userId.toString(),
            'jwtPayload': payload,
          },
        );

        return await innerHandler(authenticatedRequest);
      } on JWTExpiredException {
        return Response(
          401,
          body: 'Authentication token has expired',
        );
      } on JWTException {
        return Response(
          401,
          body: 'Invalid authentication token',
        );
      } catch (_) {
        return Response(
          401,
          body: 'Invalid authentication token',
        );
      }
    };
  };
}