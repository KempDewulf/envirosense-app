class CacheOption {
  final String title;
  final String subtitle;
  final bool isHighImpact;
  bool isSelected;

  CacheOption({
    required this.title,
    required this.subtitle,
    this.isHighImpact = false,
    this.isSelected = false,
  });
}
