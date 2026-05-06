class NumbersConverterUtility {
  static String arabicToLatinNumbersString(String arabicNumber) {
    final Map<String, String> arabicToLatinMap = <String, String>{
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '٪': '%',
      '،': ',',
      '٫': '.',
    };
  
    final StringBuffer buffer = StringBuffer();
  
    for (int i = 0; i < arabicNumber.length; i++) {
      final String arabicDigit = arabicNumber[i];
      final String latinDigit = arabicToLatinMap[arabicDigit] ?? arabicDigit;
      buffer.write(latinDigit);
    }
  
    return buffer.toString();
  }

  static String latinToArabicNumbersString(String latinNumber) {
    final Map<String, String> latinToArabicMap = <String, String>{
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
      '%': '٪',
      ',': '،',
      '.': '٫',
    };

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < latinNumber.length; i++) {
      final String latinDigit = latinNumber[i];
      final String arabicDigit = latinToArabicMap[latinDigit] ?? latinDigit;
      buffer.write(arabicDigit);
    }

    return buffer.toString();
  }
}
