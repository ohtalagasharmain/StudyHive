import 'dart:convert';
import 'dart:io';

import 'package:quds_office_engine/quds_office_engine.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../database/db.dart';
import '../models/resource.dart';

class ResourceController {
  final _db = Database();

  static const int _maxUploadBytes = 10 * 1024 * 1024;

  static const Set<String> _allowedExtensions = {
    'pdf',
    'doc',
    'docx',
    'png',
    'jpg',
    'jpeg',
  };

  Router get router {
    final router = Router();

    router.get('/', _getResources);
    router.get('/hive/<hiveId>', _getHiveResources);
    router.post('/', _saveResource);
    router.post('/sync', _syncResources);
    router.post('/upload', _uploadResource);
    router.delete('/<id>', _deleteResource);
    router.get('/files/<id>', _getFile);

    return router;
  }

  String? _getAuthenticatedUserId(Request request) {
    final userId = request.context['userId'];

    if (userId == null || userId.toString().isEmpty) {
      return null;
    }

    return userId.toString();
  }

  Future<Response> _getResources(Request request) async {
    final authenticatedUserId =
    _getAuthenticatedUserId(request);

    if (authenticatedUserId == null) {
      return _unauthorizedResponse();
    }

    final resources = await _db.getResources();

    final filteredResources = resources
        .where(
          (resource) =>
      resource.userId == authenticatedUserId,
    )
        .toList();

    return Response.ok(
      jsonEncode(
        filteredResources
            .map((resource) => resource.toJson())
            .toList(),
      ),
      headers: {
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> _getHiveResources(
      Request request,
      String hiveId,
      ) async {
    final authenticatedUserId =
    _getAuthenticatedUserId(request);

    if (authenticatedUserId == null) {
      return _unauthorizedResponse();
    }

    final resources = await _db.getResources();

    final filteredResources = resources
        .where(
          (resource) =>
      resource.hiveId == hiveId &&
          resource.userId == authenticatedUserId,
    )
        .map((resource) => resource.toJson())
        .toList();

    return Response.ok(
      jsonEncode(filteredResources),
      headers: {
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> _saveResource(Request request) async {
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

      final resource = Resource(
        id: payload['id'] ??
            DateTime.now()
                .millisecondsSinceEpoch
                .toString(),
        title: payload['title'] ??
            'Untitled Resource',
        type: payload['type'] ?? 'doc',
        date: payload['date'] ?? '',
        path: payload['path'] ?? '',
        userId: authenticatedUserId,
        hiveId: payload['hiveId'] ?? '',
        quantity: payload['quantity'] as int? ?? 1,
        quantityCap:
        payload['quantityCap'] as int? ?? 100,
        rarity:
        payload['rarity'] as String? ?? 'common',
        multiplier:
        (payload['multiplier'] as num?)
            ?.toDouble() ??
            1.0,
        bonus:
        (payload['bonus'] as num?)
            ?.toDouble() ??
            0.0,
        sourceOfAcquisition:
        payload['sourceOfAcquisition']
        as String? ??
            'general',
        lastUpdated:
        payload['lastUpdated'] as int? ??
            DateTime.now()
                .millisecondsSinceEpoch,
        schemaVersion:
        payload['schemaVersion'] as int? ?? 1,
      );

      await _db.addResource(resource);

      return Response.ok(
        jsonEncode({
          'message': 'Resource saved',
          'resource': resource.toJson(),
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Failed to save resource',
          'details': e.toString(),
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    }
  }

  Future<Response> _syncResources(Request request) async {
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

      final List rawList =
          payload['resources'] ?? [];

      final List<Resource> resourceList =
      rawList
          .map(
            (item) => Resource.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .map(
            (resource) => Resource(
          id: resource.id,
          title: resource.title,
          type: resource.type,
          date: resource.date,
          path: resource.path,
          userId: authenticatedUserId,
          hiveId: resource.hiveId,
          quantity: resource.quantity,
          quantityCap: resource.quantityCap,
          rarity: resource.rarity,
          multiplier: resource.multiplier,
          bonus: resource.bonus,
          sourceOfAcquisition:
          resource.sourceOfAcquisition,
          lastUpdated: resource.lastUpdated,
          schemaVersion: resource.schemaVersion,
        ),
      )
          .toList();

      _db.syncUserResources(
        authenticatedUserId,
        resourceList,
      );

      return Response.ok(
        jsonEncode({
          'message': 'Resources synced successfully',
          'userId': authenticatedUserId,
          'count': resourceList.length,
          'schemaVersion': 1,
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Failed to sync resources',
          'details': e.toString(),
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    }
  }

  Future<Response> _uploadResource(Request request) async {
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

      final String title =
          payload['title'] as String? ??
              'Untitled File';

      final String type =
          payload['type'] as String? ?? 'file';

      final String date =
          payload['date'] as String? ?? '';

      final String hiveId =
          payload['hiveId'] as String? ?? '';

      final String base64File =
          payload['fileBase64'] as String? ?? '';

      if (base64File.isEmpty) {
        return _badRequestResponse(
          'fileBase64 is required',
        );
      }

      final extension =
      _getFileExtension(title);

      if (extension == null) {
        return _badRequestResponse(
          'File extension is required',
        );
      }

      if (!_allowedExtensions.contains(extension)) {
        return _badRequestResponse(
          'File type .$extension is not allowed',
        );
      }

      late final List<int> bytes;

      try {
        bytes = base64Decode(base64File);
      } on FormatException {
        return _badRequestResponse(
          'Invalid Base64 file data',
        );
      }

      if (bytes.isEmpty) {
        return _badRequestResponse(
          'Uploaded file is empty',
        );
      }

      if (bytes.length > _maxUploadBytes) {
        return _badRequestResponse(
          'File is too large. Maximum size is 10 MB',
        );
      }

      final String id =
      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      final uploadDirectory =
      Directory('uploads');

      if (!await uploadDirectory.exists()) {
        await uploadDirectory.create(
          recursive: true,
        );
      }

      final safeExtension =
          '.$extension';

      final file =
      File('uploads/$id$safeExtension');

      await file.writeAsBytes(bytes);

      final resource = Resource(
        id: id,
        title: title,
        type: type,
        date: date,
        path: '/resources/files/$id',
        userId: authenticatedUserId,
        hiveId: hiveId,
      );

      await _db.addResource(resource);

      return Response.ok(
        jsonEncode({
          'message':
          'File uploaded successfully',
          'resource': resource.toJson(),
        }),
        headers: {
          'content-type': 'application/json',
        },
      );
    } on FormatException {
      return _badRequestResponse(
        'Invalid request data',
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error':
          'Failed to upload file',
          'details': e.toString(),
        }),
        headers: {
          'content-type':
          'application/json',
        },
      );
    }
  }

  String? _getFileExtension(String fileName) {
    final trimmedName = fileName.trim();

    if (trimmedName.isEmpty ||
        !trimmedName.contains('.')) {
      return null;
    }

    final parts = trimmedName.split('.');

    if (parts.length < 2) {
      return null;
    }

    final extension =
    parts.last.trim().toLowerCase();

    if (extension.isEmpty) {
      return null;
    }

    return extension;
  }

  Future<Response> _getFile(
      Request request,
      String id,
      ) async {
    final authenticatedUserId =
    _getAuthenticatedUserId(request);

    if (authenticatedUserId == null) {
      return _unauthorizedResponse();
    }

    final directory = Directory('uploads');

    if (!await directory.exists()) {
      return Response.notFound(
        'File not found',
      );
    }

    final resources =
    await _db.getResources();

    Resource? resource;

    for (final item in resources) {
      if (item.id == id &&
          item.userId ==
              authenticatedUserId) {
        resource = item;
        break;
      }
    }

    if (resource == null) {
      return Response.notFound(
        'File not found',
      );
    }

    final files =
    await directory.list().toList();

    File? matchingFile;

    for (final entity in files) {
      if (entity is File) {
        final fileName = entity.path
            .split(Platform.pathSeparator)
            .last;

        if (fileName.startsWith(id)) {
          matchingFile = entity;
          break;
        }
      }
    }

    if (matchingFile == null ||
        !await matchingFile.exists()) {
      return Response.notFound(
        'File not found',
      );
    }

    final extension = matchingFile.path
        .split('.')
        .last
        .toLowerCase();

    if (extension == 'doc' ||
        extension == 'docx') {
      return await _previewWordDocument(
        matchingFile,
      );
    }

    String contentType =
        'application/octet-stream';

    if (extension == 'pdf') {
      contentType = 'application/pdf';
    } else if (extension == 'png') {
      contentType = 'image/png';
    } else if (extension == 'jpg' ||
        extension == 'jpeg') {
      contentType = 'image/jpeg';
    }

    return Response.ok(
      matchingFile.openRead(),
      headers: {
        'content-type': contentType,
      },
    );
  }

  Future<Response> _previewWordDocument(
      File file,
      ) async {
    try {
      final bytes =
      await file.readAsBytes();

      final document =
      WordDeserializer().readBytes(bytes);

      final pdfBytes =
      OfficePdfExport.word(
        document,
        title: file.path
            .split(Platform.pathSeparator)
            .last,
      );

      return Response.ok(
        pdfBytes,
        headers: {
          'content-type':
          'application/pdf',
          'content-disposition':
          'inline',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body:
        'Failed to preview Word document: $e',
      );
    }
  }

  Future<Response> _deleteResource(
      Request request,
      String id,
      ) async {
    try {
      final authenticatedUserId =
      _getAuthenticatedUserId(request);

      if (authenticatedUserId == null) {
        return _unauthorizedResponse();
      }

      final resources =
      await _db.getResources();

      Resource? resource;

      for (final item in resources) {
        if (item.id == id &&
            item.userId ==
                authenticatedUserId) {
          resource = item;
          break;
        }
      }

      if (resource == null) {
        return Response.notFound(
          jsonEncode({
            'error':
            'Resource not found',
          }),
          headers: {
            'content-type':
            'application/json',
          },
        );
      }

      await _db.deleteResource(
        id,
        userId: authenticatedUserId,
      );

      return Response.ok(
        jsonEncode({
          'message':
          'Resource deleted',
        }),
        headers: {
          'content-type':
          'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error':
          'Failed to delete resource',
          'details': e.toString(),
        }),
        headers: {
          'content-type':
          'application/json',
        },
      );
    }
  }

  Response _unauthorizedResponse() {
    return Response(
      401,
      body: jsonEncode({
        'error':
        'Authentication required',
      }),
      headers: {
        'content-type':
        'application/json',
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
        'content-type':
        'application/json',
      },
    );
  }
}