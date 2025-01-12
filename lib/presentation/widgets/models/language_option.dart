class LanguageOption {
  final String code;
  final String name;
  bool isSelected;

  LanguageOption({
    required this.code,
    required this.name,
    this.isSelected = false,
  });
}
