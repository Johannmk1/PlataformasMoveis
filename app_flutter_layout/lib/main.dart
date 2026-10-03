import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade Prática - Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _abaAtual = 0;

  final List<Widget> _telas = [
    const LayoutTutorialTela(), // Parte A: Layout da Documentação
    const CookbookPersistenciaTela(), // Parte B: Cookbook Persistência Local
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_abaAtual == 0 
            ? 'Parte A: Layout Tutorial' 
            : 'Parte B: Cookbook (Persistência)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
      ),
      body: _telas[_abaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual,
        onTap: (index) {
          setState(() {
            _abaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Layout (Lago)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save_outlined),
            activeIcon: Icon(Icons.save),
            label: 'Cookbook (Persistência)',
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// PARTE A: IMPLEMENTAÇÃO DO LAYOUT PROPOSTO (LAGO OESCHINEN)
// Documentação: Building Layouts Tutorial
// ====================================================================

class LayoutTutorialTela extends StatelessWidget {
  const LayoutTutorialTela({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
            'https://raw.githubusercontent.com/flutter/website/main/examples/layout/lakes/step5/images/lake.jpg',
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
          const _SecaoTitulo(
            nomeLocal: 'Oeschinen Lake Campground',
            localizacao: 'Kandersteg, Switzerland',
          ),
          const _SecaoBotoes(),
          const _SecaoTexto(
            texto:
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                'Alps. Situated 1,578 meters above sea level, it is one of the '
                'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                'half-hour walk through pine forests and over flowering alpine '
                'meadows, leads you to the lake, which warms to 20 degrees Celsius in '
                'summer. Activities enjoyed here include rowing, and riding the '
                'summer toboggan run.',
          ),
        ],
      ),
    );
  }
}

class _SecaoTitulo extends StatelessWidget {
  const _SecaoTitulo({
    required this.nomeLocal,
    required this.localizacao,
  });

  final String nomeLocal;
  final String localizacao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    nomeLocal,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  localizacao,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          const Text('41'),
        ],
      ),
    );
  }
}

class _SecaoBotoes extends StatelessWidget {
  const _SecaoBotoes();

  @override
  Widget build(BuildContext context) {
    final Color corPrimaria = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _criarBotaoAcao(corPrimaria, Icons.call, 'CALL'),
        _criarBotaoAcao(corPrimaria, Icons.near_me, 'ROUTE'),
        _criarBotaoAcao(corPrimaria, Icons.share, 'SHARE'),
      ],
    );
  }

  Widget _criarBotaoAcao(Color cor, IconData icone, String rotulo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icone, color: cor),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            rotulo,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: cor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SecaoTexto extends StatelessWidget {
  const _SecaoTexto({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        texto,
        softWrap: true,
      ),
    );
  }
}

// ====================================================================
// PARTE B: COOKBOOK (PERSISTENCE - PERSIST DATA WITH SHARED PREFERENCES)
// Exemplo Base: "Persist data with shared_preferences"
// Modificações Realizadas:
// 1. O exemplo original grava apenas um valor primitivo (ex: número).
// 2. Modificado para gerenciar uma Lista de Tarefas completa com JSON.
// 3. Persistência assíncrona (salva, lê e remove itens da memória do app).
// ====================================================================

class CookbookPersistenciaTela extends StatefulWidget {
  const CookbookPersistenciaTela({super.key});

  @override
  State<CookbookPersistenciaTela> createState() => _CookbookPersistenciaTelaState();
}

class _CookbookPersistenciaTelaState extends State<CookbookPersistenciaTela> {
  final TextEditingController _controladorInput = TextEditingController();
  List<Map<String, dynamic>> _tarefas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTarefasSalvas();
  }

  // Carrega os dados salvos do SharedPreferences ao abrir a tela
  Future<void> _carregarTarefasSalvas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tarefasString = prefs.getString('lista_tarefas_key');

    if (tarefasString != null) {
      final List<dynamic> jsonList = jsonDecode(tarefasString);
      setState(() {
        _tarefas = jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
        _carregando = false;
      });
    } else {
      setState(() {
        _carregando = false;
      });
    }
  }

  // Grava a lista atualizada no SharedPreferences
  Future<void> _salvarTarefasNoDispositivo() async {
    final prefs = await SharedPreferences.getInstance();
    final String tarefasString = jsonEncode(_tarefas);
    await prefs.setString('lista_tarefas_key', tarefasString);
  }

  void _adicionarTarefa() {
    if (_controladorInput.text.trim().isEmpty) return;

    setState(() {
      _tarefas.add({
        'titulo': _controladorInput.text.trim(),
        'concluida': false,
      });
      _controladorInput.clear();
    });

    _salvarTarefasNoDispositivo();
  }

  void _alternarStatus(int index) {
    setState(() {
      _tarefas[index]['concluida'] = !_tarefas[index]['concluida'];
    });
    _salvarTarefasNoDispositivo();
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
    _salvarTarefasNoDispositivo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cookbook Escolhido:\nPersist data with shared_preferences',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Campo para digitar nova tarefa
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controladorInput,
                  decoration: const InputDecoration(
                    labelText: 'Nova Anotação / Tarefa',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note_add),
                  ),
                  onSubmitted: (_) => _adicionarTarefa(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _adicionarTarefa,
                icon: const Icon(Icons.add),
                padding: const EdgeInsets.all(16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista de tarefas persistidas
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _tarefas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma anotação salva.\nAdicione algo acima!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tarefas.length,
                        itemBuilder: (context, index) {
                          final item = _tarefas[index];
                          final bool concluida = item['concluida'] ?? false;

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Checkbox(
                                value: concluida,
                                onChanged: (_) => _alternarStatus(index),
                              ),
                              title: Text(
                                item['titulo'] ?? '',
                                style: TextStyle(
                                  decoration: concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: concluida ? Colors.grey : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _removerTarefa(index),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}