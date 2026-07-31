import 'package:flutter/material.dart';
import '../models/certificate.dart';

const Color _nexternBlue = Color(0xFF3157F6);
const Color _navyDark = Color(0xFF1B2A4A);
const Color _accentGold = Color(0xFFD4AF37);
const Color _accentGoldLight = Color(0xFFFFF9E6);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF6B7280);

class CertificateViewerDialog extends StatelessWidget {
  final Certificate certificate;

  const CertificateViewerDialog({super.key, required this.certificate});

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420), // Compact Mobile-First Modal Width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mobile-First Scrollable Certificate Document Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF9), // Warm parchment background
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _accentGold, width: 2.5), // Outer Gold Frame
                    boxShadow: [
                      BoxShadow(
                        color: _accentGold.withValues(alpha: 0.12),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: _navyDark.withValues(alpha: 0.25), width: 1.2), // Inner Fine Hairline
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Centered Top Header: Exact Browse Programs Logo & Title Layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/nextern_logo.png',
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: _nexternBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.school_rounded, color: _accentGold, size: 16),
                              ),
                            ),
                            const SizedBox(width: 0.5),
                            const Text(
                              'NEXTERN',
                              style: TextStyle(
                                color: _nexternBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Centered Certificate Title
                        const Text(
                          'CERTIFICATE OF COMPLETION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _navyDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                            fontFamily: 'serif',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 30, height: 1, color: _accentGold),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(Icons.star, size: 10, color: _accentGold),
                            ),
                            Container(width: 30, height: 1, color: _accentGold),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Centered Recipient Section
                        const Text(
                          'PROUDLY PRESENTED TO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _accentGold,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          certificate.recipientName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _nexternBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'for successfully completing all required coursework, assignments, and assessments for',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.9),
                            fontSize: 10.5,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          certificate.programTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _navyDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        if (certificate.skillsMastered.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 4,
                            runSpacing: 3,
                            children: certificate.skillsMastered.take(4).map((skill) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _accentGoldLight,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: _accentGold.withValues(alpha: 0.35)),
                                ),
                                child: Text(
                                  skill,
                                  style: const TextStyle(color: _nexternBlue, fontSize: 9.5, fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 14),

                        // Centered Instructor Signature Line
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              certificate.instructorName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _navyDark,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              width: 120,
                              height: 1,
                              color: _navyDark.withValues(alpha: 0.35),
                            ),
                            const Text(
                              'AUTHORIZED SIGNATURE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: _textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Centered Issue Date & Verification Code
                        Text(
                          'Issued on: ${_formatDate(certificate.issueDate)} • ID: ${certificate.verificationCode}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500, color: _textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Compact Dialog Action Buttons Bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E7EF))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Certificate Verification Code: ${certificate.verificationCode}')),
                        );
                      },
                      icon: const Icon(Icons.share_outlined, size: 16),
                      label: const Text('Share', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Downloading Official Certificate PDF...'),
                            backgroundColor: Color(0xFF43A047),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Download PDF', style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _nexternBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
