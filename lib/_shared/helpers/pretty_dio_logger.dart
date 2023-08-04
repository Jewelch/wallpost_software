import 'dart:math' as math;

import 'package:dio/dio.dart';

import 'debugger.dart';

class PrettyDioLogger extends Interceptor {
  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.

  PrettyDioLogger({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 100,
    this.compact = true,
  });

  // ignore: library_private_types_in_public_api
  void logPrint(_DebugTypes type, String value) {
    switch (type) {
      case _DebugTypes.request:
        Debugger.yellow('Dio', value);
        break;

      case _DebugTypes.response:
        Debugger.green('Dio', value);
        break;

      case _DebugTypes.error:
        Debugger.red('Dio', value);
        break;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      final uri = options.uri;
      final method = options.method;
      _printBoxed(_DebugTypes.request, header: 'Request ║ $method ', text: uri.toString());
    }
    if (requestHeader) {
      _printMapAsTable(_DebugTypes.request, options.queryParameters, header: 'Query Parameters');
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout;
      requestHeaders['receiveTimeout'] = options.receiveTimeout;
      _printMapAsTable(_DebugTypes.request, requestHeaders, header: 'Headers');
      _printMapAsTable(_DebugTypes.request, options.extra, header: 'Extras');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) _printMapAsTable(_DebugTypes.request, options.data as Map?, header: 'Body');
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(_DebugTypes.request, formDataMap, header: 'Form data | ${data.boundary}');
        } else {
          _printBlock(_DebugTypes.request, data.toString());
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
          _DebugTypes.error,
          header: 'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
          text: uri.toString(),
        );
        if (err.response != null && err.response?.data != null) {
          logPrint(_DebugTypes.error, '╔ ${err.type.toString()}');
          _print(_DebugTypes.error, err.response!);
        }
        _printLine(_DebugTypes.error, '╚');
        logPrint(_DebugTypes.error, '');
      } else {
        _printBoxed(_DebugTypes.error, header: 'DioError ║ ${err.type}', text: err.message);
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers.forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(_DebugTypes.response, responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      logPrint(_DebugTypes.response, '╔ Body');
      logPrint(_DebugTypes.response, '║');
      _print(_DebugTypes.response, response);
      logPrint(_DebugTypes.response, '║');
      _printLine(_DebugTypes.response, '╚');
    }
    super.onResponse(response, handler);
  }

  void _printBoxed(_DebugTypes type, {String? header, String? text}) {
    logPrint(type, '');
    logPrint(type, '╔╣ $header');
    logPrint(type, '║  $text');
    _printLine(type, '╚');
  }

  void _print(_DebugTypes type, Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(type, response.data as Map);
      } else if (response.data is List) {
        logPrint(type, '║${_indent()}[');
        _printList(type, response.data as List);
        logPrint(type, '║${_indent()}[');
      } else {
        _printBlock(type, response.data.toString());
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(_DebugTypes.response,
        header: 'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}', text: uri.toString());
  }

  void _printLine(_DebugTypes type, [String pre = '', String suf = '╝']) => logPrint(type, '$pre${'═' * maxWidth}$suf');

  void _printKV(_DebugTypes type, String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(type, pre);
      _printBlock(type, msg);
    } else {
      logPrint(type, '$pre$msg');
    }
  }

  void _printBlock(_DebugTypes type, String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint(
          type, (i >= 0 ? '║ ' : '') + msg.substring(i * maxWidth, math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    _DebugTypes type,
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var _tabs = tabs;
    final isRoot = _tabs == initialTab;
    final initialIndent = _indent(_tabs);
    _tabs++;

    if (isRoot || isListItem) logPrint(type, '║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logPrint(type, '║${_indent(_tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          logPrint(type, '║${_indent(_tabs)} $key: {');
          _printPrettyMap(type, value, tabs: _tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logPrint(type, '║${_indent(_tabs)} $key: ${value.toString()}');
        } else {
          logPrint(type, '║${_indent(_tabs)} $key: [');
          _printList(type, value, tabs: _tabs);
          logPrint(type, '║${_indent(_tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(_tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint(type,
                '║${_indent(_tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          logPrint(type, '║${_indent(_tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint(type, '║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(_DebugTypes type, List list, {int tabs = initialTab}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logPrint(type, '║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(type, e, tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint(type, '║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  bool _canFlattenMap(Map map) {
    return map.values.where((dynamic val) => val is Map || val is List).isEmpty && map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(_DebugTypes type, Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint(type, '╔ $header ');
    map.forEach((dynamic key, dynamic value) => _printKV(type, key.toString(), value));
    _printLine(type, '╚');
  }
}

enum _DebugTypes { request, response, error }
