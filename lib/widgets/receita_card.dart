import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../theme/app_theme.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback onTap;

  const ReceitaCard({super.key, required this.receita, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: AppTheme.marrom.withValues(alpha: 0.12),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                receita.img.trim().isNotEmpty
                    ? Image.network(
                        receita.img,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagemPadrao();
                        },
                      )
                    : _imagemPadrao(),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.laranjaEscuro,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      receita.tipo.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receita.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.marrom,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    receita.ingredientes,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.marrom.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Ver receita',
                        style: TextStyle(
                          color: AppTheme.laranjaEscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppTheme.laranjaEscuro,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagemPadrao() {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFFFFE8C7),
      child: const Icon(
        Icons.restaurant_rounded,
        size: 55,
        color: AppTheme.marrom,
      ),
    );
  }
}
