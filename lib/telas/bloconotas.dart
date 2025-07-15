// Tela de bloco de notas
// Permite criar, listar, marcar como concluída e excluir notas
import 'package:flutter/material.dart';
import '../modelos/nota.dart';
import '../controllers/nota_controller.dart';

class BlocoNotas extends StatefulWidget {
  const BlocoNotas({super.key});

  @override
  State<BlocoNotas> createState() => _BlocoNotasState();
}

class _BlocoNotasState extends State<BlocoNotas> {
  final NotaController _notaController = NotaController();
  List<Nota> _notas = [];
  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  Future<void> _carregarNotas() async {
    final lista = await _notaController.listarNotas();
    setState(() {
      _notas = lista;
    });
  }

  void _salvarNota(Nota nota) {
    _notaController.salvarNota(nota);
    _carregarNotas();
  }

  void _excluirNota(String id) {
    _notaController.excluirNota(id);
    _carregarNotas();
  }

  void _mostrarDialogoNovaNota() {
    final tituloController = TextEditingController();
    final descricaoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Nova Nota',
            style: TextStyle(
              color: Color(0xFF388E3C),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF43A047)),
                  ),
                ),
                cursorColor: Color(0xFF388E3C),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF43A047)),
                  ),
                ),
                minLines: 3,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                cursorColor: Color(0xFF388E3C),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF388E3C)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF388E3C)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF43A047),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Salvar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                final nota = Nota(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  titulo: tituloController.text,
                  descricao: descricaoController.text,
                );
                _salvarNota(nota);
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
          'Bloco de Notas',
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
        itemCount: _notas.length,
        itemBuilder: (context, index) {
          final nota = _notas[index];
          return CheckboxListTile(
            value: nota.concluido,
            title: Text(
              nota.titulo,
              style: TextStyle(
                color: Color(0xFF388E3C),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(nota.descricao),
            activeColor: Color(0xFF43A047),
            checkColor: Colors.white,
            onChanged: (valor) {
              nota.concluido = valor ?? false;
              _salvarNota(nota);
            },
            secondary: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _excluirNota(nota.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF43A047),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: _mostrarDialogoNovaNota,
      ),
    );
  }
}
