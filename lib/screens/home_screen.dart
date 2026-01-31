import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/contacts_provider.dart';
import '../widgets/contact_card.dart';
import '../widgets/contact_form_sheet.dart';
import '../widgets/route_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactsProvider>().contacts;
    final hasContacts = contacts.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(42),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 16,
                    top: 12,
                    child: RouteLogo(width: 90),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: hasContacts
                          ? GridView.builder(
                              key: const ValueKey('grid'),
                              padding: const EdgeInsets.only(bottom: 90),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 14,
                                    crossAxisSpacing: 14,
                                    childAspectRatio: 0.63,
                                  ),
                              itemCount: contacts.length,
                              itemBuilder: (context, index) {
                                final c = contacts[index];
                                return ContactCard(
                                  contact: c,
                                  onDelete: () => context
                                      .read<ContactsProvider>()
                                      .deleteContact(c.id),
                                );
                              },
                            )
                          : const _EmptyState(key: ValueKey('empty')),
                    ),
                  ),

                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasContacts) ...[
                          FloatingActionButton(
                            heroTag: 'clear',
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
                            onPressed: () => _confirmClearAll(context),
                            child: const Icon(Icons.delete_outline),
                          ),
                          const SizedBox(height: 12),
                        ],
                        FloatingActionButton(
                          heroTag: 'add',
                          backgroundColor: AppColors.cardBackground,
                          foregroundColor: Colors.black,
                          onPressed: () => ContactFormSheet.show(context),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _confirmClearAll(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.darkBlue,
          title: const Text(
            'Delete all contacts?',
            style: TextStyle(color: AppColors.lightBlue),
          ),
          content: const Text(
            'This cannot be undone.',
            style: TextStyle(color: AppColors.lightBlue),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldClear == true && context.mounted) {
      context.read<ContactsProvider>().clearAll();
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/list-purple.png', width: 150),
          const SizedBox(height: 18),
          const Text(
            'There is No Contacts Added Here',
            style: TextStyle(
              color: AppColors.lightBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
