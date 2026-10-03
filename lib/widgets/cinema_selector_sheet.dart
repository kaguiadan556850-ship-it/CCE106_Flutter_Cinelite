import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cinema.dart';
import '../theme/app_theme.dart';

/// "Choose your cinemas" modal (Fig. 4 in the original design).
Future<Cinema?> showCinemaSelectorSheet(
  BuildContext context, {
  Cinema? initiallySelected,
}) {
  return showModalBottomSheet<Cinema>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CinemaSelectorSheet(initiallySelected: initiallySelected),
  );
}

class _CinemaSelectorSheet extends StatefulWidget {
  final Cinema? initiallySelected;
  const _CinemaSelectorSheet({this.initiallySelected});

  @override
  State<_CinemaSelectorSheet> createState() => _CinemaSelectorSheetState();
}

class _CinemaSelectorSheetState extends State<_CinemaSelectorSheet> {
  final TextEditingController _search = TextEditingController();
  Cinema? _picked;
  List<Cinema> _filtered = MockData.cinemas;

  @override
  void initState() {
    super.initState();
    _picked = widget.initiallySelected;
  }

  void _onSearchChanged(String q) {
    setState(() {
      _filtered = MockData.cinemas
          .where((c) =>
              c.name.toLowerCase().contains(q.toLowerCase()) ||
              c.address.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose your cinemas',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _search,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 18),
                  itemBuilder: (context, i) {
                    final cinema = _filtered[i];
                    final isSelected = _picked?.id == cinema.id;
                    return Semantics(
                      button: true,
                      selected: isSelected,
                      label: '${cinema.name}, ${cinema.address}',
                      child: InkWell(
                        onTap: () => setState(() => _picked = cinema),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.location_on_outlined,
                              color: isSelected
                                  ? AppColors.navy
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cinema.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    cinema.address,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _picked == null
                      ? null
                      : () => Navigator.of(context).pop(_picked),
                  child: const Text('DONE'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
