import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/mock_api_service.dart';

/// Состояние экрана расписания.
class ScheduleViewModel extends ChangeNotifier {
  ScheduleViewModel({MockApiService? apiService})
      : _api = apiService ?? MockApiService();

  final MockApiService _api;

  List<Slot> _slots = [];
  bool _loading = false;
  String? _error;

  List<Slot> get slots => _slots;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isEmpty => !_loading && _error == null && _slots.isEmpty;

  Future<void> loadSchedule() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _slots = _api.getSchedule();
      _error = null;
    } catch (_) {
      _slots = [];
      _error =
          'Не удалось загрузить расписание. Проверьте соединение и попробуйте снова.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> retry() => loadSchedule();
}
