import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class FlowResult {
  final String name;
  final bool ok;
  final String detail;

  FlowResult(this.name, this.ok, this.detail);
}

String _normalizeBaseUrl(String value) {
  return value.trim().replaceAll(RegExp(r'/+$'), '');
}

Future<String> _readBaseUrl() async {
  final value = await _readEnvValue('BASE_URL');
  return _normalizeBaseUrl(value);
}

Dio _buildDio({required String baseUrl, required String token}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  return dio;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
  return {};
}

int _returnCode(Map<String, dynamic> resp) {
  final dr = _asMap(resp['dataResponse']);
  final rc = dr['returnCode'];
  if (rc is int) return rc;
  return int.tryParse(rc?.toString() ?? '') ?? -1;
}

String _description(Map<String, dynamic> resp) {
  final dr = _asMap(resp['dataResponse']);
  return dr['description']?.toString() ?? '';
}

String _pickFirstStringValue(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    if (!map.containsKey(k)) continue;
    final v = map[k];
    if (v == null) continue;
    final s = v.toString().trim();
    if (s.isNotEmpty && s.toLowerCase() != 'null') return '$k=$s';
  }
  return '';
}

String _pickFirstStringValueFromKnownContainers(
  Map<String, dynamic> root,
  List<String> keys,
) {
  final direct = _pickFirstStringValue(root, keys);
  if (direct.isNotEmpty) return direct;

  const containers = [
    'subscription',
    'subscriptionOrder',
    'subscriptionDetails',
    'cart',
    'order',
    'orderDetails',
    'data',
  ];
  for (final c in containers) {
    final m = _asMap(root[c]);
    if (m.isEmpty) continue;
    final found = _pickFirstStringValue(m, keys);
    if (found.isNotEmpty) return '$c.$found';
  }
  return '';
}

Future<Map<String, dynamic>> _postWrapped(
  Dio dio,
  String path,
  Map<String, dynamic> data,
) async {
  final resp = await dio.post(
    path,
    data: jsonEncode({'data': data}),
    options: Options(contentType: Headers.jsonContentType),
  );
  return _asMap(resp.data);
}

Future<Map<String, dynamic>> _postMultipartFiles(
  Dio dio,
  String path,
  List<String> filePaths,
) async {
  final form = FormData();
  for (final p in filePaths) {
    form.files.add(MapEntry('files', await MultipartFile.fromFile(p)));
  }
  final resp = await dio.post(path, data: form);
  return _asMap(resp.data);
}

DateTime? _parseDate(String value) {
  final v = value.trim();
  if (v.isEmpty) return null;
  return DateTime.tryParse(v) ?? DateTime.tryParse(v.replaceFirst(' ', 'T'));
}

Future<String> _readEnvValue(String key) async {
  final envValue = (Platform.environment[key] ?? '').trim();
  if (envValue.isNotEmpty) return _stripQuotes(envValue);

  final file = File('.env');
  if (!await file.exists()) {
    throw StateError('$key not found. Set $key env var or add it to .env');
  }

  final lines = await file.readAsLines();
  for (final raw in lines) {
    final line = raw.trim();
    if (line.isEmpty) continue;
    if (line.startsWith('#')) continue;
    final idx = line.indexOf('=');
    if (idx <= 0) continue;
    final k = line.substring(0, idx).trim();
    if (k != key) continue;
    final value = line.substring(idx + 1).trim();
    if (value.isEmpty) break;
    return _stripQuotes(value);
  }

  throw StateError('$key not found. Set $key env var or add it to .env');
}

Future<String?> _readEnvValueOptional(String key) async {
  try {
    final v = await _readEnvValue(key);
    return v.trim().isEmpty ? null : v;
  } catch (_) {
    return null;
  }
}

String _stripQuotes(String value) {
  var v = value.trim();
  if (v.length >= 2 &&
      ((v.startsWith('"') && v.endsWith('"')) ||
          (v.startsWith("'") && v.endsWith("'")))) {
    v = v.substring(1, v.length - 1).trim();
  } else if (v.endsWith('"') || v.endsWith("'")) {
    v = v.substring(0, v.length - 1).trim();
  }
  return v;
}

