// Tela de mapa
// Permite adicionar, personalizar e excluir marcadores no mapa
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final LatLng _teresina = LatLng(-5.0892, -42.8016);
  final Map<MarkerId, Marker> _marcadores = {};

  void _adicionarMarcador(LatLng posicao) async {
    String nome = await _mostrarDialogoPersonalizar(posicao);
    if (nome.isEmpty) return;
    final markerId = MarkerId(DateTime.now().millisecondsSinceEpoch.toString());
    setState(() {
      _marcadores[markerId] = Marker(
        markerId: markerId,
        position: posicao,
        infoWindow: InfoWindow(
          title: nome,
          snippet: '${posicao.latitude}, ${posicao.longitude}',
          onTap: () => _mostrarOpcoes(markerId),
        ),
        onTap: () => _mostrarOpcoes(markerId),
      );
    });
  }

  Future<String> _mostrarDialogoPersonalizar(
    LatLng posicao, {
    String nomeAtual = '',
  }) async {
    TextEditingController controller = TextEditingController(text: nomeAtual);
    String nome = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Personalizar Marcador'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nome do marcador'),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                nome = controller.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return nome;
  }

  void _mostrarOpcoes(MarkerId markerId) {
    final marcador = _marcadores[markerId]!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Alterar nome'),
              onTap: () async {
                Navigator.of(context).pop();
                String novoNome = await _mostrarDialogoPersonalizar(
                  marcador.position,
                  nomeAtual: marcador.infoWindow.title ?? '',
                );
                if (novoNome.isNotEmpty) {
                  setState(() {
                    _marcadores[markerId] = marcador.copyWith(
                      infoWindowParam: InfoWindow(
                        title: novoNome,
                        snippet:
                            '${marcador.position.latitude}, ${marcador.position.longitude}',
                        onTap: () => _mostrarOpcoes(markerId),
                      ),
                    );
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Excluir'),
              onTap: () {
                setState(() {
                  _marcadores.remove(markerId);
                });
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
          'Mapa',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF388E3C),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _teresina, zoom: 14),
        markers: Set<Marker>.of(_marcadores.values),
        onTap: _adicionarMarcador,
      ),
    );
  }
}
