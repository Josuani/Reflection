import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PixelAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final Color borderColor;
  final double borderWidth;

  const PixelAvatar({
    super.key,
    this.avatarUrl,
    required this.size,
    this.borderColor = Colors.white,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: avatarUrl != null
            ? Image.network(
                avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[800],
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.grey[400],
      ),
    );
  }
}

class PixelAvatarCustomization extends StatefulWidget {
  final Map<String, String> initialCustomization;
  final Function(Map<String, String>) onCustomizationChanged;

  const PixelAvatarCustomization({
    Key? key,
    required this.initialCustomization,
    required this.onCustomizationChanged,
  }) : super(key: key);

  @override
  State<PixelAvatarCustomization> createState() => _PixelAvatarCustomizationState();
}

class _PixelAvatarCustomizationState extends State<PixelAvatarCustomization> {
  late Map<String, String> _customization;
  final List<String> _hairStyles = ['style1', 'style2', 'style3'];
  final List<String> _outfits = ['casual', 'formal', 'sport'];
  final List<String> _skinTones = ['light', 'medium', 'dark'];

  @override
  void initState() {
    super.initState();
    _customization = Map.from(widget.initialCustomization);
  }

  void _updateCustomization(String type, String value) {
    setState(() {
      _customization[type] = value;
      widget.onCustomizationChanged(_customization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PixelAvatar(
          avatarUrl: _customization['imageUrl'],
          size: 150,
        ),
        const SizedBox(height: 20),
        _buildCustomizationSection('Hair Style', _hairStyles, 'hair'),
        _buildCustomizationSection('Outfit', _outfits, 'outfit'),
        _buildCustomizationSection('Skin Tone', _skinTones, 'skin'),
      ],
    );
  }

  Widget _buildCustomizationSection(String title, List<String> options, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = _customization[type] == option;
              return GestureDetector(
                onTap: () => _updateCustomization(type, option),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.yellow : Colors.white,
                      width: 2,
                    ),
                    color: isSelected ? Colors.black.withOpacity(0.5) : Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/images/pixel/$type/$option.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
} 