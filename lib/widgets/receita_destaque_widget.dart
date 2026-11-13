import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../theme/app_theme.dart';

class ReceitaDestaqueWidget extends StatelessWidget {
  final Receita receita;
  final VoidCallback onTap;

  const ReceitaDestaqueWidget({
    super.key,
    required this.receita,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC46B), Color(0xFFFFD09B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: AppTheme.marrom),
                    SizedBox(width: 8),
                    Text(
                      'RECEITA EM DESTAQUE',
                      style: TextStyle(
                        color: AppTheme.marrom,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: receita.img.trim().isNotEmpty
                          ? Image.network(
                              receita.img,
                              width: 112,
                              height: 125,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _imagemPadrao();
                              },
                            )
                          : _imagemPadrao(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              receita.tipo.toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.marrom,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            receita.nome,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.marrom,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            receita.ingredientes,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.marrom,
                              fontSize: 12,
                            ),
                          ),
                          if (receita.custoAproximado > 0) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Custo: R\$ ${receita.custoAproximado.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.marrom,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ver receita completa',
                      style: TextStyle(
                        color: AppTheme.marrom,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppTheme.marrom,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagemPadrao() {
    return Container(
      width: 112,
      height: 125,
      color: Colors.white.withValues(alpha: 0.5),
      child: const Icon(
        Icons.restaurant_rounded,
        size: 42,
        color: AppTheme.marrom,
      ),
    );
  }
}