bool _looksLikeOrder(Map<String, dynamic> m) {
  if (m.containsKey('id') ||
      m.containsKey('orderId') ||
      m.containsKey('deliveryId')) {
    return true;
  }
  final nestedOrder = _asMap(m['order']);
  if (nestedOrder.containsKey('id') ||
      nestedOrder.containsKey('orderId') ||
      nestedOrder.containsKey('deliveryId')) {
    return true;
  }
  final nestedDetails = _asMap(m['details']);
  if (nestedDetails.containsKey('id') ||
      nestedDetails.containsKey('orderId') ||
      nestedDetails.containsKey('deliveryId')) {
    return true;
  }
  return false;
}

List<Map<String, dynamic>> _extractOrders(dynamic data) {
  const candidateKeys = [
    'orders',
    'deliveries',
    'orderAssignments',
    'ordersAssignment',
    'assignedOrders',
    'assignments',
    'rows',
    'items',
    'list',
  ];

  final queue = <dynamic>[data];
  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);

    if (current is List) {
      final mapped = current.map((e) => _asMap(e)).toList();
      if (mapped.any(_looksLikeOrder)) return mapped;
      queue.addAll(current);
      continue;
    }

    if (current is Map || current is Map<String, dynamic>) {
      final map = _asMap(current);
      for (final k in candidateKeys) {
        final v = map[k];
        if (v is List) {
          final mapped = v.map((e) => _asMap(e)).toList();
          if (mapped.any(_looksLikeOrder)) return mapped;
        }
      }
      if (map.containsKey('data')) {
        queue.add(map['data']);
      }
      queue.addAll(map.values);
    }
  }

  return [];
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

List<String> _extractUploadedUrls(dynamic data) {
  if (data is! List) return [];
  final out = <String>[];
  for (final item in data) {
    if (item is String) {
      out.add(item);
    } else if (item is Map && item['fileUrl'] != null) {
      out.add(item['fileUrl'].toString());
    } else if (item is Map && item['url'] != null) {
      out.add(item['url'].toString());
    }
  }
  return out;
}

String _normalizePaymentMethod(String? method) {
  if (method == null) return 'CASH';
  final lower = method.toLowerCase().trim();
  const onlineKeys = [
    'online',
    'upi',
    'card',
    'digital',
    'e-payment',
    'epayment',
    'netbanking',
  ];
  for (final k in onlineKeys) {
    if (lower.contains(k)) return 'ONLINE';
  }
  const cashKeys = [
    'cash',
    'cod',
    'pod',
    'pay_on_delivery',
    'cash_on_delivery',
    'pay on delivery',
  ];
  for (final k in cashKeys) {
    if (lower.contains(k)) return 'CASH';
  }
  return 'CASH';
}

