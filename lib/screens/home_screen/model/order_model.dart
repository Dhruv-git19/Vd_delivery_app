class OrdersResponse {
  final List<Order> orders;
  final OptimizedRoute? optimizedRoute;

  OrdersResponse({required this.orders, this.optimizedRoute});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders:
          (json['orders'] as List?)?.map((e) => Order.fromJson(e)).toList() ??
          [],
      optimizedRoute: json['optimizedRoute'] != null
          ? OptimizedRoute.fromJson(json['optimizedRoute'])
          : null,
    );
  }
}

class Order {
  final int id;
  final int userId;
  final String totalAmount;
    final String status;
  final String createdOn;
  final Cart? cart;
  final List<DeliveryPartner> deliveryPartners;
  final String type;
  final Address? address;
  final DistanceInfo? distanceInfo;
  final String? customerName;
  final String? productIds;
  final String? subscriptionType;
  final String? startDate;
  final String? endDate;
  final dynamic deliveryDays; 
  final dynamic deliveryDates; 
  final UserDetails? userDetails;
  final DeliveryPartnerDetails? deliveryPartnerDetails;

  Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdOn,
    this.cart,
    required this.deliveryPartners,
    required this.type,
    this.address,
    this.distanceInfo,
    this.customerName,
    this.productIds,
    this.subscriptionType,
    this.startDate,
    this.endDate,
    this.deliveryDays,
    this.deliveryDates,
    this.userDetails,
    this.deliveryPartnerDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      totalAmount: json['totalAmount'] ?? '',
      status: json['status'] != null ? json['status'].toString() : '',
      createdOn: json['createdOn'] ?? '',
      cart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
      deliveryPartners:
          (json['deliveryPartners'] as List?)
              ?.map((e) => DeliveryPartner.fromJson(e))
              .toList() ??
          [],
      type: json['type'] ?? '',
      address: json['address'] != null && json['address'] is Map
          ? Address.fromJson(json['address'])
          : null,
      distanceInfo: json['distanceInfo'] != null && json['distanceInfo'] is Map
          ? DistanceInfo.fromJson(json['distanceInfo'])
          : null,
      userDetails: json['userDetails'] != null && json['userDetails'] is Map
          ? UserDetails.fromJson(json['userDetails'])
          : null,
      deliveryPartnerDetails:
          json['deliveryPartnerDetails'] != null &&
              json['deliveryPartnerDetails'] is Map
          ? DeliveryPartnerDetails.fromJson(json['deliveryPartnerDetails'])
          : null,

      customerName: json['customerName'] ?? json['customer_name'] ?? null,
      productIds: json['productIds'] ?? null,
      subscriptionType: json['subscriptionType'] ?? null,
      startDate: json['startDate'] ?? null,
      endDate: json['endDate'] ?? null,
      deliveryDays: json['deliveryDays'],
      deliveryDates: json['deliveryDates'],
    );
  }
}

class Address {
  final int? id;
  final int? userId;
  final String? fullAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? latitude;
  final String? longitude;
  final String? postalCode;
  final bool? isDefault;
  final String? createdOn;
  final dynamic createdBy;
  final dynamic updatedOn;
  final dynamic updatedBy;
  final int? isDeleted;
  final dynamic deletedOn;
  final dynamic deletedBy;

  Address({
    this.id,
    this.userId,
    this.fullAddress,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.postalCode,
    this.isDefault,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.isDeleted,
    this.deletedOn,
    this.deletedBy,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['userId'],
      fullAddress: json['fullAddress'] ?? json['full_address'] ?? null,
      city: json['city'] ?? null,
      state: json['state'] ?? null,
      country: json['country'] ?? null,
      latitude: json['latitude']?.toString() ?? null,
      longitude: json['longitude']?.toString() ?? null,
      postalCode: json['postalCode'] ?? null,
      isDefault: json['isDefault'] ?? null,
      createdOn: json['createdOn'] ?? null,
      createdBy: json['createdBy'] ?? json['createdby'] ?? null,
      updatedOn: json['updatedOn'] ?? json['updatedon'] ?? null,
      updatedBy: json['updatedBy'] ?? json['updatedby'] ?? null,
      isDeleted: json['isDeleted'] ?? json['isdeleted'] ?? null,
      deletedOn: json['deletedOn'] ?? json['deletedon'] ?? null,
      deletedBy: json['deletedBy'] ?? json['deletedby'] ?? null,
    );
  }
}

class DistanceInfo {
  final String? distance;
  final String? duration;
  final int? distanceValue;
  final int? durationValue;

  DistanceInfo({
    this.distance,
    this.duration,
    this.distanceValue,
    this.durationValue,
  });

  factory DistanceInfo.fromJson(Map<String, dynamic> json) {
    return DistanceInfo(
      distance: json['distance'] ?? null,
      duration: json['duration'] ?? null,
      distanceValue: json['distanceValue'] ?? null,
      durationValue: json['durationValue'] ?? null,
    );
  }
}

class UserDetails {
  final int? id;
  final String? fullName;
  final String? emailId;
  final String? mobileNumber;

