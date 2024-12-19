String capitalizeWords(String input) {
  if (input.isEmpty) return input;
  return input.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    } else {
      return word;
    }
  }).join(' ');
}
