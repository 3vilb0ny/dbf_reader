int intParse(String hex) {
  return int.parse(hex, radix: 16);
}

String fromCharCode(String hex) {
  return hex == "00" ? "" : String.fromCharCode(intParse(hex));
}

String fromCharCodes(String hex) {
  if (hex.length % 2 != 0) return "";
  String s = "";
  for (int i = 0; i < hex.length; i += 2) {
    s += fromCharCode(hex.substring(i, i + 2));
  }
  return s.trim();
}

String lsbHexFromByteArray(Iterable<String> bytes, {int start = 0, int? end}) {
  end ??= bytes.length - 1;
  return bytes.skip(start).take(end - start).toList().reversed.join();
}
