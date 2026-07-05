import '../models/models.dart';

/// Mock implementation of the backend API service.
///
/// Returns hardcoded data simulating the real backend responses.
/// Used for development and testing before the real API is integrated.
class MockApiService {
  static final _masters = [
    const Master(
      id: 'm1',
      name: 'Анна Кузнецова',
      avatarUrl: null,
      bio: 'Мастер гончарного дела с 8-летним стажем. Специализация — работа на круге.',
      averageRating: 4.9,
      totalRatings: 47,
    ),
    const Master(
      id: 'm2',
      name: 'Дмитрий Волков',
      avatarUrl: null,
      bio: 'Художник-керамист, преподаёт ручную лепку. Любит работать с начинающими.',
      averageRating: 4.7,
      totalRatings: 34,
    ),
    const Master(
      id: 'm3',
      name: 'Елена Соколова',
      avatarUrl: null,
      bio: 'Молодой мастер, увлекается современной керамикой и глазурями.',
      averageRating: 4.2,
      totalRatings: 18,
    ),
    const Master(
      id: 'm4',
      name: 'Павел Морозов',
      avatarUrl: null,
      bio: 'Гончар в третьем поколении. Проводит мастер-классы по традиционной русской керамике.',
      averageRating: 4.8,
      totalRatings: 52,
    ),
  ];

  static const _address = 'ул. Гончарная, д. 12, Москва';

