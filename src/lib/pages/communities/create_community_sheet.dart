import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';

class CreateCommunitySheet extends StatefulWidget {
  const CreateCommunitySheet({super.key, this.embedMode = false});

  final bool embedMode;

  @override
  State<CreateCommunitySheet> createState() => _CreateCommunitySheetState();
}

class _CreateCommunitySheetState extends State<CreateCommunitySheet> {
  final _imageUrlCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _createCommunity() async {
    if (_nameCtrl.text.trim().isEmpty || _locationCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and location are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('communities').insert({
        'image': _imageUrlCtrl.text.trim(),
        'name': _nameCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'created_on': DateTime.now().toIso8601String(),
        'members': <String>[],
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_imageUrl != null && _imageUrl!.isNotEmpty)
          Container(
            width: 250,
            height: 100,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image, size: 50)),
                loadingBuilder:
                    (_, child, prog) =>
                        prog == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

        // ───────────── FIELDS ─────────────
        _buildField(_nameCtrl, 'Name *'),
        const SizedBox(height: 14),
        _buildField(
          _imageUrlCtrl,
          'Image URL',
          onChanged: (val) => setState(() => _imageUrl = val),
        ),
        const SizedBox(height: 14),
        _buildField(_locationCtrl, 'Location *'),

        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _createCommunity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Create'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController c,
    String label, {
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          textInputAction: TextInputAction.next,
          decoration: _decoration(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  InputDecoration _decoration() => InputDecoration(
    filled: true,
    fillColor: AppColors.background(context),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary(context), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  @override
  void dispose() {
    _imageUrlCtrl.dispose();
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedMode) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: _content(),
      );
    }

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: FractionallySizedBox(
        heightFactor: .82,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Material(
              color: AppColors.background(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      'New Community',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _content(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
