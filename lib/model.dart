class Fibo {
  final int index;
  final int value;
  bool isActive;

  Fibo({required this.index, required this.value, this.isActive = false});

  // A method to create a Fibo instance from a map (for JSON decoding)
  factory Fibo.fromJson(Map<String, dynamic> json) {
    return Fibo(
      index: json['index'],
      value: json['value'],
      isActive: json['isActive'] ?? false,
    );
  }

  // A method to convert a Fibo instance to a map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'value': value,
      'isActive': isActive,
    };
  }
}
