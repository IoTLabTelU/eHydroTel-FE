import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  static const String path = 'notification';

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String filter = 'All';
  final List<_NotifItem> items = [
    _NotifItem(title: 'pH High', subtitle: 'pH reached 7.2 on Meja 1', type: 'Warning', time: '10:24'),
    _NotifItem(title: 'PPM Low', subtitle: 'PPM dropped to 730 on Meja 2', type: 'Alert', time: '09:51'),
    _NotifItem(title: 'Device Online', subtitle: 'Meja 3 is back online', type: 'Info', time: '08:10', read: true),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'All' ? items : items.where((e) => e.type == filter).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: Theme.of(context).textTheme.headlineSmall?.copyWith()),
        actions: [
          IconButton(
            onPressed: () => setState(() => items.clear()),
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          _NotifFilterChips(current: filter, onChanged: (v) => setState(() => filter = v)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final n = filtered[i];
                return Dismissible(
                  key: ValueKey('${n.title}-${n.time}-$i'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: ColorValues.danger500, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                  ),
                  onDismissed: (_) => setState(() => items.remove(n)),
                  child: _NotifTile(item: n),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifFilterChips extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;
  const _NotifFilterChips({required this.current, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cats = ['All', 'Info', 'Warning', 'Alert'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: cats.map((e) {
          final selected = e == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              selected: selected,
              label: Text(e),
              selectedColor: ColorValues.iotMainColor.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: selected
                    ? ColorValues.iotMainColor
                    : Theme.brightnessOf(context) == Brightness.dark
                    ? ColorValues.whiteColor
                    : ColorValues.neutral600,
              ),
              onSelected: (_) => onChanged(e),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NotifItem {
  final String title;
  final String subtitle;
  final String type;
  final String time;
  bool read;
  _NotifItem({required this.title, required this.subtitle, required this.type, required this.time, this.read = false});
}

class _NotifTile extends StatefulWidget {
  final _NotifItem item;
  const _NotifTile({required this.item});
  @override
  State<_NotifTile> createState() => _NotifTileState();
}

class _NotifTileState extends State<_NotifTile> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final badgeColor =
        {
          'Info': ColorValues.iotNodeMCUColor,
          'Warning': ColorValues.warning600,
          'Alert': ColorValues.danger600,
        }[widget.item.type] ??
        ColorValues.neutral600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 8))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => expanded = !expanded),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.item.type,
                      style: TextStyle(color: badgeColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  Text(widget.item.time, style: const TextStyle(color: ColorValues.neutral500)),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: Text(
                  widget.item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: ColorValues.neutral600),
                ),
                secondChild: Text(widget.item.subtitle, style: const TextStyle(color: ColorValues.neutral600)),
              ),
              if (expanded) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton.icon(onPressed: () {}, icon: const Icon(Icons.timeline), label: const Text('View history')),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.settings),
                      label: const Text('Adjust threshold'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
