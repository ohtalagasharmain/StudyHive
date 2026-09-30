import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../database/db.dart';
import '../models/hive.dart';

class HiveController {
  final _db = Database();

  Router get router {
    final router = Router();

    router.get('/', _getAllHivesHandler);
    router.post('/', _createHiveHandler);

    return router;
  }

  String? _getAuthenticatedUserId(Request request) {
    final userId = request.context['userId'];

    if (userId == null || userId.toString().isEmpty) {
      return null;
    }

    return userId.toString();
  }

  Future<Response> _getAllHivesHandler(
      Request request,
      ) async {
    final authenticatedUserId =
    _getAuthenticatedUserId(request);

    if (authenticatedUserId == null) {
      return _unauthorizedResponse();
    }

    final userHives = _db.hives
        .where(
          (hive) =>
      hive.creatorId == authenticatedUserId ||
          hive.members.contains(authenticatedUserId),
    )
        .map((hive) => hive.toJson())
        .toList();

    return Response.ok(
      jsonEncode(userHives),
      headers: {
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> _createHiveHandler(
      Request request,
      ) async {
    try {
      final authenticatedUserId =
      _getAuthenticatedUserId(request);

      if (authenticatedUserId == null) {
        return _unauthorizedResponse();
      }

      final body = await request.readAsString();

      if (body.isEmpty) {
        return _badRequestResponse(
          'Request body is required',
        );
      }

      final payload = jsonDecode(body);

      if (payload is! Map<String, dynamic>) {
        return _badRequestResponse(
          'Invalid request body',
        );
      }

      final name = payload['name'];

      if (name is! String || name.trim().isEmpty) {
        return _badRequestResponse(
          'Hive name is required',
        );
      }

      final description =
      payload['description'] is String
          ? payload['description'].trim()
          : '';

      final newHive = Hive(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        name: name.trim(),
        description: description,

        // IMPORTANT:
        // Never trust creatorId from the request.
        // Use the authenticated JWT user.
        creatorId: authenticatedUserId,

        members: [
          authenticatedUserId,
        ],
      );

      _db.addHive(newHive);

      return Response.ok(
        jsonEncode({
          'message': 'Hive created',
          'hive': newHive.toJson(),
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Failed to create hive',
          'details': e.toString(),
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    }
  }

  Response _unauthorizedResponse() {
    return Response(
      401,
      body: jsonEncode({
        'error': 'Authentication required',
      }),
      headers: {
        'content-type': 'application/json',
      },
    );
  }

  Response _badRequestResponse(
      String message,
      ) {
    return Response(
      400,
      body: jsonEncode({
        'error': message,
      }),
      headers: {
        'content-type': 'application/json',
      },
    );
  }
}