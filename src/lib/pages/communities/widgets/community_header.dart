import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';

class CommunitiesTopBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const CommunitiesTopBar({super.key, required this.onSearchChanged});

  @override
  State<CommunitiesTopBar> createState() => _CommunitiesTopBarState();
}

class _CommunitiesTopBarState extends State<CommunitiesTopBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearchToggle() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        widget.onSearchChanged('');
        _searchFocusNode.unfocus();
      }
    });
  }

  void _onSearchTextChanged(String text) {
    widget.onSearchChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedCrossFade(
            firstChild: Text(
              'Communities',
              style: AppTheme()
                  .light(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: const Color(0xFF1b1b1b)),
            ),
            secondChild: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Search communities…',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  isDense: true,
                ),
                onChanged: _onSearchTextChanged,
              ),
            ),
            crossFadeState:
                _isSearching
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ),
        GestureDetector(
          onTap: _handleSearchToggle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.grey,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}
