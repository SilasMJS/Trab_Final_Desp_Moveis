// Tela de cadastro de usuário
// Permite criar uma nova conta e salvar no banco de dados
// Importa dependências do Flutter e a classe de acesso ao banco de dados
import 'package:flutter/material.dart';
import 'package:trabalho_final_app/controllers/usuario_controller.dart';
import 'package:trabalho_final_app/modelos/usuario.dart';

// Widget principal da tela de cadastro
class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

// Estado da tela de cadastro
class _CadastroState extends State<Cadastro> {
  // Chave para validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Variável para controlar o estado de carregamento do botão
  bool _estaCarregando = false;

  // Instância do controller
  final UsuarioController _usuarioController = UsuarioController();

  // Função que realiza o cadastro do usuário usando o Controller
  void _fazerCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _estaCarregando = true;
      });
      try {
        await _usuarioController.cadastrarUsuario(
          Usuario(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            nome: _nomeController.text,
            email: _emailController.text,
            senha: _senhaController.text,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _nomeController.clear();
        _emailController.clear();
        _senhaController.clear();
        _confirmarSenhaController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar: email já existe!'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _estaCarregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barra superior personalizada
        title: Text(
          'Cadastro',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF388E3C), // Verde escuro
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
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 2),
                  Image.asset('assets/logo.png', width: 220, height: 220),
                  SizedBox(height: 2),
                  Text(
                    'Criar Conta!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  SizedBox(height: 18),
                  // Campo Nome
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF388E3C)),
                      ),
                      prefixIcon: Icon(Icons.person, color: Color(0xFF388E3C)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF388E3C),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (nome) {
                      if (nome == null || nome.isEmpty) {
                        return 'Por favor, digite seu nome completo';
                      }
                      if (nome.length < 3) {
                        return 'O nome deve ter pelo menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  // Campo Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF388E3C)),
                      ),
                      prefixIcon: Icon(Icons.email, color: Color(0xFF388E3C)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF388E3C),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Por favor, digite seu email';
                      }
                      if (!email.contains('@') || !email.contains('.')) {
                        return 'Por favor, digite um email válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  // Campo Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF388E3C)),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF388E3C)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF388E3C),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Por favor, digite sua senha';
                      }
                      if (senha.length < 6) {
                        return 'A senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  // Campo Confirmar Senha
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF388E3C)),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF388E3C),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF388E3C),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (confirmarSenha) {
                      if (confirmarSenha == null || confirmarSenha.isEmpty) {
                        return 'Por favor, confirme sua senha';
                      }
                      if (confirmarSenha != _senhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  // Botão de cadastro ou indicador de progresso
                  _estaCarregando
                      ? CircularProgressIndicator(color: Color(0xFF388E3C))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Color(0xFF43A047), // Verde médio
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _fazerCadastro,
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  SizedBox(height: 10),
                  // Botão para voltar ao login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF388E3C),
                    ),
                    child: Text('Já tem uma conta? Faça login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
