import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/models.dart';

/// Карточка занятия в списке расписания.
class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.slot,
    this.onTap,
  });

  final Slot slot;
  final VoidCallback? onTap;

  bool get _cancelled => slot.status == SlotStatus.cancelledByWorkshop;

  Color _accentColor(ColorScheme cs) {
    if (_cancelled) return AppTheme.slotAccentCancelled;
    if (slot.status == SlotStatus.fullyBooked || slot.availableSeats == 0) {
      return AppTheme.slotAccentFull;
    }
    return AppTheme.slotAccentAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accent = _accentColor(cs);

    Widget content = Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: slot.isBookable ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(14),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _headerRow(theme, accent),
                        const SizedBox(height: 10),
                        _programTitle(theme),
                        const SizedBox(height: 10),
                        _masterLine(theme),
                        const SizedBox(height: 10),
                        _footerRow(theme),
                        if (_cancelled && slot.cancellationReason != null) ...[
                          const SizedBox(height: 12),
                          _cancelReason(cs),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (_cancelled) {
      content = Opacity(opacity: 0.5, child: content);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: content,
    );
  }

  Widget _headerRow(ThemeData theme, Color accent) {
    return Row(
      children: [
        Text(
          _shortDate(slot.startTime),
          style: theme.textTheme.labelLarge?.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${_hhmm(slot.startTime)} – ${_hhmm(slot.endTime)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        _statusLabel(theme),
      ],
    );
  }

  Widget _programTitle(ThemeData theme) {
    final base = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.2,
    );

    return Text(
      slot.program.displayName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: _cancelled
          ? base?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : base,
    );
  }

  Widget _masterLine(ThemeData theme) {
    final cs = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _cancelled ? cs.outlineVariant : cs.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            slot.master.name.isNotEmpty
                ? slot.master.name[0].toUpperCase()
                : '?',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _cancelled
                  ? cs.onSurfaceVariant
                  : cs.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            slot.master.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (slot.master.averageRating > 0 && !_cancelled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cs.secondaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 13, color: cs.secondary),
                const SizedBox(width: 3),
                Text(
                  slot.master.averageRating.toStringAsFixed(1),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _footerRow(ThemeData theme) {
    final cs = theme.colorScheme;
    final mins = slot.durationMinutes;
    final h = mins ~/ 60;
    final m = mins % 60;
    final duration = h > 0 ? '$h ч $m мин' : '$m мин';

    return Row(
      children: [
        Icon(Icons.timelapse, size: 15, color: cs.outline),
        const SizedBox(width: 4),
        Text(
          duration,
          style: theme.textTheme.labelMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        if (slot.status == SlotStatus.available) ...[
          Icon(
            Icons.event_seat_outlined,
            size: 15,
            color: slot.availableSeats <= 2 ? cs.error : cs.outline,
          ),
          const SizedBox(width: 4),
          Text(
            '${slot.availableSeats} из ${slot.totalSeats}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: slot.availableSeats <= 2 ? cs.error : cs.onSurfaceVariant,
              fontWeight:
                  slot.availableSeats <= 2 ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _statusLabel(ThemeData theme) {
    final cs = theme.colorScheme;

    if (_cancelled) {
      return _pill(
        theme,
        label: 'Отменено',
        bg: cs.errorContainer,
        fg: cs.onErrorContainer,
      );
    }
    if (slot.status == SlotStatus.fullyBooked || slot.availableSeats == 0) {
      return _pill(
        theme,
        label: 'Нет мест',
        bg: cs.outlineVariant,
        fg: cs.onSurfaceVariant,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _pill(
    ThemeData theme, {
    required String label,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _cancelReason(ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 15, color: cs.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              slot.cancellationReason!,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shortDate(DateTime d) {
    const months = [
      '', 'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
    ];
    return '${d.day} ${months[d.month]}';
  }

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
