bool isInteger(String input) {
  try {
    int.parse(input);
    return true;
  } catch (e) {
    return false;
  }
}

bool isNonNegativeInteger(String input) {
  return isInteger(input) && int.parse(input) >= 0;
}