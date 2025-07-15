// lib/modelos/contato.dart

class Contato {
  String id;
  String nome;
  String telefone;
  String email;
  String? usuarioId;

  Contato({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    this.usuarioId,
  });

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      usuarioId: map['usuarioId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'usuarioId': usuarioId,
    };
  }
}
