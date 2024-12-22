import 'package:flutter/material.dart';

class SubmissionDetailPopup extends StatefulWidget {
  final String name;
  final String textResponse;
  final String? fileUrl;
  final double? grade;
  final ValueChanged<double> onGradeChange;
  final VoidCallback onSubmit;

  const SubmissionDetailPopup({
    super.key,
    required this.name,
    required this.textResponse,
    required this.fileUrl,
    required this.grade,
    required this.onGradeChange,
    required this.onSubmit,
  });

  @override
  SubmissionDetailPopupState createState() => SubmissionDetailPopupState();
}

class SubmissionDetailPopupState extends State<SubmissionDetailPopup> {
  final TextEditingController gradeController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    gradeController.text = widget.grade?.toString() ?? '';
  }

  void handleSubmit() {
    String gradeText = gradeController.text.replaceAll(',', '.');
    final double? newGrade = double.tryParse(gradeText);
    if (newGrade == null) {
      setState(() {
        errorMessage = 'Vui lòng nhập điểm hợp lệ';
      });
    } else {
      widget.onGradeChange(newGrade);
      widget.onSubmit();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chi tiết bài làm'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sinh viên:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.name,
              style: const TextStyle(),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Bài làm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (widget.textResponse.isNotEmpty) ...[
              Text(widget.textResponse),
            ],
            const SizedBox(height: 8.0),
            if (widget.fileUrl != null && widget.fileUrl!.isNotEmpty)
              InkWell(
                // onTap: () async {
                //   if (await canLaunch(widget.fileUrl!)) {
                //     await launch(widget.fileUrl!);
                //   } else {
                //     throw 'Could not launch ${widget.fileUrl}';
                //   }
                // },
                child: Text(
                  widget.fileUrl!,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            const Text(
              'Điểm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (widget.grade == null) ...[
              TextField(
                controller: gradeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Nhập điểm',
                ),
                onChanged: (value) {
                  setState(() {
                    errorMessage = null;
                  });
                },
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ] else ...[
              Text(
                '${widget.grade}',
                style: const TextStyle(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Thoát'),
        ),
        if (widget.grade == null)
          ElevatedButton(
            onPressed: handleSubmit,
            child: const Text('Trả điểm'),
          ),
      ],
    );
  }
}
