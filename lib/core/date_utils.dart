/// Utility functions for date operations.
library;

/// Get the Monday of the week containing [date].
/// Returns the date adjusted to the start of the week (Monday at 00:00).
DateTime getMondayOfWeek(DateTime date) {
  final daysToMonday = date.weekday - 1; // Monday is 1, Sunday is 7
  return date
      .subtract(Duration(days: daysToMonday))
      .copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
}
