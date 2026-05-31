import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _Divider('left')),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(title),
        ),

        const Expanded(child: _Divider('right')),
      ]
    );
  }
}



class _Divider extends StatelessWidget {
  const _Divider(this.side);
  final String side;

  @override
  Widget build(BuildContext context) {
    final colors = side == "left"
    ? [Colors.black.withAlpha(0), Colors.black.withAlpha(100)]
    : [Colors.black.withAlpha(100), Colors.black.withAlpha(0)];

    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors
        )
      )
    );
  }
}
