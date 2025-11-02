import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/auth_service.dart';
import '../core/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text;
      await AuthService.instance.register(name, email, password);
      // On success navigate to dashboard or root
      if (mounted) Navigator.of(context).pushReplacementNamed('/dashboard');
    } on Exception catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create account', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.green.shade800)),
                    const SizedBox(height: 8),
                    Text('Register with email & password', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 18),

                    TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person)), validator: (v) => v==null||v.trim().isEmpty? 'Enter your name': null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)), keyboardType: TextInputType.emailAddress, validator: (v) { if (v==null||v.trim().isEmpty) return 'Enter email'; final pattern = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}"); if(!pattern.hasMatch(v)) return 'Enter valid email'; return null; }),
                    const SizedBox(height: 12),
                    TextFormField(controller: _passwordCtrl, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), obscureText: true, validator: (v) { if (v==null||v.length<6) return 'Password min 6 chars'; return null; }),
                    const SizedBox(height: 12),
                    TextFormField(controller: _confirmCtrl, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_outline)), obscureText: true, validator: (v) { if (v==null||v!=_passwordCtrl.text) return 'Passwords do not match'; return null; }),
                    const SizedBox(height: 16),

                    if (_error!=null) Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(_error!, style: const TextStyle(color: Colors.red))),

                    SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.green.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: _loading?null:_register, child: _loading? const SizedBox(height:18,width:18,child:CircularProgressIndicator(color: Colors.white, strokeWidth:2)): Text('Register', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)))),

                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Back to login'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
