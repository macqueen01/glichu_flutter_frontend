bool isValidResponse(Map response, List<String> keys) {
  for (String key in keys) {
    if (!response.containsKey(key) || response[key] == null) {
      return false;
    }
  }
  return true;
}
