import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/analytics_controller.dart';
import '../../notes/widgets/note_card.dart';
import '../../notes/controllers/notes_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: analyticsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (map) {
          final summary = map["summary"] as Map<String, dynamic>;
          final recent = map["recent"] as List<dynamic>;
          final usage = map["usage"] as List<dynamic>;

          return RefreshIndicator(
            onRefresh: () => ref.read(analyticsControllerProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(summary),
                  const SizedBox(height: 20),
                  _buildUsageChart(usage),
                  const SizedBox(height: 20),
                  const Text("Recent notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...recent.map((n) => _buildRecentTile(n)).toList(),
                  const SizedBox(height: 20),
                  const Text("Top tags", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _buildTags(summary["topTags"] ?? []),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard("Total", s["totalNotes"]?.toString() ?? "0"),
        _statCard("Active", s["activeNotes"]?.toString() ?? "0"),
        _statCard("Trashed", s["trashedNotes"]?.toString() ?? "0"),
        _statCard("AI Calls", s["aiCalls"]?.toString() ?? "0"),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageChart(List<dynamic> usage) {
    // Simple textual chart: date - count rows. Replace later with chart package if needed.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("AI usage (last days)", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...usage.map((u) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(u["date"], style: const TextStyle(color: Colors.black54)),
            Text(u["count"].toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        )).toList()
      ],
    );
  }

  Widget _buildRecentTile(dynamic n) {
    final title = n["title"] ?? "(Untitled)";
    final content = n["content"] ?? "";
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () {
            // open in editor, requires note id - if backend returns _id add navigation
          },
        ),
      ),
    );
  }

  Widget _buildTags(dynamic tags) {
    final list = (tags as List).cast<Map<String, dynamic>>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list.map((t) => Chip(label: Text("${t['tag']} (${t['count']})"))).toList(),
    );
  }
}
