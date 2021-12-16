// @dart=2.9

import 'package:collection/collection.dart';

class MapComparer {
  static bool isMapSubsetOfAnotherMap(Map subsetCandidate, Map map) {
    if (subsetCandidate.isEmpty) return false;

    return subsetCandidate.entries.every((entry) {
      if (entry.value is Map) {
        return MapComparer.isMapSubsetOfAnotherMap(entry.value, map[entry.key]);
      } else if (entry.value is List) {
        return ListEquality().equals(entry.value, map[entry.key]);
      } else {
        return entry.value == map[entry.key];
      }

//      we used DeepCollectionEquality earlier but it failed in some cases
//      DeepCollectionEquality().equals(entry.value, map[entry.key])
    });
  }
}