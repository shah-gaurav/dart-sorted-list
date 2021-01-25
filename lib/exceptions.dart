/// An exception thrown by the [SortedList] class when a not supported operation
/// is executed
class NotSupportedException implements Exception {
  final String message;
  NotSupportedException(this.message);
  @override
  String toString() {
    return 'NotSupportedException: $message';
  }
}
