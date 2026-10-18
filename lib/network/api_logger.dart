import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// App-wide logger (package:logger).
///
/// Logs appear in the Android Studio "Run" console and in Logcat
/// (filter by tag `flutter`). In release builds nothing is printed.
final Logger appLogger = Logger(
  filter: _DebugOnlyFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 6,
    lineLength: 100,
    colors: false, // ANSI colours show up as garbage in Logcat
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

class _DebugOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}

/// How long any API call may take before it fails with a TimeoutException.
/// Change this one value to adjust the timeout for the whole app.
const Duration kApiTimeout = Duration(seconds: 60);

/// Shared HTTP client that logs every API request and response.
/// Use it instead of `http.post(...)`:  `apiClient.post(...)`.
final http.Client apiClient = LoggingClient(http.Client());

/// An [http.BaseClient] that logs method, URL, headers, body, status,
/// duration and response body for every call — including failures.
class LoggingClient extends http.BaseClient {
  LoggingClient(this._inner);

  final http.Client _inner;
  static int _counter = 0;

  /// Keys whose values are hidden in logs.
  static const _sensitiveKeys = {'password', 'pwd', 'token', 'otp'};

  /// Bodies longer than this are cut in the log (the app still gets it all).
  static const _maxBodyChars = 6000;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!kDebugMode) return _inner.send(request).timeout(kApiTimeout);

    final id = ++_counter;
    final tag = '#$id ${request.method} ${_shortPath(request.url)}';
    final requestBody =
        request is http.Request ? request.body : '<${request.runtimeType}>';

    appLogger.i([
      '➡️ REQUEST $tag',
      'URL: ${request.url}',
      if (request.headers.isNotEmpty) 'Headers: ${request.headers}',
      if (requestBody.isNotEmpty) 'Body:\n${_pretty(requestBody, mask: true)}',
    ].join('\n'));

    final stopwatch = Stopwatch()..start();
    try {
      final streamed = await _inner.send(request).timeout(kApiTimeout);
      final bytes = await streamed.stream.toBytes().timeout(kApiTimeout);
      stopwatch.stop();

      final bodyText = utf8.decode(bytes, allowMalformed: true);
      final status = streamed.statusCode;
      final message = [
        '${status < 400 ? '✅' : '❌'} RESPONSE $tag',
        'Status: $status ${streamed.reasonPhrase ?? ''}'.trim(),
        'Time: ${stopwatch.elapsedMilliseconds} ms   Size: ${_size(bytes.length)}',
        'Body:\n${_pretty(bodyText)}',
      ].join('\n');

      if (status >= 500) {
        appLogger.e(message);
      } else if (status >= 400) {
        appLogger.w(message);
      } else {
        appLogger.d(message);
      }

      // Rebuild the stream we consumed so callers work as normal.
      return http.StreamedResponse(
        http.ByteStream.fromBytes(bytes),
        status,
        contentLength: bytes.length,
        request: streamed.request,
        headers: streamed.headers,
        isRedirect: streamed.isRedirect,
        persistentConnection: streamed.persistentConnection,
        reasonPhrase: streamed.reasonPhrase,
      );
    } catch (e, st) {
      stopwatch.stop();
      appLogger.e(
        '⛔ FAILED $tag after ${stopwatch.elapsedMilliseconds} ms\nURL: ${request.url}',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  void close() => _inner.close();

  // ------------------------------------------------------------ helpers

  static String _shortPath(Uri url) {
    final segments = url.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length <= 2) return url.path;
    return '…/${segments.sublist(segments.length - 2).join('/')}';
  }

  static String _size(int bytes) =>
      bytes < 1024 ? '$bytes B' : '${(bytes / 1024).toStringAsFixed(1)} KB';

  static String _pretty(String text, {bool mask = false}) {
    String out;
    try {
      var decoded = json.decode(text);
      if (mask) decoded = _mask(decoded);
      out = const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      out = text.isEmpty ? '<empty>' : text;
    }
    if (out.length > _maxBodyChars) {
      out = '${out.substring(0, _maxBodyChars)}\n… (${out.length - _maxBodyChars} more chars truncated)';
    }
    return out;
  }

  static dynamic _mask(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(
            k,
            _sensitiveKeys.contains(k.toString().toLowerCase())
                ? '••••••'
                : _mask(v),
          ));
    }
    if (value is List) return value.map(_mask).toList();
    return value;
  }
}
