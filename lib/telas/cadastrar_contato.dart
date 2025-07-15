import 'package:flutter/material.dart';
import 'package:trabalho_final_app/modelos/contato.dart';

class CadastroContato extends StatefulWidget {
  final Contato? contato; // Contato opcional para edição

  const CadastroContato({super.key, this.contato});

  @override
  _CadastroContatoState createState() => _CadastroContatoState();
}

class _CadastroContatoState extends State<CadastroContato> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;

  bool get _isEditing => widget.contato != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.contato?.nome ?? '');
    _telefoneController = TextEditingController(
      text: widget.contato?.telefone ?? '',
    );
    _emailController = TextEditingController(text: widget.contato?.email ?? '');
  }

  void _salvarContato() {
    if (_formKey.currentState!.validate()) {
      final novoContato = Contato(
        id: _isEditing
            ? widget.contato!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
      );
      // Retorna o contato para a tela anterior
      Navigator.pop(context, novoContato);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar Contato' : 'Novo Contato',
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C)),
                  ),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF388E3C)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C)),
                  ),
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF388E3C)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C)),
                  ),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF388E3C)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF43A047),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _salvarContato,
                child: Text(
                  'Salvar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
