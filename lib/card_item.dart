import 'package:flutter/material.dart';
import 'card_data.dart';

class CardItemWidget extends StatefulWidget {
  final CardData data;
  final VoidCallback onLikeToggle; // Обработчик события лайка

  const CardItemWidget({
    super.key,
    required this.data,
    required this.onLikeToggle,
  });


  @override
  State<CardItemWidget> createState() => _CardItemWidgetState();
}

class _CardItemWidgetState extends State<CardItemWidget>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // проигрываем короткую анимацию "пульсации"
    _controller.forward(from: 0.0);

    // выводим уведомление Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLiked
              ? 'Вы поставили ❤️ карточке "${widget.data.title}"'
              : 'Вы убрали лайк с карточки "${widget.data.title}"',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // вызываем пользовательский обработчик (по ТЗ)
    widget.onLikeToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              widget.data.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.data.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.data.subtitle,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: IconButton(
                iconSize: 32,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleLike,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
