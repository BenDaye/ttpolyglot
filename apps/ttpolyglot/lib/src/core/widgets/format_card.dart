import 'package:flutter/material.dart';

/// 格式卡片组件
class FormatCard extends StatelessWidget {
  const FormatCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.onTap,
    this.trailing,
    this.color,
  });

  final String name;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    icon,
                    size: 20.0,
                    color: color ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          description,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8.0),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
