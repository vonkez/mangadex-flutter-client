class Order {
  final String key;
  final String direction;
  const Order.asc(this.key): direction = "asc";
  const Order.desc(this.key): direction = "desc";

  @override
  String toString() {
    return 'Order{key: $key}';
  }
}