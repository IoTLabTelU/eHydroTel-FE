// // lib/src/devices/presentation/history/history_record_list.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../domain/entities/history_entity.dart';

// class HistoryRecordList extends StatelessWidget {
//   final List<HistoryEntity> history;
//   const HistoryRecordList({super.key, required this.history});

//   @override
//   Widget build(BuildContext context) {
//     // Show newest first
//     final items = [...history].reversed.toList();

//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, idx) {
//         final h = items[idx];
//         final timeLabel = DateFormat('yyyy-MM-dd HH:mm').format(h.time);

//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 6),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: ExpansionTile(
//             tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             title: Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(timeLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(
//                       'PH avg: ${h.phAvg.toStringAsFixed(2)}   ppm avg: ${h.ppmAvg.toStringAsFixed(1)}',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text('PH min/max: ${h.phMin.toStringAsFixed(2)}/${h.phMax.toStringAsFixed(2)}'),
//                     Text('PPM min/max: ${h.ppmMin.toStringAsFixed(1)}/${h.ppmMax.toStringAsFixed(1)}'),
//                   ],
//                 ),
//               ],
//             ),
//             childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             children: [
//               if (h.records == null || h.records!.isEmpty)
//                 const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('No raw records for this timeslot'))
//               else
//                 SizedBox(
//                   height: 160,
//                   child: ListView.separated(
//                     itemCount: h.records!.length,
//                     separatorBuilder: (_, __) => const Divider(height: 8),
//                     itemBuilder: (ctx, ridx) {
//                       final r = h.records![ridx];
//                       final t = DateFormat('HH:mm:ss').format(r.timestamp);
//                       return Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Text(t, style: const TextStyle(fontFamily: 'monospace')),
//                           ),
//                           Expanded(flex: 4, child: Text('PH: ${r.ph.toStringAsFixed(2)}')),
//                           Expanded(flex: 4, child: Text('PPM: ${r.ppm.toStringAsFixed(1)}')),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
