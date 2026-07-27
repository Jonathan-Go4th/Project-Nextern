import 'package:flutter/material.dart';

import '../services/enrollment_service.dart';

class ProgramApplicationForm extends StatefulWidget {
  final String programTitle;

  const ProgramApplicationForm({super.key, required this.programTitle});

  @override
  State<ProgramApplicationForm> createState() => _ProgramApplicationFormState();
}

enum _SubmitState { idle, loading, success, error }

class _ProgramApplicationFormState extends State<ProgramApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  final _reasonController = TextEditingController();
  final _portfolioController = TextEditingController();

  String? _experienceLevel;
  bool _confirmed = false;

  _SubmitState _state = _SubmitState.idle;
  String? _errorMessage;

  static const List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  bool get _isLoading => _state == _SubmitState.loading;

  @override
  void dispose() {
    _reasonController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  String? _validateExperience(String? value) {
    if (_experienceLevel == null) {
      return 'Please select your experience level';
    }

    return null;
  }

  String? _validateReason(String? value) {
    final reason = value?.trim() ?? '';

    if (reason.isEmpty) {
      return 'Please tell us why you want to join';
    }

    if (reason.length < 20) {
      return 'Reason must be at least 20 characters';
    }

    return null;
  }

  String? _validatePortfolio(String? value) {
    final url = value?.trim() ?? '';

    if (url.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(url);

    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        !(uri.scheme == 'http' || uri.scheme == 'https')) {
      return 'Enter a valid URL';
    }

    return null;
  }

  Future<void> _submitApplication() async {
    if (_isLoading) return;

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) return;

    if (!_confirmed) {
      setState(() {
        _state = _SubmitState.error;
        _errorMessage = 'Please confirm the information before submitting.';
      });

      return;
    }

    setState(() {
      _state = _SubmitState.loading;
      _errorMessage = null;
    });

    try {
      await EnrollmentService.instance.submitApplication(
        programTitle: widget.programTitle,
        reason: _reasonController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _state = _SubmitState.success;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _state = _SubmitState.error;
        _errorMessage = 'Submission failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _SubmitState.success) {
      return _buildSuccessState();
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Apply for ${widget.programTitle}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _experienceLevel,
            decoration: const InputDecoration(
              labelText: 'Experience Level',
              border: OutlineInputBorder(),
            ),
            items: _experienceLevels
                .map(
                  (level) => DropdownMenuItem(value: level, child: Text(level)),
                )
                .toList(),
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      _experienceLevel = value;
                    });
                  },
            validator: _validateExperience,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _reasonController,
            enabled: !_isLoading,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Reason for joining',
              border: OutlineInputBorder(),
            ),
            validator: _validateReason,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _portfolioController,
            enabled: !_isLoading,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Portfolio URL (optional)',
              border: OutlineInputBorder(),
            ),
            validator: _validatePortfolio,
          ),

          const SizedBox(height: 16),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _confirmed,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      _confirmed = value ?? false;
                    });
                  },
            title: const Text(
              'I confirm that the information provided is accurate.',
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),

          if (_state == _SubmitState.error && _errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _isLoading ? null : _submitApplication,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit Application'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 48),

        const SizedBox(height: 12),

        Text(
          'Application Submitted',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 8),

        const Text('Status: Under Review'),
      ],
    );
  }
}
