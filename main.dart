import 'dart:convert'; // Necessário para jsonEncode e jsonDecode
import 'dart:io';      // Necessário para File
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; // Necessário adicionar no pubspec.yaml
import 'dart:math'; // Necessário para 'min' e 'pi'

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const FinanceiroApp());
}

class FinanceiroApp extends StatelessWidget {
  const FinanceiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Financeiro Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'SF Pro Display',
      ),
      home: const BaseNavegacao(),
    );
  }
}

class BaseNavegacao extends StatefulWidget {
  const BaseNavegacao({super.key});

  @override
  State<BaseNavegacao> createState() => _BaseNavegacaoState();
}

class _BaseNavegacaoState extends State<BaseNavegacao> with SingleTickerProviderStateMixin {
  int _indiceAtual = 0;
  late AnimationController _animController;

  final List<Widget> _telas = [
    const Tela1_VisaoGeral(),
    const Tela2_MinhasContas(),
    const Tela3_Relatorios(),
    const Tela4_Investimentos(),
    const Tela5_Pagamentos(),
    const Tela6_Transferencias(),
    const Tela7_Objetivos(),
    const Tela8_Relatorios(),
    const Tela9_Configuracoes(),
    const Tela10_Ajuda(),
  ];

  final List<Map<String, dynamic>> _menuItems = [
    // Tela 1: Dashboard Geral
    {'icon': Icons.dashboard_rounded, 'label': 'Visão Geral', 'gradient': [Color(0xFF667eea), Color(0xFF764ba2)]},

    // Tela 2: Gestão de Contas e Movimentações
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Carteira', 'gradient': [Color(0xFF2193b0), Color(0xFF6dd5ed)]},

    // Tela 3: Relatórios, Pesquisa e Faturas
    {'icon': Icons.analytics_rounded, 'label': 'Relatórios', 'gradient': [Color(0xFFB06AB3), Color(0xFF4568DC)]},

    // Tela 4: Projeção Futura e Investimentos
    {'icon': Icons.rocket_launch_rounded, 'label': 'Projeção', 'gradient': [Color(0xFF11998e), Color(0xFF38ef7d)]},

    // Tela 5: Planejamento de Limites (50-30-20)
    {'icon': Icons.savings_rounded, 'label': 'Planejar', 'gradient': [Color(0xFFf093fb), Color(0xFFF5576C)]},

    // --- Telas ainda não desenvolvidas (Placeholders) ---
    {'icon': Icons.swap_horiz_rounded, 'label': 'Transf', 'gradient': [Color(0xFF4facfe), Color(0xFF00f2fe)]},
    {'icon': Icons.flag_rounded, 'label': 'Metas', 'gradient': [Color(0xFFfa709a), Color(0xFFfee140)]},
    {'icon': Icons.pie_chart_rounded, 'label': 'Outros', 'gradient': [Color(0xFF3f2b96), Color(0xFFa8c0ff)]},
    {'icon': Icons.settings_rounded, 'label': 'Config', 'gradient': [Color(0xFF434343), Color(0xFF000000)]},
    {'icon': Icons.help_rounded, 'label': 'Ajuda', 'gradient': [Color(0xFF00c6ff), Color(0xFF0072ff)]},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _aoTocarMenu(int index) {
    setState(() {
      _indiceAtual = index;
    });
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _telas[_indiceAtual],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _menuItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _indiceAtual == index;

                return GestureDetector(
                  onTap: () => _aoTocarMenu(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 75,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        colors: item['gradient'] as List<Color>,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: isSelected ? 28 : 26,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


// ==============================================================================
// WIDGETS AUXILIARES
// ==============================================================================
class ModernCard extends StatelessWidget {
  final Widget child;
  final List<Color>? gradient;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const ModernCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient != null
              ? LinearGradient(
            colors: gradient!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}


// ==============================================================================
// TELA 1: DASHBOARD / VISÃO GERAL
// ==============================================================================
// Inicio tela 1
class Tela1_VisaoGeral extends StatefulWidget {
  const Tela1_VisaoGeral({super.key});

  @override
  State<Tela1_VisaoGeral> createState() => _Tela1_VisaoGeralState();
}

class _Tela1_VisaoGeralState extends State<Tela1_VisaoGeral> {
  // Dados
  List<ContaModelo> _contas = [];
  Map<String, double> _limitesPlanejados = {};

  // Mapeamento de Tags: Chave = Categoria do Planejamento (Ex: Casa), Valor = Lista de Tags (Ex: [Casa, Mercado])
  Map<String, List<String>> _mapeamentoTags = {};

  // Lista de todas as tags encontradas no histórico + padrão
  Set<String> _todasTagsDisponiveis = {};

  // Estado Visual
  bool _carregando = true;
  DateTime _dataFocada = DateTime.now(); // Mês selecionado

  // Totais do Mês Selecionado
  double _totalEntradas = 0.0;
  double _totalSaidas = 0.0;
  double _saldoDoMes = 0.0;
  double _patrimonioNoFinalDoMes = 0.0;
  double? _variacaoPatrimonioPct;

  @override
  void initState() {
    super.initState();
    _carregarDadosGerais();
  }

  // --- CARREGAMENTO DE DADOS ---
  Future<void> _carregarDadosGerais() async {
    setState(() => _carregando = true);
    try {
      final dir = await getApplicationDocumentsDirectory();

      // 1. Carregar Contas e Transações
      final fileContas = File('${dir.path}/financeiro_db_geral.json');
      if (await fileContas.exists()) {
        final jsonString = await fileContas.readAsString();
        final decoded = jsonDecode(jsonString);
        if (decoded["contas"] != null) {
          _contas = (decoded["contas"] as List).map((e) => ContaModelo.fromJson(e)).toList();

          // Extrair todas as tags usadas para facilitar a configuração
          _todasTagsDisponiveis = {
            'Mercado', 'Lazer', 'Esporádico', 'Casa', 'Transporte', 'Saúde',
            'Salário', 'Contas Gerais', 'Beleza', 'Assinaturas', 'Roupas', 'Mimos p/mim', 'Rendimento', 'Investimento', 'Ajuste', 'Outros', 'Aporte', 'presentes'
          };
          for (var c in _contas) {
            for (var t in c.historico) {
              _todasTagsDisponiveis.add(t.categoria);
            }
          }
        }
      }

      // 2. Carregar Limites Planejados (Tela 5)
      final fileLimites = File('${dir.path}/config_limites.json');
      if (await fileLimites.exists()) {
        final jsonString = await fileLimites.readAsString();
        final decoded = jsonDecode(jsonString);
        if (decoded["limites"] != null) {
          Map<String, dynamic> limitesMap = decoded["limites"];
          limitesMap.forEach((key, value) {
            _limitesPlanejados[key] = (value as num).toDouble();
          });
        }
      }

      // 3. Carregar Mapeamento de Tags Personalizado
      final fileMapping = File('${dir.path}/config_tags_planejamento.json');
      if (await fileMapping.exists()) {
        final jsonString = await fileMapping.readAsString();
        final decoded = jsonDecode(jsonString);
        Map<String, dynamic> mapRaw = decoded;
        mapRaw.forEach((key, value) {
          _mapeamentoTags[key] = List<String>.from(value);
        });
      } else {
        // Mapeamento Padrão Inicial (Se não existir configuração)
        _mapeamentoTags = {
          'Casa': ['Casa', 'Mercado', 'Contas Fixas'],
          'Alimentação': ['Alimentação', 'Restaurante'],
          'Lazer': ['Lazer', 'Viagem'],
          'Investimento Futuro': ['Investimento', 'Aporte', 'Rendimento'],
        };
      }

      _processarDadosDoMes();

    } catch (e) {
      debugPrint("Erro dashboard: $e");
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _salvarMapeamentoTags() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/config_tags_planejamento.json');
      await file.writeAsString(jsonEncode(_mapeamentoTags));
    } catch (e) {
      debugPrint("Erro ao salvar mapeamento: $e");
    }
  }

  // --- PROCESSAMENTO ---
  void _processarDadosDoMes() {
    double entradas = 0;
    double saidas = 0;

    List<TransacaoModelo> todasTransacoes = [];
    for (var c in _contas) {
      todasTransacoes.addAll(c.historico);
    }

    for (var t in todasTransacoes) {
      // CORREÇÃO: Ignora 'Pagamento Fatura' no balanço de despesas, pois os gastos já foram contados individualmente.
      if (t.categoria == 'Saldo Inicial' || t.categoria == 'Pagamento Fatura') continue;

      if (t.data.month == _dataFocada.month && t.data.year == _dataFocada.year) {
        if (t.isEntrada) entradas += t.valor; else saidas += t.valor;
      }
    }

    double patrimonioAtual = _contas.fold(0.0, (sum, c) => sum + c.saldo);
    double patrimonioFocado = patrimonioAtual;
    final fimDoMesFocado = DateTime(_dataFocada.year, _dataFocada.month + 1, 0, 23, 59, 59);

    // Engenharia reversa para saldo histórico (aqui Pagamento Fatura DEVE ser considerado pois afeta o saldo da conta)
    for (var t in todasTransacoes) {
      if (t.data.isAfter(fimDoMesFocado)) {
        if (t.isEntrada) patrimonioFocado -= t.valor;
        else patrimonioFocado += t.valor;
      }
    }

    double patrimonioMesAnterior = patrimonioFocado;
    for (var t in todasTransacoes) {
      if (t.data.month == _dataFocada.month && t.data.year == _dataFocada.year) {
        if (t.isEntrada) patrimonioMesAnterior -= t.valor;
        else patrimonioMesAnterior += t.valor;
      }
    }

    double? variacao;
    if (patrimonioMesAnterior > 0) {
      variacao = ((patrimonioFocado - patrimonioMesAnterior) / patrimonioMesAnterior) * 100;
    } else if (patrimonioMesAnterior == 0 && patrimonioFocado > 0) {
      variacao = 100.0;
    }

    setState(() {
      _totalEntradas = entradas;
      _totalSaidas = saidas;
      _saldoDoMes = entradas - saidas;
      _patrimonioNoFinalDoMes = patrimonioFocado;
      _variacaoPatrimonioPct = variacao;
    });
  }

  void _navegarMes(int meses) {
    setState(() {
      _dataFocada = DateTime(_dataFocada.year, _dataFocada.month + meses, 1);
    });
    _processarDadosDoMes();
  }

  String _getTextoMes() {
    const meses = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
    return "${meses[_dataFocada.month - 1]} ${_dataFocada.year}";
  }

  // --- DIALOGO DE CONFIGURAÇÃO DE TAGS ---
  void _abrirConfiguracaoTags() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Vincular Tags ao Planejamento"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: _limitesPlanejados.keys.map((categoriaPlanejada) {
                    return ExpansionTile(
                      title: Text(categoriaPlanejada, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        _mapeamentoTags[categoriaPlanejada]?.join(", ") ?? "Nenhuma tag",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      children: [
                        Wrap(
                          spacing: 6,
                          children: _todasTagsDisponiveis.map((tag) {
                            final isSelected = _mapeamentoTags[categoriaPlanejada]?.contains(tag) ?? false;
                            return FilterChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (selected) {
                                setStateDialog(() {
                                  if (_mapeamentoTags[categoriaPlanejada] == null) {
                                    _mapeamentoTags[categoriaPlanejada] = [];
                                  }

                                  if (selected) {
                                    _mapeamentoTags[categoriaPlanejada]!.add(tag);
                                  } else {
                                    _mapeamentoTags[categoriaPlanejada]!.remove(tag);
                                  }
                                });
                                // Atualiza a tela principal também
                                setState(() {});
                                _salvarMapeamentoTags();
                              },
                              selectedColor: Colors.indigo.shade100,
                              checkmarkColor: Colors.indigo,
                            );
                          }).toList(),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Concluir"))
              ],
            );
          }
      ),
    );
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 10, left: 10, right: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left, color: Colors.indigo), onPressed: () => _navegarMes(-1)),
                Column(
                  children: [
                    const Text("Resumo de", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(_getTextoMes(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.chevron_right, color: Colors.indigo), onPressed: () => _navegarMes(1)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_totalEntradas == 0 && _totalSaidas == 0 && _patrimonioNoFinalDoMes == 0)
                    _buildEmptyState()
                  else ...[
                    _buildSaldoTotalCard(),
                    const SizedBox(height: 20),
                    _buildCardsResumo(),
                    const SizedBox(height: 20),
                    // Gráfico de Pizza
                    _buildGraficoPizza(),
                    const SizedBox(height: 20),
                    // Planejado vs Realizado
                    _buildPlanejadoVsRealizado(),
                    const SizedBox(height: 20),
                    _buildSaudeFinanceira(),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Icon(Icons.insert_chart_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text("Sem registros neste mês", style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _navegarMes((DateTime.now().month - _dataFocada.month) + (DateTime.now().year - _dataFocada.year) * 12),
            icon: const Icon(Icons.today),
            label: const Text("Voltar para Hoje"),
          )
        ],
      ),
    );
  }

  Widget _buildSaldoTotalCard() {
    bool cresceu = (_variacaoPatrimonioPct ?? 0) >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo.shade800, Colors.indigo.shade500], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Patrimônio Total (Fim do Mês)", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text("R\$ ${_patrimonioNoFinalDoMes.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),

          if (_variacaoPatrimonioPct != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cresceu ? Icons.trending_up : Icons.trending_down, color: cresceu ? Colors.greenAccent : Colors.redAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "${cresceu ? '+' : ''}${_variacaoPatrimonioPct!.toStringAsFixed(1)}% vs mês anterior",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildCardsResumo() {
    return Row(
      children: [
        Expanded(child: _buildMiniCard("Entradas", _totalEntradas, Colors.green, Icons.arrow_downward)),
        const SizedBox(width: 12),
        Expanded(child: _buildMiniCard("Saídas", _totalSaidas, Colors.red, Icons.arrow_upward)),
        const SizedBox(width: 12),
        Expanded(child: _buildMiniCard("Resultado", _saldoDoMes, _saldoDoMes >= 0 ? Colors.blue : Colors.orange, Icons.functions)),
      ],
    );
  }

  Widget _buildMiniCard(String titulo, double valor, Color cor, IconData icone) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(height: 8),
          Text(titulo, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          FittedBox(child: Text("R\$ ${valor.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildPlanejadoVsRealizado() {
    // Agora pegamos as categorias definidas na tela de Configuração (Tela 5)
    // Se não tiver nenhuma configurada, usa as padrão.
    List<String> categoriasAlvo = _limitesPlanejados.keys.toList();
    if (categoriasAlvo.isEmpty) {
      categoriasAlvo = ['Lazer', 'Alimentação', 'Casa', 'Investimento Futuro'];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Planejado vs Realizado", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.settings, size: 20, color: Colors.grey),
                onPressed: _abrirConfiguracaoTags,
                tooltip: "Configurar quais TAGS compõem cada categoria",
              )
            ],
          ),
          const SizedBox(height: 16),

          ...categoriasAlvo.map((cat) {
            double limite = _limitesPlanejados[cat] ?? 0.0;
            double realizado = 0.0;

            // Pega as tags vinculadas a esta categoria. Se não tiver vinculo, tenta usar o próprio nome da categoria como tag.
            List<String> tagsVinculadas = _mapeamentoTags[cat] ?? [cat];

            // Calcula realizado (gasto ou aporte) no mês
            for (var c in _contas) {
              for (var t in c.historico) {
                if (t.data.month == _dataFocada.month && t.data.year == _dataFocada.year) {
                  // Se a transação tem uma tag que está na lista vinculada
                  if (tagsVinculadas.contains(t.categoria)) {
                    // Ignora pagamento de fatura aqui também para não duplicar se estiver mapeado
                    if (t.categoria == 'Pagamento Fatura') continue;

                    if (cat.contains("Investimento") || cat.contains("Guardar")) {
                      realizado += t.valor;
                    } else {
                      // Para despesas, somamos apenas saídas
                      if (!t.isEntrada) realizado += t.valor;
                    }
                  }
                }
              }
            }

            // Evita divisão por zero
            double progresso = limite > 0 ? (realizado / limite) : (realizado > 0 ? 1.0 : 0.0);
            Color corBarra;
            if (cat.contains("Investimento") || cat.contains("Guardar")) {
              // Para investimento, quanto mais melhor (até 100% é azul/verde, acima é ótimo)
              corBarra = progresso >= 1.0 ? Colors.green : Colors.blue;
            } else {
              // Para gasto, acima de 100% é ruim
              corBarra = progresso > 1.0 ? Colors.red : (progresso > 0.8 ? Colors.orange : Colors.indigo);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cat, style: const TextStyle(fontWeight: FontWeight.w600)),
                      // MUDANÇA: Exibe Valor em Reais e Porcentagem
                      Text("R\$ ${realizado.toStringAsFixed(0)}  (${(progresso * 100).toStringAsFixed(0)}%)", style: TextStyle(color: corBarra, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progresso > 1 ? 1 : progresso, // Trava visual em 100%
                      backgroundColor: Colors.grey.shade100,
                      color: corBarra,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Texto de meta abaixo
                      Text("Meta: R\$ ${limite.toStringAsFixed(0)}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),

          if (_limitesPlanejados.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Configure seus limites na tela de Configurações para ver este gráfico.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 12)),
            )
        ],
      ),
    );
  }

  Widget _buildGraficoPizza() {
    Map<String, double> gastosPorCat = {};
    for (var c in _contas) {
      for (var t in c.historico) {
        if (t.data.month == _dataFocada.month && t.data.year == _dataFocada.year &&
            !t.isEntrada &&
            t.categoria != 'Investimento' && t.categoria != 'Aporte' && t.categoria != 'Saldo Inicial' && t.categoria != 'Pagamento Fatura') { // CORREÇÃO: Ignora 'Pagamento Fatura'
          gastosPorCat[t.categoria] = (gastosPorCat[t.categoria] ?? 0) + t.valor;
        }
      }
    }

    if (gastosPorCat.isEmpty) return const SizedBox.shrink();

    var sortedEntries = gastosPorCat.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    List<Color> cores = [Colors.indigo, Colors.blue, Colors.teal, Colors.orange, Colors.purple, Colors.red];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Distribuição de Gastos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _PieChartPainter(gastosPorCat.values.toList(), cores),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: List.generate(min(sortedEntries.length, 5), (index) {
                    final entry = sortedEntries[index];
                    final pct = _totalSaidas > 0 ? (entry.value / _totalSaidas) : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: cores[index % cores.length], shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Expanded(child: Text("${entry.key} - R\$ ${entry.value.toStringAsFixed(2)}", style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                          Text("${(pct * 100).toStringAsFixed(0)}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSaudeFinanceira() {
    double taxaPoupanca = _totalEntradas > 0 ? ((_totalEntradas - _totalSaidas) / _totalEntradas) * 100 : 0;
    String status = "";
    Color corStatus = Colors.grey;
    String mensagem = "";

    if (taxaPoupanca >= 20) {
      status = "Excelente";
      corStatus = Colors.green;
      mensagem = "Você poupou mais de 20% da sua renda. Continue assim!";
    } else if (taxaPoupanca > 0) {
      status = "Equilibrado";
      corStatus = Colors.orange;
      mensagem = "Você está no azul, mas tente poupar um pouco mais.";
    } else {
      status = "Atenção";
      corStatus = Colors.red;
      mensagem = "Seus gastos superaram seus ganhos. Revise o orçamento.";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: corStatus.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: corStatus.withOpacity(0.3))),
      child: Row(
        children: [
          Icon(taxaPoupanca >= 0 ? Icons.health_and_safety : Icons.warning, color: corStatus, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saúde Financeira: $status", style: TextStyle(fontWeight: FontWeight.bold, color: corStatus, fontSize: 15)),
                const SizedBox(height: 4),
                Text(mensagem, style: TextStyle(fontSize: 12, color: corStatus.withOpacity(0.8))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _PieChartPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.fold(0, (sum, val) => sum + val);
    if (total == 0) return;

    double startAngle = -pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;
      final paint = Paint()..color = colors[i % colors.length]..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// Fim da tela 1

// Inicio tela 2


class ContaFixaModelo {
  final String id;
  final String titulo;
  final double valor;
  final int diaVencimento;
  final String tipoPagamento;
  final String categoria;
  final String? idContaOrigem;
  DateTime? ultimaDataLancamento;

  ContaFixaModelo({
    required this.id, required this.titulo, required this.valor, required this.diaVencimento,
    this.tipoPagamento = 'D', this.categoria = 'Geral', this.idContaOrigem, this.ultimaDataLancamento,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'titulo': titulo, 'valor': valor, 'diaVencimento': diaVencimento,
    'tipoPagamento': tipoPagamento, 'categoria': categoria, 'idContaOrigem': idContaOrigem,
    'ultimaDataLancamento': ultimaDataLancamento?.toIso8601String(),
  };

  factory ContaFixaModelo.fromJson(Map<String, dynamic> json) {
    return ContaFixaModelo(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: json['titulo'],
      valor: (json['valor'] as num).toDouble(),
      diaVencimento: json['diaVencimento'],
      tipoPagamento: json['tipoPagamento'] ?? 'D',
      categoria: json['categoria'] ?? 'Geral',
      idContaOrigem: json['idContaOrigem'],
      ultimaDataLancamento: json['ultimaDataLancamento'] != null ? DateTime.parse(json['ultimaDataLancamento']) : null,
    );
  }
}

class TransacaoModelo {
  final String id;
  final String titulo;
  final double valor;
  final bool isEntrada;
  final DateTime data;
  final String categoria;
  final String tipoPagamento; // 'D' = Débito, 'C' = Crédito
  final bool isFixa;
  final double? percentualRendimento;
  bool faturaPaga;
  String? paymentId; // ID da transação que pagou esta compra
  String? mesReferencia; // NOVO: Identifica a qual fatura pertence (ex: "02/2026")

  TransacaoModelo({
    required this.id, required this.titulo, required this.valor, required this.isEntrada,
    required this.data, this.categoria = 'Geral', this.tipoPagamento = 'D', this.isFixa = false,
    this.percentualRendimento, this.faturaPaga = false, this.paymentId,
    this.mesReferencia,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'titulo': titulo, 'valor': valor, 'isEntrada': isEntrada,
    'data': data.toIso8601String(), 'categoria': categoria, 'tipoPagamento': tipoPagamento,
    'isFixa': isFixa, 'percentualRendimento': percentualRendimento, 'faturaPaga': faturaPaga,
    'paymentId': paymentId, 'mesReferencia': mesReferencia,
  };

  factory TransacaoModelo.fromJson(Map<String, dynamic> json) {
    return TransacaoModelo(
      id: json['id'] ?? DateTime.now().toIso8601String(),
      titulo: json['titulo'],
      valor: (json['valor'] as num).toDouble(),
      isEntrada: json['isEntrada'], data: DateTime.parse(json['data']),
      categoria: json['categoria'] ?? 'Geral', tipoPagamento: json['tipoPagamento'] ?? 'D',
      isFixa: json['isFixa'] ?? false,
      percentualRendimento: (json['percentualRendimento'] as num?)?.toDouble(),
      faturaPaga: json['faturaPaga'] ?? false,
      paymentId: json['paymentId'],
      mesReferencia: json['mesReferencia'],
    );
  }
}

class ContaModelo {
  String id;
  String nome;
  double saldo;
  IconData icone;
  List<Color> gradiente;
  List<TransacaoModelo> historico;
  List<ContaFixaModelo> contasFixas;
  String tipoConta;
  bool permiteDebito;
  bool permiteCredito;
  int diaVencimento;
  List<String> faturasFechadas; // NOVO: Lista de meses ("MM/yyyy") que foram fechados manualmente

  ContaModelo({
    required this.id, required this.nome, required this.saldo, required this.icone, required this.gradiente,
    this.historico = const [], this.contasFixas = const [], this.tipoConta = 'BANCO',
    this.permiteDebito = true, this.permiteCredito = false, this.diaVencimento = 10,
    this.faturasFechadas = const [],
  });

  // Retorna o valor total da fatura ABERTA (transações de crédito não pagas e não pertencentes a faturas fechadas)
  double get faturaAbertaTotal {
    if (!permiteCredito) return 0.0;
    return historico
        .where((t) => !t.isEntrada && t.tipoPagamento == 'C' && !t.faturaPaga && !faturasFechadas.contains(t.mesReferencia))
        .fold(0.0, (sum, t) => sum + t.valor);
  }

  // Retorna o mês de referência sugerido para a fatura aberta (o menor mês que tem transações em aberto ou o atual)
  String get mesFaturaAbertaPrincipal {
    final transacoesAbertas = historico
        .where((t) => !t.isEntrada && t.tipoPagamento == 'C' && !t.faturaPaga && !faturasFechadas.contains(t.mesReferencia))
        .toList();

    if (transacoesAbertas.isEmpty) {
      final now = DateTime.now();
      return "${now.month.toString().padLeft(2, '0')}/${now.year}";
    }

    // Tenta pegar o mesReferencia mais antigo, assumindo que é a fatura atual
    // (Simplificação: pega a primeira que aparecer, idealmente ordenaria)
    transacoesAbertas.sort((a, b) => a.data.compareTo(b.data));
    return transacoesAbertas.first.mesReferencia ?? "${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";
  }

  // Retorna lista de faturas FECHADAS que ainda não foram pagas
  List<String> get faturasFechadasPendentes {
    final pendentes = <String>{};
    for (var t in historico) {
      if (!t.isEntrada && t.tipoPagamento == 'C' && !t.faturaPaga && t.mesReferencia != null) {
        if (faturasFechadas.contains(t.mesReferencia)) {
          pendentes.add(t.mesReferencia!);
        }
      }
    }
    // Ordena decrescente (mais recente primeiro)
    return pendentes.toList()..sort((a, b) {
      // Comparação simples de string MM/yyyy pode falhar na virada de ano se não fizer parse,
      // mas para listas curtas visual funciona. Vamos fazer parse para garantir.
      try {
        final partsA = a.split('/'); final partsB = b.split('/');
        final dateA = DateTime(int.parse(partsA[1]), int.parse(partsA[0]));
        final dateB = DateTime(int.parse(partsB[1]), int.parse(partsB[0]));
        return dateB.compareTo(dateA);
      } catch (e) { return 0; }
    });
  }

  // Calcula valor de uma fatura fechada específica
  double valorFaturaFechada(String mesRef) {
    return historico
        .where((t) => !t.isEntrada && t.tipoPagamento == 'C' && !t.faturaPaga && t.mesReferencia == mesRef)
        .fold(0.0, (sum, t) => sum + t.valor);
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'nome': nome, 'saldo': saldo,
    'icone_codePoint': icone.codePoint, 'icone_fontFamily': icone.fontFamily, 'icone_fontPackage': icone.fontPackage,
    'gradiente': gradiente.map((c) => c.value).toList(),
    'historico': historico.map((t) => t.toJson()).toList(),
    'contasFixas': contasFixas.map((c) => c.toJson()).toList(),
    'tipoConta': tipoConta, 'permiteDebito': permiteDebito, 'permiteCredito': permiteCredito, 'diaVencimento': diaVencimento,
    'faturasFechadas': faturasFechadas,
  };

  factory ContaModelo.fromJson(Map<String, dynamic> json) {
    return ContaModelo(
      id: json['id'], nome: json['nome'], saldo: (json['saldo'] as num).toDouble(),
      icone: IconData(json['icone_codePoint'], fontFamily: json['icone_fontFamily'], fontPackage: json['icone_fontPackage']),
      gradiente: (json['gradiente'] as List).map((c) => Color(c)).toList(),
      historico: (json['historico'] as List).map((t) => TransacaoModelo.fromJson(t)).toList(),
      contasFixas: (json['contasFixas'] as List?)?.map((c) => ContaFixaModelo.fromJson(c)).toList() ?? [],
      tipoConta: json['tipoConta'] ?? 'BANCO', permiteDebito: json['permiteDebito'] ?? true,
      permiteCredito: json['permiteCredito'] ?? false, diaVencimento: json['diaVencimento'] ?? 10,
      faturasFechadas: (json['faturasFechadas'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

// ==============================================================================
// LÓGICA DA TELA 2
// ==============================================================================

class Tela2_MinhasContas extends StatefulWidget {
  const Tela2_MinhasContas({super.key});

  @override
  State<Tela2_MinhasContas> createState() => _Tela2_MinhasContasState();
}

class _Tela2_MinhasContasState extends State<Tela2_MinhasContas> {
  final List<ContaModelo> _contas = [];

  Map<String, int> _categoriasIcones = {
    'Mercado': Icons.shopping_cart.codePoint,
    'Lazer': Icons.movie.codePoint,
    'Esporádico': Icons.star.codePoint,
    'Casa': Icons.home.codePoint,
    'Transporte': Icons.directions_car.codePoint,
    'Saúde': Icons.medical_services.codePoint,
    'Salário': Icons.attach_money.codePoint,
    'Contas Fixas': Icons.calendar_today.codePoint,
    'Pagamento Fatura': Icons.receipt.codePoint,
    'Rendimento': Icons.trending_up.codePoint,
    'Investimento': Icons.savings.codePoint,
    'Ajuste': Icons.balance.codePoint,
    'Saldo Inicial': Icons.flag.codePoint,
    'Outros': Icons.category.codePoint,
  };

  List<String> _sugestoesDescricao = ["Almoço", "Uber", "Salário", "Pagamento de Fatura", "Academia", "Netflix", "Internet"];

  ContaModelo? _contaSelecionada;
  double get _saldoTotal => _contas.fold(0, (sum, item) => sum + item.saldo);

  String _textoBusca = "";
  DateTime? _filtroDataInicio;
  DateTime? _filtroDataFim;
  bool _filtrosAtivos = false;

  Future<File> _getArquivoJson() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/financeiro_db_geral.json');
  }

  Future<void> _salvarDados() async {
    try {
      final file = await _getArquivoJson();
      final data = {
        "contas": _contas.map((c) => c.toJson()).toList(),
        "categorias": _categoriasIcones,
        "sugestoes": _sugestoesDescricao,
      };
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint("Erro salvar: $e");
    }
  }

  Future<void> _carregarDados() async {
    try {
      final file = await _getArquivoJson();
      if (!await file.exists()) {
        if (_contas.isEmpty) {
          setState(() {
            _contas.add(ContaModelo(
                id: '1', nome: 'Carteira', saldo: 0, icone: Icons.wallet, gradiente: [Colors.blue, Colors.blueAccent],
                historico: [], contasFixas: []
            ));
          });
        }
        return;
      }

      final jsonString = await file.readAsString();
      final decoded = jsonDecode(jsonString);

      setState(() {
        if (decoded["contas"] != null) {
          _contas.clear();
          _contas.addAll((decoded["contas"] as List).map((e) => ContaModelo.fromJson(e)).toList());
        }
        if (decoded["categorias"] != null) {
          _categoriasIcones = Map<String, int>.from(decoded["categorias"]);
        }
        if (decoded["sugestoes"] != null) {
          _sugestoesDescricao = List<String>.from(decoded["sugestoes"]);
        }
      });

      // Migração de dados legados (sem mesReferencia)
      _migrarDadosFaturas();

      bool precisaSalvar = false;
      for (var conta in _contas) {
        if (_verificarRecorrencias(conta, silent: true)) {
          precisaSalvar = true;
        }
      }
      if (precisaSalvar) _salvarDados();

    } catch (e) {
      debugPrint("Erro carregar: $e");
    }
  }

  void _migrarDadosFaturas() {
    // Garante que transações de crédito antigas tenham um mesReferencia
    bool houveMudanca = false;
    for (var conta in _contas) {
      for (var t in conta.historico) {
        if (t.tipoPagamento == 'C' && t.mesReferencia == null) {
          // Atribui o mês da transação como referência default
          t.mesReferencia = "${t.data.month.toString().padLeft(2, '0')}/${t.data.year}";
          houveMudanca = true;
        }
      }
    }
    if (houveMudanca) _salvarDados();
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // --- LÓGICA DE AUTOMATIZAÇÃO (Contas Fixas) ---
  bool _verificarRecorrencias(ContaModelo conta, {bool silent = false}) {
    bool houveAlteracao = false;
    final hoje = DateTime.now();

    // 1. Contas Fixas e Aportes
    for (var fixa in conta.contasFixas) {
      bool jaLancouEsteMes = false;
      if (fixa.ultimaDataLancamento != null) {
        if (fixa.ultimaDataLancamento!.month == hoje.month &&
            fixa.ultimaDataLancamento!.year == hoje.year) {
          jaLancouEsteMes = true;
        }
      }

      if (!jaLancouEsteMes && hoje.day >= fixa.diaVencimento) {
        String mesRef = "${hoje.month.toString().padLeft(2, '0')}/${hoje.year}";

        if (conta.tipoConta == 'INVESTIMENTO' && fixa.idContaOrigem != null) {
          // ... (Lógica de investimento inalterada por brevidade, mas deve considerar o mesRef se for credito)
          // Simplificando: investimentos geralmente são débito em conta corrente.
          // Se fosse crédito, precisaria atribuir o mesRef.
        }
        else {
          // Se for crédito, precisamos saber qual fatura jogar. Por padrão automático: Mês atual.
          // Se o mês atual já estiver fechado, joga para o próximo.
          String mesDestino = mesRef;
          if (fixa.tipoPagamento == 'C' && conta.faturasFechadas.contains(mesRef)) {
            mesDestino = _getNextMonth(mesRef);
          }

          final novaTransacao = TransacaoModelo(
            id: DateTime.now().millisecondsSinceEpoch.toString() + fixa.id,
            titulo: "${fixa.titulo} (Automático)", valor: fixa.valor, isEntrada: false,
            data: DateTime(hoje.year, hoje.month, fixa.diaVencimento),
            categoria: fixa.categoria, tipoPagamento: fixa.tipoPagamento, isFixa: true,
            mesReferencia: fixa.tipoPagamento == 'C' ? mesDestino : null,
          );
          if (fixa.tipoPagamento == 'D') conta.saldo -= fixa.valor;
          conta.historico.insert(0, novaTransacao);
          houveAlteracao = true;
        }
        fixa.ultimaDataLancamento = DateTime.now();
      }
    }

    // REMOVIDO: Pagamento Automático de Fatura. Agora é MANUAL como solicitado.

    if (houveAlteracao) {
      conta.historico.sort((a, b) => b.data.compareTo(a.data));
    }
    return houveAlteracao;
  }

  String _getNextMonth(String currentMesRef) {
    try {
      final parts = currentMesRef.split('/');
      final dt = DateTime(int.parse(parts[1]), int.parse(parts[0]) + 1);
      return "${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) { return currentMesRef; }
  }

  IconData _getIcon(int codePoint) => IconData(codePoint, fontFamily: 'MaterialIcons');

  // --- UI AUXILIAR ---
  void _gerenciarCategorias() { /* ... Código inalterado ... */ }
  void _abrirGestaoContasFixas() { /* ... Código inalterado ... */ }
  void _dialogAdicionarContaFixa(StateSetter setStateSheet) { /* ... Código inalterado ... */ }
  void _adicionarOuEditarConta({ContaModelo? contaExistente}) { /* ... Código inalterado ... */ }

  // --- MOVIMENTAÇÕES ---

  void _abrirDialogoTransacao({bool isEntrada = false, TransacaoModelo? transacaoExistente}) {
    if (_contaSelecionada == null) return;
    final isEditando = transacaoExistente != null;
    final bool tipoOperacaoEntrada = isEditando ? transacaoExistente.isEntrada : isEntrada;

    final bool isPagamentoFatura = isEditando && transacaoExistente.categoria == 'Pagamento Fatura';

    final valorCtrl = TextEditingController(text: isEditando ? transacaoExistente.valor.toStringAsFixed(2) : "");
    final descCtrl = TextEditingController(text: isEditando ? transacaoExistente.titulo : "");
    DateTime dataSelecionada = isEditando ? transacaoExistente.data : DateTime.now();
    String categoriaSelecionada = isEditando ? transacaoExistente.categoria : (tipoOperacaoEntrada ? 'Salário' : 'Outros');
    String tipoPagamento = isEditando ? transacaoExistente.tipoPagamento : 'D';
    if (!tipoOperacaoEntrada && _contaSelecionada!.permiteCredito && !_contaSelecionada!.permiteDebito) tipoPagamento = 'C';

    // Configuração do seletor de fatura (apenas para crédito)
    String mesReferenciaSelecionado = transacaoExistente?.mesReferencia ??
        "${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";

    // Se a sugestão padrão já estiver fechada, tenta o próximo mês
    if (!isEditando && _contaSelecionada!.faturasFechadas.contains(mesReferenciaSelecionado)) {
      mesReferenciaSelecionado = _getNextMonth(mesReferenciaSelecionado);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Gera lista de faturas disponíveis (Atual até +12 meses)
            List<String> opcoesFatura = [];
            DateTime baseDate = DateTime.now();
            // Começa do mês anterior para garantir caso esteja editando algo antigo
            baseDate = DateTime(baseDate.year, baseDate.month - 1);

            for(int i=0; i<14; i++) {
              DateTime d = DateTime(baseDate.year, baseDate.month + i);
              String m = "${d.month.toString().padLeft(2, '0')}/${d.year}";
              opcoesFatura.add(m);
            }

            return AlertDialog(
              title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(isEditando ? "Editar" : (tipoOperacaoEntrada ? "Entrada 🤑" : "Saída 💸")), if(!isPagamentoFatura) IconButton(icon: const Icon(Icons.settings, size: 20), onPressed: _gerenciarCategorias)]),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: valorCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: "Valor (R\$)", prefixText: "R\$ "),
                      autofocus: !isEditando,
                      readOnly: isPagamentoFatura,
                      style: isPagamentoFatura ? const TextStyle(color: Colors.grey) : null,
                    ),
                    const SizedBox(height: 10),
                    Autocomplete<String>(
                      initialValue: TextEditingValue(text: descCtrl.text),
                      optionsBuilder: (v) => v.text == '' ? const Iterable<String>.empty() : _sugestoesDescricao.where((s) => s.toLowerCase().contains(v.text.toLowerCase())),
                      onSelected: (s) => descCtrl.text = s,
                      fieldViewBuilder: (ctx, ctrl, focus, onSubmit) {
                        if (descCtrl.text.isNotEmpty && ctrl.text.isEmpty) ctrl.text = descCtrl.text;
                        return TextField(controller: ctrl, focusNode: focus, decoration: const InputDecoration(labelText: "Descrição"), onChanged: (v) => descCtrl.text = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(context: context, initialDate: dataSelecionada, firstDate: DateTime(2020), lastDate: DateTime(2030));
                        if (picked != null) setStateDialog(() => dataSelecionada = picked);
                      },
                      child: Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8), Text("${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}")]),
                    ),
                    if (!tipoOperacaoEntrada && _contaSelecionada!.permiteDebito && _contaSelecionada!.permiteCredito && !isPagamentoFatura)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          children: [
                            Row(children: [Expanded(child: RadioListTile<String>(title: const Text("Débito", style: TextStyle(fontSize: 12)), value: 'D', groupValue: tipoPagamento, onChanged: (v) => setStateDialog(() => tipoPagamento = v!), contentPadding: EdgeInsets.zero)), Expanded(child: RadioListTile<String>(title: const Text("Crédito", style: TextStyle(fontSize: 12)), value: 'C', groupValue: tipoPagamento, onChanged: (v) => setStateDialog(() => tipoPagamento = v!), contentPadding: EdgeInsets.zero))]),
                            // SELETOR DE FATURA (SÓ APARECE NO CRÉDITO)
                            if (tipoPagamento == 'C')
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: opcoesFatura.contains(mesReferenciaSelecionado) ? mesReferenciaSelecionado : null,
                                    hint: const Text("Selecione a fatura"),
                                    items: opcoesFatura.map((mes) {
                                      bool fechada = _contaSelecionada!.faturasFechadas.contains(mes);
                                      return DropdownMenuItem(
                                        value: mes,
                                        enabled: !fechada, // Desabilita se estiver fechada
                                        child: Text(fechada ? "$mes (Fechada)" : "Fatura $mes", style: TextStyle(color: fechada ? Colors.grey : Colors.black)),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      if(v != null) setStateDialog(() => mesReferenciaSelecionado = v);
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),

                    if (isPagamentoFatura)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Categoria: Pagamento Fatura (Fixo)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      )
                    else
                      Wrap(spacing: 8, children: _categoriasIcones.entries.map((e) => ChoiceChip(label: Text(e.key), selected: categoriaSelecionada == e.key, onSelected: (v) => setStateDialog(() => categoriaSelecionada = e.key), avatar: Icon(_getIcon(e.value), size: 16), selectedColor: tipoOperacaoEntrada ? Colors.green : Colors.redAccent)).toList()),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: tipoOperacaoEntrada ? Colors.green : Colors.red, foregroundColor: Colors.white),
                  onPressed: () {
                    final valor = double.tryParse(valorCtrl.text.replaceAll(',', '.'));
                    if (valor != null && valor > 0) {
                      _processarSalvarTransacao(
                          valor: valor, descricao: descCtrl.text, categoria: categoriaSelecionada,
                          data: dataSelecionada, isEntrada: tipoOperacaoEntrada, tipoPagamento: tipoPagamento,
                          transacaoAntiga: transacaoExistente, mesReferencia: tipoPagamento == 'C' ? mesReferenciaSelecionado : null
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Confirmar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _processarSalvarTransacao({required double valor, required String descricao, required String categoria, required DateTime data, required bool isEntrada, required String tipoPagamento, TransacaoModelo? transacaoAntiga, String? mesReferencia}) {
    setState(() {
      if (transacaoAntiga != null) {
        if (transacaoAntiga.isEntrada) _contaSelecionada!.saldo -= transacaoAntiga.valor;
        else if (transacaoAntiga.tipoPagamento == 'D') _contaSelecionada!.saldo += transacaoAntiga.valor;
        _contaSelecionada!.historico.removeWhere((t) => t.id == transacaoAntiga.id);
      }

      if (isEntrada) _contaSelecionada!.saldo += valor;
      else if (tipoPagamento == 'D') _contaSelecionada!.saldo -= valor;

      String descFinal = descricao.isEmpty ? categoria : descricao;
      if (!_sugestoesDescricao.contains(descFinal)) _sugestoesDescricao.add(descFinal);

      final novaTransacao = TransacaoModelo(
        id: transacaoAntiga?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: descFinal, valor: valor, isEntrada: isEntrada, data: data, categoria: categoria, tipoPagamento: tipoPagamento,
        paymentId: transacaoAntiga?.paymentId,
        faturaPaga: transacaoAntiga?.faturaPaga ?? false,
        mesReferencia: mesReferencia,
      );

      _contaSelecionada!.historico.insert(0, novaTransacao);
      _contaSelecionada!.historico.sort((a, b) => b.data.compareTo(a.data));
    });
    _salvarDados();
  }

  // --- CONTROLE DE FATURAS MANUAL ---

  void _fecharFaturaManual() {
    String mesParaFechar = _contaSelecionada!.mesFaturaAbertaPrincipal;
    double valor = _contaSelecionada!.faturaAbertaTotal;

    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text("Fechar Fatura $mesParaFechar?"),
      content: Text("Isso moverá o valor de R\$ ${valor.toStringAsFixed(2)} para 'Faturas Fechadas'.\n\nVocê não poderá mais adicionar compras a esta fatura, apenas pagá-la."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _contaSelecionada!.faturasFechadas.add(mesParaFechar);
              });
              _salvarDados();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fatura fechada com sucesso!")));
            },
            child: const Text("Fechar Fatura")
        )
      ],
    ));
  }

  void _pagarFaturaEspecifica(String mesRef) {
    double totalFatura = _contaSelecionada!.valorFaturaFechada(mesRef);
    if (totalFatura <= 0) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pagar Fatura $mesRef"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total: R\$ ${totalFatura.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            const Text("Deseja confirmar o pagamento?"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                String idPagamento = "PAGTO_${mesRef.replaceAll('/', '_')}";
                _contaSelecionada!.saldo -= totalFatura;

                _contaSelecionada!.historico.insert(0, TransacaoModelo(
                  id: idPagamento,
                  titulo: "Pagamento Fatura $mesRef",
                  valor: totalFatura,
                  isEntrada: false,
                  data: DateTime.now(),
                  categoria: "Pagamento Fatura",
                  tipoPagamento: 'D',
                ));

                // Marca itens deste mês específico como pagos
                for (var t in _contaSelecionada!.historico) {
                  if (t.tipoPagamento == 'C' && !t.faturaPaga && !t.isEntrada && t.mesReferencia == mesRef) {
                    t.faturaPaga = true;
                    t.paymentId = idPagamento;
                  }
                }
              });
              _salvarDados();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pagamento realizado!")));
            },
            child: const Text("Confirmar"),
          )
        ],
      ),
    );
  }

  void _atualizarRendimento() { /* ... Inalterado, usar código anterior ou lógica simples ... */
    final valorTotalCtrl = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Atualizar Posição"), content: TextField(controller: valorTotalCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: "Saldo Total", prefixText: "R\$ ")), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")), ElevatedButton(onPressed: () { /* simplificado */ Navigator.pop(context); }, child: const Text("Salvar"))]));
  }

  void _iniciarTransferencia() { /* ... Inalterado, usar código anterior ... */
    // Código de transferência simples, omitido para focar na lógica da fatura
  }

  void _ajustarSaldo() {
    final valorRealCtrl = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Ajustar Saldo"), content: TextField(controller: valorRealCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: "Saldo Real", prefixText: "R\$ "), autofocus: true), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")), ElevatedButton(onPressed: () { final novoSaldo = double.tryParse(valorRealCtrl.text.replaceAll(',', '.')); if (novoSaldo != null) { final diff = novoSaldo - _contaSelecionada!.saldo; if (diff != 0) { setState(() { _contaSelecionada!.saldo = novoSaldo; _contaSelecionada!.historico.insert(0, TransacaoModelo(id: DateTime.now().millisecondsSinceEpoch.toString(), titulo: "Ajuste de Saldo", valor: diff.abs(), isEntrada: diff > 0, data: DateTime.now(), categoria: "Ajuste", tipoPagamento: 'D')); }); _salvarDados(); } Navigator.pop(context); } }, child: const Text("Confirmar"))]));
  }

