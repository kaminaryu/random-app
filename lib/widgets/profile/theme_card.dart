import 'package:flutter/material.dart';
import 'package:i_bazaar/services/theme_mode_handler.dart';


class ThemeCard extends StatefulWidget {
  const ThemeCard(this.theme, {super.key});

  final ThemeData theme;

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeModeHandler.themeModeNotifier,
      builder: (context, savedThemeMode, child) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Theme', style: widget.theme.textTheme.titleSmall),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _themeButton(
                      "light",
                      Icons.light_mode,
                      widget.theme,
                      savedThemeMode,
                    )),
                    const SizedBox(width: 8),

                    Expanded(child: _themeButton(
                      "dark",
                      Icons.dark_mode,
                      widget.theme,
                      savedThemeMode,
                    )),
                    const SizedBox(width: 8),

                    Expanded(child: _themeButton(
                      "system",
                      Icons.settings_brightness,
                      widget.theme,
                      savedThemeMode,
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}



Widget _themeButton(String themeMode, IconData icon, ThemeData theme, String savedThemeMode) {
  final selected = savedThemeMode == themeMode;

  return Material(
    color: selected
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => ThemeModeHandler.setAppTheme(themeMode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Icon(
          icon,
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withAlpha(128),
        ),
      ),
    ),
  );
}
