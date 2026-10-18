import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A form field that looks like the app's text inputs and, when tapped,
/// opens a bottom sheet with a search box and a filterable list.
///
/// Works with [Form] validation just like [DropdownButtonFormField].
class SearchableDropdownField<T> extends FormField<T> {
  SearchableDropdownField({
    super.key,
    required List<T> items,
    required String Function(T item) itemLabel,
    String? Function(T item)? itemSubtitle,
    Widget Function(T item)? itemLeading,
    bool Function(T a, T b)? isSame,
    required String hintText,
    String? sheetTitle,
    String searchHint = 'Search',
    String emptyText = 'No matches found',
    IconData? prefixIcon,
    T? initialValue,
    ValueChanged<T?>? onChanged,
    super.validator,
    bool enabled = true,
    bool clearable = true,
  }) : super(
          initialValue: initialValue,
          enabled: enabled,
          builder: (state) {
            final context = state.context;
            final value = state.value;
            final hasValue = value != null;
            final canOpen = enabled && items.isNotEmpty;
            final subtitle = value != null ? itemSubtitle?.call(value) : null;

            Future<void> open() async {
              FocusScope.of(context).unfocus();
              final picked = await showModalBottomSheet<_Picked<T>>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _SearchSheet<T>(
                  title: sheetTitle ?? hintText,
                  items: items,
                  selected: value,
                  itemLabel: itemLabel,
                  itemSubtitle: itemSubtitle,
                  itemLeading: itemLeading,
                  isSame: isSame ?? (a, b) => a == b,
                  searchHint: searchHint,
                  emptyText: emptyText,
                ),
              );
              if (picked != null) {
                state.didChange(picked.value);
                onChanged?.call(picked.value);
              }
            }

            return InkWell(
              onTap: canOpen ? open : null,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: InputDecorator(
                isEmpty: !hasValue,
                isFocused: false,
                decoration: InputDecoration(
                  enabled: enabled,
                  hintText: items.isEmpty ? 'No options available' : hintText,
                  errorText: state.errorText,
                  prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
                  suffixIcon: hasValue && clearable && enabled
                      ? IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            state.didChange(null);
                            onChanged?.call(null);
                          },
                        )
                      : const Icon(Icons.keyboard_arrow_down_rounded),
                ),
                child: value != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            itemLabel(value),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (subtitle != null && subtitle.trim().isNotEmpty)
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      )
                    : null,
              ),
            );
          },
        );
}

/// Wrapper so the sheet can distinguish "picked" from "dismissed".
class _Picked<T> {
  const _Picked(this.value);
  final T value;
}

class _SearchSheet<T> extends StatefulWidget {
  const _SearchSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.itemLabel,
    required this.itemSubtitle,
    required this.itemLeading,
    required this.isSame,
    required this.searchHint,
    required this.emptyText,
  });

  final String title;
  final List<T> items;
  final T? selected;
  final String Function(T) itemLabel;
  final String? Function(T)? itemSubtitle;
  final Widget Function(T)? itemLeading;
  final bool Function(T, T) isSame;
  final String searchHint;
  final String emptyText;

  @override
  State<_SearchSheet<T>> createState() => _SearchSheetState<T>();
}

class _SearchSheetState<T> extends State<_SearchSheet<T>> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<T> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items.where((e) {
      final label = widget.itemLabel(e).toLowerCase();
      final sub = (widget.itemSubtitle?.call(e) ?? '').toLowerCase();
      return label.contains(q) || sub.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final results = _filtered;

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SizedBox(
        height: media.size.height * 0.72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${results.length} of ${widget.items.length}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? _empty()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 2),
                      itemBuilder: (_, i) => _tile(results[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(T item) {
    final selected =
        widget.selected != null && widget.isSame(widget.selected as T, item);
    final sub = widget.itemSubtitle?.call(item);
    return Material(
      color: selected ? AppColors.primarySoft : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: widget.itemLeading?.call(item),
        title: _highlight(widget.itemLabel(item), selected),
        subtitle: (sub == null || sub.trim().isEmpty)
            ? null
            : Text(
                sub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary),
              ),
        trailing: selected
            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
            : null,
        onTap: () => Navigator.pop(context, _Picked<T>(item)),
      ),
    );
  }

  /// Bolds the part of [text] that matches the search query.
  Widget _highlight(String text, bool selected) {
    final base = TextStyle(
      fontSize: 15,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      color: AppColors.textPrimary,
    );
    final q = _query.trim();
    final idx = q.isEmpty ? -1 : text.toLowerCase().indexOf(q.toLowerCase());
    if (idx < 0) {
      return Text(text,
          maxLines: 1, overflow: TextOverflow.ellipsis, style: base);
    }
    return Text.rich(
      TextSpan(style: base, children: [
        TextSpan(text: text.substring(0, idx)),
        TextSpan(
          text: text.substring(idx, idx + q.length),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        TextSpan(text: text.substring(idx + q.length)),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded,
                  size: 40, color: AppColors.textMuted),
              const SizedBox(height: 10),
              Text(
                widget.emptyText,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