  /// Generates hardcoded slots for the next 7 days.
  ///
  /// Includes:
  /// - A slot cancelled by the workshop (force majeure).
  /// - A fully booked slot (0 available seats).
  /// - A slot with few remaining seats.
  /// - Regular available slots.
  List<Slot> getSchedule() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      // --- Day 1 (today) ---
      Slot(
        id: 's1',
        startTime: today.add(const Duration(hours: 10)),
        endTime: today.add(const Duration(hours: 12, minutes: 30)),
        program: ProgramType.handBuilding,
        master: _masters[1],
        totalSeats: 6,
        availableSeats: 3,
        rentalInventoryAvailable: 4,
        status: SlotStatus.available,
        address: _address,
        description: 'Базовый мастер-класс по ручной лепке. Научитесь создавать простые формы без гончарного круга.',
      ),
      Slot(
        id: 's2',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 16, minutes: 30)),
        program: ProgramType.wheelThrowing,
        master: _masters[0],
        totalSeats: 10,
        availableSeats: 0,
        rentalInventoryAvailable: 2,
        status: SlotStatus.fullyBooked,
        address: _address,
        description: 'Работа на гончарном круге для тех, кто уже пробовал. Опыт приветствуется.',
      ),
      Slot(
        id: 's3',
        startTime: today.add(const Duration(hours: 17)),
        endTime: today.add(const Duration(hours: 19, minutes: 30)),
        program: ProgramType.handBuilding,
        master: _masters[2],
        totalSeats: 6,
        availableSeats: 5,
        rentalInventoryAvailable: 6,
        status: SlotStatus.available,
        address: _address,
        description: 'Вечерний мастер-класс по лепке. Отличный вариант после рабочего дня.',
      ),

      // --- Day 2 ---
      Slot(
        id: 's4',
        startTime: today.add(const Duration(days: 1, hours: 10)),
        endTime: today.add(const Duration(days: 1, hours: 12, minutes: 30)),
        program: ProgramType.wheelThrowing,
        master: _masters[3],
        totalSeats: 10,
        availableSeats: 4,
        rentalInventoryAvailable: 5,
        status: SlotStatus.available,
        address: _address,
        description: 'Классический гончарный круг. Научитесь центровать и вытягивать форму.',
      ),
      Slot(
        id: 's5',
        startTime: today.add(const Duration(days: 1, hours: 14)),
        endTime: today.add(const Duration(days: 1, hours: 16, minutes: 30)),
        program: ProgramType.handBuilding,
        master: _masters[1],
        totalSeats: 6,
        availableSeats: 2,
        rentalInventoryAvailable: 3,
        status: SlotStatus.available,
        address: _address,
        description: 'Продвинутая лепка: создаём декоративные тарелки и чаши.',
      ),

      // --- Day 3 ---
      Slot(
        id: 's6',
        startTime: today.add(const Duration(days: 2, hours: 11)),
        endTime: today.add(const Duration(days: 2, hours: 13, minutes: 30)),
        program: ProgramType.wheelThrowing,
        master: _masters[0],
        totalSeats: 10,
        availableSeats: 1,
        rentalInventoryAvailable: 1,
        status: SlotStatus.available,
        address: _address,
        description: 'Интенсив по гончарному кругу. Осталось всего 1 место!',
      ),
      Slot(
        id: 's7',
        startTime: today.add(const Duration(days: 2, hours: 15)),
        endTime: today.add(const Duration(days: 2, hours: 17, minutes: 30)),
        program: ProgramType.handBuilding,
        master: _masters[2],
        totalSeats: 6,
        availableSeats: 6,
        rentalInventoryAvailable: 6,
        status: SlotStatus.available,
        address: _address,
        description: 'Семейный мастер-класс. Можно прийти с детьми от 10 лет.',
      ),

      // --- Day 4 ---
      Slot(
        id: 's8',
        startTime: today.add(const Duration(days: 3, hours: 10)),
        endTime: today.add(const Duration(days: 3, hours: 12, minutes: 30)),
        program: ProgramType.wheelThrowing,
        master: _masters[3],
        totalSeats: 10,
        availableSeats: 7,
        rentalInventoryAvailable: 8,
        status: SlotStatus.available,
        address: _address,
        description: 'Утренний круг. Идеально для тех, кто хочет начать день с творчества.',
      ),

      // --- Day 5 ---
      Slot(
        id: 's9',
        startTime: today.add(const Duration(days: 4, hours: 14)),
        endTime: today.add(const Duration(days: 4, hours: 16, minutes: 30)),
        program: ProgramType.handBuilding,
        master: _masters[1],
        totalSeats: 6,
        availableSeats: 4,
        rentalInventoryAvailable: 5,
        status: SlotStatus.available,
        address: _address,
        description: 'Лепка и декор: создаём авторскую кружку с росписью.',
      ),

      // --- Day 6 ---
      Slot(
        id: 's10',
        startTime: today.add(const Duration(days: 5, hours: 11)),
        endTime: today.add(const Duration(days: 5, hours: 13, minutes: 30)),
        program: ProgramType.wheelThrowing,
        master: _masters[0],
        totalSeats: 10,
        availableSeats: 8,
        rentalInventoryAvailable: 10,
        status: SlotStatus.available,
        address: _address,
        description: 'Гончарный круг для продолжающих. Отработка техники.',
      ),

      // --- Day 7 ---
      Slot(
        id: 's11',
        startTime: today.add(const Duration(days: 6, hours: 10)),
        endTime: today.add(const Duration(days: 6, hours: 12, minutes: 30)),
        program: ProgramType.handBuilding,
        master: _masters[2],
        totalSeats: 6,
        availableSeats: 3,
        rentalInventoryAvailable: 4,
        status: SlotStatus.available,
        address: _address,
        description: 'Воскресная лепка. Создаём интерьерные вазы и кашпо.',
      ),

      // --- CANCELLED BY WORKSHOP (force majeure) ---
      Slot(
        id: 's12',
        startTime: today.add(const Duration(days: 6, hours: 14)),
        endTime: today.add(const Duration(days: 6, hours: 16, minutes: 30)),
        program: ProgramType.wheelThrowing,
        master: _masters[3],
        totalSeats: 10,
        availableSeats: 0,
        rentalInventoryAvailable: 0,
        status: SlotStatus.cancelledByWorkshop,
        cancellationReason: 'Поломка печи для обжига. Занятие переносится. Приносим извинения за неудобства.',
        address: _address,
        description: 'Отменено. Ведутся ремонтные работы.',
      ),
    ];
  }

  /// Simulates booking a slot.
  ///
  /// Returns a [Booking] on success, or throws an exception on failure
  /// (e.g., no available seats, slot cancelled, or network error).
  Future<Booking> bookSlot({
    required String slotId,
    required String clientId,
    required bool needsRental,
  }) async {
    // Simulate network delay.
    await Future.delayed(const Duration(milliseconds: 800));

    final slots = getSchedule();
    final slot = slots.firstWhere(
      (s) => s.id == slotId,
      orElse: () => throw const ApiException('Слот не найден'),
    );

    if (slot.status == SlotStatus.cancelledByWorkshop) {
      throw const ApiException('Это занятие отменено мастерской. Запись невозможна.');
    }

    if (slot.status == SlotStatus.fullyBooked || slot.availableSeats <= 0) {
      throw const ApiException('На это занятие больше нет свободных мест.');
    }

    if (slot.hasStarted) {
      throw const ApiException('Занятие уже началось. Запись невозможна.');
    }

    if (needsRental && slot.rentalInventoryAvailable <= 0) {
      throw const ApiException('Прокат инструментов на эту дату недоступен. Вы можете записаться со своими инструментами.');
    }

    return Booking(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      clientId: clientId,
      slot: slot,
      needsRental: needsRental,
      status: BookingStatus.active,
      createdAt: DateTime.now(),
    );
  }

  /// Simulates cancelling a booking.
  ///
  /// Throws if cancellation is not allowed (less than 10 minutes before start).
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real scenario, we'd look up the booking and check timing.
    // For mock purposes, cancellation always succeeds.
  }

  /// Simulates rating a master after a completed class.
  Future<void> rateMaster({
    required String bookingId,
    required int rating,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (rating < 1 || rating > 5) {
      throw const ApiException('Оценка должна быть от 1 до 5');
    }
  }

  /// Returns hardcoded bookings for a given client.
  ///
  /// Includes a mix of active, past, and cancelled-by-workshop bookings.
  List<Booking> getClientBookings(String clientId) {
    final slots = getSchedule();

    return [
      // Active booking — upcoming class.
      Booking(
        id: 'b1',
        clientId: clientId,
        slot: slots[0], // s1 — today, hand building, 3 seats available
        needsRental: true,
        status: BookingStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      // Active booking — almost full slot.
      Booking(
        id: 'b2',
        clientId: clientId,
        slot: slots[4], // s5 — day 2, hand building, 2 seats available
        needsRental: false,
        status: BookingStatus.active,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),

      // Cancelled by workshop (force majeure).
      Booking(
        id: 'b3',
        clientId: clientId,
        slot: slots[11], // s12 — cancelled by workshop
        needsRental: true,
        status: BookingStatus.cancelledByWorkshop,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        cancellationReason: 'Поломка печи для обжига.',
      ),

      // Past booking with rating.
      Booking(
        id: 'b4',
        clientId: clientId,
        slot: Slot(
          id: 's_old1',
          startTime: DateTime.now().subtract(const Duration(days: 10)),
          endTime: DateTime.now().subtract(const Duration(days: 10, hours: -2, minutes: -30)),
          program: ProgramType.wheelThrowing,
          master: _masters[0],
          totalSeats: 10,
          availableSeats: 0,
          rentalInventoryAvailable: 0,
          status: SlotStatus.available,
          address: _address,
        ),
        needsRental: true,
        status: BookingStatus.attended,
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
        rating: 5,
      ),

      // Past booking without rating (rateable).
      Booking(
        id: 'b5',
        clientId: clientId,
        slot: Slot(
          id: 's_old2',
          startTime: DateTime.now().subtract(const Duration(days: 5)),
          endTime: DateTime.now().subtract(const Duration(days: 5, hours: -2, minutes: -30)),
          program: ProgramType.handBuilding,
          master: _masters[1],
          totalSeats: 6,
          availableSeats: 0,
          rentalInventoryAvailable: 0,
          status: SlotStatus.available,
          address: _address,
        ),
        needsRental: false,
        status: BookingStatus.attended,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        rating: null, // Not yet rated.
      ),
    ];
  }
}

/// Exception thrown by [MockApiService] on business logic errors.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}