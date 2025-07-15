// Tela de contatos
// Permite listar, adicionar, editar e excluir contatos do usuário
import 'package:trabalho_final_app/controllers/contato_controller.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_final_app/modelos/contato.dart';
import 'package:trabalho_final_app/telas/cadastrar_contato.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  final ContatoController _contatoController = ContatoController();
  List<Contato> _contatos = [];
  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  Future<void> _carregarContatos() async {
    final lista = await _contatoController.listarContatos();
    setState(() {
      _contatos = lista;
    });
  }

  void _salvarContato(Contato contato) {
    _contatoController.salvarContato(contato);
    _carregarContatos();
  }

  void _excluirContato(String id) {
    _contatoController.excluirContato(id);
    _carregarContatos();
  }

  void _navegarParaCadastro({Contato? contato}) async {
    final novoContato = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroContato(contato: contato),
      ),
    );
    if (novoContato != null) {
      _salvarContato(novoContato);
    }
  }

  // Função para mostrar confirmação de exclusão
  void _confirmarExclusao(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Você tem certeza que deseja excluir este contato?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _excluirContato(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Contatos',
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
      body: ListView.builder(
        itemCount: _contatos.length,
        itemBuilder: (context, index) {
          final contato = _contatos[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF43A047),
              child: Text(
                contato.nome[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              contato.nome,
              style: TextStyle(
                color: Color(0xFF388E3C),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(contato.telefone),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarExclusao(contato.id),
            ),
            onTap: () => _navegarParaCadastro(contato: contato),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF43A047),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => _navegarParaCadastro(),
      ),
    );
  }
}
