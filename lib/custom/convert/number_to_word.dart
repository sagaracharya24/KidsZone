class NumberToWord {
  String convert(int digit) {
    final int number = digit;
    String numberString = '0000000000' + number.toString();
    numberString =
        numberString.substring(number.toString().length, numberString.length);
    var str = '';

    List<String> ones = [
      '',
      'one ',
      'two ',
      'three ',
      'four ',
      'five ',
      'six ',
      'seven ',
      'eight ',
      'nine ',
      'ten ',
      'eleven ',
      'twelve ',
      'thirteen ',
      'fourteen ',
      'fifteen ',
      'sixteen ',
      'seventeen ',
      'eighteen ',
      'nineteen '
    ];
    List<String> tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];

    str += (numberString[0]) != '0'
        ? ones[int.parse(numberString[0])] + 'hundred '
        : ''; //hundreds
    if ((int.parse('${numberString[1]}${numberString[2]}')) < 20 &&
        (int.parse('${numberString[1]}${numberString[2]}')) > 9) {
      str += ones[int.parse('${numberString[1]}${numberString[2]}')] + 'crore ';
    } else {
      str += (numberString[1]) != '0'
          ? tens[int.parse(numberString[1])] + ' '
          : ''; //tens
      str += (numberString[2]) != '0'
          ? ones[int.parse(numberString[2])] + 'crore '
          : ''; //ones
      str +=
          (numberString[1] != '0') && (numberString[2] == '0') ? 'crore ' : '';
    }
    if ((int.parse('${numberString[3]}${numberString[4]}')) < 20 &&
        (int.parse('${numberString[3]}${numberString[4]}')) > 9) {
      str += ones[int.parse('${numberString[3]}${numberString[4]}')] + 'lakh ';
    } else {
      str += (numberString[3]) != '0'
          ? tens[int.parse(numberString[3])] + ' '
          : ''; //tens
      str += (numberString[4]) != '0'
          ? ones[int.parse(numberString[4])] + 'lakh '
          : ''; //ones
      str +=
          (numberString[3] != '0') && (numberString[4] == '0') ? 'lakh ' : '';
    }
    if ((int.parse('${numberString[5]}${numberString[6]}')) < 20 &&
        (int.parse('${numberString[5]}${numberString[6]}')) > 9) {
      str +=
          ones[int.parse('${numberString[5]}${numberString[6]}')] + 'thousand ';
    } else {
      str += (numberString[5]) != '0'
          ? tens[int.parse(numberString[5])] + ' '
          : ''; //ten thousands
      str += (numberString[6]) != '0'
          ? ones[int.parse(numberString[6])] + 'thousand '
          : ''; //thousands
      str += (numberString[5] != '0') && (numberString[6] == '0')
          ? 'thousand '
          : '';
    }
    str += (numberString[7]) != '0'
        ? ones[int.parse(numberString[7])] + 'hundred '
        : ''; //hundreds
    if ((int.parse('${numberString[8]}${numberString[9]}')) < 20 &&
        (int.parse('${numberString[8]}${numberString[9]}')) > 9) {
      str += ones[int.parse('${numberString[8]}${numberString[9]}')];
    } else {
      str += (numberString[8]) != '0'
          ? tens[int.parse(numberString[8])] + ' '
          : ''; //tens
      str += (numberString[9]) != '0'
          ? ones[int.parse(numberString[9])]
          : ''; //ones
    }

    return str;
  }
}
