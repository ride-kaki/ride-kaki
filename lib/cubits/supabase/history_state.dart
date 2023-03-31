part of 'history_cubit.dart';

@immutable
abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<History> currentHistory;
  HistoryLoaded({required this.currentHistory});
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError({required this.message});
}

class HistoryEmpty extends HistoryState {
  HistoryEmpty();
}