  UserDetails({this.id, this.fullName, this.emailId, this.mobileNumber});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      fullName: json['full_name'] ?? json['fullName'] ?? null,
      emailId: json['email_id'] ?? json['emailId'] ?? null,
      mobileNumber: json['mobile_number'] ?? json['mobileNumber'] ?? null,
    );
  }
}

class DeliveryPartnerDetails {
  final int? id;
  final String? fullName;
  final String? emailId;
  final String? mobileNumber;

  DeliveryPartnerDetails({
    this.id,
    this.fullName,
    this.emailId,
    this.mobileNumber,
  });

  factory DeliveryPartnerDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryPartnerDetails(
      id: json['id'],
      fullName: json['full_name'] ?? json['fullName'] ?? null,
      emailId: json['email_id'] ?? json['emailId'] ?? null,
      mobileNumber: json['mobile_number'] ?? json['mobileNumber'] ?? null,
    );
  }
}

class Cart {
  final int id;
  final int userId;
  final String status;
  final String totalPrice;
  final String createdon;
  final dynamic createdby;
  final dynamic updatedon;
  final dynamic updatedby;
  final int isdeleted;
  final dynamic deletedon;
  final dynamic deletedby;

  Cart({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.createdon,
    this.createdby,
    this.updatedon,
    this.updatedby,
    required this.isdeleted,
    this.deletedon,
    this.deletedby,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      status: json['status'] ?? '',
      totalPrice: json['totalPrice'] ?? '',
      createdon: json['createdon'] ?? '',
      createdby: json['createdby'],
      updatedon: json['updatedon'],
      updatedby: json['updatedby'],
      isdeleted: json['isdeleted'] ?? 0,
      deletedon: json['deletedon'],
      deletedby: json['deletedby'],
    );
  }
}

class DeliveryPartner {
  final int id;
  final int deliveryPartnerId;
  final String status;
  final String assignedOn;

  DeliveryPartner({
    required this.id,
    required this.deliveryPartnerId,
    required this.status,
    required this.assignedOn,
  });

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id'],
      deliveryPartnerId: json['deliveryPartnerId'],
      status: json['status'] ?? '',
      assignedOn: json['assignedOn'] ?? '',
    );
  }
}

class OptimizedRoute {
  final List<dynamic> waypointOrder;
  final String overviewPolyline;
  final List<Leg> legs;
  final int totalDistance;
  final int totalDuration;

  OptimizedRoute({
    required this.waypointOrder,
    required this.overviewPolyline,
    required this.legs,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory OptimizedRoute.fromJson(Map<String, dynamic> json) {
    return OptimizedRoute(
      waypointOrder: json['waypointOrder'] ?? [],
      overviewPolyline: json['overviewPolyline'] ?? '',
      legs: (json['legs'] as List?)?.map((e) => Leg.fromJson(e)).toList() ?? [],
      totalDistance: json['totalDistance'] ?? 0,
      totalDuration: json['totalDuration'] ?? 0,
    );
  }
}

class Leg {
  final Distance distance;
  final DurationValue duration;
  final String endAddress;
  final Location endLocation;
  final String startAddress;
  final Location startLocation;
  final List<Step> steps;
  final List<dynamic> trafficSpeedEntry;
  final List<dynamic> viaWaypoint;

  Leg({
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,
    required this.steps,
    required this.trafficSpeedEntry,
    required this.viaWaypoint,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      distance: Distance.fromJson(json['distance']),
      duration: DurationValue.fromJson(json['duration']),
      endAddress: json['end_address'] ?? '',
      endLocation: Location.fromJson(json['end_location']),
      startAddress: json['start_address'] ?? '',
      startLocation: Location.fromJson(json['start_location']),
      steps:
          (json['steps'] as List?)?.map((e) => Step.fromJson(e)).toList() ?? [],
      trafficSpeedEntry: json['traffic_speed_entry'] ?? [],
      viaWaypoint: json['via_waypoint'] ?? [],
    );
  }
}

class Distance {
  final String text;
  final int value;

  Distance({required this.text, required this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(text: json['text'] ?? '', value: json['value'] ?? 0);
  }
}

class DurationValue {
  final String text;
  final int value;

  DurationValue({required this.text, required this.value});

  factory DurationValue.fromJson(Map<String, dynamic> json) {
    return DurationValue(text: json['text'] ?? '', value: json['value'] ?? 0);
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Step {
  final Distance distance;
  final DurationValue duration;
  final Location endLocation;
  final String htmlInstructions;
  final Polyline polyline;
  final Location startLocation;
  final String travelMode;

  Step({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.polyline,
    required this.startLocation,
    required this.travelMode,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      distance: Distance.fromJson(json['distance']),
      duration: DurationValue.fromJson(json['duration']),
      endLocation: Location.fromJson(json['end_location']),
      htmlInstructions: json['html_instructions'] ?? '',
      polyline: Polyline.fromJson(json['polyline']),
      startLocation: Location.fromJson(json['start_location']),
      travelMode: json['travel_mode'] ?? '',
    );
  }
}

class Polyline {
  final String points;

  Polyline({required this.points});

  factory Polyline.fromJson(Map<String, dynamic> json) {
    return Polyline(points: json['points'] ?? '');
  }
}
