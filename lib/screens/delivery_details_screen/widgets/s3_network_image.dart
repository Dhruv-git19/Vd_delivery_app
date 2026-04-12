import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/constants/s3_signurl.dart';

class S3NetworkImage extends StatefulWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const S3NetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<S3NetworkImage> createState() => _S3NetworkImageState();
}

class _S3NetworkImageState extends State<S3NetworkImage> {
  String? signedUrl;
  bool isLoading = true;
  bool hasError = false;

  String _directIfHttpUrl(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return '';
    if (uri.scheme == 'http' || uri.scheme == 'https') return raw.trim();
    return '';
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant S3NetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        signedUrl = null;
        isLoading = true;
        hasError = false;
      });
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    try {
      final raw = widget.imageUrl!.trim();
      final url = await generateSignedUrl(raw);
      final resolved = url.isNotEmpty ? url : _directIfHttpUrl(raw);
      if (mounted) {
        setState(() {
          signedUrl = resolved;
          isLoading = false;
          hasError = resolved.isEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        final raw = widget.imageUrl!.trim();
        final resolved = _directIfHttpUrl(raw);
        setState(() {
          signedUrl = resolved.isNotEmpty ? resolved : null;
          hasError = resolved.isEmpty;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        width: widget.width ?? 48,
        height: widget.height ?? 48,
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (hasError || signedUrl == null || signedUrl!.isEmpty) {
      return Container(
        width: widget.width ?? 48,
        height: widget.height ?? 48,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return Image.network(
      signedUrl!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: widget.width ?? 48,
          height: widget.height ?? 48,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.width ?? 48,
          height: widget.height ?? 48,
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }
}
