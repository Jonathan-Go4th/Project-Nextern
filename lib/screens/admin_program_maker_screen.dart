import 'package:flutter/material.dart';

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

  DateTime? _programStartDate;
  DateTime? _programEndDate;

  final List<Map<String, dynamic>> _modules = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialProgram?['title'] ?? '');
    _descController = TextEditingController(text: widget.initialProgram?['desc'] ?? '');

    // Add a default week 1 if creating new
    if (widget.initialProgram == null) {
      _addModule();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
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

  void _saveProgram() {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all basic details.')));
      return;
    }
    if (_programStartDate == null || _programEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Program Start and End dates.')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Program & Resources saved successfully!')));
    Navigator.of(context).pop(true);
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
            _buildTextField('Short Description', _descController, maxLines: 3),
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

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
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
