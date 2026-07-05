import 'master.dart';

enum ProgramType {
  handBuilding,
  wheelThrowing;

  String get displayName => switch (this) {
        ProgramType.handBuilding => 'Ручная лепка',
        ProgramType.wheelThrowing => 'Гончарный круг',
      };

  String get apiValue => switch (this) {
        ProgramType.handBuilding => 'hand_building',
        ProgramType.wheelThrowing => 'wheel_throwing',
      };

  static ProgramType fromApi(String value) => switch (value) {
        'hand_building' => ProgramType.handBuilding,
        'wheel_throwing' => ProgramType.wheelThrowing,
        _ => throw ArgumentError('Unknown program type: $value'),
      };
}

enum SlotStatus {
  available,
  fullyBooked,
  cancelledByWorkshop;

  String get displayName => switch (this) {
        SlotStatus.available => 'Доступно',
        SlotStatus.fullyBooked => 'Мест нет',
        SlotStatus.cancelledByWorkshop => 'Отменено мастерской',
      };

  String get apiValue => switch (this) {
        SlotStatus.available => 'available',
        SlotStatus.fullyBooked => 'fully_booked',
        SlotStatus.cancelledByWorkshop => 'cancelled_by_workshop',
      };

  static SlotStatus fromApi(String value) => switch (value) {
        'available' => SlotStatus.available,
        'fully_booked' => SlotStatus.fullyBooked,
        'cancelled_by_workshop' => SlotStatus.cancelledByWorkshop,
        _ => throw ArgumentError('Unknown slot status: $value'),
      };
}

class Slot {
  const Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.program,
    required this.master,
    required this.totalSeats,
    required this.availableSeats,
    this.rentalInventoryAvailable = 0,
    this.status = SlotStatus.available,
    this.cancellationReason,
    required this.address,
    this.description,
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final ProgramType program;
  final Master master;
  final int totalSeats;
  final int availableSeats;
  final int rentalInventoryAvailable;
  final SlotStatus status;
  final String? cancellationReason;
  final String address;
  final String? description;

  bool get hasStarted => DateTime.now().isAfter(startTime);
  bool get hasEnded => DateTime.now().isAfter(endTime);
  bool get isPast => hasEnded;
  bool get isUpcoming => !hasStarted;

  bool get isBookable =>
      status == SlotStatus.available && availableSeats > 0 && !hasStarted;

  int get durationMinutes => endTime.difference(startTime).inMinutes;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json['id'] as String,
        startTime: DateTime.parse(json['start_time'] as String),
        endTime: DateTime.parse(json['end_time'] as String),
        program: ProgramType.fromApi(json['program'] as String),
        master: Master.fromJson(json['master'] as Map<String, dynamic>),
        totalSeats: (json['total_seats'] as num).toInt(),
        availableSeats: (json['available_seats'] as num).toInt(),
        rentalInventoryAvailable:
            (json['rental_inventory_available'] as num?)?.toInt() ?? 0,
        status: json['status'] != null
            ? SlotStatus.fromApi(json['status'] as String)
            : SlotStatus.available,
        cancellationReason: json['cancellation_reason'] as String?,
        address: json['address'] as String? ?? '',
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'program': program.apiValue,
        'master': master.toJson(),
        'total_seats': totalSeats,
        'available_seats': availableSeats,
        'rental_inventory_available': rentalInventoryAvailable,
        'status': status.apiValue,
        'cancellation_reason': cancellationReason,
        'address': address,
        'description': description,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Slot && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Slot($id, ${program.displayName}, $availableSeats/$totalSeats)';
}
