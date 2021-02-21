bool isInteger(String input) {
  try {
    int.parse(input);
    return true;
  } catch (e) {
    return false;
  }
}