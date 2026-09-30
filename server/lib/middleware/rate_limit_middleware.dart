import 'dart:async';

import 'package:shelf/shelf.dart';

class _RequestRecord {
  final DateTime timestamp;

  _RequestRecord(this.timestamp);
}

Middleware rateLimitMiddleware({
  int maxRequests = 60,
  Duration window = const Duration(minutes: 1),
}) {
  final Map<String, List<_RequestRecord>> requests = {};

  Timer.periodic(
    const Duration(minutes: 5),
        (_) {
      final cutoff =
      DateTime.now().subtract(window);

      requests.removeWhere(
            (_, records) {
          records.removeWhere(
                (record) =>
                record.timestamp.isBefore(cutoff),
          );

          return records.isEmpty;
        },
      );
    },
  );

  return (Handler innerHandler) {
    return (Request request) async {
      final clientKey =
      _getClientKey(request);

      final now = DateTime.now();

      final cutoff =
      now.subtract(window);

      final records =
      requests.putIfAbsent(
        clientKey,
            () => [],
      );

      records.removeWhere(
            (record) =>
            record.timestamp.isBefore(cutoff),
      );

      if (records.length >= maxRequests) {
        return Response(
          429,
          body:
          'Too many requests. Please try again later.',
          headers: {
            'content-type': 'text/plain',
            'retry-after':
            window.inSeconds.toString(),
          },
        );
      }

      records.add(
        _RequestRecord(now),
      );

      return innerHandler(request);
    };
  };
}

String _getClientKey(Request request) {
  final forwardedFor =
  request.headers['x-forwarded-for'];

  if (forwardedFor != null &&
      forwardedFor.isNotEmpty) {
    return forwardedFor
        .split(',')
        .first
        .trim();
  }

  final realIp =
  request.headers['x-real-ip'];

  if (realIp != null &&
      realIp.isNotEmpty) {
    return realIp;
  }

  return request
      .context['shelf.io.connection_info']
      ?.toString() ??
      'unknown-client';
}