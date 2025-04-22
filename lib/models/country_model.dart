class CountryModel {
  final String name;
  final String code;
  final String phoneCode;
  final String flag;

  CountryModel({
    required this.name,
    required this.code,
    required this.phoneCode,
    required this.flag,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryModel && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
