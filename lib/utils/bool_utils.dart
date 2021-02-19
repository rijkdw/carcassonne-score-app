bool any(List<bool> list) {
  for (var b in list) {
    if (b) return true;
  }
  return false;
}

bool all(List<bool> list) {
  for (var b in list) {
    if (!b) return false;
  }
  return true;
}