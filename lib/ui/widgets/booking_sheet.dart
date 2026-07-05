import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../viewmodels/booking_viewmodel.dart';
import '../screens/booking_success_screen.dart';

/// Bottom sheet для записи на занятие.
class BookingSheet extends StatefulWidget {
  const BookingSheet({super.key, required this.slot});

  final Slot slot;

  static Future<Booking?> show(BuildContext context, Slot slot) {
    return showModalBottomSheet<Booking>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BookingSheet(slot: slot),
    );
  }

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  late final BookingViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = BookingViewModel(slot: widget.slot, clientId: 'client_001');
    _vm.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _vm.removeListener(_refresh);
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_vm.isSuccess) {
      return BookingSuccessContent(
        booking: _vm.bookingResult!,
        onClose: () => Navigator.of(context).pop(_vm.bookingResult),
      );
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(22, 10, 22, bottom + 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Запись',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.slot.program.displayName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          _SummaryBlock(slot: widget.slot),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          _SeatPicker(
            count: _vm.seats,
            max: _vm.maxSeats,
            enabled: !_vm.isSubmitting,
            onMinus: _vm.decrementSeats,
            onPlus: _vm.incrementSeats,
          ),
          const SizedBox(height: 14),
          _RentalRow(
            checked: _vm.needsRental,
            available: widget.slot.rentalInventoryAvailable > 0,
            enabled: !_vm.isSubmitting,
            onChanged: _vm.toggleRental,
          ),
          if (_vm.error != null) ...[
            const SizedBox(height: 16),
            _ErrorBanner(message: _vm.error!),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _vm.isSubmitting ? null : _vm.submitBooking,
            child: _vm.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Подтвердить запись'),
          ),
        ],
      ),
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock({required this.slot});

  final Slot slot;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final date =
        '${slot.startTime.day}.${slot.startTime.month}.${slot.startTime.year}';
    final time =
        '${_hh(slot.startTime)} – ${_hh(slot.endTime)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _line(context, Icons.schedule, '$date, $time'),
          const SizedBox(height: 8),
          _line(context, Icons.person, slot.master.name),
          const SizedBox(height: 8),
          _line(context, Icons.place_outlined, slot.address),
          const SizedBox(height: 8),
          _line(context, Icons.event_seat, 'Свободно: ${slot.availableSeats}'),
        ],
      ),
    );
  }

  Widget _line(BuildContext context, IconData icon, String text) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 17, color: cs.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface,
                  height: 1.35,
                ),
          ),
        ),
      ],
    );
  }

  String _hh(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _SeatPicker extends StatelessWidget {
  const _SeatPicker({
    required this.count,
    required this.max,
    required this.enabled,
    required this.onMinus,
    required this.onPlus,
  });

  final int count;
  final int max;
  final bool enabled;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Мест',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        _roundBtn(
          context,
          icon: Icons.remove,
          active: enabled && count > 1,
          onTap: enabled && count > 1 ? onMinus : null,
        ),
        Container(
          width: 44,
          alignment: Alignment.center,
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.primary,
                ),
          ),
        ),
        _roundBtn(
          context,
          icon: Icons.add,
          active: enabled && count < max,
          onTap: enabled && count < max ? onPlus : null,
        ),
      ],
    );
  }

  Widget _roundBtn(
    BuildContext context, {
    required IconData icon,
    required bool active,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: active ? cs.primary : cs.outlineVariant,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 20,
            color: active ? Colors.white : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _RentalRow extends StatelessWidget {
  const _RentalRow({
    required this.checked,
    required this.available,
    required this.enabled,
    required this.onChanged,
  });

  final bool checked;
  final bool available;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: const Text('Аренда инвентаря'),
        subtitle: available
            ? const Text('Инструменты и фартук')
            : Text(
                'Сейчас недоступно',
                style: TextStyle(color: cs.error, fontSize: 12),
              ),
        value: checked && available,
        onChanged: enabled && available ? onChanged : null,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 20, color: cs.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onErrorContainer,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
