// Tela de perfil do usuário
// Permite visualizar, editar e excluir dados do usuário logado
import 'package:flutter/material.dart';
import 'package:trabalho_final_app/controllers/usuario_controller.dart';
import 'package:trabalho_final_app/modelos/usuario.dart';
import 'package:trabalho_final_app/telas/login.dart';

class PerfilUsuario extends StatefulWidget {
  final String emailUsuario;
  const PerfilUsuario({super.key, required this.emailUsuario});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final UsuarioController _usuarioController = UsuarioController();
  bool _editando = false;
  bool _verSenha = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String? _usuarioId;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    // Busca o usuário logado pelo e-mail passado via parâmetro
    final usuario = await _usuarioController.buscarPorEmail(
      widget.emailUsuario,
    );
    if (usuario != null) {
      setState(() {
        _usuarioId = usuario.id;
        _nomeController.text = usuario.nome;
        _emailController.text = usuario.email;
        _senhaController.text = usuario.senha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Perfil do Usuário',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF388E3C),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        iconTheme: IconThemeData(color: Color(0xFF388E3C)),
        actionsIconTheme: IconThemeData(color: Color(0xFF388E3C)),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        toolbarTextStyle: TextStyle(color: Color(0xFF388E3C)),
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              enabled: _editando,
              decoration: InputDecoration(
                labelText: 'Nome completo',
                labelStyle: TextStyle(color: Color(0xFF388E3C)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF43A047)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF43A047)),
                ),
                prefixIcon: Icon(Icons.person, color: Color(0xFF388E3C)),
                filled: _editando,
                fillColor: _editando ? Color(0xFFE8F5E9) : null,
              ),
              cursorColor: Color(0xFF388E3C),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              enabled: _editando,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFF388E3C)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF43A047)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF43A047)),
                ),
                prefixIcon: Icon(Icons.email, color: Color(0xFF388E3C)),
                filled: _editando,
                fillColor: _editando ? Color(0xFFE8F5E9) : null,
              ),
              cursorColor: Color(0xFF388E3C),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _senhaController,
              enabled: _editando,
              obscureText: !_verSenha,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Color(0xFF388E3C)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF43A047)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF43A047)),
                ),
                prefixIcon: Icon(Icons.lock, color: Color(0xFF388E3C)),
                filled: _editando,
                fillColor: _editando ? Color(0xFFE8F5E9) : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _verSenha ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF388E3C),
                  ),
                  onPressed: () {
                    setState(() {
                      _verSenha = !_verSenha;
                    });
                  },
                ),
              ),
              cursorColor: Color(0xFF388E3C),
            ),
            SizedBox(height: 30),
            !_editando
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF43A047),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _editando = true;
                      });
                    },
                    child: Text(
                      'Editar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF43A047),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            // Sempre salva, mesmo sem edição
                            if (_usuarioId != null) {
                              await _usuarioController.cadastrarUsuario(
                                Usuario(
                                  id: _usuarioId!,
                                  nome: _nomeController.text,
                                  email: _emailController.text,
                                  senha: _senhaController.text,
                                ),
                              );
                              setState(() {
                                _editando = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Informações salvas com sucesso!',
                                  ),
                                  backgroundColor: Color(0xFF43A047),
                                ),
                              );
                            } else {
                              // Feedback caso não haja usuário
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Usuário não encontrado!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            // Confirmação antes de excluir
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Excluir conta'),
                                content: Text(
                                  'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                      'Excluir',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirmar == true && _usuarioId != null) {
                              await _usuarioController.excluirUsuario(
                                _usuarioId!,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Conta excluída com sucesso!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              // Redireciona para tela de login após excluir conta
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: Text(
                            'Excluir conta',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // Versão correta acima. Código duplicado e antigo removido.
}
