import 'package:orbit_standard_library/src/optional.dart';

import 'map_nullable.dart';

extension MapOptional<A> on Optional<A> {
  B fold<B>(final B Function() onEmpty, final B Function(A) onSome) =>
      switch (this) {
        Some(some: var some) => onSome(some),
        None() => onEmpty()
      };

  Optional<B> mapNullable<B>(final B Function(A) f) => switch (this) {
        Some(some: var some) => Some(f(some)),
        None() => None(),
      };

  Optional<B> onNullDo<B>(final B Function() f) => switch (this) {
        Some(some: var _) => None(),
        None() => Some(f()),
      };

  Optional<B> onNull<B>(final B value) => onNullDo(always(value));

  A orElseDo(final A Function() f) => fold(f, identity);

  A orElse(final A value) => orElseDo(always(value));
}
