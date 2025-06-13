import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String name;
  final String? description;
  final bool isEditingName;
  final bool isEditingDescription;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final VoidCallback onEditName;
  final VoidCallback onEditDescription;
  final VoidCallback onSaveName;
  final VoidCallback onSaveDescription;
  final VoidCallback onCancelName;
  final VoidCallback onCancelDescription;

  const ProfileInfo({
    Key? key,
    required this.name,
    this.description,
    required this.isEditingName,
    required this.isEditingDescription,
    required this.nameController,
    required this.descriptionController,
    required this.onEditName,
    required this.onEditDescription,
    required this.onSaveName,
    required this.onSaveDescription,
    required this.onCancelName,
    required this.onCancelDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameSection(context),
          const SizedBox(height: 16),
          _buildDescriptionSection(context),
        ],
      ),
    );
  }

  Widget _buildNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: isEditingName
                  ? TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            if (!isEditingName)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEditName,
              ),
          ],
        ),
        if (isEditingName)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancelName,
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSaveName,
                child: const Text('Guardar'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: isEditingDescription
                  ? TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    )
                  : Text(
                      description ?? 'Sin descripción',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
            ),
            if (!isEditingDescription)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEditDescription,
              ),
          ],
        ),
        if (isEditingDescription)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancelDescription,
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSaveDescription,
                child: const Text('Guardar'),
              ),
            ],
          ),
      ],
    );
  }
} 