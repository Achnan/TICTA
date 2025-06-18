class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          },
          child: const Text("Mock Sign In"),
        ),
      ),
    );
  }
}