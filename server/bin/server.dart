import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../lib/controllers/auth_controller.dart';
import '../lib/controllers/hive_controller.dart';
import '../lib/controllers/resource_controller.dart';
import '../lib/middleware/auth_middleware.dart';
import '../lib/middleware/rate_limit_middleware.dart';

const int maxRequestBodyBytes = 15 * 1024 * 1024;

Middleware requestSizeLimit() {
  return (Handler innerHandler) {
    return (Request request) async {
      final contentLength = request.contentLength;

      if (contentLength != null &&
          contentLength > maxRequestBodyBytes) {
        return Response(
          413,
          body: 'Request body is too large',
          headers: {
            'content-type': 'text/plain',
          },
        );
      }

      return innerHandler(request);
    };
  };
}

void main(List<String> args) async {
  final port = int.parse(
    Platform.environment['PORT'] ?? '8080',
  );

  final router = Router();

  // Public health check
  router.get('/', (Request request) {
    return Response.ok(
      'StudyHive Backend is running!',
    );
  });

  // Public authentication routes
  router.mount(
    '/auth',
    AuthController().router.call,
  );

  // Protected resource routes
  final protectedResources = const Pipeline()
      .addMiddleware(authMiddleware())
      .addHandler(
    ResourceController().router.call,
  );

  // Protected hive routes
  final protectedHives = const Pipeline()
      .addMiddleware(authMiddleware())
      .addHandler(
    HiveController().router.call,
  );

  router.mount(
    '/resources',
    protectedResources,
  );

  router.mount(
    '/hives',
    protectedHives,
  );

  // Global middleware
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addMiddleware(
    rateLimitMiddleware(
      maxRequests: 60,
      window: const Duration(minutes: 1),
    ),
  )
      .addMiddleware(requestSizeLimit())
      .addHandler(router.call);

  final server = await serve(
    handler,
    InternetAddress.anyIPv4,
    port,
  );

  print(
    'Server listening on port ${server.port}',
  );
}