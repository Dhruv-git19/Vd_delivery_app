import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/route_navigation_screen/provider/route_navigation_provider.dart';

class RouteNavigationScreen extends StatefulWidget {
  const RouteNavigationScreen({super.key});

  @override
  State<RouteNavigationScreen> createState() => _RouteNavigationScreenState();
}

class _RouteNavigationScreenState extends State<RouteNavigationScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  late final double warehouseLat;
  late final double warehouseLng;

  @override
  void initState() {
    super.initState();
    warehouseLat = double.parse(dotenv.env['WAREHOUSE_LAT'] ?? '28.6139');
    warehouseLng = double.parse(dotenv.env['WAREHOUSE_LNG'] ?? '77.2090');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RouteNavigationProvider>(
        context,
        listen: false,
      ).fetchTodaysOrders(context);
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _updateMap();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  void _updateMap() {
    final provider = Provider.of<RouteNavigationProvider>(
      context,
      listen: false,
    );
    final nextOrder = provider.nextOrder;

    _markers.clear();
    _polylines.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    // Add warehouse marker
    _markers.add(
      Marker(
        markerId: const MarkerId('warehouse'),
        position: LatLng(warehouseLat, warehouseLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Warehouse'),
      ),
    );

    // Add next delivery marker
    if (nextOrder != null && nextOrder.address != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('delivery_${nextOrder.id}'),
          position: LatLng(
            nextOrder.address!.latitude!,
            nextOrder.address!.longitude!,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: nextOrder.userDetails?.fullName ?? 'Delivery',
            snippet: nextOrder.address!.fullAddress,
          ),
        ),
      );

      // Draw polyline from current location to next delivery
      if (_currentPosition != null) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              LatLng(
                nextOrder.address!.latitude!,
                nextOrder.address!.longitude!,
              ),
            ],
            color: primaryColor,
            width: 4,
          ),
        );
      }

      // Move camera to show all markers
      _fitMarkersInView();
    }

    setState(() {});
  }

  void _fitMarkersInView() {
    if (_mapController == null || _markers.isEmpty) return;

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (var marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Route'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<RouteNavigationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || _isLoadingLocation) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.r, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading route',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchTodaysOrders(context);
                      _getCurrentLocation();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64.r,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No deliveries with valid addresses',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final nextOrder = provider.nextOrder;

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition != null
                      ? LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        )
                      : LatLng(warehouseLat, warehouseLng),
                  zoom: 12,
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                  _updateMap();
                },
              ),

              // Bottom card showing next delivery
              if (nextOrder != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildDeliveryCard(nextOrder, provider),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeliveryCard(nextOrder, RouteNavigationProvider provider) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Delivery ${provider.currentOrderIndex + 1}/${provider.orders.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${nextOrder.type.toUpperCase()}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            nextOrder.userDetails?.fullName ?? 'Unknown Customer',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AllColors.deliverydetailfontColor,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on, size: 16.r, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  nextOrder.address?.fullAddress ?? 'No address',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (nextOrder.distanceInfo != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.navigation, size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    nextOrder.distanceInfo!.distance,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(Icons.access_time, size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    nextOrder.distanceInfo!.duration,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      AppRoutes.deliveryDetailsScreen,
                      extra: {'id': nextOrder.id, 'type': nextOrder.type},
                    );
                  },
                  icon: Icon(Icons.info_outline, size: 18.r),
                  label: Text(
                    'View Details',
                    style: TextStyle(fontSize: 13.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 8.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: provider.hasNextOrder
                      ? () {
                          provider.moveToNextOrder();
                          _updateMap();
                        }
                      : null,
                  icon: Icon(Icons.arrow_forward, size: 18.r),
                  label: Text(
                    'Next Stop',
                    style: TextStyle(fontSize: 13.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 8.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
