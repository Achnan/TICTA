class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Email: user@example.com"),
        const SizedBox(height: 20),
        const Text("ตารางการทำคอร์ส (mock calendar)"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
          child: const Text("Logout"),
        )
      ],
    );
  }
}
