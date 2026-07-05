import 'slot.dart';

enum BookingStatus {
  active,
  cancelledByClient,
  cancelledByWorkshop,
  attended,
  noShow;

  String get displayName => switch (this) {
        BookingStatus.active => 'Активно',
        BookingStatus.cancelledByClient => 'Отменено',
        BookingStatus.cancelledByWorkshop => 'Отменено мастерской',
        BookingStatus.attended => 'Посещено',
        BookingStatus.noShow => 'Не явился',
      };

  String get apiValue => switch (this) {
        BookingStatus.active => 'active',
        BookingStatus.cancelledByClient => 'cancelled_by_client',
        BookingStatus.cancelledByWorkshop => 'cancelled_by_workshop',
        BookingStatus.attended => 'attended',
        BookingStatus.noShow => 'no_show',
      };

  static BookingStatus fromApi(String value) => switch (value) {
        'active' => BookingStatus.active,
        'cancelled_by_client' => BookingStatus.cancelledByClient,
        'cancelled_by_workshop' => BookingStatus.cancelledByWorkshop,
        'attended' => BookingStatus.attended,
        'no_show' => BookingStatus.noShow,
        _ => throw ArgumentError('Unknown booking status: $value'),
      };
}

class Booking {
  const Booking({
    required this.id,
    required this.clientId,
    required this.slot,
    required this.needsRental,
    this.status = BookingStatus.active,
    required this.createdAt,
    this.rating,
    this.cancellationReason,
  });

  final String id;
  final String clientId;
  final Slot slot;
  final bool needsRental;
  final BookingStatus status;
  final DateTime createdAt;
  final int? rating;
  final String? cancellationReason;

  bool get isCancellable {
    if (status != BookingStatus.active) return false;
    return slot.startTime.difference(DateTime.now()).inMinutes > 10;
  }

  bool get isRateable =>
      (status == BookingStatus.attended ||
          (slot.hasEnded && status == BookingStatus.active)) &&
      rating == null;

  bool get isUpcoming => status == BookingStatus.active && !slot.hasStarted;
  bool get isPast => status != BookingStatus.active || slot.hasEnded;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        clientId: json['client_id'] as String,
        slot: Slot.fromJson(json['slot'] as Map<String, dynamic>),
        needsRental: json['needs_rental'] as bool? ?? false,
        status: json['status'] != null
            ? BookingStatus.fromApi(json['status'] as String)
            : BookingStatus.active,
        createdAt: DateTime.parse(json['created_at'] as String),
        rating: json['rating'] as int?,
        cancellationReason: json['cancellation_reason'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'client_id': clientId,
        'slot': slot.toJson(),
        'needs_rental': needsRental,
        'status': status.apiValue,
        'created_at': createdAt.toIso8601String(),
        'rating': rating,
        'cancellation_reason': cancellationReason,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Booking && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Booking($id → ${slot.id}, $status)';
}
