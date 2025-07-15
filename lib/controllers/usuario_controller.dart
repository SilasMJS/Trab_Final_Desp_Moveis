// Controller: lógica de negócio do usuário
import '../database/db.dart';
import '../modelos/usuario.dart';

class UsuarioController {
  String? getUsuarioLogado() {
    return DB.getUsuarioLogado();
  }

  Future<void> excluirUsuario(String id) async {
    final db = await DB.getDb();
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  void setUsuarioLogado(String email) {
    DB.setUsuarioLogado(email);
  }

  Future<void> cadastrarUsuario(Usuario usuario) async {
    // Se já existe, atualiza; se não, cadastra novo
    final existente = await DB.buscarUsuarioPorEmail(usuario.email);
    if (existente != null && existente['id'] == usuario.id) {
      await DB.atualizarUsuario(
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
        senha: usuario.senha,
      );
    } else {
      await DB.salvarUsuario(
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
        senha: usuario.senha,
      );
    }
  }

  Future<Usuario?> buscarPorEmail(String email) async {
    final map = await DB.buscarUsuarioPorEmail(email);
    if (map != null) {
      return Usuario.fromMap(map);
    }
    return null;
  }

  Future<bool> validarLogin(String email, String senha) async {
    return await DB.validarLogin(email, senha);
  }
}
