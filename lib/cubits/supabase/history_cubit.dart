import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_kaki/models/history.dart';
import 'package:ride_kaki/supabase/snackbar.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoading());

  StreamSubscription<List<History>>? _historyList;
  List<History> _history = [];

  late final String _userId;

  final String table = 'history';

  void initializeHistory() async {
    _userId = supabase.auth.currentUser!.id;

    _historyList = supabase
        .from(table)
        .stream(primaryKey: ['user_id'])
        .eq('user_id', _userId)
        .order('created_at')
        .limit(3)
        .map((event) => event.map<History>((e) => History.fromJson(e)).toList())
        .listen((data) {
          _history = data;
          if (_history.isEmpty) {
            emit(HistoryEmpty());
          } else {
            emit(HistoryLoaded(currentHistory: _history));
          }
        });
  }

  Future<List<dynamic>> addHistory(History history) async {
    return supabase.from(table).insert(history.toJson()).select();
  }
}
