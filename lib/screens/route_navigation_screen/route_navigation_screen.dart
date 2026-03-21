import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/screens/route_navigation_screen/model/route_orders_model.dart';
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
  bool _isBuildingRoute = false;
  String? _routeBuiltFor;
  int? _routeDistanceMeters;
  int? _routeDurationSeconds;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _positionSubscription;
  final Set<int> _proximityNotifiedOrderIds = {};
  bool _isShowingProximityDialog = false;

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

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _startLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((position) {
          if (!mounted) return;
          _currentPosition = position;
          final provider = Provider.of<RouteNavigationProvider>(
            context,
            listen: false,
          );
          _maybeNotifyProximity(provider);
          _updateMap();
        }, onError: (_) {});
  }

  Future<void> _maybeNotifyProximity(RouteNavigationProvider provider) async {
    if (!mounted) return;
    if (_isShowingProximityDialog) return;
    if (_currentPosition == null) return;

    final nextOrder = provider.nextOrder;
    if (nextOrder == null || !nextOrder.hasValidAddress) return;
    if (_proximityNotifiedOrderIds.contains(nextOrder.id)) return;

    final destLat = nextOrder.address!.latitude!;
    final destLng = nextOrder.address!.longitude!;
    final distMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      destLat,
      destLng,
    );

    if (distMeters > 50) return;

    _proximityNotifiedOrderIds.add(nextOrder.id);
    _isShowingProximityDialog = true;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reached delivery location'),
          content: Text(
            'You are within 50 meters of stop ${provider.currentOrderIndex + 1}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    _isShowingProximityDialog = false;
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        // Use warehouse location as fallback
        setState(() {
          _currentPosition = Position(
            latitude: warehouseLat,
            longitude: warehouseLng,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
          _isLoadingLocation = false;
        });
        _updateMap();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          // Use warehouse location as fallback
          setState(() {
            _currentPosition = Position(
              latitude: warehouseLat,
              longitude: warehouseLng,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            );
            _isLoadingLocation = false;
          });
          _updateMap();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission permanently denied. Enable in settings.',
              ),
            ),
          );
        }
        // Use warehouse location as fallback
        setState(() {
          _currentPosition = Position(
            latitude: warehouseLat,
            longitude: warehouseLng,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
          _isLoadingLocation = false;
        });
        _updateMap();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      if (!mounted) return;
      final provider = Provider.of<RouteNavigationProvider>(
        context,
        listen: false,
      );
      _maybeNotifyProximity(provider);
      _startLocationTracking();
      _updateMap();
    } catch (e) {
      setState(() {
        // Use warehouse location as fallback on any error
        _currentPosition = Position(
          latitude: warehouseLat,
          longitude: warehouseLng,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Using warehouse location: $e')));
      }
      _updateMap();
    }
  }

  void _updateMap() {
    if (!mounted) return;

    final provider = Provider.of<RouteNavigationProvider>(
      context,
      listen: false,
    );
    final orders = provider.orders;

    _markers.clear();

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

    for (int i = 0; i < orders.length; i++) {
      final order = orders[i];
      if (!order.hasValidAddress) continue;
      final isCurrent = i == provider.currentOrderIndex;
      final isCompleted = i < provider.currentOrderIndex;
      final hue = isCurrent
          ? BitmapDescriptor.hueRed
          : isCompleted
          ? BitmapDescriptor.hueAzure
          : BitmapDescriptor.hueGreen;
      _markers.add(
        Marker(
          markerId: MarkerId('delivery_${order.id}'),
          position: LatLng(order.address!.latitude!, order.address!.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(
            title:
                'Stop ${i + 1}: ${order.userDetails?.fullName ?? 'Delivery'}',
            snippet: order.address!.fullAddress,
          ),
        ),
      );
    }

    _fitMarkersInView();

    if (mounted) {
      setState(() {});
    }
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

    if (minLat == maxLat && minLng == maxLng) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(minLat, minLng), 14.0),
      );
    } else {
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
  }

  Future<void> _maybeBuildRoute(RouteNavigationProvider provider) async {
    if (_isBuildingRoute) return;
    if (_currentPosition == null) return;
    if (provider.orders.isEmpty) return;

    final orderIds = provider.orders.map((e) => e.id).join(',');
    final routeKey = orderIds;
    if (_routeBuiltFor == routeKey) return;

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      _routeBuiltFor = routeKey;
      _routeDistanceMeters = null;
      _routeDurationSeconds = null;
      _buildStraightPolyline(provider);
      return;
    }

    setState(() {
      _isBuildingRoute = true;
    });

    try {
      final origin = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      final stops = provider.orders
          .where((o) => o.hasValidAddress)
          .map((o) => LatLng(o.address!.latitude!, o.address!.longitude!))
          .toList();

      final result = await _buildOptimizedRoute(
        apiKey: apiKey,
        origin: origin,
        stops: stops,
      );

      if (result.orderedStopIndices.isNotEmpty &&
          result.orderedStopIndices.length == provider.orders.length) {
        final optimizedOrders = [
          for (final idx in result.orderedStopIndices) provider.orders[idx],
        ];
        provider.setOptimizedOrder(optimizedOrders);
      }

      final newOrderIds = provider.orders.map((e) => e.id).join(',');
      _routeBuiltFor = newOrderIds;
      _routeDistanceMeters = result.distanceMeters;
      _routeDurationSeconds = result.durationSeconds;

      _polylines
        ..clear()
        ..add(
          Polyline(
            polylineId: const PolylineId('route_all'),
            points: result.polylinePoints,
            color: primaryColor,
            width: 4,
          ),
        );
    } catch (_) {
      _routeBuiltFor = routeKey;
      _routeDistanceMeters = null;
      _routeDurationSeconds = null;
      _buildStraightPolyline(provider);
    } finally {
      if (mounted) {
        setState(() {
          _isBuildingRoute = false;
        });
      }
      _updateMap();
    }
  }

  void _buildStraightPolyline(RouteNavigationProvider provider) {
    if (_currentPosition == null) return;
    final points = <LatLng>[
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ...provider.orders
          .where((o) => o.hasValidAddress)
          .map((o) => LatLng(o.address!.latitude!, o.address!.longitude!)),
    ];
    _polylines
      ..clear()
      ..add(
        Polyline(
          polylineId: const PolylineId('route_all'),
          points: points,
          color: primaryColor,
          width: 4,
        ),
      );
  }

  Future<_OptimizedRouteResult> _buildOptimizedRoute({
    required String apiKey,
    required LatLng origin,
    required List<LatLng> stops,
  }) async {
    if (stops.isEmpty) {
      return _OptimizedRouteResult(
        orderedStopIndices: const [],
        polylinePoints: [origin],
        distanceMeters: 0,
        durationSeconds: 0,
      );
    }

    const maxStopsPerSegment = 24;
    final allPolyline = <LatLng>[origin];
    final orderedIndices = <int>[];
    int totalMeters = 0;
    int totalSeconds = 0;

    LatLng currentOrigin = origin;
    int offset = 0;
    while (offset < stops.length) {
      final segmentStops = stops.skip(offset).take(maxStopsPerSegment).toList();
      final segment = await _fetchOptimizedSegment(
        apiKey: apiKey,
        origin: currentOrigin,
        stops: segmentStops,
      );

      totalMeters += segment.distanceMeters;
      totalSeconds += segment.durationSeconds;

      for (final p in segment.polylinePoints) {
        if (allPolyline.isEmpty ||
            allPolyline.last.latitude != p.latitude ||
            allPolyline.last.longitude != p.longitude) {
          allPolyline.add(p);
        }
      }

      for (final idx in segment.orderedStopIndices) {
        orderedIndices.add(offset + idx);
      }

      currentOrigin = segmentStops[segment.orderedStopIndices.last];
      offset += segmentStops.length;
    }

    return _OptimizedRouteResult(
      orderedStopIndices: orderedIndices,
      polylinePoints: allPolyline,
      distanceMeters: totalMeters,
      durationSeconds: totalSeconds,
    );
  }

  Future<_OptimizedRouteResult> _fetchOptimizedSegment({
    required String apiKey,
    required LatLng origin,
    required List<LatLng> stops,
  }) async {
    if (stops.length == 1) {
      final r = await _fetchDirections(
        apiKey: apiKey,
        origin: origin,
        destination: stops.first,
        waypoints: const [],
        optimize: false,
      );
      return _OptimizedRouteResult(
        orderedStopIndices: const [0],
        polylinePoints: r.polylinePoints,
        distanceMeters: r.distanceMeters,
        durationSeconds: r.durationSeconds,
      );
    }

    int destIndex = 0;
    double maxDist = -1;
    for (int i = 0; i < stops.length; i++) {
      final d = Geolocator.distanceBetween(
        origin.latitude,
        origin.longitude,
        stops[i].latitude,
        stops[i].longitude,
      );
      if (d > maxDist) {
        maxDist = d;
        destIndex = i;
      }
    }

    final destination = stops[destIndex];
    final waypoints = <LatLng>[];
    final waypointToStopIndex = <int>[];
    for (int i = 0; i < stops.length; i++) {
      if (i == destIndex) continue;
      waypoints.add(stops[i]);
      waypointToStopIndex.add(i);
    }

    final r = await _fetchDirections(
      apiKey: apiKey,
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      optimize: true,
    );

    final segmentOrder = <int>[];
    if (r.waypointOrder.isNotEmpty &&
        r.waypointOrder.length == waypointToStopIndex.length) {
      for (final wIdx in r.waypointOrder) {
        if (wIdx >= 0 && wIdx < waypointToStopIndex.length) {
          segmentOrder.add(waypointToStopIndex[wIdx]);
        }
      }
    } else {
      segmentOrder.addAll(waypointToStopIndex);
    }
    segmentOrder.add(destIndex);

    return _OptimizedRouteResult(
      orderedStopIndices: segmentOrder,
      polylinePoints: r.polylinePoints,
      distanceMeters: r.distanceMeters,
      durationSeconds: r.durationSeconds,
    );
  }

  Future<_DirectionsResult> _fetchDirections({
    required String apiKey,
    required LatLng origin,
    required LatLng destination,
    required List<LatLng> waypoints,
    required bool optimize,
  }) async {
    final dio = Dio();
    final waypointParam = waypoints.isEmpty
        ? null
        : [
            if (optimize) 'optimize:true',
            ...waypoints.map((p) => '${p.latitude},${p.longitude}'),
          ].join('|');

    final resp = await dio.get(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        if (waypointParam != null) 'waypoints': waypointParam,
        'mode': 'driving',
        'key': apiKey,
      },
    );

    final data = resp.data;
    if (data is! Map) {
      throw StateError('Invalid directions response');
    }

    final routes = data['routes'];
    if (routes is! List || routes.isEmpty) {
      throw StateError('No routes returned');
    }

    final first = routes.first;
    if (first is! Map) {
      throw StateError('Invalid route shape');
    }

    final overview = first['overview_polyline'];
    final encoded = overview is Map ? overview['points']?.toString() ?? '' : '';
    final points = encoded.isNotEmpty ? _decodePolyline(encoded) : <LatLng>[];

    final legs = first['legs'];
    int meters = 0;
    int seconds = 0;
    if (legs is List) {
      for (final leg in legs) {
        if (leg is! Map) continue;
        final dist = leg['distance'];
        final dur = leg['duration'];
        final distVal = dist is Map
            ? int.tryParse(dist['value']?.toString() ?? '')
            : null;
        final durVal = dur is Map
            ? int.tryParse(dur['value']?.toString() ?? '')
            : null;
        if (distVal != null) meters += distVal;
        if (durVal != null) seconds += durVal;
      }
    }

    final wo = first['waypoint_order'];
    final waypointOrder = <int>[];
    if (wo is List) {
      for (final item in wo) {
        final parsed = int.tryParse(item?.toString() ?? '');
        if (parsed != null) waypointOrder.add(parsed);
      }
    }

    return _DirectionsResult(
      polylinePoints: points.isEmpty ? [origin, destination] : points,
      waypointOrder: waypointOrder,
      distanceMeters: meters,
      durationSeconds: seconds,
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    final poly = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return poly;
  }

  String _formatTotalDistance() {
    final meters = _routeDistanceMeters;
    if (meters == null) return 'N/A';
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(km >= 10 ? 0 : 1)} km';
    }
    return '$meters m';
  }

  String _formatTotalDuration() {
    final seconds = _routeDurationSeconds;
    if (seconds == null) return 'N/A';
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    if (rem == 0) return '${hours}h';
    return '${hours}h ${rem}m';
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
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.r, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      'Error Loading Route',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () {
                        provider.fetchTodaysOrders(context);
                        _getCurrentLocation();
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        'Retry',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64.r,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No Deliveries Today',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'There are no delivery orders with valid addresses for today.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () {
                        provider.fetchTodaysOrders(context);
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        'Refresh',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final nextOrder = provider.nextOrder;

          // Ensure we have a valid position before rendering map
          if (_currentPosition == null) {
            return const Center(child: CircularProgressIndicator());
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _maybeBuildRoute(provider);
          });

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  zoom: 12,
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
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
              if (_isBuildingRoute)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 3.h,
                    color: Colors.white,
                    backgroundColor: primaryColor.withValues(alpha: 0.25),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeliveryCard(
    RouteOrder nextOrder,
    RouteNavigationProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                  color: primaryColor.withValues(alpha: 0.1),
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
                nextOrder.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.alt_route, size: 16.r, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  '${provider.orders.length} stops • ${_formatTotalDistance()} • ${_formatTotalDuration()}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
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
                  onPressed: provider.currentOrderIndex > 0
                      ? () {
                          provider.moveToPreviousOrder();
                          _updateMap();
                        }
                      : null,
                  icon: Icon(Icons.arrow_back, size: 18.r),
                  label: Text(
                    'Previous',
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

class _OptimizedRouteResult {
  final List<int> orderedStopIndices;
  final List<LatLng> polylinePoints;
  final int distanceMeters;
  final int durationSeconds;

  const _OptimizedRouteResult({
    required this.orderedStopIndices,
    required this.polylinePoints,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class _DirectionsResult {
  final List<LatLng> polylinePoints;
  final List<int> waypointOrder;
  final int distanceMeters;
  final int durationSeconds;

  const _DirectionsResult({
    required this.polylinePoints,
    required this.waypointOrder,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}
