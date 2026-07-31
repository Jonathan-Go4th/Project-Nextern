import 'package:flutter/material.dart';
import '../models/program.dart';
import '../services/program_store.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminProgramMakerScreen extends StatefulWidget {
  final Map<String, dynamic>? initialProgram;

  const AdminProgramMakerScreen({super.key, this.initialProgram});

  @override
  State<AdminProgramMakerScreen> createState() => _AdminProgramMakerScreenState();
}

class _AdminProgramMakerScreenState extends State<AdminProgramMakerScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _companyController;
  late TextEditingController _imageUrlController;

  DateTime? _programStartDate;
  DateTime? _programEndDate;

  final List<Map<String, dynamic>> _modules = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialProgram?['title'] ?? '');
    _descController = TextEditingController(text: widget.initialProgram?['desc'] ?? widget.initialProgram?['shortDescription'] ?? '');
    _companyController = TextEditingController(text: widget.initialProgram?['company'] ?? 'Nextern Academy');
    _imageUrlController = TextEditingController(text: widget.initialProgram?['imageUrl'] ?? '');

    // Add a default week 1 if creating new
    if (widget.initialProgram == null) {
      _addModule();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _companyController.dispose();
    _imageUrlController.dispose();
    for (final module in _modules) {
      for (final res in module['resources']) {
        (res['controller'] as TextEditingController).dispose();
      }
    }
    super.dispose();
  }

  void _addModule() {
    setState(() {
      _modules.add({
        'title': 'Week ${_modules.length + 1}',
        'resources': [],
      });
    });
  }

  void _deleteModule(int moduleIndex) {
    final moduleTitle = _modules[moduleIndex]['title'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Module'),
          content: Text('Are you sure you want to delete "$moduleTitle" and all its attached resources?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final module = _modules.removeAt(moduleIndex);
                  for (final res in module['resources']) {
                    if (res['controller'] != null) {
                      (res['controller'] as TextEditingController).dispose();
                    }
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"$moduleTitle" deleted'), duration: const Duration(seconds: 1)),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _editModuleTitle(int moduleIndex) {
    final titleController = TextEditingController(text: _modules[moduleIndex]['title']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Module / Week'),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Module Title',
              hintText: 'e.g. Week 1: Getting Started',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  setState(() {
                    _modules[moduleIndex]['title'] = titleController.text.trim();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Module title updated'), duration: Duration(seconds: 1)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  void _addResource(int moduleIndex, String type) {
    setState(() {
      _modules[moduleIndex]['resources'].add({
        'type': type,
        'controller': TextEditingController(),
        'dueDate': null, // only used if type is 'Assignment'
      });
    });
  }

  Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _programStartDate = picked;
        } else {
          _programEndDate = picked;
        }
      });
    }
  }

  Future<void> _selectDueDate(BuildContext context, int moduleIndex, int resourceIndex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _modules[moduleIndex]['resources'][resourceIndex]['dueDate'] = picked;
      });
    }
  }

  void _deleteResource(int moduleIndex, int resourceIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Resource'),
          content: const Text('Are you sure you want to delete this resource?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final removed = _modules[moduleIndex]['resources'].removeAt(resourceIndex);
                  if (removed['controller'] != null) {
                    (removed['controller'] as TextEditingController).dispose();
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resource deleted'), duration: Duration(seconds: 1)),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _editResource(int moduleIndex, int resourceIndex) {
    final res = _modules[moduleIndex]['resources'][resourceIndex];
    String selectedType = res['type'] as String;
    final editController = TextEditingController(text: res['controller'] != null ? (res['controller'] as TextEditingController).text : '');
    DateTime? editDueDate = res['dueDate'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Resource', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resource Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textSecondary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: ['Video', 'PDF', 'Flashcard', 'Assignment', 'Other'].map((type) {
                        final isSelected = selectedType == type;
                        return ChoiceChip(
                          label: Text(type, style: TextStyle(color: isSelected ? Colors.white : _textPrimary, fontSize: 12)),
                          selected: isSelected,
                          selectedColor: _primaryBlue,
                          backgroundColor: _background,
                          onSelected: (val) {
                            if (val) {
                              setDialogState(() {
                                selectedType = type;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Resource Link / Title', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textSecondary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: editController,
                      decoration: InputDecoration(
                        hintText: selectedType == 'Video'
                            ? 'Enter Video URL'
                            : selectedType == 'PDF'
                                ? 'Enter PDF Link'
                                : selectedType == 'Flashcard'
                                    ? 'Enter Flashcard Deck ID'
                                    : selectedType == 'Assignment'
                                        ? 'Enter Assignment Prompt'
                                        : 'Enter Custom Resource Link or Note',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    if (selectedType == 'Assignment') ...[
                      const SizedBox(height: 16),
                      const Text('Due Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textSecondary)),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: editDueDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              editDueDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.event, size: 16),
                        label: Text(editDueDate != null ? _formatDate(editDueDate!) : 'Select Due Date'),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      res['type'] = selectedType;
                      (res['controller'] as TextEditingController).text = editController.text;
                      res['dueDate'] = editDueDate;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resource updated'), duration: Duration(seconds: 1)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> _saveProgram() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all basic details.')));
      return;
    }

    final String title = _titleController.text.trim();
    final String desc = _descController.text.trim();
    final String company = _companyController.text.trim().isEmpty ? 'Nextern Academy' : _companyController.text.trim();
    final String? imageUrl = _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim();
    final String programId = widget.initialProgram?['id'] ?? 'prog_${DateTime.now().millisecondsSinceEpoch}';

    final program = Program(
      id: programId,
      title: title,
      category: widget.initialProgram?['category'] ?? 'PROGRAM',
      arrangement: widget.initialProgram?['arrangement'] ?? 'REMOTE',
      company: company,
      shortDescription: desc,
      fullDescription: desc,
      tags: ['New', 'Featured'],
      imageUrl: imageUrl,
      duration: _programStartDate != null && _programEndDate != null
          ? '${(_programEndDate!.difference(_programStartDate!).inDays / 7).ceil()} Weeks'
          : '8 Weeks',
      effort: '15 hrs/week',
      level: 'All levels',
      format: '100% Online',
    );

    if (widget.initialProgram != null) {
      await ProgramStore.instance.updateProgram(program);
    } else {
      await ProgramStore.instance.addProgram(program);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Program & Resources saved successfully!')));
      Navigator.of(context).pop(true);
    }
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialProgram != null;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isEditing ? 'Edit Program' : 'Create Program',
          style: const TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProgram,
            child: const Text('Save', style: TextStyle(color: _primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Basic Details', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _buildTextField('Program Title', _titleController),
            const SizedBox(height: 16),
            _buildTextField('Company / Organization', _companyController),
            const SizedBox(height: 16),
            _buildTextField('Short Description', _descController, maxLines: 3),
            const SizedBox(height: 16),

            const Text('Program Cover Image', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageUrlController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.image_outlined, color: _primaryBlue),
                      hintText: 'Enter Image URL or upload sample',
                      hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryBlue, width: 2)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    const sampleUrl = 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&q=80';
                    setState(() {
                      _imageUrlController.text = sampleUrl;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cover image uploaded successfully!'), duration: Duration(seconds: 1)),
                    );
                  },
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.code, size: 14, color: _primaryBlue),
                  label: const Text('Tech Sample', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    setState(() {
                      _imageUrlController.text = 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&q=80';
                    });
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.brush, size: 14, color: _primaryBlue),
                  label: const Text('UI/UX Sample', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    setState(() {
                      _imageUrlController.text = 'https://lh3.googleusercontent.com/aida-public/AB6AXuBRLMT7A6qJiQ7rlwVMobLypRC5k8PGCUDLi6H0-DOZ8qMy1O9ELxF2sQEx5eezFcaRyTV1iZ7DgzUIp5hJYUqljE5H5x1jNKxh3rUJrquSgg_9zPcr-eXPPeR2YrTQUhTgnN_CpUFY6QtMFQV0k-CJ0YkRoX2sxyDRMgEHmMsTNo-156JrGQ54LqhEWsnB6jFhMLlEV5J6tMF0_gYtRFwz-rh73MxxIQ3gppiMNJMknMOP4N1QeL3_BZ2Fwxs-xHOkUHMXJLDSeYQ';
                    });
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.analytics, size: 14, color: _primaryBlue),
                  label: const Text('Data Sample', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    setState(() {
                      _imageUrlController.text = 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80';
                    });
                  },
                ),
              ],
            ),
            if (_imageUrlController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlController.text.trim(),
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: const Color(0xFFE8ECFF),
                        child: const Center(child: Text('Invalid image URL', style: TextStyle(color: _textSecondary))),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _imageUrlController.clear();
                        });
                      },
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            
            const Text('Program Schedule', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, isStart: true),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_programStartDate != null ? _formatDate(_programStartDate!) : 'Start Date'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, isStart: false),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_programEndDate != null ? _formatDate(_programEndDate!) : 'End Date'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            const Divider(color: _border),
            const SizedBox(height: 24),
            
            const Text('Curriculum Builder', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Add modules and attach resources to them.', style: TextStyle(color: _textSecondary, fontSize: 13)),
            const SizedBox(height: 16),

            if (_modules.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'No modules added yet. Tap "Add Module / Week" below to create one.',
                    style: TextStyle(color: _textSecondary, fontStyle: FontStyle.italic),
                  ),
                ),
              ),

            ..._modules.asMap().entries.map((entry) {
              final int moduleIndex = entry.key;
              final Map<String, dynamic> module = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: ExpansionTile(
                  title: Text(module['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: _textPrimary)),
                  initiallyExpanded: moduleIndex == _modules.length - 1,
                  shape: const Border(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: _primaryBlue, size: 18),
                        tooltip: 'Rename Module',
                        onPressed: () => _editModuleTitle(moduleIndex),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFE53935), size: 18),
                        tooltip: 'Delete Module',
                        onPressed: () => _deleteModule(moduleIndex),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: _textSecondary),
                    ],
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: _border)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (module['resources'].isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Text('No resources added yet.', style: TextStyle(color: _textSecondary, fontStyle: FontStyle.italic)),
                            ),
                          
                          ...module['resources'].asMap().entries.map<Widget>((resEntry) {
                            final int resIndex = resEntry.key;
                            final Map<String, dynamic> res = resEntry.value;

                            IconData icon = Icons.insert_drive_file;
                            String hint = 'Enter Resource Link/Title';
                            if (res['type'] == 'Video') { icon = Icons.play_circle_fill; hint = 'Enter Video URL'; }
                            else if (res['type'] == 'PDF') { icon = Icons.picture_as_pdf; hint = 'Enter PDF Link'; }
                            else if (res['type'] == 'Flashcard') { icon = Icons.style; hint = 'Enter Flashcard Deck ID'; }
                            else if (res['type'] == 'Assignment') { icon = Icons.assignment; hint = 'Enter Assignment Prompt'; }
                            else if (res['type'] == 'Other') { icon = Icons.more_horiz; hint = 'Enter Custom Resource Link or Note'; }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: res['controller'],
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(icon, color: _primaryBlue),
                                            hintText: hint,
                                            hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
                                            filled: true,
                                            fillColor: _background,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: _primaryBlue, size: 20),
                                        tooltip: 'Edit resource',
                                        onPressed: () => _editResource(moduleIndex, resIndex),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Color(0xFFE53935), size: 20),
                                        tooltip: 'Delete resource',
                                        onPressed: () => _deleteResource(moduleIndex, resIndex),
                                      ),
                                    ],
                                  ),
                                  if (res['type'] == 'Assignment') ...[
                                    const SizedBox(height: 8),
                                    OutlinedButton.icon(
                                      onPressed: () => _selectDueDate(context, moduleIndex, resIndex),
                                      icon: const Icon(Icons.event, size: 14),
                                      label: Text(
                                        res['dueDate'] != null ? 'Due: ${_formatDate(res['dueDate'])}' : 'Set Submission Due Date',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: res['dueDate'] != null ? _primaryBlue : _textSecondary,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        minimumSize: Size.zero,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),

                          const SizedBox(height: 8),
                          const Text('Add Resource:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: _textSecondary)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildAddResourceChip('Video', Icons.play_circle_fill, () => _addResource(moduleIndex, 'Video')),
                              _buildAddResourceChip('PDF Document', Icons.picture_as_pdf, () => _addResource(moduleIndex, 'PDF')),
                              _buildAddResourceChip('Flashcards', Icons.style, () => _addResource(moduleIndex, 'Flashcard')),
                              _buildAddResourceChip('Assignment', Icons.assignment, () => _addResource(moduleIndex, 'Assignment')),
                              _buildAddResourceChip('Other', Icons.more_horiz, () => _addResource(moduleIndex, 'Other')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addModule,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Module / Week'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryBlue,
                  side: const BorderSide(color: _primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAddResourceChip(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: _primaryBlue),
      label: Text(label, style: const TextStyle(fontSize: 12, color: _textPrimary)),
      backgroundColor: const Color(0xFFF0F3FF),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onTap,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryBlue, width: 2)),
          ),
        ),
      ],
    );
  }
}
