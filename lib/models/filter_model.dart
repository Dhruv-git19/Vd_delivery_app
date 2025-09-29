// lib/models/filter_model.dart
class FilterModel {
  final int currentPage;
  final int pageSize;
  final String searchText;
  final int totalRows;
  final int filterRowsCount;
  final String orderBy;
  final String orderType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String>? selectedSubjectIds;

  FilterModel({
    required this.currentPage,
    required this.pageSize,
    this.searchText = '',
    required this.totalRows,
    required this.filterRowsCount,
    required this.orderBy,
    required this.orderType,
    this.fromDate,
    this.toDate,
    this.selectedSubjectIds
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) {

        List<String>? subjectIds;
    if (json['subjectId'] != null) {
      if (json['subjectId'] is List) {
        subjectIds = (json['subjectId'] as List).map((e) => e.toString()).toList();
      } else {
        subjectIds = [json['subjectId'].toString()];
      }
    }
    return FilterModel(
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 2000,
      searchText: json['searchText'] ?? '',
      totalRows: json['totalRows'] ?? 0,
      filterRowsCount: json['filterRowsCount'] ?? 0,
      orderBy: json['orderBy'] ?? 'id',
      orderType: json['orderType'] ?? 'ASC',
      fromDate:
          json['fromDate'] != null ? DateTime.tryParse(json['fromDate']) : null,
      toDate: json['toDate'] != null ? DateTime.tryParse(json['toDate']) : null,
      selectedSubjectIds: subjectIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize,
      'currentPage': currentPage,
      'filterRowsCount': filterRowsCount,
      'totalRows': totalRows,
      'searchText': searchText,
      'orderType': orderType,
      'orderBy': orderBy,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'subjectId': selectedSubjectIds,
    };
  }

  FilterModel copyWith({
    int? currentPage,
    int? pageSize,
    int? totalRows,
    int? filterRowsCount,
    String? orderBy,
    String? orderType,
    String? searchText,
    DateTime? fromDate,
    DateTime? toDate,
    List<String>? selectedSubjectIds,
  }) {
    return FilterModel(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalRows: totalRows ?? this.totalRows,
      filterRowsCount: filterRowsCount ?? this.filterRowsCount,
      orderBy: orderBy ?? this.orderBy,
      orderType: orderType ?? this.orderType,
      searchText: searchText ?? this.searchText,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
    );
  }
}
