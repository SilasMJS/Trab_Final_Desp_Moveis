// Controller: lógica de negócio dos contatos
import '../database/db.dart';
import '../modelos/contato.dart';

class ContatoController {
  Future<List<Contato>> listarContatos() async {
    return await buscarContatos();
  }

  Future<void> salvarContato(Contato contato) async {
    final usuarioId = await _getUsuarioId();
    final contatoMap = contato.toMap();
    contatoMap['usuarioId'] = usuarioId;
    await DB.salvarContato(contatoMap);
  }

  Future<String?> _getUsuarioId() async {
    final email = DB.emailUsuarioLogado;
    if (email == null) return null;
    final usuario = await DB.buscarUsuarioPorEmail(email);
    return usuario?['id'];
  }

  Future<List<Contato>> buscarContatos() async {
    final lista = await DB.buscarContatos();
    return lista.map((c) => Contato.fromMap(c)).toList();
  }

  Future<void> excluirContato(String id) async {
    await DB.excluirContato(id);
  }
}
