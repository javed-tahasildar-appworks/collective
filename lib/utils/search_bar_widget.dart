import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged; // Add this line

  const SearchBarWidget({
    super.key,
    this.onChanged, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FA),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          onChanged: onChanged, // Pass the callback here
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            // Optional: Add formatter to enforce capitalization
            TextInputFormatter.withFunction(
              (oldValue, newValue) => TextEditingValue(
                text: newValue.text.splitMapJoin(
                  ' ',
                  onNonMatch: (word) => word.isNotEmpty
                      ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                      : '',
                ),
                selection: newValue.selection,
              ),
            ),
          ],
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black54,
            ),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
