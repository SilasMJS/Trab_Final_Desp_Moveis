// Tela principal do app
// Menu de navegação para as funcionalidades principais
// lib/telas/tela_home.dart

import 'package:flutter/material.dart';
import 'package:trabalho_final_app/telas/contatos.dart';
import 'package:trabalho_final_app/telas/login.dart';
import 'package:trabalho_final_app/telas/mapa.dart';
import 'package:trabalho_final_app/telas/bloconotas.dart';
import 'package:trabalho_final_app/telas/perfil_usuario.dart';
import 'package:trabalho_final_app/controllers/usuario_controller.dart';

class Principal extends StatelessWidget {
  final UsuarioController _usuarioController = UsuarioController();
  Principal({super.key});

  // Função auxiliar para criar os botões do menu
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: Color(0xFF388E3C)),
            Text(label, style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }

  void _abrirPerfil(BuildContext context) {
    final email = _usuarioController.getUsuarioLogado();
    if (email != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerfilUsuario(emailUsuario: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Nenhum usuário logado!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            color: Color(0xFF388E3C),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            },
          ),
        ],
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
                SizedBox(height: 18),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.contacts,
                      label: 'Contatos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Contatos()),
                        );
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.map,
                      label: 'Mapa',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Mapa()),
                        );
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.note,
                      label: 'Bloco de Notas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BlocoNotas()),
                        );
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.person,
                      label: 'Perfil',
                      onTap: () {
                        _abrirPerfil(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
