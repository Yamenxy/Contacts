import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';
import '../utils/validators.dart';

class ContactFormSheet extends StatefulWidget {
  const ContactFormSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ContactFormSheet(),
    );
  }

  @override
  State<ContactFormSheet> createState() => _ContactFormSheetState();
}

class _ContactFormSheetState extends State<ContactFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  ContactImageSource _imageSource = ContactImageSource.asset;
  String _imagePath = 'assets/Person_1.png';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() {
      _imageSource = ContactImageSource.file;
      _imagePath = picked.path;
    });
  }

  void _selectAssetImage(String assetPath) {
    setState(() {
      _imageSource = ContactImageSource.asset;
      _imagePath = assetPath;
    });
  }

  void _showAssetImagePicker() {
    final assetImages = [
      'assets/Person_1.png',
      'assets/Person_2.png',
      'assets/Person_3.png',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Profile Image',
              style: TextStyle(
                color: AppColors.lightBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: assetImages.length,
              itemBuilder: (ctx, index) {
                final assetPath = assetImages[index];
                final isSelected = _imagePath == assetPath;

                return GestureDetector(
                  onTap: () {
                    _selectAssetImage(assetPath);
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.cardBackground
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<ContactsProvider>();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    // Check for duplicates
    final duplicateError = provider.getDuplicateError(email, phone);
    if (duplicateError != null) {
      _showErrorDialog(context, duplicateError);
      return;
    }

    final contact = Contact(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: email,
      phone: phone,
      imagePath: _imagePath,
      imageSource: _imageSource,
    );

    provider.addContact(contact);
    Navigator.of(context).pop();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: const Text(
          'Duplicate Contact',
          style: TextStyle(color: AppColors.lightBlue),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.lightBlue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.cardBackground),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final previewName = _nameController.text.trim().isEmpty
        ? 'User Name'
        : _nameController.text.trim();
    final previewEmail = _emailController.text.trim().isEmpty
        ? 'example@email.com'
        : _emailController.text.trim();
    final previewPhone = _phoneController.text.trim().isEmpty
        ? '+200000000000'
        : _phoneController.text.trim();

    final imageProvider = _imageSource == ContactImageSource.asset
        ? AssetImage(_imagePath)
        : (kIsWeb
              ? const AssetImage('assets/Person_1.png')
              : FileImage(File(_imagePath)) as ImageProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Preview card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF32445C),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundImage: imageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Material(
                              color: AppColors.cardBackground,
                              shape: const CircleBorder(),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.black87,
                                ),
                                onPressed: _pickImage,
                                tooltip: 'Pick Image',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              previewName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.lightBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              previewEmail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.lightBlue,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              previewPhone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.lightBlue,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter User Name',
                        ),
                        validator: (v) => Validators.requiredText(
                          v,
                          message: 'Name is required',
                        ),
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter User Email',
                        ),
                        validator: Validators.email,
                        onChanged: (_) => setState(() {}),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Enter User Phone',
                        ),
                        validator: Validators.phone,
                        onChanged: (_) => setState(() {}),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 14),
                      // Image selection buttons
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _showAssetImagePicker,
                              icon: const Icon(Icons.photo_library),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF32445C),
                                foregroundColor: AppColors.lightBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              label: const Text(
                                'Assets',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.image_outlined),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF32445C),
                                foregroundColor: AppColors.lightBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              label: const Text(
                                'Gallery',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.cardBackground,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Enter user',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
