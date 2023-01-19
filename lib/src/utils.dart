/// A converter from hexadecimal number in String format to an integer
/// Example: "41" -> 65
int intParse(String hex) {
  return int.parse(hex, radix: 16);
}

/// A converter from hexadecimal number in String format to an ascii Char
/// Returns `` if is a null char (`00`)
/// Example: `41` -> `A`
String fromCharCode(String hex) {
  return hex == "00" ? "" : String.fromCharCode(intParse(hex));
}

/// A converter from hexadecimal word in String format to ascii word
/// Example: `41424344` -> `ABCD`
String fromCharCodes(String hex) {
  if (hex.length % 2 != 0) return "";
  String s = "";
  for (int i = 0; i < hex.length; i += 2) {
    s += fromCharCode(hex.substring(i, i + 2));
  }
  return s.trim();
}

/// A converter from byte array to hexadecimal in String format,
/// defining start byte and end byte it follows the "LSB" rule
String lsbHexFromByteArray(Iterable<String> bytes, {int start = 0, int? end}) {
  end ??= bytes.length - 1;
  return bytes.skip(start).take(end - start).toList().reversed.join();
}
