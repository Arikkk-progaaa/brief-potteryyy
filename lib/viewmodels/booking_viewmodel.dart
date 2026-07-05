import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/mock_api_service.dart';

/// Состояние формы записи на занятие.
class BookingViewModel extends ChangeNotifier {
  BookingViewModel({
    required Slot slot,
    required String clientId,
    MockApiService? apiService,
  })  : _slot = slot,
        _clientId = clientId,
        _api = apiService ?? MockApiService();

  final MockApiService _api;
  final Slot _slot;
  final String _clientId;

  int _seats = 1;
  bool _needsRental = false;
  bool _submitting = false;
  String? _error;
  Booking? _result;

  int get seats => _seats;
  bool get needsRental => _needsRental;
  int get maxSeats => _slot.availableSeats;
  int get minSeats => 1;
  Slot get slot => _slot;
  bool get isSubmitting => _submitting;
  String? get error => _error;
  Booking? get bookingResult => _result;
  bool get isSuccess => _result != null;

  void setSeats(int value) {
    if (_submitting) return;
    if (value < minSeats) value = minSeats;
    if (value > maxSeats) value = maxSeats;
    _seats = value;
    _dropError();
    notifyListeners();
  }

  void incrementSeats() {
    if (_submitting || _seats >= maxSeats) return;
    _seats++;
    _dropError();
    notifyListeners();
  }

  void decrementSeats() {
    if (_submitting || _seats <= minSeats) return;
    _seats--;
    _dropError();
    notifyListeners();
  }

  void toggleRental(bool value) {
    if (_submitting) return;
    _needsRental = value;
    _dropError();
    notifyListeners();
  }

  Future<void> submitBooking() async {
    if (_submitting) return;

    _submitting = true;
    _error = null;
    notifyListeners();

    try {
      final count = _seats;
      Booking? last;

      for (var i = 0; i < count; i++) {
        last = await _api.bookSlot(
          slotId: _slot.id,
          clientId: _clientId,
          needsRental: _needsRental,
        );
      }

      _result = last;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _result = null;
    } catch (_) {
      _error =
          'Не удалось выполнить запись. Проверьте соединение и попробуйте снова.';
      _result = null;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  void reset() {
    _seats = 1;
    _needsRental = false;
    _submitting = false;
    _error = null;
    _result = null;
    notifyListeners();
  }

  void _dropError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
