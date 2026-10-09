import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../services/receita_service.dart';
import '../theme/app_theme.dart';

class NovaReceitaScreen extends StatefulWidget {
  final Receita? receita;

  const NovaReceitaScreen({super.key, this.receita});

  @override
  State<NovaReceitaScreen> createState() => _NovaReceitaScreenState();
}

class _NovaReceitaScreenState extends State<NovaReceitaScreen> {
  final chave = GlobalKey<FormState>();
  final nome = TextEditingController();
  final ingredientes = TextEditingController();
  final modo = TextEditingController();
  final imagem = TextEditingController();
  final custo = TextEditingController();

  final service = ReceitaService();

  String tipo = 'SALGADA';
  bool salvando = false;

  bool get editando => widget.receita != null;

  @override
  void initState() {
    super.initState();

    final r = widget.receita;

    if (r != null) {
      nome.text = r.nome;
      ingredientes.text = r.ingredientes;
      modo.text = r.modoFazer;
      imagem.text = r.img;
      custo.text = r.custoAproximado == 0 ? '' : r.custoAproximado.toString();

      if (['DOCE', 'SALGADA', 'BEBIDA'].contains(r.tipo.toUpperCase())) {
        tipo = r.tipo.toUpperCase();
      }
    }
  }

  @override
  void dispose() {
    nome.dispose();
    ingredientes.dispose();
    modo.dispose();
    imagem.dispose();
    custo.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (!chave.currentState!.validate()) return;

    setState(() => salvando = true);

    final receita = Receita(
      id: widget.receita?.id,
      nome: nome.text.trim(),
      tipo: tipo,
      ingredientes: ingredientes.text.trim(),
      modoFazer: modo.text.trim(),
      img: imagem.text.trim(),
      custoAproximado:
          double.tryParse(custo.text.trim().replaceAll(',', '.')) ?? 0,
    );

    try {
      if (editando) {
        await service.atualizar(receita);
      } else {
        await service.criar(receita);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editando ? 'Receita atualizada!' : 'Receita cadastrada!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar receita' : 'Nova receita',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Form(
        key: chave,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.amarelo,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 42,
                    color: AppTheme.laranjaEscuro,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guarde uma delícia!',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.marrom,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Preencha os dados da sua receita.',
                          style: TextStyle(color: AppTheme.marrom),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _rotulo('Nome da receita'),
            TextFormField(
              controller: nome,
              decoration: const InputDecoration(
                hintText: 'Ex.: Bolo de cenoura',
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Informe o nome da receita.'
                  : null,
            ),

            const SizedBox(height: 16),
            _rotulo('Tipo da receita'),
            DropdownButtonFormField<String>(
              value: tipo,
              decoration: const InputDecoration(),
              items: const [
                DropdownMenuItem(value: 'DOCE', child: Text('Doce')),
                DropdownMenuItem(value: 'SALGADA', child: Text('Salgada')),
                DropdownMenuItem(value: 'BEBIDA', child: Text('Bebida')),
              ],
              onChanged: (v) {
                setState(() => tipo = v ?? 'SALGADA');
              },
            ),

            const SizedBox(height: 16),
            _rotulo('Ingredientes'),
            TextFormField(
              controller: ingredientes,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Escreva os ingredientes...',
                alignLabelWithHint: true,
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Informe os ingredientes.'
                  : null,
            ),

            const SizedBox(height: 16),
            _rotulo('Modo de preparo'),
            TextFormField(
              controller: modo,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Descreva o passo a passo...',
                alignLabelWithHint: true,
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Informe o modo de preparo.'
                  : null,
            ),

            const SizedBox(height: 16),
            _rotulo('URL da imagem (opcional)'),
            TextFormField(
              controller: imagem,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(hintText: 'https://...'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return null;
                }

                final uri = Uri.tryParse(v.trim());

                if (uri == null ||
                    !uri.hasScheme ||
                    !['http', 'https'].contains(uri.scheme)) {
                  return 'Digite uma URL válida.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),
            _rotulo('Custo aproximado (opcional)'),
            TextFormField(
              controller: custo,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: 'R\$ ',
                hintText: '0,00',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return null;
                }

                if (double.tryParse(v.trim().replaceAll(',', '.')) == null) {
                  return 'Digite um valor válido.';
                }

                return null;
              },
            ),

            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: salvando ? null : salvar,
                icon: salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  salvando
                      ? 'Salvando...'
                      : editando
                      ? 'Salvar alterações'
                      : 'Cadastrar receita',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppTheme.marrom,
        ),
      ),
    );
  }
}
