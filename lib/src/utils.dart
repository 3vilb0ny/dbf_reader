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

String lsbHexFromByteArray(List<String> bytes, int start, int end) {
  return bytes.getRange(start, end).toList().reversed.join();
}
