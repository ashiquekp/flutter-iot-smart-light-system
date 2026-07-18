import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final int? divisions;
  final String? label;

  const CustomSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
        thumbColor: theme.colorScheme.primary,
        overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        trackShape: const RoundedRectSliderTrackShape(),
        trackHeight: 6,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: onChanged,
      ),
    );
  }
}