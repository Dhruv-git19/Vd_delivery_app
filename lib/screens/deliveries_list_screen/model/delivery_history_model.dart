class DeliveryHistoryResponse {
  final List<Delivery> deliveries;
  final Pagination? pagination;
  final Summary? summary;

  DeliveryHistoryResponse({
    required this.deliveries,
    this.pagination,
    this.summary,
  });

  factory DeliveryHistoryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryHistoryResponse(
      deliveries:
          (json['deliveries'] as List?)
              ?.map((e) => Delivery.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
      summary: json['summary'] != null
          ? Summary.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Delivery {
  final int deliveryId;
  final int orderId;
  final String type;
  final int customerId;
  final String customerName;
  final String customerMobile;
  final String totalAmount;
  final String orderStatus;
  final String deliveryStatus;
  final String? assignedOn;
  final String? deliveryDate;
  final String? completedOn;
  final Address? address;
  final List<DeliveryItem> items;
  final int itemCount;

  Delivery({
    required this.deliveryId,
    required this.orderId,
    required this.type,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.totalAmount,
    required this.orderStatus,
    required this.deliveryStatus,
    this.assignedOn,
    this.deliveryDate,
    this.completedOn,
    this.address,
    required this.items,
    required this.itemCount,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      deliveryId: json['deliveryId'] as int? ?? 0,
      orderId: json['orderId'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      customerId: json['customerId'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? '',
      customerMobile: json['customerMobile'] as String? ?? '',
      totalAmount: json['totalAmount']?.toString() ?? '0',
      orderStatus: json['orderStatus'] as String? ?? '',
      deliveryStatus: json['deliveryStatus'] as String? ?? '',
      assignedOn: json['assignedOn'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      completedOn: json['completedOn'] as String?,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      items:
          (json['items'] as List?)
              ?.map((e) => DeliveryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemCount: json['itemCount'] as int? ?? 0,
    );
  }
}

class Address {
  final String fullAddress;
  final String city;
  final String state;
  final String postalCode;

  Address({
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fullAddress: json['fullAddress'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
    );
  }
}

class DeliveryItem {
  final int productId;
  final String productName;
  final int variantId;
  final String variantName;
  final int quantity;
  final String price;
  final String totalPrice;

  DeliveryItem({
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.variantName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      productId: json['productId'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      variantId: json['variantId'] as int? ?? 0,
      variantName: json['variantName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      price: json['price']?.toString() ?? '0',
      totalPrice: json['totalPrice']?.toString() ?? '0',
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  Pagination({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}

class Summary {
  final int totalDeliveries;
  final int completedDeliveries;
  final int pendingDeliveries;
  final int cartDeliveries;
  final int subscriptionDeliveries;

  Summary({
    required this.totalDeliveries,
    required this.completedDeliveries,
    required this.pendingDeliveries,
    required this.cartDeliveries,
    required this.subscriptionDeliveries,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalDeliveries: json['totalDeliveries'] as int? ?? 0,
      completedDeliveries: json['completedDeliveries'] as int? ?? 0,
      pendingDeliveries: json['pendingDeliveries'] as int? ?? 0,
      cartDeliveries: json['cartDeliveries'] as int? ?? 0,
      subscriptionDeliveries: json['subscriptionDeliveries'] as int? ?? 0,
    );
  }
}
