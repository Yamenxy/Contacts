import 'package:flutter/foundation.dart';

import '../models/contact.dart';

class ContactsProvider extends ChangeNotifier {
  final List<Contact> _contacts = [];

  List<Contact> get contacts => List.unmodifiable(_contacts);

  /// Checks if a contact with the same email or phone already exists.
  /// Returns an error message if a duplicate is found, null otherwise.
  String? getDuplicateError(String email, String phone) {
    final existingContact = _contacts.firstWhere(
      (c) => c.email == email || c.phone == phone,
      orElse: () => const Contact(
        id: '',
        name: '',
        email: '',
        phone: '',
        imagePath: '',
        imageSource: ContactImageSource.asset,
      ),
    );

    if (existingContact.id.isEmpty) {
      return null; // No duplicate found
    }

    // Determine which field caused the duplicate
    if (existingContact.email == email && existingContact.phone == phone) {
      return 'A contact with this email and phone already exists!';
    } else if (existingContact.email == email) {
      return 'A contact with this email already exists!';
    } else {
      return 'A contact with this phone already exists!';
    }
  }

  void addContact(Contact contact) {
    _contacts.insert(0, contact);
    notifyListeners();
  }

  void deleteContact(String id) {
    _contacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void clearAll() {
    _contacts.clear();
    notifyListeners();
  }
}
