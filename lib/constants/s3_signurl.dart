import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:s3_storage/s3_storage.dart';

final Map<String, String> signedUrls = {};

Future<String> generateSignedUrl(String rawS3Url) async {
  final raw = rawS3Url.trim();
  if (raw.isEmpty) return "";
  final cached = signedUrls[raw];
  if (cached != null && cached.isNotEmpty) return cached;

  try {
    final uri = Uri.tryParse(raw);
    if (uri != null &&
        uri.hasQuery &&
        uri.queryParameters.keys.any((k) => k.startsWith('X-Amz-'))) {
      signedUrls[raw] = raw;
      return raw;
    }

    String objectKey;
    if (uri == null || !uri.hasScheme) {
      objectKey = raw;
    } else if (uri.scheme == 's3') {
      objectKey = uri.path;
    } else if (uri.scheme == 'http' || uri.scheme == 'https') {
      final host = uri.host.toLowerCase();
      final isS3Host = host.contains('amazonaws.com') || host.contains('s3');
      if (!isS3Host) {
        signedUrls[raw] = raw;
        return raw;
      }
      objectKey = uri.path;
    } else {
      objectKey = uri.path;
    }

    objectKey = objectKey.split('?').first;
    while (objectKey.startsWith('/')) {
      objectKey = objectKey.substring(1);
    }

    if (objectKey.isEmpty) {
      throw Exception("Invalid S3 URL");
    }

    final region = dotenv.env['AWS_REGION']!;
    final bucket = dotenv.env['S3_BUCKET']!;
    final accessKey = dotenv.env['AWS_ACCESS_KEY_ID']!;
    final secretKey = dotenv.env['AWS_SECRET_ACCESS_KEY']!;

    final s3Storage = S3Storage(
      endPoint: "s3.$region.amazonaws.com",
      accessKey: accessKey,
      secretKey: secretKey,
      region: region,
    );

    final presignedUrl = await s3Storage.presignedGetObject(
      bucket,
      objectKey,
      expires: 300,
    );

    signedUrls[raw] = presignedUrl;
    return presignedUrl;
  } catch (e) {
    log("Error generating signed URL: $e");
    return "";
  }
}
