import 'package:flutter/material.dart';

import '../../models/models.dart';

/// Экран подтверждения успешной записи (внутри bottom sheet).
class BookingSuccessContent extends StatelessWidget {
  const BookingSuccessContent({
    super.key,
    required this.booking,
    required this.onClose,
  });

  final Booking booking;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final slot = booking.slot;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(cs),
            const SizedBox(height: 28),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.check, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 22),
            Text(
              'Запись подтверждена',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'До встречи в мастерской!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                children: [
                  _row(theme, 'Занятие', slot.program.displayName),
                  _divider(cs),
                  _row(theme, 'Мастер', slot.master.name),
                  _divider(cs),
                  _row(
                    theme,
                    'Дата',
                    '${slot.startTime.day}.${slot.startTime.month}.${slot.startTime.year}',
                  ),
                  _divider(cs),
                  _row(
                    theme,
                    'Время',
                    '${_t(slot.startTime)} – ${_t(slot.endTime)}',
                  ),
                  _divider(cs),
                  _row(theme, 'Адрес', slot.address),
                  if (booking.needsRental) ...[
                    _divider(cs),
                    _row(theme, 'Инвентарь', 'Аренда инструментов и фартука'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: onClose, child: const Text('Закрыть')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _handle(ColorScheme cs) => Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: cs.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  Widget _divider(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: cs.outlineVariant, height: 1),
      );

  Widget _row(ThemeData theme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  String _t(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
