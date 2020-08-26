import 'package:collection/collection.dart';

class MapComparer {
  static bool isMapSubsetOfAnotherMap(Map subsetCandidate, Map map) {
    if (subsetCandidate.isEmpty) return false;

    return subsetCandidate.entries.every((entry) {
      return DeepCollectionEquality().equals(entry.value, map[entry.key]);
    });
  }
}
