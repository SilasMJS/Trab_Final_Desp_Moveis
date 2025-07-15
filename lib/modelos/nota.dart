class Nota {
  String id;
  String titulo;
  String descricao;
  bool concluido;
  String? usuarioId;

  Nota({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.concluido = false,
    this.usuarioId,
  });

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      concluido: (map['concluido'] ?? 0) == 1,
      usuarioId: map['usuarioId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'concluido': concluido ? 1 : 0,
      'usuarioId': usuarioId,
    };
  }
}
