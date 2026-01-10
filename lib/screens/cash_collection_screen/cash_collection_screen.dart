import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/coloredContainerWidget.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/iconTextWidget.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

class CashCollectionScreen extends StatefulWidget {
  const CashCollectionScreen({super.key});

  @override
  State<CashCollectionScreen> createState() => _CashCollectionScreenState();
}

class _CashCollectionScreenState extends State<CashCollectionScreen> {
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  List<Map<String, dynamic>> _collections = [];
  int _totalPending = 0;
  int _totalPages = 1;
  final String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  // Selection state
  final Set<int> _selectedCollectionIds = {};
  bool _handoverLoading = false;
  // Admin users
  List<Map<String, dynamic>> _adminUsers = [];
  int? _selectedAdminId;
  final TextEditingController _remarksController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCollections();
  }

  Future<void> _fetchCollections() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final dio = DioHttp();
      final resp = await dio.getCashCollections(
        context,
        page: _page,
        limit: _limit,
      );
      final data = resp.data['data'] ?? {};
      final collections =
          (data['collections'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      setState(() {
        _collections = collections;
        _totalPending = data['totalPending'] ?? 0;
        _totalPages = data['pagination']?['totalPages'] ?? 1;
      });
    } catch (e) {
      MySnackBar.showSnackBar(context, 'Failed to load collections');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCollectionItem(Map<String, dynamic> item) {
    final order = item['order'] ?? {};
    final orderNo = order['orderNo']?.toString() ?? '--';
    final status = item['collectionStatus']?.toString() ?? '--';
    final remarks = item['remarks']?.toString() ?? '';
    final date = item['collectionDate']?.toString().split('T').first ?? '--';
    final amount = item['amountCollected']?.toString() ?? '--';
    final id = item['id'] is int ? item['id'] as int : null;
    final isSelected = id != null && _selectedCollectionIds.contains(id);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onLongPress: id != null
            ? () {
                setState(() {
                  if (_selectedCollectionIds.contains(id)) {
                    _selectedCollectionIds.remove(id);
                  } else {
                    _selectedCollectionIds.add(id);
                  }
                });
              }
            : null,
        child: Container(
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? AllColors.primaryColor
                  : const Color.fromARGB(255, 219, 219, 219),
            ),
            color: isSelected ? const Color(0xFFE8FFF9) : Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: id == null
                    ? null
                    : (val) {
                        setState(() {
                          if (val == true) {
                            _selectedCollectionIds.add(id);
                          } else {
                            _selectedCollectionIds.remove(id);
                          }
                        });
                      },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          orderNo,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AllColors.deliverydetailshadelight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        coloredContainer(
                          status,
                          AllColors.primaryColor,
                          const Color(0xFFE8FFF9),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        iconText(Icons.location_on_outlined, date),
                        SizedBox(width: 20.w),
                        iconText(Icons.currency_rupee, amount),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          remarks,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromARGB(255, 131, 131, 131),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCollections = _searchText.isEmpty
        ? _collections
        : _collections.where((item) {
            final orderNo = (item['order']?['orderNo'] ?? '')
                .toString()
                .toLowerCase();
            final remarks = (item['remarks'] ?? '').toString().toLowerCase();
            return orderNo.contains(_searchText.toLowerCase()) ||
                remarks.contains(_searchText.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppbar(title: 'Cash Collections'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pending:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '₹$_totalPending',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AllColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: filteredCollections.isEmpty
                        ? Center(
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
                                  _searchText.isEmpty
                                      ? 'No collections found'
                                      : 'No results for "$_searchText"',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchCollections,
                            child: ListView.builder(
                              itemCount: filteredCollections.length,
                              itemBuilder: (context, index) {
                                final item = filteredCollections[index];
                                return _buildCollectionItem(item);
                              },
                            ),
                          ),
                  ),
                  if (_totalPages > 1)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: _page > 1 && !_isLoading
                                ? () {
                                    setState(() {
                                      _page--;
                                    });
                                    _fetchCollections();
                                  }
                                : null,
                          ),
                          Text('Page $_page/$_totalPages'),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: _page < _totalPages && !_isLoading
                                ? () {
                                    setState(() {
                                      _page++;
                                    });
                                    _fetchCollections();
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  // Handover Button
                  SizedBox(height: 8.h),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    label: Text('Handover Cash to Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AllColors.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48.h),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed:
                        _selectedCollectionIds.isEmpty || _handoverLoading
                        ? null
                        : _showHandoverDialog,
                  ),
                  if (_handoverLoading)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: const LinearProgressIndicator(),
                    ),
                ],
              ),
            ),
    );
  }

  Future<void> _showHandoverDialog() async {
    setState(() {
      _handoverLoading = true;
    });
    try {
      final dio = DioHttp();
      final resp = await dio.getAdminUsers(context);
      final data = resp.data['data'] ?? {};
      final users =
          (data['users'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      setState(() {
        _adminUsers = users;
        _selectedAdminId = null;
        _remarksController.clear();
      });
    } catch (e) {
      MySnackBar.showSnackBar(context, 'Failed to load admin users');
      setState(() {
        _handoverLoading = false;
      });
      return;
    }
    setState(() {
      _handoverLoading = false;
    });
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) {
        int? selectedAdminId;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AllColors.primaryColor,
                          size: 28.r,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Handover Cash',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AllColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'Select Admin',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: DropdownButtonFormField<int>(
                        initialValue: selectedAdminId,
                        items: _adminUsers
                            .map(
                              (admin) => DropdownMenuItem<int>(
                                value: admin['id'] as int?,
                                child: Text(admin['fullName'] ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setStateDialog(() {
                            selectedAdminId = val;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: false,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 0,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AllColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Remarks',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TextField(
                        controller: _remarksController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter remarks',
                          isDense: false,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 0,
                          ),
                        ),
                        minLines: 1,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black54,
                            textStyle: TextStyle(fontSize: 15.sp),
                          ),
                          child: const Text('Cancel'),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: selectedAdminId == null || _handoverLoading
                              ? null
                              : () async {
                                  _selectedAdminId = selectedAdminId;
                                  Navigator.of(ctx).pop();
                                  await _submitHandover();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AllColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitHandover() async {
    setState(() {
      _handoverLoading = true;
    });
    try {
      final dio = DioHttp();
      final payload = {
        'data': {
          'cashCollectionIds': _selectedCollectionIds.toList(),
          'submittedToAdminId': _selectedAdminId,
          'remarks': _remarksController.text.trim(),
        },
      };
      final resp = await dio.addCashHandover(context, payload: payload);
      final code = resp.data['dataResponse']?['returnCode'];
      if (code == 0) {
        MySnackBar.showSnackBar(
          context,
          'Cash submitted to admin successfully',
        );
        setState(() {
          _selectedCollectionIds.clear();
        });
        await _fetchCollections();
      } else {
        MySnackBar.showSnackBar(
          context,
          resp.data['dataResponse']?['description'] ?? 'Failed to submit cash',
        );
      }
    } catch (e) {
      MySnackBar.showSnackBar(context, 'Failed to submit cash');
    } finally {
      setState(() {
        _handoverLoading = false;
      });
    }
  }
}
