import 'package:collection/collection.dart';

class MapComparer {
  static bool isMapSubsetOfAnotherMap(Map subsetCandidate, Map map) {
    return subsetCandidate.entries.every((entry) => DeepCollectionEquality().equals(entry.value, map[entry.key]));
  }
}
