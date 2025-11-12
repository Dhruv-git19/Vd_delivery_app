class SpecificDeliveryResponse {
  final int deliveryId;
  final int orderId;
  final String type;
  final Customer? customer;
  final DeliveryPartner? deliveryPartner;
  final OrderDetails? orderDetails;
  final DeliveryDetails? deliveryDetails;
  final DeliveryAddress? address;
  final DeliveryProof? deliveryProof;

  SpecificDeliveryResponse({
    required this.deliveryId,
    required this.orderId,
    required this.type,
    this.customer,
    this.deliveryPartner,
    this.orderDetails,
    this.deliveryDetails,
    this.address,
    this.deliveryProof,
  });

  factory SpecificDeliveryResponse.fromJson(Map<String, dynamic> json) {
    return SpecificDeliveryResponse(
      deliveryId: json['deliveryId'] as int? ?? 0,
      orderId: json['orderId'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      deliveryPartner: json['deliveryPartner'] != null
          ? DeliveryPartner.fromJson(
              json['deliveryPartner'] as Map<String, dynamic>,
            )
          : null,
      orderDetails: json['orderDetails'] != null
          ? OrderDetails.fromJson(json['orderDetails'] as Map<String, dynamic>)
          : null,
      deliveryDetails: json['deliveryDetails'] != null
          ? DeliveryDetails.fromJson(
              json['deliveryDetails'] as Map<String, dynamic>,
            )
          : null,
      address: json['address'] != null
          ? DeliveryAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      deliveryProof: json['deliveryProof'] != null
          ? DeliveryProof.fromJson(
              json['deliveryProof'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class Customer {
  final int id;
  final String fullName;
  final String mobileNumber;
  final String emailId;

  Customer({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.emailId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      emailId: json['emailId'] as String? ?? '',
    );
  }
}

class DeliveryPartner {
  final int id;
  final String fullName;
  final String mobileNumber;
  final String emailId;

  DeliveryPartner({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.emailId,
  });

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      emailId: json['emailId'] as String? ?? '',
    );
  }
}

class OrderDetails {
  final String totalAmount;
  final String orderStatus;
  final Cart? cart;

  OrderDetails({
    required this.totalAmount,
    required this.orderStatus,
    this.cart,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      totalAmount: json['totalAmount']?.toString() ?? '0',
      orderStatus: json['orderStatus'] as String? ?? '',
      cart: json['cart'] != null
          ? Cart.fromJson(json['cart'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Cart {
  final int id;
  final String totalPrice;
  final String status;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as int? ?? 0,
      totalPrice: json['totalPrice']?.toString() ?? '0',
      status: json['status'] as String? ?? '',
      items:
          (json['items'] as List?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CartItem {
  final int id;
  final int productId;
  final String productName;
  final String productDescription;
  final List<ProductImage> productImages;
  final int variantId;
  final String variantName;
  final int quantity;
  final String unitPrice;
  final String totalPrice;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.variantId,
    required this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int? ?? 0,
      productId: json['productId'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      productDescription: json['productDescription'] as String? ?? '',
      productImages:
          (json['productImages'] as List?)
              ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variantId: json['variantId'] as int? ?? 0,
      variantName: json['variantName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: json['unitPrice']?.toString() ?? '0',
      totalPrice: json['totalPrice']?.toString() ?? '0',
    );
  }
}

class ProductImage {
  final int id;
  final String imageUrl;

  ProductImage({required this.id, required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}

class DeliveryDetails {
  final String status;
  final String? assignedOn;
  final String? deliveryDate;
  final String? completedOn;

  DeliveryDetails({
    required this.status,
    this.assignedOn,
    this.deliveryDate,
    this.completedOn,
  });

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryDetails(
      status: json['status'] as String? ?? '',
      assignedOn: json['assignedOn'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      completedOn: json['completedOn'] as String?,
    );
  }
}

class DeliveryAddress {
  final int id;
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double? latitude;
  final double? longitude;

  DeliveryAddress({
    required this.id,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'] as int? ?? 0,
      fullAddress: json['fullAddress'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }
}

class DeliveryProof {
  final int id;
  final List<String> proofUrls;
  final String? latitude;
  final String? longitude;
  final int? distanceMeters;
  final int? exchangeBottles;
  final String? submittedOn;

  DeliveryProof({
    required this.id,
    required this.proofUrls,
    this.latitude,
    this.longitude,
    this.distanceMeters,
    this.exchangeBottles,
    this.submittedOn,
  });

  factory DeliveryProof.fromJson(Map<String, dynamic> json) {
    return DeliveryProof(
      id: json['id'] as int? ?? 0,
      proofUrls: (json['proofUrls'] as List?)?.cast<String>() ?? [],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      distanceMeters: json['distanceMeters'] as int?,
      exchangeBottles: json['exchangeBottles'] as int?,
      submittedOn: json['submittedOn'] as String?,
    );
  }
}
