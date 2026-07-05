import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../common/empty_state.dart';
import '../widgets/booking_sheet.dart';
import '../widgets/slot_card.dart';

/// Экран расписания занятий.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final ScheduleViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = ScheduleViewModel();
    _vm.addListener(_refresh);
    _vm.loadSchedule();
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Глина',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Расписание',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_vm.isLoading) return const _LoadingSkeleton();

    if (_vm.error != null) {
      return EmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Не удалось загрузить',
        subtitle: _vm.error,
        actionLabel: 'Обновить',
        onAction: _vm.retry,
      );
    }

    if (_vm.isEmpty) {
      return const EmptyState(
        icon: Icons.hourglass_empty_outlined,
        title: 'Занятий пока нет',
        subtitle: 'Загляните позже — расписание обновляется регулярно',
      );
    }

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: _vm.loadSchedule,
      child: _slotList(),
    );
  }

  Widget _slotList() {
    final grouped = _byDay(_vm.slots);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 4, bottom: 28),
      itemCount: grouped.length,
      itemBuilder: (context, i) {
        final e = grouped.entries.elementAt(i);
        return _DaySection(
          day: e.key,
          slots: e.value,
          onTap: _openBooking,
        );
      },
    );
  }

  Future<void> _openBooking(Slot slot) async {
    if (!slot.isBookable) return;

    final result = await BookingSheet.show(context, slot);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Запись оформлена: ${slot.program.displayName}')),
      );
    }
  }

  Map<DateTime, List<Slot>> _byDay(List<Slot> slots) {
    final map = <DateTime, List<Slot>>{};
    for (final s in slots) {
      final key = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
      map.putIfAbsent(key, () => []).add(s);
    }
    return map;
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.day,
    required this.slots,
    required this.onTap,
  });

  final DateTime day;
  final List<Slot> slots;
  final void Function(Slot) onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        day.day == now.day && day.month == now.month && day.year == now.year;

    const weekdays = [
      'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс',
    ];
    const months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];

    final weekday = weekdays[day.weekday - 1];
    final caption = isToday
        ? 'Сегодня · ${day.day} ${months[day.month]}'
        : '$weekday · ${day.day} ${months[day.month]}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
          child: Row(
            children: [
              if (isToday)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                caption,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
              ),
            ],
          ),
        ),
        ...slots.map((s) => SlotCard(slot: s, onTap: () => onTap(s))),
      ],
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.outlineVariant;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 118,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: fill),
          ),
          child: Row(
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bar(fill, 90, 12),
                      const SizedBox(height: 12),
                      _bar(fill, 160, 16),
                      const SizedBox(height: 10),
                      _bar(fill, 120, 12),
                      const Spacer(),
                      _bar(fill, 80, 11),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(Color c, double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
