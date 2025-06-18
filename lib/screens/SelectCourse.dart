class SelectCoursePage extends StatefulWidget {
  const SelectCoursePage({super.key});
  @override
  State<SelectCoursePage> createState() => _SelectCoursePageState();
}

class _SelectCoursePageState extends State<SelectCoursePage> {
  String? selectedCourse;
  final List<String> courses = ["คอระดับเริ่มต้น", "ไหล่ระดับกลาง", "ขาระดับสูง"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            hint: const Text("เลือกคอร์สกายภาพ"),
            value: selectedCourse,
            onChanged: (value) => setState(() => selectedCourse = value),
            items: courses.map((course) => DropdownMenuItem(value: course, child: Text(course))).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedCourse == null
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraPage(course: selectedCourse!),
                      ),
                    ),
            child: const Text("เริ่มทำท่า"),
          ),
        ],
      ),
    );
  }
}