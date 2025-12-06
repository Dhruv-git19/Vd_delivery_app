class RouteOrdersResponse {
  final List<RouteOrder> orders;
  final dynamic optimizedRoute;

  RouteOrdersResponse({required this.orders, this.optimizedRoute});

  factory RouteOrdersResponse.fromJson(Map<String, dynamic> json) {
    return RouteOrdersResponse(
      orders:
          (json['orders'] as List?)
              ?.map((e) => RouteOrder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      optimizedRoute: json['optimizedRoute'],
    );
  }
}

class RouteOrder {
  final int id;
  final String type;
  final RouteAddress? address;
  final RouteDistanceInfo? distanceInfo;
  final RouteUserDetails? userDetails;
  final String? status;
  final String? totalAmount;

  RouteOrder({
    required this.id,
    required this.type,
    this.address,
    this.distanceInfo,
    this.userDetails,
    this.status,
    this.totalAmount,
  });

  factory RouteOrder.fromJson(Map<String, dynamic> json) {
    return RouteOrder(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      address: json['address'] != null
          ? RouteAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      distanceInfo: json['distanceInfo'] != null
          ? RouteDistanceInfo.fromJson(
              json['distanceInfo'] as Map<String, dynamic>,
            )
          : null,
      userDetails: json['userDetails'] != null
          ? RouteUserDetails.fromJson(
              json['userDetails'] as Map<String, dynamic>,
            )
          : null,
      status: json['status'] as String?,
      totalAmount: json['totalAmount']?.toString(),
    );
  }

  bool get hasValidAddress {
    return address != null &&
        address!.latitude != null &&
        address!.longitude != null;
  }
}

class RouteAddress {
  final int id;
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double? latitude;
  final double? longitude;

  RouteAddress({
    required this.id,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
  });

  factory RouteAddress.fromJson(Map<String, dynamic> json) {
    double? parseLat(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    String parsePostalCode(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is int) return value.toString();
      return value.toString();
    }

    String parseString(dynamic value, String defaultValue) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return RouteAddress(
      id: parseInt(json['id']),
      fullAddress: parseString(json['fullAddress'], ''),
      city: parseString(json['city'], ''),
      state: parseString(json['state'], ''),
      country: parseString(json['country'], ''),
      postalCode: parsePostalCode(json['postalCode']),
      latitude: parseLat(json['latitude']),
      longitude: parseLat(json['longitude']),
    );
  }
}

class RouteDistanceInfo {
  final String distance;
  final String duration;

  RouteDistanceInfo({required this.distance, required this.duration});

  factory RouteDistanceInfo.fromJson(Map<String, dynamic> json) {
    return RouteDistanceInfo(
      distance: json['distance'] as String? ?? 'N/A',
      duration: json['duration'] as String? ?? 'N/A',
    );
  }
}

class RouteUserDetails {
  final int id;
  final String fullName;
  final String? mobileNumber;

  RouteUserDetails({
    required this.id,
    required this.fullName,
    this.mobileNumber,
  });

  factory RouteUserDetails.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse mobile number
    String? parseMobileNumber(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is int) return value.toString();
      return value.toString();
    }

    return RouteUserDetails(
      id: json['id'] as int? ?? 0,
      fullName: json['full_name'] as String? ?? 'Unknown',
      mobileNumber: parseMobileNumber(json['mobile_number']),
    );
  }
}
