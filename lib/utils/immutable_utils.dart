extension ImmutableList<T> on List<T> {
  List<T> replace(T object, T newObject) {
    return this.map((e) => e == object ? newObject : e).toList();
  }
}
