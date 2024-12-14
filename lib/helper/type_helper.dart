class TypeHelper<T> {
  const TypeHelper();
  bool operator >=(TypeHelper other) => other is TypeHelper<T>;
  bool operator <=(TypeHelper other) => other >= this;
  bool operator >(TypeHelper other) => this >= other && !(other >= this);
  bool operator <(TypeHelper other) => other >= this && ! (this >= other);
}