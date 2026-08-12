import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/services/activity_service.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity_category.dart';

class CreateActivitySheet extends StatefulWidget {
  const CreateActivitySheet({
    super.key,
    this.embedMode = false,
    this.onPageMove,
  });

  final bool embedMode;
  final ValueChanged<int>? onPageMove;

  @override
  State<CreateActivitySheet> createState() => _CreateActivitySheetState();
}

class _CreateActivitySheetState extends State<CreateActivitySheet>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _communityController = TextEditingController();
  final _imageController = TextEditingController();

  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());

  final PageController _pageController = PageController();
  int _currentPage = 0;

  DateTime _selectedDate = DateTime.now();
  String? _imageUrl;
  bool _isLoading = false;
  String? _communityName;
  ActivityCategory? _selectedCategory;

  late final AnimationController _toastController;
  late final Animation<Offset> _toastAnimation;
  OverlayEntry? _toastOverlay;

  @override
  void initState() {
    super.initState();
    _loadCommunity();

    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _toastAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _toastController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    _communityController.dispose();
    _imageController.dispose();
    _pageController.dispose();
    _toastController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunity() async {
    final prefs = await SharedPreferences.getInstance();
    final community = prefs.getString('community') ?? '';
    _communityController.text = community;
  }

  void _hideToast() {
    if (_toastOverlay == null) return;

    _toastController.reverse().whenComplete(() {
      _toastOverlay?.remove();
      _toastOverlay = null;
    });
  }

  void _showToast({
    required bool success,
    String? message,
    VoidCallback? onUndo,
  }) {
    _hideToast();

    _toastOverlay = OverlayEntry(
      builder:
          (ctx) => Positioned(
            top: MediaQuery.of(ctx).padding.top + 16,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _toastAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: success ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message ?? (success ? 'Success!' : 'Error occurred'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (onUndo != null)
                      TextButton(
                        onPressed: onUndo,
                        child: const Text(
                          'Undo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_toastOverlay!);
    _toastController.forward();

    Future.delayed(const Duration(seconds: 3), _hideToast);
  }

  Future<bool> _validateCommunity(String communityId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');

      if (username == null || username.isEmpty) {
        Navigator.of(context).pop('Username not found. Please log in again.');
        return false;
      }

      final response =
          await Supabase.instance.client
              .from('communities')
              .select('id, name, members')
              .eq('id', int.parse(communityId))
              .single();

      final members = List<String>.from(response['members'] ?? []);

      if (!members.contains(username)) {
        Navigator.of(context).pop('You are not a member of this community');
        return false;
      }

      _communityName = response['name'];
      return true;
    } catch (e) {
      Navigator.of(context).pop('Community not found or invalid ID');
      return false;
    }
  }

  String _formatDate(DateTime dt) => intl.DateFormat.MMMd().add_jm().format(dt);

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _createActivity() async {
    if (!(_formKeys[_currentPage].currentState?.validate() ?? false)) {
      _formKeys[_currentPage].currentState?.validate();
      return;
    }

    if (_selectedCategory == null) {
      _showToast(success: false, message: 'Please select a category');
      return;
    }

    final maxParticipants = int.tryParse(_maxParticipantsController.text);
    if (maxParticipants == null) {
      Navigator.of(context).pop('Invalid number of participants');
      return;
    }

    final communityId = _communityController.text.trim();
    if (communityId.isEmpty) {
      Navigator.of(context).pop('Community ID is required');
      return;
    }

    if (int.tryParse(communityId) == null) {
      Navigator.of(context).pop('Invalid community ID format');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isValidCommunity = await _validateCommunity(communityId);
      if (!isValidCommunity) {
        setState(() => _isLoading = false);
        return;
      }

      await ActivityService.addActivity(
        image: _imageController.text.isEmpty ? null : _imageController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _selectedDate,
        maxParticipants: maxParticipants,
        location: _locationController.text,
        community: _communityName!,
        communityId: int.parse(communityId),
        category: _selectedCategory!.label,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop('Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              widget.onPageMove?.call(i);
            },
            children: [_buildPage1(), _buildPage2(), _buildPage3()],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(36),
          child: Row(
            children: [
              if (_currentPage > 0)
                OutlinedButton.icon(
                  style: _outlinedBtn(context),
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                )
              else
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.primary(context)),
                  ),
                ),
              const Spacer(),
              ElevatedButton.icon(
                style: _primaryFilledBtn(context),
                onPressed:
                    _isLoading
                        ? null
                        : (_currentPage == 2 ? _createActivity : _nextPage),
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : (_currentPage == 2
                            ? const Icon(Icons.check)
                            : const Icon(Icons.arrow_forward)),
                label: Text(_currentPage == 2 ? 'Create' : 'Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _nextPage() {
    if (!(_formKeys[_currentPage].currentState?.validate() ?? false)) return;
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKeys[0],
        child: Column(
          children: [
            if (_imageUrl != null && _imageUrl!.isNotEmpty)
              Container(
                height: 100,
                width: 250,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                    loadingBuilder:
                        (_, child, progress) =>
                            progress == null
                                ? child
                                : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                  ),
                ),
              ),

            _buildValidatedField(
              _titleController,
              'Title *',
              (v) => v == null || v.isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: 14),
            _buildField(_imageController, 'Image URL'),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKeys[1],
        child: Column(
          children: [
            _buildValidatedField(
              _descriptionController,
              'Description *',
              (v) => v == null || v.isEmpty ? 'Enter a description' : null,
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            _buildValidatedField(
              _locationController,
              'Location *',
              (v) => v == null || v.isEmpty ? 'Enter a location' : null,
            ),
            const SizedBox(height: 14),
            _buildCategoryDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKeys[2],
        child: Column(
          children: [
            _buildValidatedField(
              _maxParticipantsController,
              'Max Participants *',
              (v) {
                if (v == null || v.isEmpty) return 'Enter max participants';
                if (int.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date & Time'),
                subtitle: Text(_formatDate(_selectedDate)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectDateTime,
              ),
            ),
            const SizedBox(height: 14),
            _buildValidatedField(
              _communityController,
              'Community ID *',
              (v) {
                if (v == null || v.isEmpty) return 'Enter community ID';
                if (int.tryParse(v) == null)
                  return 'Enter a valid community ID';
                return null;
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background(context),
          ),
          child: DropdownButtonFormField<ActivityCategory>(
            value: _selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items:
                ActivityCategory.values.map((category) {
                  return DropdownMenuItem<ActivityCategory>(
                    value: category,
                    child: Row(
                      children: [
                        category.getIcon(size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category.label,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (ActivityCategory? value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
            isExpanded: true,
            menuMaxHeight: 300,
          ),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController c, String label) {
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
          onChanged:
              label == 'Image URL'
                  ? (val) => setState(() => _imageUrl = val)
                  : null,
        ),
      ],
    );
  }

  Widget _buildValidatedField(
    TextEditingController c,
    String label,
    String? Function(String?) validator, {
    int? maxLines,
    TextInputType? keyboardType,
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
        TextFormField(
          controller: c,
          textInputAction: TextInputAction.next,
          decoration: _decoration(),
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged:
              label == 'Image URL'
                  ? (val) => setState(() => _imageUrl = val)
                  : null,
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
  Widget build(BuildContext context) {
    if (!widget.embedMode) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.background(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.6,
          expand: false,
          builder: (_, __) => _content(context),
        ),
      );
    }

    return _content(context);
  }
}

ButtonStyle _primaryFilledBtn(BuildContext ctx) => ElevatedButton.styleFrom(
  backgroundColor: AppColors.primary(ctx),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
);

ButtonStyle _outlinedBtn(BuildContext ctx) => OutlinedButton.styleFrom(
  foregroundColor: AppColors.textPrimary(ctx),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  side: BorderSide(color: Colors.grey.shade400),
  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
);
