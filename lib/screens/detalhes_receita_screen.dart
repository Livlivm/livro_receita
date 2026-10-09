import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../theme/app_theme.dart';
import 'nova_receita_screen.dart';

class DetalhesReceitaScreen extends StatefulWidget {
  final Receita receita;
  final bool favorita;
  final VoidCallback onFavoritar;
  final Future<void> Function() onExcluir;

  const DetalhesReceitaScreen({
    super.key,
    required this.receita,
    required this.favorita,
    required this.onFavoritar,
    required this.onExcluir,
  });

  @override
  State<DetalhesReceitaScreen> createState() => _DetalhesReceitaScreenState();
}

class _DetalhesReceitaScreenState extends State<DetalhesReceitaScreen> {
  late bool favorita;

  @override
  void initState() {
    super.initState();
    favorita = widget.favorita;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.receita;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da receita',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Favoritar',
            onPressed: () {
              widget.onFavoritar();
              setState(() => favorita = !favorita);
            },
            icon: Icon(
              favorita ? Icons.favorite : Icons.favorite_border,
              color: favorita ? Colors.red : AppTheme.laranjaEscuro,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (opcao) async {
              if (opcao == 'editar') {
                final resultado = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NovaReceitaScreen(receita: r),
                  ),
                );

                if (resultado == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              }

              if (opcao == 'excluir') {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Excluir receita?'),
                    content: const Text(
                      'Deseja realmente excluir esta receita?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Excluir'),
                      ),
                    ],
                  ),
                );

                if (confirmar == true) {
                  try {
                    await widget.onExcluir();

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar receita')),
              PopupMenuItem(value: 'excluir', child: Text('Excluir receita')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: r.img.isNotEmpty
                ? Image.network(
                    r.img,
                    height: 235,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagemPadrao(),
                  )
                : _imagemPadrao(),
          ),
          const SizedBox(height: 20),
          Text(
            r.tipo.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.laranjaEscuro,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            r.nome,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppTheme.marrom,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            r.custoAproximado > 0
                ? 'Custo aproximado: R\$ ${r.custoAproximado.toStringAsFixed(2)}'
                : 'Custo não informado',
            style: const TextStyle(color: Color(0xFF92745D)),
          ),
          const SizedBox(height: 22),
          _secao(
            'Ingredientes',
            Icons.shopping_basket_outlined,
            r.ingredientes,
          ),
          const SizedBox(height: 15),
          _secao('Modo de preparo', Icons.soup_kitchen_outlined, r.modoFazer),
        ],
      ),
    );
  }

  Widget _imagemPadrao() {
    return Container(
      height: 235,
      width: double.infinity,
      color: const Color(0xFFFFEBCB),
      child: const Icon(
        Icons.restaurant,
        size: 75,
        color: AppTheme.laranjaEscuro,
      ),
    );
  }

  Widget _secao(String titulo, IconData icone, String conteudo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1E1CF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: AppTheme.laranjaEscuro),
              const SizedBox(width: 10),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.marrom,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            conteudo.isEmpty ? 'Não informado.' : conteudo,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xFF79563C),
            ),
          ),
        ],
      ),
    );
  }
}
