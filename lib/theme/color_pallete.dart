import 'package:flutter/material.dart';

class AppColor {
  static Color primaryColor = Color(0xFF000658);
  static Color secondaryColor = Color(0xFFED7B22);
  static Color constWhite = Color(0xFFffffff);
  static Color background = Color(0xFFF7F7F7);
  static Color constBlack = Color(0xFF000000);
  static Color titleText = Color(0xFF000000);
  static Color subTitleText = Color.fromARGB(255, 91, 91, 91);
  static Color grayColor = Color(0xFF767680);
  static Color correntAnswer = Color(0xFFD6FFE2);
  static Color wrongAnswer = Color(0xFFFFE7F0);
  static Color listBorder = Color(0xFFFFC779);
  static Color passedText = Color(0xFF1EA23F);
  static Color correctBorder = Color.fromRGBO(30, 162, 63, 0.2);
  static Color wrongBorder = Color.fromRGBO(255, 112, 136, 0.2);
  static Color failedText = Color(0xFFEF4450);
  static Color circleRadiusColor = Color(0xFF7265BE);
  static Color circleBackgroundColor = Color(0xFFE4E6EB);
  static Color transperent = Colors.transparent;
  static Color lightGray = Color(0xFFAEAEB2);
  static Color difficultyLevel = Color(0xFF34C759);
  static Color numberOfQuestions = Color(0xFFFF5A8E);
  static Color passingPercentage = Color(0xFF787AFC);
  static Color totalMarks = Color(0xFF3276FF);
  static Color noDataFound = Color(0xFF999999);
  static Color skeletonColor = Colors.grey[300]!;
  static const addQuestionIconBorder = Color(0XFFEDF1F5);
  static Color borderColor = Color(0x80FFFFFF);
  static Color borderExpansion = Color(0xFFE2E8F0);
  static Color questionBorderColor = Color(0xFFED7B22);
  static Color inputBorderColor = Color.fromARGB(255, 223, 223, 223);
  static Color inputLabelBackgroundColor = Color.fromARGB(255, 246, 246, 246);
  static Color divider = Color(0xFFF5F2FF);
  static Color hintText = Color(0xFFBDBDBD);
  static Color logoutButton = Color(0xffFF6E01);
  static Color progressbar = Color(0xffE7E7E7);
  static Color activeRadioButton = Color(0xFF1EA23F);
  static Color grey = Colors.grey;
  static Color borderGrey = Color(0xFFD9D9D9);
  static Color bgContainer = Color(0xFFF4F4F4);
  static Color unansweredContainer = Color(0xFFF1F3FF);
  static Color greenBorder = Color(0xFF1DA43F);
  static Color orangeBorder = Color(0xFFFF6E01);
  static Color greyBorder = Color(0xFFD7DDFF);
  static Color redBorder = Color(0xFFEE4E4E);
  static Color sheetBackground = Color(0xFFFFFFFF);
  static Color dashboardQuizAttemptBackground = Color(0xFFF5F2FF);
  static Color dashboardQuizAttemptCount = Color(0xFF7265BE);
  static Color dashboardQuizAttemptBorder = Color(0xFFE1E4FF);

  static Color dashboardQuizPercentageBackground = Color(0xFFFFFCE9);
  static Color dashboardQuizPercentageCount = Color(0xFFD5A041);
  static Color dashboardQuizPercentageBorder = Color(0xFFFEECCA);

  static Color dashboardQuizPassedBackground = Color(0xFFF2FCF5);
  static Color dashboardQuizPassedCount = Color(0xFF1EA23F);
  static Color dashboardQuizPassedBorder = Color(0xFFC4EFDC);

  static Color dashboardQuizFailedBackground = Color(0xFFFFF1F6);
  static Color dashboardQuizFailedCount = Color(0xFFFF7088);
  static Color dashboardQuizFailedBorder = Color(0xFFFFC3C7);
  static Color dashboardPassingColor = Color(0xFF34C759);

  static Color scaffold = Color(0xFFF7F7F7);
  static Color dashboardHeaderBorder = Color(0xFFE6E8E8);
  static Color dashboardBlack = Color(0xFF212325);

