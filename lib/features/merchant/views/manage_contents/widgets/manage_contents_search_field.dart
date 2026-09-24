import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';

class ManageContentsSearchField extends StatefulWidget {
  const ManageContentsSearchField({super.key, required this.controller});

  final ManageContentsController controller;

  @override
  State<ManageContentsSearchField> createState() =>
      _ManageContentsSearchFieldState();
}

class _ManageContentsSearchFieldState extends State<ManageContentsSearchField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _textController,
          onChanged: (value) => widget.controller.searchQuery.value = value,
          style: GoogleFonts.krub(fontSize: 14, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: 'ค้นหาชื่อเรื่องราว ข่าวสาร หรือหมวดหมู่...',
            hintStyle: GoogleFonts.krub(
              color: const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF059669),
              size: 22,
            ),
            suffixIcon: Obx(
              () => widget.controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      tooltip: 'ล้างคำค้นหา',
                      icon: const Icon(
                        Icons.clear_rounded,
                        size: 18,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () {
                        _textController.clear();
                        widget.controller.searchQuery.value = '';
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
