class DateUtilsHelper {
  static String getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return (month >= 1 && month <= 12) ? monthNames[month - 1] : 'Unknown';
  }
}