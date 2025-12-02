import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widget/loader.dart';
import 'package:go_router/go_router.dart';
import '../controllers/notes_controller.dart';
import '../widgets/note_card.dart';
import '../screens/note_editor_screen.dart';
import '../../ai/controllers/global_ai_controller.dart';
import '../../notes/controllers/search_query_provider.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  bool _fabExpanded = false;

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesControllerProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
  title: const Text("Your Notes"),
  actions: [
    IconButton(
      icon: const Icon(Icons.insights),
      onPressed: () {
        context.push("/dashboard");

      },
    ),
  ],
),


      floatingActionButton: _buildFabGroup(),

      body: notesState.when(
        loading: () => const Loader(),

        error: (err, _) => Center(child: Text("Error: $err")),

        data: (notes) {
          return Column(
            children: [
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                    ref.read(notesControllerProvider.notifier)
                        .filterNotes(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search notes...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // AI SEARCH BUTTON
              if (searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(globalAiControllerProvider.notifier)
                          .search(searchQuery);

                      _showGlobalAiBottomSheet();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.smart_toy, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text("Ask AI: \"$searchQuery\""),
                      ],
                    ),
                  ),
                ),

              // NOTES LIST
              Expanded(
                child: notes.isEmpty
                    ? const Center(child: Text("No notes yet."))
                    : RefreshIndicator(
                        onRefresh: () => ref
                            .read(notesControllerProvider.notifier)
                            .loadNotes(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: notes.length,
                          itemBuilder: (context, i) {
                            final note = notes[i];
                            return Dismissible(
                              key: ValueKey(note.id),
                              background: Container(
                                color: Colors.red,
                                padding: const EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (_) {
                                ref
                                    .read(notesControllerProvider.notifier)
                                    .deleteNote(note.id);
                              },
                              child: NoteCard(note: note),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // FAB MENU
  Widget _buildFabGroup() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_fabExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: FloatingActionButton.extended(
              heroTag: "ai_btn",
              onPressed: () {
                _fabExpanded = false;
                setState(() {});
                _showGlobalAskDialog();
              },
              icon: const Icon(Icons.smart_toy),
              label: const Text("Ask AI"),
            ),
          ),

        if (_fabExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 160),
            child: FloatingActionButton.extended(
              heroTag: "add_btn",
              onPressed: () {
                _fabExpanded = false;
                setState(() {});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NoteEditorScreen()));
              },
              icon: const Icon(Icons.add),
              label: const Text("New Note"),
            ),
          ),

        FloatingActionButton(
          heroTag: "main_fab",
          child: Icon(_fabExpanded ? Icons.close : Icons.menu),
          onPressed: () =>
              setState(() => _fabExpanded = !_fabExpanded),
        ),
      ],
    );
  }

  // ASK AI dialog
  void _showGlobalAskDialog() {
    final queryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ask AI anything"),
        content: TextField(
          controller: queryCtrl,
          decoration:
              const InputDecoration(hintText: "Your question..."),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Ask"),
            onPressed: () {
              Navigator.pop(context);
              final text = queryCtrl.text.trim();
              if (text.isNotEmpty) _runGlobalAi(text);
            },
          ),
        ],
      ),
    );
  }


  // RUN GLOBAL AI

  void _runGlobalAi(String query) {
    ref.read(globalAiControllerProvider.notifier).ask(query);
    _showGlobalAiBottomSheet();
  }


  // BOTTOM SHEET

  void _showGlobalAiBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(globalAiControllerProvider);

            return Padding(
              padding: const EdgeInsets.all(24),
              child: state.when(
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (e, _) => Text("Error: $e"),
                data: (result) => SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
