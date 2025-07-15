// Controller: lógica de negócio das notas
import '../database/db.dart';
import '../modelos/nota.dart';

class NotaController {
  Future<List<Nota>> listarNotas() async {
    return await buscarNotas();
  }

  Future<void> salvarNota(Nota nota) async {
    final usuarioId = await _getUsuarioId();
    final notaMap = nota.toMap();
    notaMap['usuarioId'] = usuarioId;
    await DB.salvarNota(notaMap);
  }

  Future<String?> _getUsuarioId() async {
    final email = DB.emailUsuarioLogado;
    if (email == null) return null;
    final usuario = await DB.buscarUsuarioPorEmail(email);
    return usuario?['id'];
  }

  Future<List<Nota>> buscarNotas() async {
    final lista = await DB.buscarNotas();
    return lista.map((n) => Nota.fromMap(n)).toList();
  }

  Future<void> excluirNota(String id) async {
    await DB.excluirNota(id);
  }
}
