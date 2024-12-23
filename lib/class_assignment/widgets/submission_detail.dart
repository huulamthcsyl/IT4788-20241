import 'package:flutter/material.dart';

class SubmissionDetailPopup extends StatefulWidget {
  final String name;
  final String textResponse;
  final String? fileUrl;
  final double? grade;
  final ValueChanged<double> onGradeChange;
  final Future<void> Function() onSubmit; // Change to Future<void>

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

  void handleSubmit() async {
    String gradeText = gradeController.text.replaceAll(',', '.');
    final double? newGrade = double.tryParse(gradeText);
    if (newGrade == null) {
      setState(() {
        errorMessage = 'Vui lòng nhập điểm hợp lệ';
      });
    } else {
      widget.onGradeChange(newGrade);
      await widget.onSubmit(); // Await the Future<void> function
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFAFAFA),
      // Set background color to a lighter shade
      title: const Text(
        'Chi tiết bài làm',
        style: TextStyle(fontWeight: FontWeight.bold), // Make title bold
      ),
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
            const SizedBox(height: 8.0),
            const Text(
              'Điểm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(8.0), // Border radius
              ),
              child: TextField(
                controller: gradeController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Nhập điểm',
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  // Remove the outline
                  enabledBorder: InputBorder.none,
                  // Remove the outline when enabled
                  focusedBorder: InputBorder.none,
                  // Remove the outline when focused
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0), // Add horizontal padding
                ),
                onChanged: (value) {
                  setState(() {
                    errorMessage = null;
                  });
                },
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8.0),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
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
          style: TextButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            // Background color for "Thoát" button
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Thoát',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.8),
            // Background color for "Trả điểm" button
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Trả điểm',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}