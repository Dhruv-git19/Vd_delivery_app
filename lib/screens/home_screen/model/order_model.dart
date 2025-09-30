class OrdersResponse {
  final List<Order> orders;
  final OptimizedRoute? optimizedRoute;

  OrdersResponse({required this.orders, this.optimizedRoute});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders: (json['orders'] as List?)?.map((e) => Order.fromJson(e)).toList() ?? [],
      optimizedRoute: json['optimizedRoute'] != null ? OptimizedRoute.fromJson(json['optimizedRoute']) : null,
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
  final String? address;
  final String? distanceInfo;

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
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      totalAmount: json['totalAmount'] ?? '',
      status: json['status'] ?? '',
      createdOn: json['createdOn'] ?? '',
      cart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
      deliveryPartners: (json['deliveryPartners'] as List?)?.map((e) => DeliveryPartner.fromJson(e)).toList() ?? [],
      type: json['type'] ?? '',
      address: json['address'],
      distanceInfo: json['distanceInfo'],
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
      steps: (json['steps'] as List?)?.map((e) => Step.fromJson(e)).toList() ?? [],
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
    return Distance(
      text: json['text'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class DurationValue {
  final String text;
  final int value;

  DurationValue({required this.text, required this.value});

  factory DurationValue.fromJson(Map<String, dynamic> json) {
    return DurationValue(
      text: json['text'] ?? '',
      value: json['value'] ?? 0,
    );
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
