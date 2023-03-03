import 'dart:convert';

/// A converter from hexadecimal number in String format to an integer
/// Example: "41" -> 65
int intParse(String hex) {
  if (hex.isEmpty) return 0;
  return int.parse(hex, radix: 16);
}

/// A converter from byte array to hexadecimal in String format,
/// defining start byte and end byte it follows the "LSB" rule
String lsbHexFromByteArray(Iterable<String> bytes, {int start = 0, int? end}) {
  end ??= bytes.length - 1;
  return bytes.skip(start).take(end - start).toList().reversed.join();
}

String mapToAscii(String hex) {
  return Latin1Decoder()
      .convert(RegExp(r".{2}")
          .allMatches(hex.replaceAll("00", ""))
          .map((m) => intParse(m.group(0).toString()))
          .toList())
      .trim();
}
