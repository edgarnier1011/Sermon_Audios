import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GlassEmailSenderWidget extends StatefulWidget {
  const GlassEmailSenderWidget({super.key});

  @override
  State<GlassEmailSenderWidget> createState() => _GlassEmailSenderWidgetState();
}

class _GlassEmailSenderWidgetState extends State<GlassEmailSenderWidget> {
  final TextEditingController subjectController = TextEditingController();
  bool isSending = false;

  /*This function sends an email to the specified address with the desired text to be submitted. isSending is set to true, so the user cannot submit another request while one is in progress, as shown in line 150 */
  Future<void> sendEmail() async {
    isSending = true;
    final String subject = Uri.encodeComponent(subjectController.text.trim());

    final Uri emailUri = Uri.parse(
      "mailto:edgartorresberumen101193@gmail.com?subject=$subject",
    );

    if (subject.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title for sermon')),
      );

      isSending = false;
      return;
    }
    if (await canLaunchUrl(emailUri)) {
      // check if email app is available
      bool success = await launchUrl(emailUri);
      if (success) {
        isSending = false;
        return;
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
      isSending = false;
      return;
    }
    isSending = false;
  }

  @override
  void dispose() {
    subjectController.dispose();
    super.dispose();
  }

  InputDecoration glassInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.22),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Submit Text Request',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.14),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.45),
                      blurRadius: 24,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Submit Text Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 12),
                        TextField(
                          controller: subjectController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white70,
                          decoration: glassInputDecoration('Sermon Title'),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: isSending ? null : sendEmail,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('Send'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.10),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*prototype for sending emails directly from the application
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:url_launcher/url_launcher.dart';

// class EmailSenderWidget extends StatefulWidget {
//   const EmailSenderWidget({super.key});

//   @override
//   State<EmailSenderWidget> createState() => _EmailSenderWidgetState();
// }

// class _EmailSenderWidgetState extends State<EmailSenderWidget> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController subjectController = TextEditingController();
//   final TextEditingController bodyController = TextEditingController();
//   bool isHTML = false;

//   Email emailtoSend = Email();

//   Future<void> sendEmail() async {
//     final String email = emailController.text.trim();
//     final String subject = subjectController.text.trim();
//     final String body = bodyController.text.trim();

//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {
//         'subject': subject,
//         'body': body,
//       },
//     );

//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open email app')),
//       );
//     }
//   }

//   Future<void> sendEmail1() async {
//     final Email email = Email(
//       body: bodyController.text,
//       subject: subjectController.text,
//       recipients: [
//         emailController.text,
//       ],
//       attachmentPaths: [],
//       isHTML: isHTML,
//     );

//     String platformResponse;

//     try {
//       await FlutterEmailSender.send(email);
//       platformResponse = 'success';
//     } catch (error) {
//       print(error);
//       platformResponse = error.toString();
//     }

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(platformResponse),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     subjectController.dispose();
//     bodyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey.shade900,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               "Send Email",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: emailController,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 labelText: 'Recipient Email',
//                 labelStyle: TextStyle(color: Colors.white70),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: subjectController,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 labelText: 'Subject',
//                 labelStyle: TextStyle(color: Colors.white70),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: bodyController,
//               maxLines: 3,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 labelText: 'Message',
//                 labelStyle: TextStyle(color: Colors.white70),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: sendEmail,
//               child: const Text("Send Email"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
*/
