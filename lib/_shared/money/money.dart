class Money {
  late final num _amount;

  static Money zero() {
    return Money(0);
  }

  Money(num amount) {
    _amount = amount;
  }

  //MARK: Functions to perform math operations

  Money add(Money other) {
    return Money(_amount + other._amount);
  }

  Money subtract(Money other) {
    return Money(_amount - other._amount);
  }

  Money multiply(num times) {
    return Money(_amount * times);
  }

  // MARK: Functions to compare money objects

  bool greaterThan(Money money) {
    return _amount > money._amount;
  }

  bool lessThan(Money money) {
    return _amount < money._amount;
  }

  @override
  bool operator ==(Object other) {
    return other is Money && _amount == other._amount;
  }

  //MARK: Util functions

  @override
  int get hashCode => _amount.hashCode;

  @override
  String toString() {
    return _amount.toStringAsFixed(2);
  }
}

