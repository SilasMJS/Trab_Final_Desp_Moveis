// Tela de Login do Usuário
// Esta tela permite que o usuário faça login informando email e senha.
// Utiliza o UsuarioController para validar o login e gerenciar sessão.
// Também permite navegação para cadastro e recuperação de senha.
// Estrutura: Formulário de login, botões de navegação, feedback visual.
import 'package:flutter/material.dart';
import 'package:trabalho_final_app/telas/cadastro.dart';
import 'package:trabalho_final_app/telas/recuperarsenha.dart'; // Importa tela de recuperar senha
import 'package:trabalho_final_app/telas/principal.dart'; // Importa tela principal após login
import 'package:trabalho_final_app/controllers/usuario_controller.dart';

// Instância do controller
// Instancia o controller responsável pela lógica de usuário
final UsuarioController _usuarioController = UsuarioController();

// Widget principal da tela de login
// Widget principal da tela de login
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

// Estado da tela de login
class _LoginState extends State<Login> {
  // Chave global para validação do formulário
  final _formKey = GlobalKey<FormState>();
  // Controladores para capturar email e senha digitados
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Variável para controlar o estado de carregamento do botão
  bool _estaCarregando = false;

  // Função que realiza o login do usuário usando o Controller
  // Valida o formulário, chama o controller e navega para a tela principal se válido
  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _estaCarregando = true;
      });
      String email = _emailController.text;
      String senha = _senhaController.text;
      try {
        // Chama o controller para validar login
        final valido = await _usuarioController.validarLogin(email, senha);
        if (valido) {
          // Se válido, salva usuário logado na sessão
          _usuarioController.setUsuarioLogado(email);
          setState(() {
            _estaCarregando = false;
          });
          // Navega para tela principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Principal()),
          );
        } else {
          setState(() {
            _estaCarregando = false;
          });
          // Exibe mensagem de erro
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Email ou senha inválidos!')));
        }
      } catch (e) {
        setState(() {
          _estaCarregando = false;
        });
        // Exibe mensagem de erro genérica
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao fazer login!')));
      }
    }
  }

  // Método que constrói a interface da tela de login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
        // Personalização do hover do botão de voltar
        shadowColor: Colors.transparent,
      ),
      // Corpo principal da tela
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
                children: [
                  SizedBox(height: 2),
                  // Logo do aplicativo
                  Image.asset('assets/logo.png', width: 220, height: 220),
                  SizedBox(height: 2),
                  // Mensagem de boas-vindas
                  Text(
                    'Bem-Vindo!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C), // Verde escuro
                    ),
                  ),
                  SizedBox(height: 18),
                  // Campo de email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color(0xFF388E3C)),
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

                  // Campo de Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Color(0xFF388E3C)),
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
                  SizedBox(height: 10), // Espaçamento ajustado
                  // Botão de Entrar
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
                          onPressed: _fazerLogin,
                          child: Text(
                            'Entrar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  SizedBox(height: 10),

                  // Link para recuperar a senha centralizado
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navega para tela de recuperação de senha
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecuperarSenha(),
                          ),
                        );
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Color(0xFF388E3C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Botão de Cadastro
                  TextButton(
                    onPressed: () {
                      // Navega para tela de cadastro de usuário
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cadastro()),
                      );
                    },
                    child: Text(
                      'Não tem uma conta? Cadastre-se',
                      style: TextStyle(color: Color(0xFF388E3C)),
                    ),
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