Future<void> main(List<String> args) async {
  final results = <FlowResult>[];

  String baseUrl;
  try {
    baseUrl = await _readBaseUrl();
  } catch (e) {
    stderr.writeln('BASE_URL error: $e');
    exitCode = 2;
    return;
  }

  String token;
  try {
    token = await _readEnvValue('DELIVERY_PARTNER_TOKEN');
  } catch (e) {
    stderr.writeln('DELIVERY_PARTNER_TOKEN error: $e');
    exitCode = 2;
    return;
  }
  if (token.toLowerCase().startsWith('bearer ')) {
    token = token.substring('bearer '.length).trim();
  }
  if (token.isEmpty) {
    stderr.writeln('DELIVERY_PARTNER_TOKEN is empty after parsing.');
    exitCode = 2;
    return;
  }

  final dio = _buildDio(baseUrl: baseUrl, token: token);

  Map<String, dynamic>? firstOrder;
  int? orderId;
  String orderType = 'cart';
  Map<String, dynamic>? orderDetails;

  final overrideOrderId = await _readEnvValueOptional('ORDER_ID');
  final overrideOrderType = await _readEnvValueOptional('ORDER_TYPE');
  if (overrideOrderId != null && overrideOrderId.isNotEmpty) {
    orderId = int.tryParse(overrideOrderId);
    if (orderId == null) {
      stderr.writeln('Invalid ORDER_ID: $overrideOrderId');
      exitCode = 2;
      return;
    }
    orderType = (overrideOrderType != null && overrideOrderType.isNotEmpty)
        ? overrideOrderType
        : 'cart';
    results.add(
      FlowResult(
        '1) getSpecificOrdersAssignment',
        true,
        'Skipped (ORDER_ID=$orderId type=$orderType)',
      ),
    );
  }

  if (orderId != null) {
    firstOrder = {'id': orderId, 'type': orderType};
  }

  if (orderId == null) {
    try {
      final resp = await _postWrapped(dio, '/getSpecificOrdersAssignment', {});
      final rc = _returnCode(resp);
      if (rc != 0) {
        results.add(
          FlowResult(
            '1) getSpecificOrdersAssignment',
            false,
            'returnCode=$rc ${_description(resp)}',
          ),
        );
        _printReport(baseUrl, results);
        exitCode = 1;
        return;
      }
      final data = resp['data'];
      final orders = _extractOrders(data);
      final preferType =
          (overrideOrderType != null && overrideOrderType.isNotEmpty)
          ? overrideOrderType
          : null;

      if (orders.isEmpty) {
        try {
          final historyResp = await _postWrapped(
            dio,
            '/getDeliveryPartnerOrderHistory',
            {"deliveryStatus": "DELIVERED", "page": 1, "pageSize": 50},
          );
          final historyRc = _returnCode(historyResp);
          if (historyRc != 0) {
            final dataMap = _asMap(data);
            final keys = dataMap.keys.toList()..sort();
            results.add(
              FlowResult(
                '1) getSpecificOrdersAssignment',
                false,
                'No assigned orders. dataKeys=$keys. History returnCode=$historyRc ${_description(historyResp)}',
              ),
            );
            _printReport(baseUrl, results);
            exitCode = 1;
            return;
          }

          final historyOrders = _extractOrders(historyResp['data']);
          if (historyOrders.isEmpty) {
            final dataMap = _asMap(data);
            final keys = dataMap.keys.toList()..sort();
            results.add(
              FlowResult(
                '1) getSpecificOrdersAssignment',
                false,
                'No assigned orders. dataKeys=$keys. History returned no deliveries.',
              ),
            );
            _printReport(baseUrl, results);
            exitCode = 1;
            return;
          }

          if (preferType != null) {
            firstOrder = historyOrders.firstWhere(
              (o) =>
                  (o['type']?.toString() ?? '').toLowerCase() ==
                  preferType.toLowerCase(),
              orElse: () => historyOrders.first,
            );
          } else {
            firstOrder = historyOrders.first;
          }

          orderId =
              int.tryParse(firstOrder['orderId']?.toString() ?? '') ??
              int.tryParse(firstOrder['id']?.toString() ?? '');
          orderType = firstOrder['type']?.toString() ?? 'cart';
          if (orderId == null) {
            results.add(
              FlowResult(
                '1) getSpecificOrdersAssignment',
                false,
                'No assigned orders. History order missing orderId. keys=${firstOrder.keys.toList()..sort()}',
              ),
            );
            _printReport(baseUrl, results);
            exitCode = 1;
            return;
          }

          results.add(
            FlowResult(
              '1) getSpecificOrdersAssignment',
              true,
              'No assigned orders. Using history orderId=$orderId type=$orderType',
            ),
          );
        } catch (e) {
          final dataMap = _asMap(data);
          final keys = dataMap.keys.toList()..sort();
          results.add(
            FlowResult(
              '1) getSpecificOrdersAssignment',
              false,
              'No assigned orders. dataKeys=$keys. History fetch error: $e',
            ),
          );
          _printReport(baseUrl, results);
          exitCode = 1;
          return;
        }
      } else {
        orders.sort((a, b) {
          final ad = _parseDate(a['createdOn']?.toString() ?? '');
          final bd = _parseDate(b['createdOn']?.toString() ?? '');
          if (ad == null && bd == null) {
            final ai = int.tryParse(a['id']?.toString() ?? '') ?? 0;
            final bi = int.tryParse(b['id']?.toString() ?? '') ?? 0;
            return bi.compareTo(ai);
          }
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        });

        if (preferType != null) {
          firstOrder = orders.firstWhere(
            (o) =>
                (o['type']?.toString() ?? '').toLowerCase() ==
                preferType.toLowerCase(),
            orElse: () => orders.first,
          );
        } else {
          firstOrder = orders.first;
        }

        final nestedOrder = _asMap(firstOrder['order']);
        orderId =
            int.tryParse(firstOrder['id']?.toString() ?? '') ??
            int.tryParse(firstOrder['orderId']?.toString() ?? '') ??
            int.tryParse(nestedOrder['id']?.toString() ?? '') ??
            int.tryParse(nestedOrder['orderId']?.toString() ?? '');
        orderType =
            firstOrder['type']?.toString() ??
            nestedOrder['type']?.toString() ??
            'cart';
        if (orderId == null) {
          results.add(
            FlowResult(
              '1) getSpecificOrdersAssignment',
              false,
              'First order missing id. keys=${firstOrder.keys.toList()..sort()}',
            ),
          );
          _printReport(baseUrl, results);
          exitCode = 1;
          return;
        }

        results.add(
          FlowResult(
            '1) getSpecificOrdersAssignment',
            true,
            'Picked orderId=$orderId type=$orderType',
          ),
        );
      }
    } catch (e) {
      results.add(
        FlowResult('1) getSpecificOrdersAssignment', false, e.toString()),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
  }

  try {
    final resp = await _postWrapped(dio, '/getSpecificOrderDetails', {
      'orderId': orderId,
      'type': orderType,
      'warehouseLocation': {'lat': 28.6139, 'lng': 77.2090},
    });
    final rc = _returnCode(resp);
    if (rc != 0) {
      results.add(
        FlowResult(
          '2) getSpecificOrderDetails',
          false,
          'returnCode=$rc ${_description(resp)}',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    orderDetails = _asMap(resp['data']);
    results.add(
      FlowResult('2) getSpecificOrderDetails', true, 'Fetched order details'),
    );

    final statusSummaryParts = <String>[];
    final statusPair = _pickFirstStringValue(orderDetails, [
      'status',
      'paymentStatus',
      'payment_status',
      'orderStatus',
      'order_status',
      'deliveryStatus',
      'delivery_status',
    ]);
    if (statusPair.isNotEmpty) statusSummaryParts.add(statusPair);

    final paymentModePair = _pickFirstStringValue(orderDetails, [
      'paymentMode',
      'payment_mode',
      'paymentMethod',
      'payment_method',
    ]);
    if (paymentModePair.isNotEmpty) statusSummaryParts.add(paymentModePair);

    final cart = _asMap(orderDetails['cart']);
    final cartStatusPair = _pickFirstStringValue(cart, [
      'status',
      'paymentStatus',
      'payment_status',
    ]);
    if (cartStatusPair.isNotEmpty) {
      statusSummaryParts.add('cart.$cartStatusPair');
    }

    results.add(
      FlowResult(
        '2a) payment status fields',
        true,
        statusSummaryParts.isEmpty
            ? 'No status/payment keys found'
            : statusSummaryParts.join(' | '),
      ),
    );

    final noteKeys = [
      'deliveryNote',
      'delivery_note',
      'note',
      'notes',
      'instruction',
      'instructions',
      'specialInstruction',
      'specialInstructions',
      'remark',
      'remarks',
      'comment',
      'comments',
      'message',
    ];
    final notePair = _pickFirstStringValueFromKnownContainers(
      orderDetails,
      noteKeys,
    );
    results.add(
      FlowResult(
        '2b) delivery partner note',
        notePair.isNotEmpty,
        notePair.isNotEmpty ? notePair : 'No note field found in response',
      ),
    );
  } catch (e) {
    results.add(FlowResult('2) getSpecificOrderDetails', false, e.toString()));
    _printReport(baseUrl, results);
    exitCode = 1;
    return;
  }

  final destLat = _toDouble(_asMap(orderDetails['address'])['latitude']);
  final destLng = _toDouble(_asMap(orderDetails['address'])['longitude']);
  if (destLat == null || destLng == null) {
    results.add(
      FlowResult(
        '3) openMaps',
        false,
        'Missing address latitude/longitude in order details',
      ),
    );
  } else {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving';
    results.add(FlowResult('3) openMaps', true, url));
  }

  try {
    final latToSend = destLat ?? 24.578961;
    final lngToSend = destLng ?? 73.689943;
    final resp = await _postWrapped(dio, '/verifyDeliveryLocation', {
      'orderId': orderId.toString(),
      'type': orderType,
      'currentLat': latToSend.toString(),
      'currentLng': lngToSend.toString(),
    });
    final rc = _returnCode(resp);
    if (rc != 0) {
      results.add(
        FlowResult(
          '4) verifyDeliveryLocation (At Destination)',
          false,
          'returnCode=$rc ${_description(resp)}',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    results.add(
      FlowResult(
        '4) verifyDeliveryLocation (At Destination)',
        true,
        _description(resp),
      ),
    );
  } catch (e) {
    results.add(
      FlowResult(
        '4) verifyDeliveryLocation (At Destination)',
        false,
        e.toString(),
      ),
    );
    _printReport(baseUrl, results);
    exitCode = 1;
    return;
  }

  List<String> uploadedUrls = [];
  try {
    final proofPath =
        (Platform.environment['PROOF_IMAGE_PATH'] ??
                'assets/images/DeliveryAppIcon.png')
            .trim();
    final proofFile = File(proofPath);
    if (!await proofFile.exists()) {
      results.add(
        FlowResult(
          '5) uploadProofImages',
          false,
          'File not found: $proofPath (set PROOF_IMAGE_PATH)',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }

    final resp = await _postMultipartFiles(dio, '/uploadProofImages', [
      proofPath,
    ]);
    final rc = _returnCode(resp);
    if (rc != 0) {
      results.add(
        FlowResult(
          '5) uploadProofImages',
          false,
          'returnCode=$rc ${_description(resp)}',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    uploadedUrls = _extractUploadedUrls(resp['data']);
    if (uploadedUrls.isEmpty) {
      results.add(
        FlowResult('5) uploadProofImages', false, 'No uploaded URLs returned'),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    results.add(
      FlowResult(
        '5) uploadProofImages',
        true,
        'uploadedUrls=${uploadedUrls.length}',
      ),
    );
  } catch (e) {
    results.add(FlowResult('5) uploadProofImages', false, e.toString()));
    _printReport(baseUrl, results);
    exitCode = 1;
    return;
  }

  try {
    final latToSend = destLat ?? 24.578961;
    final lngToSend = destLng ?? 73.689943;
    final resp = await _postWrapped(dio, '/submitOrderProof', {
      'orderId': orderId.toString(),
      'type': orderType,
      'currentLat': latToSend.toString(),
      'currentLng': lngToSend.toString(),
      'uploadedFileUrls': uploadedUrls,
    });
    final rc = _returnCode(resp);
    if (rc != 0) {
      results.add(
        FlowResult(
          '6) submitOrderProof (Confirm Order)',
          false,
          'returnCode=$rc ${_description(resp)}',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    results.add(
      FlowResult(
        '6) submitOrderProof (Confirm Order)',
        true,
        _description(resp),
      ),
    );
  } catch (e) {
    results.add(
      FlowResult('6) submitOrderProof (Confirm Order)', false, e.toString()),
    );
    _printReport(baseUrl, results);
    exitCode = 1;
    return;
  }

  String serverMode = 'CASH';
  try {
    final resp = await _postWrapped(dio, '/checkOrderPaymentMode', {
      'orderId': orderId.toString(),
      'type': orderType,
    });
    final rc = _returnCode(resp);
    if (rc != 0) {
      results.add(
        FlowResult(
          '7) checkOrderPaymentMode',
          false,
          'returnCode=$rc ${_description(resp)}',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    final data = _asMap(resp['data']);
    serverMode = _normalizePaymentMethod(data['paymentMode']?.toString());
    results.add(
      FlowResult(
        '7) checkOrderPaymentMode',
        true,
        'serverMode=$serverMode raw=${data['paymentMode']}',
      ),
    );
  } catch (e) {
    results.add(FlowResult('7) checkOrderPaymentMode', false, e.toString()));
    _printReport(baseUrl, results);
    exitCode = 1;
    return;
  }

  if (serverMode == 'ONLINE') {
    results.add(
      FlowResult(
        '8) completeDeliveryPayment',
        true,
        'Skipped: serverMode=ONLINE',
      ),
    );
    _printReport(baseUrl, results);
    return;
  }

  try {
    final resp = await _postWrapped(dio, '/completeDeliveryPayment', {
      'orderId': orderId.toString(),
      'paymentMethod': 'CASH',
    });
    final rc = _returnCode(resp);
    if (rc != 0) {
      results.add(
        FlowResult(
          '8) completeDeliveryPayment (POD/Cash)',
          false,
          'returnCode=$rc ${_description(resp)}',
        ),
      );
      _printReport(baseUrl, results);
      exitCode = 1;
      return;
    }
    results.add(
      FlowResult(
        '8) completeDeliveryPayment (POD/Cash)',
        true,
        _description(resp),
      ),
    );
  } catch (e) {
    results.add(
      FlowResult('8) completeDeliveryPayment (POD/Cash)', false, e.toString()),
    );
    _printReport(baseUrl, results);
    exitCode = 1;
    return;
  }

  _printReport(baseUrl, results);
}

void _printReport(String baseUrl, List<FlowResult> results) {
  stdout.writeln('Delivery Flow Test');
  stdout.writeln('BASE_URL: $baseUrl');
  stdout.writeln('');
  for (final r in results) {
    final status = r.ok ? 'PASS' : 'FAIL';
    stdout.writeln('$status  ${r.name}');
    stdout.writeln('      ${r.detail}');
  }
}
