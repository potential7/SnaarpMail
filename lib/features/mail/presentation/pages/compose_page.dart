import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/mail_bloc.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _recipientController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    if (_recipientController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipient')),
      );
      return;
    }

    setState(() => _isSending = true);
    
    context.read<MailBloc>().add(
          MailSendEmail(
            recipient: _recipientController.text.trim(),
            subject: _subjectController.text.trim(),
            body: _bodyController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MailBloc, MailState>(
      listener: (context, state) {
        if (state.status == MailStatus.sendSuccess) {
          setState(() => _isSending = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email sent!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state.status == MailStatus.failure) {
          setState(() => _isSending = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Failed to send email')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.whiteColor,
        appBar: AppBar(
          backgroundColor: AppPallete.whiteColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppPallete.greyColor),
          title: const Text(
            'Compose',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
          ),
          actions: [
            _isSending
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppPallete.primaryRed,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _sendEmail,
                    icon: const Icon(Icons.send, color: AppPallete.primaryRed),
                    tooltip: 'Send',
                  ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: AppPallete.greyColor),
            ),
          ],
        ),
        body: Column(
          children: [
            const Divider(height: 1, thickness: 1, color: AppPallete.borderColor),
            _buildField(
              label: 'From',
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'snaarp.user@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppPallete.borderColor),
            _buildField(
              label: 'To',
              child: TextField(
                controller: _recipientController,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppPallete.borderColor),
            _buildField(
              label: 'Subject',
              child: TextField(
                controller: _subjectController,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppPallete.borderColor),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: 'Compose email',
                  hintStyle: TextStyle(color: AppPallete.greyColor),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label',
              style: const TextStyle(
                fontSize: 16,
                color: AppPallete.greyColor,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
