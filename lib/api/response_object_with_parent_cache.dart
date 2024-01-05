
// This describes an object that combines an API response
// object (that is generated in Flutter) with its
// parent entity's cache JSON.
// This allows arbitrary custom objects to be passed around
// with bundled parent JSON that can later be used to update
// a local cache.

class ResponseObjectWithParentCache {
  Map<String, dynamic> parentJSON;
  final dynamic responseObj;

  ResponseObjectWithParentCache({
    required this.responseObj,
    required this.parentJSON,
  });

  ResponseObjectWithParentCache.fromJson({
    required responseObj,
    required rawJSON,
    required String cacheParam,
  })
      : responseObj = responseObj,
        parentJSON = rawJSON[cacheParam];
}