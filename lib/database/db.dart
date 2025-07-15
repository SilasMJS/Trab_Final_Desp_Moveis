import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DB {
  static Future<List<Map<String, dynamic>>> listarUsuarios() async {
    final db = await getDb();
    return await db.query('usuarios');
  }

  // Armazena o e-mail do usuário logado
  static String? emailUsuarioLogado;

  static void setUsuarioLogado(String email) {
    emailUsuarioLogado = email;
  }

  static String? getUsuarioLogado() {
    return emailUsuarioLogado;
  }

  static Future<void> atualizarUsuario({
    required String id,
    required String nome,
    required String email,
    required String senha,
  }) async {
    final db = await getDb();
    await db.update(
      'usuarios',
      {'nome': nome, 'email': email, 'senha': senha},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Database? _db;

  static Future<Database> getDb() async {
    try {
      final dbPath = await getDatabasesPath();
      print('CAMINHO DO BANCO: ' + p.join(dbPath, 'app.db'));
      if (_db != null) return _db!;
      // Teste de inicialização: printa se está em desktop e se o databaseFactory está correto
      print('[DB] Inicializando banco de dados...');
      print(
        '[DB] databaseFactory: '
        '${identical(databaseFactory.toString(), "Instance of 'SqfliteDatabaseFactoryFfi'") ? 'FFI' : databaseFactory.toString()}',
      );
      _db = await openDatabase(
        p.join(dbPath, 'app.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE usuarios(
              id TEXT PRIMARY KEY,
              nome TEXT,
              email TEXT UNIQUE,
              senha TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE notas(
              id TEXT PRIMARY KEY,
              titulo TEXT,
              descricao TEXT,
              concluido INTEGER,
              usuarioId TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE contatos(
              id TEXT PRIMARY KEY,
              nome TEXT,
              telefone TEXT,
              email TEXT,
              usuarioId TEXT
            );
          ''');
        },
      );
      print('[DB] Banco de dados inicializado com sucesso!');
      return _db!;
    } catch (e, s) {
      print('[DB] Erro ao inicializar o banco: $e\n$s');
      rethrow;
    }
  }

  // Usuário
  static Future<void> salvarUsuario({
    required String id,
    required String nome,
    required String email,
    required String senha,
  }) async {
    final db = await getDb();
    try {
      await db.insert('usuarios', {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
      }, conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (e) {
      // Se o email já existe, lança erro para ser tratado na tela
      throw Exception('Email já cadastrado');
    }
  }

  static Future<Map<String, dynamic>?> buscarUsuarioPorEmail(
    String email,
  ) async {
    final db = await getDb();
    final res = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  static Future<bool> validarLogin(String email, String senha) async {
    final usuario = await buscarUsuarioPorEmail(email);
    if (usuario == null) return false;
    return usuario['senha'] == senha;
  }

  // Notas
  static Future<void> salvarNota(Map<String, dynamic> nota) async {
    final db = await getDb();
    await db.insert(
      'notas',
      nota,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> buscarNotas() async {
    final db = await getDb();
    if (emailUsuarioLogado == null) return [];
    final usuario = await buscarUsuarioPorEmail(emailUsuarioLogado!);
    if (usuario == null) return [];
    return await db.query(
      'notas',
      where: 'usuarioId = ?',
      whereArgs: [usuario['id']],
    );
  }

  static Future<void> excluirNota(String id) async {
    final db = await getDb();
    await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }

  // Contatos
  static Future<void> salvarContato(Map<String, dynamic> contato) async {
    final db = await getDb();
    await db.insert(
      'contatos',
      contato,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> buscarContatos() async {
    final db = await getDb();
    if (emailUsuarioLogado == null) return [];
    final usuario = await buscarUsuarioPorEmail(emailUsuarioLogado!);
    if (usuario == null) return [];
    return await db.query(
      'contatos',
      where: 'usuarioId = ?',
      whereArgs: [usuario['id']],
    );
  }

  static Future<void> excluirContato(String id) async {
    final db = await getDb();
    await db.delete('contatos', where: 'id = ?', whereArgs: [id]);
  }
}
