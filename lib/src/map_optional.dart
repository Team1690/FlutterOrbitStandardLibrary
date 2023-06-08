import "package:orbit_standard_library/src/optional.dart";

import "package:orbit_standard_library/src/map_nullable.dart";

extension MapOptional<A> on Optional<A> {
  B fold<B>(final B Function() onEmpty, final B Function(A) onSome) =>
      switch (this) {
        Some<A>(some: final A some) => onSome(some),
        None<A>() => onEmpty()
      };

  Optional<B> mapNullable<B>(final B Function(A) f) => switch (this) {
        Some<A>(some: final A some) => Some<B>(f(some)),
        None<A>() => None<B>(),
      };

  Optional<B> onNullDo<B>(final B Function() f) => switch (this) {
        Some<A>(some: _) => None<B>(),
        None<A>() => Some<B>(f()),
      };

  Optional<B> onNull<B>(final B value) => onNullDo(always(value));

  A orElseDo(final A Function() f) => fold(f, identity);

  A orElse(final A value) => orElseDo(always(value));
}
