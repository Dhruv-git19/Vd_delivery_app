enum ReturnCodes {
  R_SUCCESS,
  R_DB_ERROR,
  R_NOT_FOUND,
  R_AUTHENTICATION_FAILED,
  R_DUPLICATE_DATA,
  R_UNAUTHORIZED,
  R_CREATED,
  R_INVALID_VALUE,
  R_ALREADY_EXIST,
  R_PROMOTION_TYPE,
  R_STARTDATE,
  R_INVALID_PASSWORD,
}

extension ReturnCodesExtension on ReturnCodes {
  int get value {
    switch (this) {
      case ReturnCodes.R_SUCCESS:
        return 0;
      case ReturnCodes.R_DB_ERROR:
        return 1;
      case ReturnCodes.R_NOT_FOUND:
        return 2;
      case ReturnCodes.R_AUTHENTICATION_FAILED:
        return 3;
      case ReturnCodes.R_DUPLICATE_DATA:
        return 4;
      case ReturnCodes.R_UNAUTHORIZED:
        return 5;
      case ReturnCodes.R_CREATED:
        return 6;
      case ReturnCodes.R_INVALID_VALUE:
        return 7;
      case ReturnCodes.R_ALREADY_EXIST:
        return 8;
      case ReturnCodes.R_PROMOTION_TYPE:
        return 9;
      case ReturnCodes.R_STARTDATE:
        return 10;
      case ReturnCodes.R_INVALID_PASSWORD:
        return 11;
    }
  }
}

enum RoleId {
  STUDENT(22),
  TEACHER(51),
  ADMIN(2);

  final int value;
  const RoleId(this.value);
}

enum UserType {
  attempter,
  creator;

  int toApiValue() {
    return this == creator ? 1 : 0;
  }

  bool get isCreator => this == creator;
}

// Source Link Types for AI Quiz Generation
enum SourceLinkType {
  YOUTUBE,
  PDF,
  AUDIO,
  IMAGES,
  PPT,
  WORD_DOC,
}

extension SourceLinkTypeExtension on SourceLinkType {
  int get value {
    switch (this) {
      case SourceLinkType.YOUTUBE:
        return 1;
      case SourceLinkType.PDF:
        return 2;
      case SourceLinkType.AUDIO:
        return 3;
      case SourceLinkType.IMAGES:
        return 4;
      case SourceLinkType.PPT:
        return 5;
      case SourceLinkType.WORD_DOC:
        return 6;
    }
  }

  String get displayName {
    switch (this) {
      case SourceLinkType.YOUTUBE:
        return 'YouTube';
      case SourceLinkType.PDF:
        return 'PDF';
      case SourceLinkType.AUDIO:
        return 'Audio';
      case SourceLinkType.IMAGES:
        return 'Images';
      case SourceLinkType.PPT:
        return 'PowerPoint';
      case SourceLinkType.WORD_DOC:
        return 'Word Document';
    }
  }

  List<String> get acceptedMimeTypes {
    switch (this) {
      case SourceLinkType.YOUTUBE:
        return ['YOUTUBE'];
      case SourceLinkType.PDF:
        return ['application/pdf'];
      case SourceLinkType.AUDIO:
        return ['AUDIO'];
      case SourceLinkType.IMAGES:
        return ['image/webp', 'image/jpeg', 'image/svg+xml', 'image/png'];
      case SourceLinkType.PPT:
        return [
          'application/vnd.openxmlformats-officedocument.presentationml.presentation'
        ];
      case SourceLinkType.WORD_DOC:
        return [
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        ];
    }
  }
}

enum QuizCreationType {
  Add_QUIZ,
  AI_GENERATED,
}

extension QuizCreationTypeExtension on QuizCreationType {
  String get displayName {
    switch (this) {
      case QuizCreationType.Add_QUIZ:
        return 'Regular Quiz';
      case QuizCreationType.AI_GENERATED:
        return 'AI Generated Quiz';
    }
  }

  int get value => index;
}

enum ProfessionUniqueId {
  Teacher,
  Mentor,
  Assessor,
  Advisor,
  Others,
}

extension ProfessionUniqueIdExtension on ProfessionUniqueId {
  String get value {
    switch (this) {
      case ProfessionUniqueId.Teacher:
        return 'Teacher';
      case ProfessionUniqueId.Mentor:
        return 'Mentor';
      case ProfessionUniqueId.Assessor:
        return 'Assessor';
      case ProfessionUniqueId.Advisor:
        return 'Advisor';
      case ProfessionUniqueId.Others:
        return 'Others';
    }
  }
}
enum SubjectUniqueId {
MATHS,
HINDI,
ENGLISH,
OTHER,
}

extension SubjectUniqueIdExtension on SubjectUniqueId {
  String get value {
    switch (this) {
      case SubjectUniqueId.HINDI:
        return 'Hindi';
      case SubjectUniqueId.ENGLISH:
        return 'English';
      case SubjectUniqueId.MATHS:
        return 'Maths';
      case SubjectUniqueId.OTHER:
        return 'otherSubjectName';
    }
  }
}


enum DownloadFileType {
  PDF(1),
  EXCEL(2);

  final int value;
  const DownloadFileType(this.value);
}

enum DownloadReportType {
  NORMAL("normal"),
  RANKWISE("rankwise"),
  NAMEWISE("namewise");

  final String value;
  const DownloadReportType(this.value);
}
