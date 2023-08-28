import 'dart:math';

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

  String generatePassword(Map<String, dynamic> passwordConf) {
    if (passwordConf['length'] == null) {
      passwordConf['length'] = 12;
    }
    if (passwordConf['lowercase'] == null) {
      passwordConf['lowercase'] = true;
    }
    if (passwordConf['uppercase'] == null) {
      passwordConf['uppercase'] = true;
    }
    if (passwordConf['numbers'] == null) {
      passwordConf['numbers'] = true;
    }
    if (passwordConf['symbols'] == null) {
      passwordConf['symbols'] = true;
    }

    final lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    final uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numberChars = '0123456789';
    final symbolChars = '!@#\$%^&*()-_+=<>?';

    String validChars = '';
    if (passwordConf['lowercase']) {
      validChars += lowercaseChars;
    }
    if (passwordConf['uppercase']) {
      validChars += uppercaseChars;
    }
    if (passwordConf['numbers']) {
      validChars += numberChars;
    }
    if (passwordConf['symbols']) {
      validChars += symbolChars;
    }

    String password = '';
    final random = Random();
    for (int i = 0; i < passwordConf['length']; i++) {
      password += validChars[random.nextInt(validChars.length)];
    }

    return password;
  }

  void copyToClipboard(String value) {

  }
}