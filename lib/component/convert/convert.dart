class SahaConvert {
  static int millisecondFirebaseToMinuteInDay(int millisecond) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(millisecond);
    return (dateTime.hour * 60) + dateTime.minute;
  }

  static int millisecondFirebaseToSecondInDay(int millisecond) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(millisecond);
    return int.parse(((dateTime.hour * 3600) + (dateTime.minute * 60) + dateTime.second).toString());
  }
}
