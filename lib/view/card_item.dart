import 'package:flutter/material.dart';
import 'package:lab1/generated/l10n.dart';
import '../model/card_data.dart';
import 'detail_screen.dart';

class CardItem extends StatelessWidget {
  final CardData card;
  final VoidCallback onLikePressed;
  final bool isLiked;

  const CardItem({
    super.key,
    required this.card,
    required this.onLikePressed,
    required this.isLiked,
  });

  String _display(String? v) => (v != null && v.isNotEmpty) ? v : '—';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(card: card)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              // Изображение персонажа (если есть)
              if (card.image != null)
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(card.image!),
                )
              else
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFEDE7F6),
                  child: Icon(Icons.person, color: Colors.deepPurple),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('${S.of(context).house}: ${_display(card.house)}'),
                    Text('${S.of(context).gender}: ${_display(card.gender)}'),
                    Text('${S.of(context).hair_color}: ${_display(card.hairColor)}'),
                    Text('${S.of(context).height}: ${_display(card.height)}'),

                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onLikePressed,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(isLiked),
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
