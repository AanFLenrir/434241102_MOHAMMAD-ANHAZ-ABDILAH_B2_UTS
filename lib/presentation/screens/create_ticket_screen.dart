import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/ticket_controller.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TicketController controller = Get.find<TicketController>();
  
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String selectedCategory = 'Jaringan';
  String selectedPriority = 'medium';
  String? attachmentPath;
  bool isLoading = false;
  
  final List<String> categories = const ['Jaringan', 'Hardware', 'Software', 'Akses', 'Lainnya'];
  final List<String> priorities = const ['low', 'medium', 'high', 'critical'];
  
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => attachmentPath = picked.path);
    }
  }
  
  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => attachmentPath = picked.path);
    }
  }
  
  Future<void> submit() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Judul tiket harus diisi');
      return;
    }
    if (descController.text.isEmpty) {
      Get.snackbar('Error', 'Deskripsi harus diisi');
      return;
    }
    setState(() => isLoading = true);
    try {
      await controller.createTicket(
        title: titleController.text,
        description: descController.text,
        category: selectedCategory,
        priority: selectedPriority,
        attachmentUrl: attachmentPath,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
  
  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Tiket Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Tiket',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                prefixIcon: Icon(Icons.category),
              ),
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Prioritas',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: priorities.map((prio) => DropdownMenuItem(value: prio, child: Text(prio.toUpperCase()))).toList(),
              onChanged: (val) => setState(() => selectedPriority = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Masalah',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Lampiran (Opsional)', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeri'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                  ),
                ),
              ],
            ),
            if (attachmentPath != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file),
                    const SizedBox(width: 8),
                    Expanded(child: Text(attachmentPath!.split('/').last)),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() => attachmentPath = null),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              child: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Kirim Tiket', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}