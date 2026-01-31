import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/contact.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact, required this.onDelete});

  final Contact contact;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: Image(image: contact.imageProvider, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE1C9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.email_outlined, text: contact.email),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.call_outlined, text: contact.phone),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
