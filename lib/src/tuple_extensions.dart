import "package:collection/collection.dart";

extension TupleExtensions<T> on List<T> {
  List<(int, T)> enumerate() =>
      mapIndexed((final int index, final T element) => (index, element))
          .toList();
}