  static Gradient mainGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xff5169FF),
        Color(0xff1F36C7),
      ]);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 180, 185, 255),
      Color.fromARGB(255, 255, 224, 200)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class DarkAppColor {
  static Color primaryColor = Color(0xFF5169FF);
  static Color secondaryColor = Color(0xFFFFAE5F);
  static Color constWhite = Color(0xFF2C2C2E);
  static Color background = Color.fromARGB(255, 21, 21, 21);
  static Color constBlack = Color(0xFFFFFFFF);
  static Color titleText = Color(0xFFFFFFFF);
  static Color subTitleText = Color(0xFFB0B0B0);
  static Color grayColor = Color(0xFF8E8E93);
  static Color correntAnswer = Color(0xFF2E7D32);
  static Color wrongAnswer = Color(0xFFB00020);
  static Color listBorder = Color(0xFFFFAE5F);
  static Color passedText = Color(0xFF34C759);
  static Color correctBorder = Color.fromRGBO(76, 175, 80, 0.3);
  static Color wrongBorder = Color.fromRGBO(239, 83, 80, 0.3);
  static Color failedText = Color(0xFFFF6E6E);
  static Color circleRadiusColor = Color(0xFF9FA8DA);
  static Color circleBackgroundColor = Color(0xFF1E1E1E);
  static Color transperent = Colors.transparent;
  static Color lightGray = Color(0xFF4A4A4A);
  static Color difficultyLevel = Color(0xFF30D158);
  static Color numberOfQuestions = Color(0xFFFF6E99);
  static Color passingPercentage = Color(0xFF8E94FF);
  static Color totalMarks = Color(0xFF639BFF);
  static Color noDataFound = Color(0xFFAAAAAA);
  static Color skeletonColor = Colors.grey[700]!;
  static const addQuestionIconBorder = Color(0xFF2A2A2A);
  static Color borderColor = Color(0x40FFFFFF);
  static Color borderExpansion = Color(0xFF3A3A3A);
  static Color questionBorderColor = Color(0xFFFFAE5F);
  static Color inputBorderColor = Color(0xFF444444);
  static Color inputLabelBackgroundColor = Color(0xFF2C2C2E);
  static Color divider = Color(0xFF383838);
  static Color hintText = Color(0xFF888888);
  static Color logoutButton = Color(0xFFFF6E01);
  static Color progressbar = Color(0xFF2C2C2C);
  static Color activeRadioButton = Color(0xFF30D158);
  static Color grey = Colors.grey[600]!;
  static Color borderGrey = Color(0xFF444444);
  static Color bgContainer = Color(0xFF1A1A1A);
  static Color unansweredContainer = Color(0xFF2D2F45);
  static Color greenBorder = Color(0xFF30D158);
  static Color orangeBorder = Color(0xFFFF6E01);
  static Color greyBorder = Color(0xFF555B7A);
  static Color redBorder = Color(0xFFFF6E6E);
  static Color sheetBackground = Color(0xFF121212);

  static Color dashboardQuizAttemptBackground = Color(0xFF292C3F);
  static Color dashboardQuizAttemptCount = Color(0xFFB3A9FF);
  static Color dashboardQuizAttemptBorder = Color(0xFF4C4F75);

  static Color dashboardQuizPercentageBackground = Color(0xFF3A3429);
  static Color dashboardQuizPercentageCount = Color(0xFFFFCB7C);
  static Color dashboardQuizPercentageBorder = Color(0xFF5C4A3B);

  static Color dashboardQuizPassedBackground = Color(0xFF26332B);
  static Color dashboardQuizPassedCount = Color(0xFF4CD964);
  static Color dashboardQuizPassedBorder = Color(0xFF355944);

  static Color dashboardQuizFailedBackground = Color(0xFF3B1F24);
  static Color dashboardQuizFailedCount = Color(0xFFFF7088);
  static Color dashboardQuizFailedBorder = Color(0xFF6A3B4B);
  static Color dashboardPassingColor = Color(0xFF30D158);

  static Color scaffold = Color(0xFF121212);
  static Color dashboardHeaderBorder = Color(0xFF2E2E2E);
  static Color dashboardBlack = Color(0xFFFFFFFF);

  static Gradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff6B7CFF),
      Color(0xff3A49C6),
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