  void _excluirTransacao(TransacaoModelo transacao) {
    setState(() {
      if (transacao.isEntrada) _contaSelecionada!.saldo -= transacao.valor;
      else if (transacao.tipoPagamento == 'D') _contaSelecionada!.saldo += transacao.valor;

      if (transacao.categoria == 'Pagamento Fatura') {
        for (var t in _contaSelecionada!.historico) {
          if (t.paymentId == transacao.id) {
            t.faturaPaga = false;
            t.paymentId = null;
          }
        }
      }
      _contaSelecionada!.historico.removeWhere((t) => t.id == transacao.id);
    });
    _salvarDados();
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_contaSelecionada != null) IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => setState(() { _contaSelecionada = null; _filtrosAtivos = false; _textoBusca = ""; _filtroDataInicio = null; _filtroDataFim = null; })),
                    Expanded(child: Text(_contaSelecionada == null ? "Minhas Contas" : _contaSelecionada!.nome, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                    IconButton(onPressed: _contaSelecionada == null ? () => _adicionarOuEditarConta() : () => _adicionarOuEditarConta(contaExistente: _contaSelecionada), icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(_contaSelecionada == null ? Icons.add : Icons.edit, color: Colors.white, size: 20))),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFF5F7FA), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                  child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _contaSelecionada == null ? _buildListaContas() : _buildDetalheConta()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListaContas() {
    return ListView(
      padding: const EdgeInsets.only(top: 20, bottom: 80),
      children: [
        ModernCard(
          gradient: const [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          child: Column(children: [const Text("Saldo Total", style: TextStyle(color: Colors.white70)), const SizedBox(height: 8), Text("R\$ ${_saldoTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))]),
        ),
        ..._contas.map((conta) => ModernCard(
          onTap: () {
            _verificarRecorrencias(conta);
            setState(() => _contaSelecionada = conta);
          },
          gradient: conta.gradiente,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(children: [
                Icon(conta.icone, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(conta.nome, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    Text(conta.tipoConta == 'INVESTIMENTO' ? "Investimento" : (conta.permiteCredito ? "Fatura Aberta: R\$ ${conta.faturaAbertaTotal.toStringAsFixed(2)}" : "Débito"), style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12), overflow: TextOverflow.ellipsis)
                  ]),
                )
              ]),
            ),
            const SizedBox(width: 8),
            Text("R\$ ${conta.saldo.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
        )).toList(),
      ],
    );
  }

  Widget _buildDetalheConta() {
    final conta = _contaSelecionada!;
    final faturasPendentes = conta.faturasFechadasPendentes;

    final listaFiltrada = conta.historico.where((t) {
      bool passaTexto = true;
      bool passaData = true;

      if (_textoBusca.isNotEmpty) {
        final busca = _textoBusca.toLowerCase();
        passaTexto = t.titulo.toLowerCase().contains(busca) ||
            t.categoria.toLowerCase().contains(busca) ||
            t.valor.toString().contains(busca);
      }

      if (_filtroDataInicio != null && _filtroDataFim != null) {
        final dataT = DateTime(t.data.year, t.data.month, t.data.day);
        final inicio = DateTime(_filtroDataInicio!.year, _filtroDataInicio!.month, _filtroDataInicio!.day);
        final fim = DateTime(_filtroDataFim!.year, _filtroDataFim!.month, _filtroDataFim!.day);
        passaData = (dataT.isAtSameMomentAs(inicio) || dataT.isAfter(inicio)) &&
            (dataT.isAtSameMomentAs(fim) || dataT.isBefore(fim));
      }

      return passaTexto && passaData;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Saldo", style: TextStyle(color: Colors.grey[500], fontSize: 12)), Text("R\$ ${conta.saldo.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey[800], fontSize: 24, fontWeight: FontWeight.bold))]),
                if (conta.permiteCredito)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text("Fatura Aberta (${conta.mesFaturaAbertaPrincipal})", style: TextStyle(color: Colors.blue[800], fontSize: 11, fontWeight: FontWeight.bold)),
                      Text("R\$ ${conta.faturaAbertaTotal.toStringAsFixed(2)}", style: TextStyle(color: Colors.blue[900], fontSize: 18, fontWeight: FontWeight.bold)),
                      if(conta.faturaAbertaTotal > 0)
                        InkWell(
                          onTap: _fecharFaturaManual,
                          child: const Padding(padding: EdgeInsets.only(top:4), child: Text("Fechar Fatura", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))),
                        )
                    ]),
                  ),
              ]),

              // ÁREA DE FATURAS FECHADAS (PENDENTES)
              if (conta.permiteCredito && faturasPendentes.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: faturasPendentes.length,
                    itemBuilder: (ctx, idx) {
                      String mes = faturasPendentes[idx];
                      double val = conta.valorFaturaFechada(mes);
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange)),
                        child: Row(children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text("Fatura $mes", style: TextStyle(fontSize: 10, color: Colors.orange[900], fontWeight: FontWeight.bold)),
                            Text("R\$ ${val.toStringAsFixed(2)}", style: TextStyle(fontSize: 12, color: Colors.orange[900])),
                          ]),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900], foregroundColor: Colors.white, minimumSize: const Size(0, 30), padding: const EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () => _pagarFaturaEspecifica(mes),
                            child: const Text("Pagar", style: TextStyle(fontSize: 10)),
                          )
                        ]),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _botaoAcao(Icons.arrow_downward, "Entrada", Colors.green, () => _abrirDialogoTransacao(isEntrada: true)),
                  const SizedBox(width: 16),
                  _botaoAcao(Icons.swap_horiz, "Transf.", Colors.blue, _iniciarTransferencia),
                  const SizedBox(width: 16),
                  _botaoAcao(Icons.arrow_upward, "Saída", Colors.red, () => _abrirDialogoTransacao(isEntrada: false)),
                  if (conta.tipoConta == 'INVESTIMENTO') ...[
                    const SizedBox(width: 16),
                    _botaoAcao(Icons.trending_up, "Atualizar", Colors.purple, _atualizarRendimento),
                  ] else ...[
                    const SizedBox(width: 16),
                    _botaoAcao(Icons.balance, "Ajustar", Colors.deepPurple, _ajustarSaldo),
                  ]
                ]),
              ),
            ],
          ),
        ),

        // BARRA DE PESQUISA E FILTROS (Mantido igual)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar...",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                  onChanged: (val) => setState(() => _textoBusca = val),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      initialDateRange: (_filtroDataInicio != null && _filtroDataFim != null)
                          ? DateTimeRange(start: _filtroDataInicio!, end: _filtroDataFim!)
                          : null
                  );
                  if (picked != null) {
                    setState(() {
                      _filtroDataInicio = picked.start;
                      _filtroDataFim = picked.end;
                      _filtrosAtivos = true;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _filtrosAtivos ? Colors.indigo : Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                  child: Icon(Icons.filter_list, size: 20, color: _filtrosAtivos ? Colors.white : Colors.grey.shade600),
                ),
              ),
              if (_filtrosAtivos) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => setState(() { _filtrosAtivos = false; _filtroDataInicio = null; _filtroDataFim = null; }),
                  child: const Icon(Icons.close, color: Colors.red, size: 20),
                )
              ]
            ],
          ),
        ),

        Expanded(
          child: listaFiltrada.isEmpty
              ? Center(child: Text("Sem movimentações", style: TextStyle(color: Colors.grey[400])))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listaFiltrada.length,
            itemBuilder: (context, index) {
              final t = listaFiltrada[index];
              return Dismissible(
                key: Key(t.id),
                direction: DismissDirection.endToStart,
                background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), color: Colors.red.shade100, child: const Icon(Icons.delete, color: Colors.red)),
                confirmDismiss: (_) async => await showDialog(context: context, builder: (c) => AlertDialog(title: const Text("Apagar?"), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Não")), TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("Sim"))])),
                onDismissed: (_) => _excluirTransacao(t),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: t.categoria == 'Pagamento Fatura' ? Colors.green.shade50 : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(
                      child: Row(children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: t.isEntrada ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), shape: BoxShape.circle), child: Icon(_getIcon(_categoriasIcones[t.categoria] ?? Icons.help.codePoint), size: 20, color: t.isEntrada ? Colors.green : Colors.red)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                            Row(children: [
                              if (t.isFixa) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.repeat, size: 12, color: Colors.indigo)),
                              Flexible(child: Text(t.categoria, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              // Tag de Status da Fatura
                              if (t.tipoPagamento == 'C')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(color: t.faturaPaga ? Colors.green.shade100 : Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                      t.faturaPaga ? "PAGO" : (conta.faturasFechadas.contains(t.mesReferencia) ? "FECHADA" : "ABERTA"),
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: t.faturaPaga ? Colors.green.shade800 : Colors.orange.shade800)
                                  ),
                                ),
                              Text(t.mesReferencia != null && t.tipoPagamento == 'C' ? "Fatura ${t.mesReferencia}" : "${t.data.day}/${t.data.month}", style: const TextStyle(fontSize: 11, color: Colors.grey))
                            ]),
                          ]),
                        ),
                      ]),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${t.isEntrada ? '+' : '-'} R\$ ${t.valor.toStringAsFixed(2)}", style: TextStyle(color: t.isEntrada ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(width: 8),
                        IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.grey), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: () => _abrirDialogoTransacao(transacaoExistente: t))
                      ],
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _botaoAcao(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Column(children: [Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: color, size: 28)), const SizedBox(height: 6), Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey[700]))]));
  }
}
// Fim da tela 2



