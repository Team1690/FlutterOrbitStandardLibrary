extension EmptyToNull<A> on List<A> {
  List<A>? get emptyToNull => isEmpty ? null : this;
}
