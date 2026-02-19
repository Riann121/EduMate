import 'package:edumate/home_page/models/weekly_submission_item.dart';
import 'package:flutter/material.dart';

class WeeklySubmissionsSection extends StatefulWidget {
  const WeeklySubmissionsSection({super.key});

  @override
  State<WeeklySubmissionsSection> createState() =>
      _WeeklySubmissionsSectionState();
}

class _WeeklySubmissionsSectionState extends State<WeeklySubmissionsSection> {
  late final List<WeeklySubmissionItem> _weeklySubmissions;

  @override
  void initState() {
    super.initState();
    _weeklySubmissions = buildDummyWeeklySubmissionItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _weeklySubmissionsTitle(context),
          const SizedBox(height: 14),
          ..._weeklySubmissionsContent(),
        ],
      ),
    );
  }

  // ---------- Weekly Submissions Section outer box ----------
  BoxDecoration _sectionBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }

  //section title
  Widget _weeklySubmissionsTitle(BuildContext context) {
    return Text(
      "This Week's Assignments & Lab Reports",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  //section content - list of weekly submissions or empty state
  List<Widget> _weeklySubmissionsContent() {
    if (_weeklySubmissions.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'No assignments or lab reports due this week',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ];
    }

    return _weeklySubmissions
        .asMap()
        .entries
        .map((entry) {
          return _weeklySubmissionTile(index: entry.key, item: entry.value);
        })
        .toList(growable: false);
  }

  //weekly submission tile with course name, title, type, deadline and done toggle chip and button
  Widget _weeklySubmissionTile({
    required int index,
    required WeeklySubmissionItem item,
  }) {
    final isDone = item.isDone;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        decoration: _weeklySubmissionTileDecoration(),
        child: _weeklySubmissionTileContent(
          index: index,
          item: item,
          isDone: isDone,
        ),
      ),
    );
  }

  BoxDecoration _weeklySubmissionTileDecoration() {
    return BoxDecoration(
      color: const Color(0xFFEFEFEF),
      borderRadius: BorderRadius.circular(14),
    );
  }

  Widget _weeklySubmissionTileContent({
    required int index,
    required WeeklySubmissionItem item,
    required bool isDone,
  }) {
    return Row(
      children: [
        Expanded(child: _weeklySubmissionDetails(item)),
        const SizedBox(width: 8),
        _weeklySubmissionActions(index: index, item: item, isDone: isDone),
      ],
    );
  }

  Widget _weeklySubmissionDetails(WeeklySubmissionItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _weeklySubmissionMetaText(item.courseName, fontSize: 13),
        const SizedBox(height: 3),
        _weeklySubmissionTitleText(item.title),
        const SizedBox(height: 3),
        _weeklySubmissionMetaText(item.type),
        const SizedBox(height: 2),
        _weeklySubmissionMetaText('Deadline: ${_deadlineLabel(item.dueDate)}'),
      ],
    );
  }

  Widget _weeklySubmissionActions({
    required int index,
    required WeeklySubmissionItem item,
    required bool isDone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _weeklySubmissionToggleChip(index: index, item: item),
        const SizedBox(height: 6),
        _weeklySubmissionDoneButton(index: index, isDone: isDone),
      ],
    );
  }

  Widget _weeklySubmissionMetaText(String value, {double fontSize = 12}) {
    return Text(
      value,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _weeklySubmissionTitleText(String value) {
    return Text(
      value,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  //submission functionalities - toggle chip and remove button
  Widget _weeklySubmissionToggleChip({
    required int index,
    required WeeklySubmissionItem item,
  }) {
    final isDone = item.isDone;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => _toggleWeeklySubmissionStatus(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFFDDF4DD) : const Color(0xFFFFE9CC),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isDone ? const Color(0xFF81C784) : const Color(0xFFFFCC80),
          ),
        ),
        child: Text(
          isDone ? 'Done' : 'Pending',
          style: TextStyle(
            color: isDone ? const Color(0xFF2E7D32) : const Color(0xFFEF6C00),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _weeklySubmissionDoneButton({
    required int index,
    required bool isDone,
  }) {
    return TextButton(
      onPressed: isDone ? () => _removeWeeklySubmission(index) : null,
      style: TextButton.styleFrom(
        minimumSize: const Size(56, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      child: const Text(
        'Remove',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _toggleWeeklySubmissionStatus(int index) {
    setState(() {
      final current = _weeklySubmissions[index];
      _weeklySubmissions[index] = current.copyWith(isDone: !current.isDone);
    });
  }

  void _removeWeeklySubmission(int index) {
    setState(() {
      _weeklySubmissions.removeAt(index);
    });
  }

  String _deadlineLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final target = DateUtils.dateOnly(date);
    final dayDiff = target.difference(today).inDays;

    if (dayDiff == 0) {
      return 'Today';
    }
    if (dayDiff == 1) {
      return 'Tomorrow';
    }

    const monthShort = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${monthShort[target.month - 1]} ${target.day}';
  }
}
