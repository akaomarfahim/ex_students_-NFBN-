
Future<List<String>> stringtoList({required String string, required String breaker}) async {
  List<String> finalList = string.split(breaker);
  return finalList;
}

String? listToSingleString({required List<String>? list, required String adder}) {
  if (list != null) {
    return list.map((item) => item).toList().join(adder);
  }
  return null;
}

List<String>? stringtoListDirect({required String? string, required String breaker}) {
  // log(string.split(breaker).toString());
  if (string != null) return string.split(breaker);
  return null;
}

String removeExtension(String string) {
  var pos = string.lastIndexOf('.');
  String result = (pos != -1) ? string.substring(0, pos) : string;
  return result;
}
