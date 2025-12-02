import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/notes_controller.dart';
import '../data/note_model.dart';
import '../../ai/controllers/ai_controller.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final NoteModel? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  ConsumerState<NoteEditorScreen> createState() =>
      _NoteEditorScreenState();
}

class _NoteEditorScreenState
    extends ConsumerState<NoteEditorScreen> {
  late TextEditingController title;
  late TextEditingController content;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.note?.title ?? "");
    content = TextEditingController(text: widget.note?.content ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final notesCtrl = ref.read(notesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "New Note" : "Edit Note"),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await notesCtrl.deleteNote(widget.note!.id);
                if (!mounted) return;
                Navigator.pop(context);
              },
            )
        ],
      ),

      // AI TOOLBAR
      bottomNavigationBar: _buildAiToolbar(),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.note == null) {
            await notesCtrl.addNote(title.text, content.text);
          } else {
            await notesCtrl.updateNote(
              widget.note!.id,
              title.text,
              content.text,
            );
          }

          if (!mounted) return;
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: content,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Start typing...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


    //  AI TOOLBAR WIDGET


  Widget _buildAiToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _aiButton(Icons.summarize, "Summary", () {
            _runAI("summary");
          }),
          _aiButton(Icons.auto_fix_high, "Improve", () {
            _runAI("improve");
          }),
          _aiButton(Icons.checklist, "Tasks", () {
            _runAI("tasks");
          }),
          _aiButton(Icons.lightbulb_outline, "Actions", () {
            _runAI("actions");
          }),
          _aiButton(Icons.transform, "Format", () {
            _showTransformOptions();
          }),
        ],
      ),
    );
  }

  Widget _aiButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

    //  AI EXECUTION HANDLER


  void _runAI(String type) async {
    final ai = ref.read(aiControllerProvider.notifier);
    final text = content.text;

    if (text.trim().isEmpty) {
      _showError("Write something first.");
      return;
    }

    switch (type) {
      case "summary":
        ai.summarize(text);
        break;
      case "improve":
        ai.improve(text);
        break;
      case "tasks":
        ai.tasks(text);
        break;
      case "actions":
        ai.actions(text);
        break;
    }

    _showAiBottomSheet();
  }

    //  FORMAT OPTIONS

  void _showTransformOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Convert to Email"),
            onTap: () {
              Navigator.pop(context);
              ref.read(aiControllerProvider.notifier)
                  .transform(content.text, "email");
              _showAiBottomSheet();
            },
          ),
          ListTile(
            title: const Text("Convert to Bullet Points"),
            onTap: () {
              Navigator.pop(context);
              ref.read(aiControllerProvider.notifier)
                  .transform(content.text, "bullets");
              _showAiBottomSheet();
            },
          ),
          ListTile(
            title: const Text("Convert to Blog"),
            onTap: () {
              Navigator.pop(context);
              ref.read(aiControllerProvider.notifier)
                  .transform(content.text, "blog");
              _showAiBottomSheet();
            },
          ),
        ],
      ),
    );
  }


    //  AI RESULT BOTTOM SHEET

  void _showAiBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final aiState = ref.watch(aiControllerProvider);

            return Padding(
              padding: const EdgeInsets.all(24),
              child: aiState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
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

    //  ERROR HANDLER
 
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }
}