// Inicio tela 3

// ==============================================================================
// TELA 3: RELATÓRIOS, PESQUISA AVANÇADA E FATURAS
// ==============================================================================

class Tela3_Relatorios extends StatefulWidget {
  const Tela3_Relatorios({super.key});

  @override
  State<Tela3_Relatorios> createState() => _Tela3_RelatoriosState();
}

class _Tela3_RelatoriosState extends State<Tela3_Relatorios> {
  List<ContaModelo> _contasCarregadas = [];
  bool _carregando = true;

  // Estado de Filtro de Data (Global para Balanço e Faturas)
  DateTime _dataFocada = DateTime.now();
  bool _periodoTotal = false;

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/financeiro_db_geral.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final decoded = jsonDecode(jsonString);
        if (decoded["contas"] != null) {
          setState(() {
            _contasCarregadas = (decoded["contas"] as List)
                .map((e) => ContaModelo.fromJson(e))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados na Tela 3: $e");
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _navegarMes(int meses) {
    setState(() {
      _periodoTotal = false;
      _dataFocada = DateTime(_dataFocada.year, _dataFocada.month + meses, 1);
    });
  }

  String _getTextoPeriodo() {
    if (_periodoTotal) return "Período Completo";
    const meses = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"];
    return "${meses[_dataFocada.month - 1]} ${_dataFocada.year}";
  }

  void _compartilharResumo() {
    double entradas = 0;
    double saidas = 0;
    for (var c in _contasCarregadas) {
      for (var t in c.historico) {
        // Ignora Saldo Inicial no resumo também
        if (t.categoria == 'Saldo Inicial') continue;

        bool dataOk = _periodoTotal || (t.data.month == _dataFocada.month && t.data.year == _dataFocada.year);
        if (dataOk) {
          if (t.isEntrada) entradas += t.valor; else saidas += t.valor;
        }
      }
    }
    final texto = "Resumo Financeiro - ${_getTextoPeriodo()}\nEntradas: R\$ ${entradas.toStringAsFixed(2)}\nSaídas: R\$ ${saidas.toStringAsFixed(2)}\nSaldo: R\$ ${(entradas - saidas).toStringAsFixed(2)}";
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resumo pronto para compartilhar!")));
  }

  IconData _getIcon(String categoria) {
    Map<String, int> padroes = {
      'Mercado': Icons.shopping_cart.codePoint,
      'Lazer': Icons.movie.codePoint,
      'Casa': Icons.home.codePoint,
      'Transporte': Icons.directions_car.codePoint,
      'Saúde': Icons.medical_services.codePoint,
      'Salário': Icons.attach_money.codePoint,
      'Contas Fixas': Icons.calendar_today.codePoint,
      'Rendimento': Icons.trending_up.codePoint,
      'Investimento': Icons.savings.codePoint,
      'Ajuste': Icons.balance.codePoint,
      'Saldo Inicial': Icons.flag.codePoint,
    };
    return IconData(padroes[categoria] ?? Icons.category.codePoint, fontFamily: 'MaterialIcons');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Painel Financeiro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.indigo,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.indigo,
            tabs: [
              Tab(text: "Balanço", icon: Icon(Icons.pie_chart_outline)),
              Tab(text: "Pesquisa", icon: Icon(Icons.filter_alt)),
              Tab(text: "Faturas", icon: Icon(Icons.credit_card)),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.share), onPressed: _compartilharResumo),
            IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarDados)
          ],
        ),
        body: _carregando
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _AbaBalanco(
              contas: _contasCarregadas,
              dataFocada: _dataFocada,
              periodoTotal: _periodoTotal,
              onNavegarMes: _navegarMes,
              onTogglePeriodoTotal: () => setState(() => _periodoTotal = !_periodoTotal),
              textoPeriodo: _getTextoPeriodo(),
              getIcon: _getIcon,
            ),
            _AbaPesquisaAvancada(
              contas: _contasCarregadas,
              getIcon: _getIcon,
            ),
            _AbaFaturas(
              contas: _contasCarregadas,
              dataFocada: _dataFocada,
              periodoTotal: _periodoTotal,
              onNavegarMes: _navegarMes,
              textoPeriodo: _getTextoPeriodo(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================================================
// ABA 1: BALANÇO MENSAL (COM RANKING DE GASTOS)
// ==============================================================================
class _AbaBalanco extends StatelessWidget {
  final List<ContaModelo> contas;
  final DateTime dataFocada;
  final bool periodoTotal;
  final Function(int) onNavegarMes;
  final VoidCallback onTogglePeriodoTotal;
  final String textoPeriodo;
  final Function(String) getIcon;

  const _AbaBalanco({
    required this.contas,
    required this.dataFocada,
    required this.periodoTotal,
    required this.onNavegarMes,
    required this.onTogglePeriodoTotal,
    required this.textoPeriodo,
    required this.getIcon,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Filtrar Transações do Período
    List<TransacaoModelo> transacoesFiltradas = [];
    for (var c in contas) {
      transacoesFiltradas.addAll(c.historico.where((t) {
        // CORREÇÃO: Ignora 'Saldo Inicial' nas listas e cálculos do balanço
        if (t.categoria == 'Saldo Inicial') return false;

        if (periodoTotal) return true;
        return t.data.month == dataFocada.month && t.data.year == dataFocada.year;
      }));
    }
    transacoesFiltradas.sort((a, b) => b.data.compareTo(a.data));

    // 2. Calcular Totais e Ranking
    double entradas = 0;
    double saidas = 0;
    Map<String, double> gastosPorCategoria = {};

    for (var t in transacoesFiltradas) {
      if (t.isEntrada) {
        entradas += t.valor;
      } else {
        saidas += t.valor;
        // Soma para o ranking (apenas saídas, excluindo transferências de investimento e pagamento de faturas)
        if (t.categoria != 'Investimento' && t.categoria != 'Aporte' && t.categoria != 'Pagamento Fatura') {
          gastosPorCategoria[t.categoria] = (gastosPorCategoria[t.categoria] ?? 0) + t.valor;
        }
      }
    }
    final saldo = entradas - saidas;

    // 3. Ordenar Ranking
    var rankingOrdenado = gastosPorCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        // Seletor de Data
        Container(
          color: Colors.indigo.shade50,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.chevron_left, color: Colors.indigo), onPressed: () => onNavegarMes(-1)),
              InkWell(
                onTap: onTogglePeriodoTotal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: periodoTotal ? Colors.indigo : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigo),
                  ),
                  child: Text(textoPeriodo, style: TextStyle(fontWeight: FontWeight.bold, color: periodoTotal ? Colors.white : Colors.indigo)),
                ),
              ),
              IconButton(icon: const Icon(Icons.chevron_right, color: Colors.indigo), onPressed: () => onNavegarMes(1)),
            ],
          ),
        ),

        Expanded(
          child: transacoesFiltradas.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text("Sem dados em $textoPeriodo", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                const SizedBox(height: 8),
                if (!periodoTotal)
                  TextButton(onPressed: onTogglePeriodoTotal, child: const Text("Ver todo o período"))
              ],
            ),
          )
              : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // CARDS DE RESUMO
              Row(
                children: [
                  Expanded(child: _buildCardResumo("Entradas", entradas, Colors.green, Icons.arrow_downward)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCardResumo("Saídas", saidas, Colors.red, Icons.arrow_upward)),
                ],
              ),
              const SizedBox(height: 12),
              _buildCardResumo("Saldo do Período", saldo, saldo >= 0 ? Colors.blue : Colors.deepOrange, Icons.account_balance_wallet, isBig: true),

              // RANKING DE GASTOS
              if (rankingOrdenado.isNotEmpty) ...[
                const SizedBox(height: 30),
                const Text("🏆 Ranking de Despesas", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                  child: Column(
                    children: rankingOrdenado.take(5).map((entry) {
                      double porcentagem = saidas > 0 ? (entry.value / saidas) : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Icon(getIcon(entry.key), size: 16, color: Colors.grey[700]),
                                  const SizedBox(width: 8),
                                  Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                ]),
                                Text("R\$ ${entry.value.toStringAsFixed(2)} (${(porcentagem * 100).toStringAsFixed(0)}%)", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: porcentagem,
                                backgroundColor: Colors.grey.shade100,
                                color: Colors.redAccent.withOpacity(0.7),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              // EXTRATO DETALHADO
              const SizedBox(height: 30),
              Text("Extrato de $textoPeriodo", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              ...transacoesFiltradas.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  leading: CircleAvatar(
                    backgroundColor: t.isEntrada ? Colors.green.shade50 : Colors.red.shade50,
                    child: Icon(getIcon(t.categoria), color: t.isEntrada ? Colors.green : Colors.red, size: 20),
                  ),
                  title: Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("${t.data.day}/${t.data.month} • ${t.categoria}"),
                  trailing: Text(
                      "R\$ ${t.valor.toStringAsFixed(2)}",
                      style: TextStyle(color: t.isEntrada ? Colors.green : Colors.red, fontWeight: FontWeight.bold)
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardResumo(String titulo, double valor, Color cor, IconData icone, {bool isBig = false}) {
    return Container(
      padding: EdgeInsets.all(isBig ? 20 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: cor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: cor, size: isBig ? 24 : 18),
              const SizedBox(width: 8),
              Text(titulo, style: TextStyle(fontSize: isBig ? 16 : 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "R\$ ${valor.toStringAsFixed(2)}",
            style: TextStyle(fontSize: isBig ? 22 : 16, fontWeight: FontWeight.bold, color: cor),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// ABA 2: PESQUISA AVANÇADA (Com Filtros Múltiplos e Calendário)
// ==============================================================================
class _AbaPesquisaAvancada extends StatefulWidget {
  final List<ContaModelo> contas;
  final Function(String) getIcon;

  const _AbaPesquisaAvancada({required this.contas, required this.getIcon});

  @override
  State<_AbaPesquisaAvancada> createState() => _AbaPesquisaAvancadaState();
}

class _AbaPesquisaAvancadaState extends State<_AbaPesquisaAvancada> {
  // Filtros
  String _termo = "";
  Set<String> _filtrosCategorias = {};
  DateTimeRange? _filtroPeriodo;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 1. Coletar dados
    List<TransacaoModelo> todasTransacoes = [];
    Set<String> categoriasDisponiveis = {"Todas"};

    for (var c in widget.contas) {
      todasTransacoes.addAll(c.historico);
      for(var t in c.historico) {
        categoriasDisponiveis.add(t.categoria);
      }
    }

    // 2. Aplicar Filtros (Cascata)
    final resultados = todasTransacoes.where((t) {
      // a) Filtro Texto
      bool termoOk = _termo.isEmpty ||
          t.titulo.toLowerCase().contains(_termo.toLowerCase()) ||
          t.valor.toString().contains(_termo);

      // b) Filtro Tag
      bool catOk = _filtrosCategorias.isEmpty || _filtrosCategorias.contains(t.categoria);

      // c) Filtro Período
      bool dataOk = true;
      if (_filtroPeriodo != null) {
        final dataT = DateTime(t.data.year, t.data.month, t.data.day);
        final inicio = DateTime(_filtroPeriodo!.start.year, _filtroPeriodo!.start.month, _filtroPeriodo!.start.day);
        final fim = DateTime(_filtroPeriodo!.end.year, _filtroPeriodo!.end.month, _filtroPeriodo!.end.day);

        dataOk = (dataT.isAtSameMomentAs(inicio) || dataT.isAfter(inicio)) &&
            (dataT.isAtSameMomentAs(fim) || dataT.isBefore(fim));
      }

      return termoOk && catOk && dataOk;
    }).toList();

    resultados.sort((a, b) => b.data.compareTo(a.data));

    // 3. Calcular Totais do Filtro (IGNORANDO SALDO INICIAL)
    double totalEntradas = 0;
    double totalSaidas = 0;
    for (var t in resultados) {
      if (t.categoria == 'Saldo Inicial') continue; // CORREÇÃO: Não conta no resumo financeiro
      if (t.isEntrada) totalEntradas += t.valor; else totalSaidas += t.valor;
    }
    double saldoFiltrado = totalEntradas - totalSaidas;

    return Column(
      children: [
        // PAINEL DE FILTROS
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Selecione o Período", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              // Botão Calendário Principal
              InkWell(
                onTap: () async {
                  final picked = await showDateRangePicker(
                      context: context, firstDate: DateTime(2020), lastDate: DateTime(2030),
                      initialDateRange: _filtroPeriodo, saveText: "APLICAR",
                      builder: (context, child) => Theme(data: ThemeData.light().copyWith(primaryColor: Colors.indigo, colorScheme: ColorScheme.light(primary: Colors.indigo)), child: child!)
                  );
                  if (picked != null) setState(() => _filtroPeriodo = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _filtroPeriodo != null ? Colors.indigo : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _filtroPeriodo != null ? Colors.indigo : Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month, size: 20, color: _filtroPeriodo != null ? Colors.white : Colors.grey.shade700),
                      const SizedBox(width: 8),
                      Text(
                        _filtroPeriodo == null
                            ? "Toque para selecionar datas"
                            : "${_filtroPeriodo!.start.day}/${_filtroPeriodo!.start.month}/${_filtroPeriodo!.start.year} até ${_filtroPeriodo!.end.day}/${_filtroPeriodo!.end.month}/${_filtroPeriodo!.end.year}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _filtroPeriodo != null ? Colors.white : Colors.grey.shade700),
                      ),
                      if (_filtroPeriodo != null) ...[
                        const SizedBox(width: 8),
                        InkWell(onTap: () => setState(() => _filtroPeriodo = null), child: const Icon(Icons.close, size: 18, color: Colors.white))
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text("Refinar busca (Opcional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),

              // Busca Texto
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: "Nome, comentário ou valor...",
                  prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                  suffixIcon: _termo.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear), onPressed: (){ setState(() { _termo = ""; _searchCtrl.clear(); }); })
                      : null,
                  filled: true, fillColor: Colors.indigo.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
                onChanged: (v) => setState(() => _termo = v),
              ),
              const SizedBox(height: 12),

              // Chips de Categoria
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoriasDisponiveis.map((c) {
                    bool isSelected = c == "Todas" ? _filtrosCategorias.isEmpty : _filtrosCategorias.contains(c);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(c),
                        selected: isSelected,
                        onSelected: (v) => setState(() {
                          if (c == "Todas") {
                            _filtrosCategorias.clear();
                          } else {
                            if (v) _filtrosCategorias.add(c);
                            else _filtrosCategorias.remove(c);
                          }
                        }),
                        selectedColor: Colors.indigo.shade100,
                        checkmarkColor: Colors.indigo,
                        labelStyle: TextStyle(fontSize: 12, color: isSelected ? Colors.indigo : Colors.black87),
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.indigo : Colors.grey.shade300)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // CARD RESUMO DO FILTRO
        if (resultados.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo.shade800, Colors.indigo.shade600]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoResumo("Entrou", totalEntradas, Colors.greenAccent),
                Container(height: 30, width: 1, color: Colors.white24),
                _buildInfoResumo("Saiu", totalSaidas, Colors.redAccent.shade100),
                Container(height: 30, width: 1, color: Colors.white24),
                _buildInfoResumo("Saldo", saldoFiltrado, Colors.white, isBold: true),
              ],
            ),
          ),

        // LISTA DE RESULTADOS
        Expanded(
          child: resultados.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.filter_list_off, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text("Nenhum item encontrado.", style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final t = resultados[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: t.isEntrada ? Colors.green.shade50 : Colors.red.shade50,
                        shape: BoxShape.circle
                    ),
                    child: Icon(widget.getIcon(t.categoria), size: 16, color: t.isEntrada ? Colors.green : Colors.red),
                  ),
                  title: Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${t.categoria} • ${t.data.day}/${t.data.month}/${t.data.year}"),
                  trailing: Text(
                    "R\$ ${t.valor.toStringAsFixed(2)}",
                    style: TextStyle(color: t.isEntrada ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoResumo(String label, double val, Color color, {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white70)),
        const SizedBox(height: 2),
        Text(
            "R\$ ${val.toStringAsFixed(2)}",
            style: TextStyle(color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: isBold ? 16 : 14)
        ),
      ],
    );
  }
}

// ==============================================================================
// ABA 3: FATURAS FECHADAS
// ==============================================================================
class _AbaFaturas extends StatelessWidget {
  final List<ContaModelo> contas;
  final DateTime dataFocada;
  final bool periodoTotal;
  final Function(int) onNavegarMes;
  final String textoPeriodo;

  const _AbaFaturas({required this.contas, required this.dataFocada, required this.periodoTotal, required this.onNavegarMes, required this.textoPeriodo});

  @override
  Widget build(BuildContext context) {
    final contasCredito = contas.where((c) => c.permiteCredito).toList();

    return Column(
      children: [
        Container(
          color: Colors.indigo.shade50, padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.chevron_left, color: Colors.indigo), onPressed: () => onNavegarMes(-1)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.indigo)), child: Text(periodoTotal ? "Todo Histórico" : "Fatura de $textoPeriodo", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
              IconButton(icon: const Icon(Icons.chevron_right, color: Colors.indigo), onPressed: () => onNavegarMes(1)),
            ],
          ),
        ),

        Expanded(
          child: contasCredito.isEmpty
              ? const Center(child: Text("Nenhum cartão de crédito cadastrado."))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contasCredito.length,
            itemBuilder: (context, index) {
              return _buildFaturaCard(contasCredito[index], dataFocada, periodoTotal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFaturaCard(ContaModelo conta, DateTime dataFocada, bool isTotal) {
    final diaFechamento = conta.diaVencimento > 7 ? conta.diaVencimento - 7 : 1;
    double totalFatura = 0;
    List<TransacaoModelo> itensFatura = [];

    for (var t in conta.historico) {
      if (!t.isEntrada && t.tipoPagamento == 'C') {
        DateTime vencimentoTransacao;
        if (t.data.day <= diaFechamento) {
          vencimentoTransacao = DateTime(t.data.year, t.data.month, conta.diaVencimento);
        } else {
          vencimentoTransacao = DateTime(t.data.year, t.data.month + 1, conta.diaVencimento);
        }

        if (isTotal || (vencimentoTransacao.month == dataFocada.month && vencimentoTransacao.year == dataFocada.year)) {
          totalFatura += t.valor;
          itensFatura.add(t);
        }
      }
    }

    if (itensFatura.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.credit_card, color: Colors.deepPurple.shade400),
        ),
        title: Text(conta.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Vence dia ${conta.diaVencimento}"),
        trailing: Text(
          "R\$ ${totalFatura.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        children: itensFatura.map((t) => ListTile(
          dense: true,
          title: Text(t.titulo),
          subtitle: Text("${t.data.day}/${t.data.month} • ${t.categoria}"),
          trailing: Text("R\$ ${t.valor.toStringAsFixed(2)}"),
        )).toList(),
      ),
    );
  }
}
// Fim da tela 3


// Inicio tela 4

// ==============================================================================
// TELA 4: PROJEÇÃO FINANCEIRA E INVESTIMENTOS (CORRIGIDA)
// ==============================================================================

class Tela4_Investimentos extends StatefulWidget {
  const Tela4_Investimentos({super.key});

  @override
  State<Tela4_Investimentos> createState() => _Tela4_InvestimentosState();
}

class _Tela4_InvestimentosState extends State<Tela4_Investimentos> {
  List<ContaModelo> _contas = [];
  bool _carregando = true;

  // Variáveis de Projeção
  double _mediaEntradasVariaveis = 0.0;
  double _mediaSaidasVariaveis = 0.0;
  double _taxaCrescimentoInvestimentos = 0.0; // % médio mensal

  // Parâmetros manuais para simulação (O usuário pode ajustar)
  double _ajusteInflacao = 0.0; // % ao mês (opcional)

  @override
  void initState() {
    super.initState();
    _carregarDadosEAnalizar();
  }

  Future<void> _carregarDadosEAnalizar() async {
    setState(() => _carregando = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/financeiro_db_geral.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final decoded = jsonDecode(jsonString);
        if (decoded["contas"] != null) {
          final lista = (decoded["contas"] as List).map((e) => ContaModelo.fromJson(e)).toList();
          setState(() {
            _contas = lista;
          });
          _calcularMetricasHistoricas();
        }
      }
    } catch (e) {
      debugPrint("Erro Tela 4: $e");
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _calcularMetricasHistoricas() {
    // Analisa os últimos 3 meses para projetar médias
    final agora = DateTime.now();
    int mesesAnalisados = 0;
    double somaEntradasVar = 0;
    double somaSaidasVar = 0;

    // Variáveis para cálculo de rendimento baseado na % blindada
    double somaPercentuaisRegistrados = 0.0;
    int qtdRegistrosPercentual = 0;

    // Fallback antigo (caso não tenha % registrada)
    double somaRendimentosValor = 0;

    // Mapa auxiliar para agrupar por mês
    Map<String, List<TransacaoModelo>> transacoesPorMes = {};

    for (var c in _contas) {
      for (var t in c.historico) {
        // CORREÇÃO CRÍTICA: Ignora Saldo Inicial, Aportes, Ajustes, Transferências, ESPORÁDICOS e PAGAMENTO DE FATURA
        if (t.isFixa ||
            t.categoria == 'Aporte' ||
            t.categoria == 'Investimento' ||
            t.categoria == 'Ajuste' ||
            t.categoria == 'Saldo Inicial' ||
            t.categoria == 'Esporádico' ||
            t.categoria == 'Pagamento Fatura' || // IGNORA O PAGAMENTO DA FATURA (pois as compras já contam)
            // Filtro para transferências manuais (padrão do app)
            t.titulo.startsWith("Envio para ") ||
            t.titulo.startsWith("Recebido de ") ||
            t.titulo.startsWith("Transf. ")) {

          // Se for Rendimento, precisamos analisar mesmo se tiver regra de ignore acima?
          // A regra acima ignora para "Média de Gastos/Ganhos".
          // Para Rendimento, verificamos especificamente a categoria.
          if (t.categoria != 'Rendimento') continue;
        }

        // Considera apenas últimos 90 dias
        if (t.data.isAfter(agora.subtract(const Duration(days: 90)))) {
          String chave = "${t.data.year}-${t.data.month}";
          transacoesPorMes.putIfAbsent(chave, () => []).add(t);
        }
      }
    }

    mesesAnalisados = transacoesPorMes.keys.length;
    if (mesesAnalisados == 0) mesesAnalisados = 1;

    // Calcula médias variáveis e captura rendimentos
    transacoesPorMes.forEach((key, lista) {
      for (var t in lista) {
        if (t.categoria == 'Rendimento') {
          // Lógica Nova: Usa o percentual gravado se existir
          if (t.percentualRendimento != null) {
            somaPercentuaisRegistrados += t.percentualRendimento!;
            qtdRegistrosPercentual++;
          } else {
            // Fallback: soma o valor absoluto
            somaRendimentosValor += t.valor;
          }
        } else if (t.isEntrada) {
          somaEntradasVar += t.valor;
        } else {
          somaSaidasVar += t.valor;
        }
      }
    });

    // CÁLCULO DA TAXA DE CRESCIMENTO
    double taxaMensal = 0.008; // Padrão conservador (0.8%)

    if (qtdRegistrosPercentual > 0) {
      // Prioridade: Média dos percentuais registrados (Blindado)
      taxaMensal = somaPercentuaisRegistrados / qtdRegistrosPercentual;
    } else {
      // Fallback: Cálculo baseado no valor / saldo atual (Antigo)
      double totalInvestidoAtual = _contas
          .where((c) => c.tipoConta == 'INVESTIMENTO')
          .fold(0.0, (sum, c) => sum + c.saldo);

      if (totalInvestidoAtual > 0 && somaRendimentosValor > 0) {
        taxaMensal = (somaRendimentosValor / mesesAnalisados) / totalInvestidoAtual;
      }
    }

    // Trava de segurança para valores absurdos (ex: primeira atualização com 100% de lucro)
    // Limita entre -50% e +50% ao mês para a projeção não quebrar o gráfico
    if (taxaMensal > 0.5) taxaMensal = 0.5;
    if (taxaMensal < -0.5) taxaMensal = -0.5;
    if (taxaMensal == 0) taxaMensal = 0.008; // Volta pro padrão se der zero

    setState(() {
      _mediaEntradasVariaveis = somaEntradasVar / mesesAnalisados;
      _mediaSaidasVariaveis = somaSaidasVar / mesesAnalisados;
      _taxaCrescimentoInvestimentos = taxaMensal;
    });
  }

  // --- MODELO DE PROJEÇÃO ---
  List<Map<String, dynamic>> _gerarProjecao(int mesesFuturos) {
    List<Map<String, dynamic>> projecao = [];

    // Saldos Iniciais
    double saldoCaixa = _contas.where((c) => c.tipoConta == 'BANCO').fold(0.0, (s, c) => s + c.saldo);
    double saldoInvest = _contas.where((c) => c.tipoConta == 'INVESTIMENTO').fold(0.0, (s, c) => s + c.saldo);

    // Coleta todas as contas fixas ativas de todas as contas
    List<ContaFixaModelo> todasFixas = [];
    for (var c in _contas) {
      todasFixas.addAll(c.contasFixas);
    }

    DateTime dataBase = DateTime.now();

    for (int i = 1; i <= mesesFuturos; i++) {
      DateTime mesFuturo = DateTime(dataBase.year, dataBase.month + i, 1);

      // 1. Processar Contas Fixas (Despesas e Aportes)
      double despesasFixasMes = 0;
      double aportesProgramados = 0;

      for (var fixa in todasFixas) {
        if (fixa.idContaOrigem != null) {
          // É um aporte (sai do caixa, vai pro investimento)
          aportesProgramados += fixa.valor;
        } else {
          // É despesa normal
          despesasFixasMes += fixa.valor;
        }
      }

      // 2. Calcular Rendimento
      double rendimentoMes = saldoInvest * _taxaCrescimentoInvestimentos;

      // 3. Atualizar Saldos
      // Caixa: Saldo Anterior + Entradas Variáveis - Despesas Fixas - Despesas Variáveis - Aportes
      double variacaoCaixa = _mediaEntradasVariaveis - despesasFixasMes - _mediaSaidasVariaveis - aportesProgramados;
      saldoCaixa += variacaoCaixa;

      // Investimento: Saldo Anterior + Rendimento + Aportes
      saldoInvest += rendimentoMes + aportesProgramados;

      projecao.add({
        'data': mesFuturo,
        'saldoCaixa': saldoCaixa,
        'saldoInvest': saldoInvest,
        'patrimonioTotal': saldoCaixa + saldoInvest,
        'rendimento': rendimentoMes,
        'aportes': aportesProgramados,
        'despesasFixas': despesasFixasMes,
        'lucroCaixa': variacaoCaixa // Para saber se sobra ou falta dinheiro no mês
      });
    }
    return projecao;
  }

  @override
  Widget build(BuildContext context) {
    final projecao = _gerarProjecao(12);
    final patrimonioAtual = _contas.fold(0.0, (s, c) => s + c.saldo);
    final patrimonioFuturo = projecao.isEmpty ? patrimonioAtual : projecao.last['patrimonioTotal'] as double;
    final crescimentoTotal = patrimonioFuturo - patrimonioAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Projeção Futura", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: _mostrarInfoParametros)
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD RESUMO DO CRESCIMENTO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Patrimônio em 1 Ano", style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text("R\$ ${patrimonioFuturo.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text("+ R\$ ${crescimentoTotal.toStringAsFixed(2)} projetados", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("Evolução Mês a Mês", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
            const SizedBox(height: 16),

            // LISTA DE MESES
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projecao.length,
              itemBuilder: (context, index) {
                final item = projecao[index];
                final data = item['data'] as DateTime;
                final mesStr = "${data.month.toString().padLeft(2, '0')}/${data.year}";
                final lucroCaixa = item['lucroCaixa'] as double;
                final rendimento = item['rendimento'] as double;
                final total = item['patrimonioTotal'] as double;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text(mesStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ),
                    title: Text("R\$ ${total.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        Icon(lucroCaixa >= 0 ? Icons.check_circle : Icons.warning, size: 14, color: lucroCaixa >= 0 ? Colors.green : Colors.red),
                        const SizedBox(width: 4),
                        Text(lucroCaixa >= 0 ? "Caixa Positivo" : "Caixa Negativo!", style: TextStyle(fontSize: 12, color: lucroCaixa >= 0 ? Colors.green : Colors.red)),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // MOSTRAR MÉDIAS USADAS
                            const Text("Base de Cálculo (Médias)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 4),
                            _linhaDetalhe("Entradas Var. Consideradas", _mediaEntradasVariaveis, Colors.green.shade300),
                            _linhaDetalhe("Saídas Var. Consideradas", _mediaSaidasVariaveis, Colors.redAccent.shade100),
                            const Divider(),

                            const Text("Projeção do Mês", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 4),
                            _linhaDetalhe("Saldo em Conta (Caixa)", item['saldoCaixa'], Colors.blueGrey),
                            _linhaDetalhe("Investimentos Acumulados", item['saldoInvest'], Colors.purple),
                            _linhaDetalhe("Rendimento Estimado", rendimento, Colors.green),
                            _linhaDetalhe("Aportes Programados", item['aportes'], Colors.blue),
                            const Divider(),
                            _linhaDetalhe("Contas Fixas Previstas", item['despesasFixas'], Colors.redAccent),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _linhaDetalhe(String label, double valor, Color cor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text("R\$ ${valor.toStringAsFixed(2)}", style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  void _mostrarInfoParametros() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Base de Cálculo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("O app analisou seu histórico recente para projetar o futuro:"),
            const SizedBox(height: 10),
            Text("• Rentabilidade Média: ${(_taxaCrescimentoInvestimentos * 100).toStringAsFixed(2)}% ao mês"),
            Text("• Gastos Variáveis Médios: R\$ ${_mediaSaidasVariaveis.toStringAsFixed(2)}"),
            Text("• Entradas Extras Médias: R\$ ${_mediaEntradasVariaveis.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            const Text("Os cálculos consideram também todas as suas Contas Fixas e Aportes cadastrados na tela de Contas.", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            const Text("Dica: Use a tag 'Esporádico' para que compras únicas não afetem essas médias.", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.orange)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Entendi"))],
      ),
    );
  }
}
// Fim da tela 4

// Inicio tela 5


// ==============================================================================
// TELA 5: PLANEJAMENTO E LIMITES
// ==============================================================================

class Tela5_Pagamentos extends StatefulWidget {
  const Tela5_Pagamentos({super.key});

  @override
  State<Tela5_Pagamentos> createState() => _Tela5_PagamentosState();
}

class _Tela5_PagamentosState extends State<Tela5_Pagamentos> {
  // Controladores
  final TextEditingController _rendaCtrl = TextEditingController();
  // Mapa de controladores para cada categoria (Correção do problema de digitação)
  final Map<String, TextEditingController> _controllersCategoria = {};

  // Estado dos Limites
  double _rendaMensal = 0.0;
  Map<String, double> _limites = {
    'Casa': 0.0,
    'Alimentação': 0.0,
    'Transporte': 0.0,
    'Mensalidades Fixas': 0.0,
    'Educação': 0.0,
    'Lazer': 0.0,
    'Investimento Futuro': 0.0,
    'Guardar para Mim': 0.0,
  };

  // Ícones para cada categoria
  final Map<String, IconData> _iconesCategoria = {
    'Casa': Icons.home,
    'Alimentação': Icons.restaurant,
    'Transporte': Icons.directions_car,
    'Mensalidades Fixas': Icons.receipt_long,
    'Educação': Icons.school,
    'Lazer': Icons.movie,
    'Investimento Futuro': Icons.trending_up,
    'Guardar para Mim': Icons.savings,
  };

  // Cores para categorias (Essenciais vs Estilo de Vida vs Futuro)
  final Map<String, Color> _coresCategoria = {
    'Casa': Colors.orange,
    'Alimentação': Colors.orange,
    'Transporte': Colors.orange,
    'Mensalidades Fixas': Colors.orange,
    'Educação': Colors.blue,
    'Lazer': Colors.blue,
    'Investimento Futuro': Colors.green,
    'Guardar para Mim': Colors.purple,
  };

  bool _carregando = true;

  // --- PERSISTÊNCIA ---
  Future<File> _getArquivoJson() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/config_limites.json');
  }

  Future<void> _salvarDados() async {
    try {
      final file = await _getArquivoJson();
      final data = {
        "rendaMensal": _rendaMensal,
        "limites": _limites,
      };
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint("Erro salvar limites: $e");
    }
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final file = await _getArquivoJson();
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final decoded = jsonDecode(jsonString);

        setState(() {
          _rendaMensal = (decoded["rendaMensal"] as num?)?.toDouble() ?? 0.0;
          // Atualiza texto da renda apenas ao carregar
          _rendaCtrl.text = _rendaMensal > 0 ? _rendaMensal.toStringAsFixed(2) : "";

          if (decoded["limites"] != null) {
            Map<String, dynamic> limitesCarregados = decoded["limites"];
            limitesCarregados.forEach((key, value) {
              if (_limites.containsKey(key)) {
                double val = (value as num).toDouble();
                _limites[key] = val;
                // Atualiza o controlador específico da categoria
                if (_controllersCategoria.containsKey(key)) {
                  _controllersCategoria[key]?.text = val > 0 ? val.toStringAsFixed(2) : "";
                }
              }
            });
          }
        });
      }
    } catch (e) {
      debugPrint("Erro carregar limites: $e");
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializa um controlador para cada categoria existente
    for (var cat in _limites.keys) {
      _controllersCategoria[cat] = TextEditingController();
    }
    _carregarDados();
  }

  @override
  void dispose() {
    _rendaCtrl.dispose();
    // Limpa todos os controladores criados
    for (var c in _controllersCategoria.values) {
      c.dispose();
    }
    super.dispose();
  }

  // --- LÓGICA DE CÁLCULO ---

  void _atualizarRenda(String valor) {
    // Permite digitar livremente, parseia apenas para cálculo
    double novaRenda = double.tryParse(valor.replaceAll(',', '.')) ?? 0.0;
    setState(() {
      _rendaMensal = novaRenda;
    });
    _salvarDados();
  }

  void _atualizarLimite(String categoria, String valorStr) {
    // Permite digitar livremente (ex: "50", "50.", "50.5")
    double valor = double.tryParse(valorStr.replaceAll(',', '.')) ?? 0.0;
    setState(() {
      _limites[categoria] = valor;
    });
    _salvarDados();
  }

  // Método Mágico: Aplica a regra 50-30-20
  void _aplicarMetodo503020() {
    if (_rendaMensal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Defina sua renda mensal primeiro!")));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Aplicar Método 50-30-20?"),
        content: const Text(
            "Isso vai redefinir seus limites para:\n\n"
                "🏠 50% Essenciais (Casa, Comida, Contas)\n"
                "🎉 30% Estilo de Vida (Lazer, Educação)\n"
                "💰 20% Futuro (Investimentos, Reserva)\n\n"
                "Deseja continuar?"
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Essenciais (50%)
                double essencial = _rendaMensal * 0.50;
                // Divide igual entre as 4 categorias essenciais
                _limites['Casa'] = essencial * 0.4;
                _limites['Alimentação'] = essencial * 0.3;
                _limites['Mensalidades Fixas'] = essencial * 0.2;
                _limites['Transporte'] = essencial * 0.1;

                // Estilo de Vida (30%)
                double estilo = _rendaMensal * 0.30;
                _limites['Lazer'] = estilo * 0.6;
                _limites['Educação'] = estilo * 0.4;

                // Futuro (20%)
                double futuro = _rendaMensal * 0.20;
                _limites['Investimento Futuro'] = futuro * 0.7;
                _limites['Guardar para Mim'] = futuro * 0.3;

                // Atualiza os textos dos controladores para refletir os novos valores calculados
                _limites.forEach((key, val) {
                  _controllersCategoria[key]?.text = val.toStringAsFixed(2);
                });
              });
              _salvarDados();
              Navigator.pop(ctx);
            },
            child: const Text("Aplicar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAlocado = _limites.values.fold(0, (sum, val) => sum + val);
    double restante = _rendaMensal - totalAlocado;
    double percentualComprometido = _rendaMensal > 0 ? (totalAlocado / _rendaMensal) : 0.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Fecha teclado ao tocar fora
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Planejamento & Limites", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_fix_high),
              onPressed: _aplicarMetodo503020,
              tooltip: "Sugestão Automática (50-30-20)",
            )
          ],
        ),
        body: _carregando
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // --- CABEÇALHO DE RENDA ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  const Text("Qual é sua renda mensal base?", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _rendaCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
                    decoration: const InputDecoration(
                      prefixText: "R\$ ",
                      border: InputBorder.none,
                      hintText: "0,00",
                    ),
                    onChanged: _atualizarRenda,
                  ),
                  const SizedBox(height: 16),
                  // Barra de Progresso Geral
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentualComprometido > 1 ? 1 : percentualComprometido,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      color: percentualComprometido > 1 ? Colors.red : (percentualComprometido >= 1 ? Colors.green : Colors.indigoAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Alocado: ${(percentualComprometido * 100).toStringAsFixed(1)}%", style: TextStyle(fontWeight: FontWeight.bold, color: percentualComprometido > 1 ? Colors.red : Colors.grey.shade700)),
                      Text(
                        restante >= 0 ? "Livre: R\$ ${restante.toStringAsFixed(2)}" : "Excesso: R\$ ${restante.abs().toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: restante >= 0 ? Colors.green : Colors.red),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // --- LISTA DE CATEGORIAS ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text("Distribua sua renda:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  ..._limites.keys.map((categoria) {
                    return _buildItemLimite(categoria);
                  }).toList(),
                  const SizedBox(height: 40), // Espaço final
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemLimite(String categoria) {
    double valorAtual = _limites[categoria] ?? 0.0;
    double porcentagem = _rendaMensal > 0 ? (valorAtual / _rendaMensal) : 0.0;
    Color corTema = _coresCategoria[categoria] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: corTema.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(_iconesCategoria[categoria], color: corTema, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(categoria, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              // Percentual Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  "${(porcentagem * 100).toStringAsFixed(1)}%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: corTema),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    prefixText: "R\$ ",
                    hintText: "0,00",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: corTema)),
                  ),
                  // Usa o controlador persistente em vez de criar um novo a cada build
                  controller: _controllersCategoria[categoria],
                  onChanged: (val) => _atualizarLimite(categoria, val),
                ),
              ),
            ],
          ),
          if (porcentagem > 0) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: porcentagem,
                backgroundColor: Colors.grey.shade100,
                color: corTema.withOpacity(0.6),
                minHeight: 4,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
// Fim da tela 5

// Inicio tela 6
class Tela6_Transferencias extends StatelessWidget {
  const Tela6_Transferencias({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTelaComGradiente(
      titulo: "Transferências",
      gradiente: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
      abas: const ["Nova", "Contatos", "Favoritos", "Agendadas", "Comprovantes"],
    );
  }
}
// Fim da tela 6

// Inicio tela 7
class Tela7_Objetivos extends StatelessWidget {
  const Tela7_Objetivos({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTelaComGradiente(
      titulo: "Objetivos",
      gradiente: const [Color(0xFFfa709a), Color(0xFFfee140)],
      abas: const ["Ativos", "Criar", "Concluídos", "Simulador", "Dicas"],
    );
  }
}
// Fim da tela 7

// Inicio tela 8
class Tela8_Relatorios extends StatelessWidget {
  const Tela8_Relatorios({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTelaComGradiente(
      titulo: "Relatórios",
      gradiente: const [Color(0xFF3f2b96), Color(0xFFa8c0ff)],
      abas: const ["Mensal", "Categorias", "Anual", "Exportar", "Comparativo"],
    );
  }
}
// Fim da tela 8

// Inicio tela 9
class Tela9_Configuracoes extends StatelessWidget {
  const Tela9_Configuracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTelaComGradiente(
      titulo: "Configurações",
      gradiente: const [Color(0xFF434343), Color(0xFF000000)],
      abas: const ["Perfil", "Segurança", "Notificações", "Aparência", "Conta"],
    );
  }
}
// Fim da tela 9

// Inicio tela 10
class Tela10_Ajuda extends StatelessWidget {
  const Tela10_Ajuda({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTelaComGradiente(
      titulo: "Ajuda e Suporte",
      gradiente: const [Color(0xFF00c6ff), Color(0xFF0072ff)],
      abas: const ["Chat", "FAQ", "Telefones", "Tutoriais", "Sobre"],
    );
  }
}
// Fim da tela 10

// Função Helper para Criar Telas com Padrão Visual
Widget _buildTelaComGradiente({
  required String titulo,
  required List<Color> gradiente,
  required List<String> abas,
}) {
  return DefaultTabController(
    length: abas.length,
    child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradiente,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  indicator: const BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  dividerColor: Colors.transparent,
                  tabs: abas.map((aba) => Tab(text: aba)).toList(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: TabBarView(
                    children: abas.map((aba) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.construction_rounded,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Conteúdo: $aba",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}