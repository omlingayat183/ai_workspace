import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/notes_repo.dart';
import '../data/note_model.dart';

final notesRepoProvider = Provider((ref) => NotesRepo());
List<NoteModel> _allNotes = [];


final notesControllerProvider =
    StateNotifierProvider<NotesController, AsyncValue<List<NoteModel>>>(
  (ref) => NotesController(ref.read(notesRepoProvider)),
);

class NotesController extends StateNotifier<AsyncValue<List<NoteModel>>> {
  final NotesRepo _repo;
  NotesController(this._repo) : super(const AsyncValue.loading()) {
    loadNotes();
  }


  Future<void> loadNotes() async {
  try {
    final notes = await _repo.getNotes();
    _allNotes = notes;              // store all notes
    state = AsyncValue.data(notes); // show notes
  } catch (e) {
    state = AsyncValue.error(e, StackTrace.current);
  }
}

void filterNotes(String query) {
  if (query.trim().isEmpty) {
    state = AsyncValue.data(_allNotes);
    return;
  }

  final lower = query.toLowerCase();

  final results = _allNotes.where((n) {
    return n.title.toLowerCase().contains(lower)
        || n.content.toLowerCase().contains(lower);
  }).toList();

  state = AsyncValue.data(results);
}


  Future<void> addNote(String title, String content) async {
  final note = await _repo.createNote(title, content);

  final current = state.value ?? [];   // SAFE
  final updated = [note, ...current];

  _allNotes = updated;   // sync filtered list
  state = AsyncValue.data(updated);
}


  Future<void> updateNote(String id, String title, String content) async {
    final updated = await _repo.updateNote(id, title, content);
    final list = (state.value ?? [])
    .map((n) => n.id == id ? updated : n)
    .toList();

_allNotes = list;
state = AsyncValue.data(list);

  }

  Future<void> deleteNote(String id) async {
    await _repo.deleteNote(id);
    final list = (state.value ?? [])
    .where((n) => n.id != id)
    .toList();

_allNotes = list;
state = AsyncValue.data(list);

  }
}
