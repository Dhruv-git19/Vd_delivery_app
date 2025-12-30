// lib/constants/api_constants.dart
enum ApiEndpoint {
  login('/login'),
  logout('/logout'),
  verifyOTP('/verifyOTP'),
  getSpecificUser('/getSpecificUser'),
  uploadKYCDocument('/uploadKYCDocument'),
  uploadProofImages('/uploadProofImages'),
  getSpecificOrderDetails('/getSpecificOrderDetails'),
  submitOrderProof('/submitOrderProof'),
  deleteMyAccount('/deleteMyAccount'),
  getCashCollections('/getCashCollections'),
  getAdminUsers('/getAdminUsers'),
  addCashHandover('/addCashHandover'),
  checkOrderPaymentMode('/checkOrderPaymentMode'),
  completeDeliveryPayment('/completeDeliveryPayment'),
  submitSubscriptionBottleCount('/submitSubscriptionBottleCount'),
  verifyDeliveryLocation('/verifyDeliveryLocation'),
  registerDeliveryPartner('/registerDeliveryPartner'),
  getDeliveryPartnerOrderHistory('/getDeliveryPartnerOrderHistory'),
  getSpecificDeliveryPartnerOrderHistory(
    '/getSpecificDeliveryPartnerOrderHistory',
  ),
  getSpecificOrdersAssignment('/getSpecificOrdersAssignment'),
  getAllAreas('/getAllAreas');

  final String path;

  const ApiEndpoint(this.path);

  String get fullPath => path;
}

enum EResultCode {
  success(0, 'Success'),
  dbError(1, 'Database Error'),
  noDataFound(2, 'No Data Found'),
  authenticationFailed(3, 'Authentication Failed'),
  unauthorized(4, 'Unauthorized'),
  unknown(5, 'Unknown Error'),
  invalidLoginId(6, 'Invalid Login ID'),
  invalidPassword(7, 'Invalid Password'),
  serviceError(8, 'Service Error'),
  invalidRequest(9, 'Invalid Request'),
  notFound(10, 'Not Found'),
  networkErrorServerError(11, 'Network Error or Server Error'),
  created(12, 'Created'),
  internalServerError(13, 'Internal Server Error'),
  unused(14, 'Unused'),
  multipleRecords(15, 'Multiple Records Found'),
  badRequest(16, 'Bad Request'),
  rDuplicate(25, 'Duplicate Record');

  final int code;
  final String description;

  const EResultCode(this.code, this.description);

  static EResultCode fromCode(int code) {
    return EResultCode.values.firstWhere(
      (rc) => rc.code == code,
      orElse: () => EResultCode.unknown,
    );
  }
}

// Enums for Privileges
enum EPrivileges {
  viewDashboard(1),
  viewQuiz(2),
  generateQuiz(3),
  editQuiz(4),
  deleteQuiz(5),
  shareQuiz(6),
  viewStats(7),
  printOmrSheet(8),
  addConfigGroup(9),
  editConfigGroup(10),
  deleteConfigGroup(11),
  addConfigParam(12),
  editConfigParam(13),
  deleteConfigParam(14),
  addRole(15),
  editRole(16),
  deleteRole(17),
  addUser(18),
  editUser(19),
  deleteUser(20);

  final int value;
  const EPrivileges(this.value);
}

// Enums for Language
enum ELanguage {
  english('en'),
  french('fr'),
  hindi('hi');

  final String value;
  const ELanguage(this.value);
}

// Enums for Source Link
enum ESourceLink {
  youtube(1),
  pdf(2),
  audio(3),
  images(4),
  ppt(5),
  wordDoc(6);

  final int value;
  const ESourceLink(this.value);
}

// Enums for Difficulty Level
enum EDifficultyLevel {
  high(1),
  low(2),
  medium(3);

  final int value;
  const EDifficultyLevel(this.value);
}

// Enums for Is Active
enum EIsActive {
  yes(1),
  no(0);

  final int value;
  const EIsActive(this.value);
}

// Enums for Tab
enum ETab {
  quizCode(1),
  quizInstruction(2),
  quizQuestion(3),
  quizResult(4);

  final int value;
  const ETab(this.value);
}

// Enums for Pass Status
enum EPassStatus {
  fail(0),
  pass(1);

  final int value;
  const EPassStatus(this.value);
}

// Existing ResponseField and FilterField enums (unchanged)
enum ResponseField {
  dataResponse('dataResponse'),
  returnCode('returnCode'),
  responseDateTime('responseDateTime'),
  description('description'),
  data('data'),
  filterModel('filterModel');

  final String key;
  const ResponseField(this.key);
}

enum FilterField {
  currentPage('currentPage'),
  pageSize('pageSize'),
  searchText('searchText'),
  totalRows('totalRows'),
  filterRowsCount('filterRowsCount'),
  orderBy('orderBy'),
  orderType('orderType'),
  fromDate('fromDate'),
  toDate('toDate');

  final String key;
  const FilterField(this.key);
}
