class PMHelper {
  String formatDateTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    String formattedDate = '${parsedDateTime.year}-${_addLeadingZero(parsedDateTime.month)}-${_addLeadingZero(parsedDateTime.day)}';
    String formattedTime = _formatTime(parsedDateTime.hour, parsedDateTime.minute, parsedDateTime.second);
    String period = parsedDateTime.hour < 12 ? 'AM' : 'PM';
    return '$formattedDate $formattedTime $period';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  String _formatTime(int hour, int minute, int second) {
    String formattedHour = _addLeadingZero(hour > 12 ? hour - 12 : hour);
    String formattedMinute = _addLeadingZero(minute);
    String formattedSecond = _addLeadingZero(second);
    return '$formattedHour:$formattedMinute:$formattedSecond';
  }
}