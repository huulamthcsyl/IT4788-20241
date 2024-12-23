import 'package:flutter/material.dart';

class AttendanceItem extends StatefulWidget {
  final String name;
  final String email;
  final String? status;
  final ValueChanged<String> onStatusChange;

  const AttendanceItem({
    super.key,
    required this.name,
    required this.email,
    required this.status,
    required this.onStatusChange,
  });

  @override
  AttendanceItemState createState() => AttendanceItemState();
}

class AttendanceItemState extends State<AttendanceItem> {
  late String? _selectedStatus;
  final Map<String, String> _statusMap = {
    'PRESENT': 'Có mặt',
    'EXCUSED_ABSENCE': 'Vắng mặt có phép',
    'UNEXCUSED_ABSENCE': 'Vắng mặt không phép',
  };

  // Reverse map for display
  final Map<String, String> _displayStatusMap = {
    'Có mặt': 'PRESENT',
    'Vắng mặt có phép': 'EXCUSED_ABSENCE',
    'Vắng mặt không phép': 'UNEXCUSED_ABSENCE',
  };

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      width: double.infinity, // Take up full width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            widget.email,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              value: _statusMap[_selectedStatus],
              onChanged: (String? newValue) {
                if(newValue != null){
                  setState(() {
                    _selectedStatus = _displayStatusMap[newValue]!;
                  });
                  widget.onStatusChange(_displayStatusMap[newValue]!);
                }
              },
              items: _statusMap.values
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                );
              }).toList(),
              isExpanded: true, // Ensure the dropdown button expands to fill the container
            ),
          ),
        ],
      ),
    );
  }
}