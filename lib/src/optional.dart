sealed class Optional<T> {}

class Some<T> implements Optional<T> {
  const Some(this.some);
  final T some;
}

class None<T> implements Optional<T> {}
