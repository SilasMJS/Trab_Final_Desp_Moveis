// Tela de recuperação de senha
// Permite ao usuário solicitar link de recuperação por email
import 'package:flutter/material.dart';
import 'package:trabalho_final_app/controllers/usuario_controller.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({super.key});

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  final UsuarioController _usuarioController = UsuarioController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _estaCarregando = false;

  void _enviarLinkRecuperacao() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _estaCarregando = true;
      });

      // Verifica se o email existe usando o controller
      final usuario = await _usuarioController.buscarPorEmail(
        _emailController.text,
      );
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _estaCarregando = false;
      });

      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Link de recuperação enviado para o email cadastrado.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email não cadastrado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recuperar Senha',
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
      backgroundColor: Colors.white,
      body: Padding(
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
                  'Recuperar Senha',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF388E3C),
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'Digite seu email cadastrado para receber o link de recuperação.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
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
                SizedBox(height: 25),
                _estaCarregando
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _enviarLinkRecuperacao,
                        child: Text('Enviar Link'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
