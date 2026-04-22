import 'package:get/get.dart';
import '../../data/services/ticket_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/models/ticket_model.dart';

class TicketController extends GetxController {
  final TicketService _ticketService = TicketService();
  final AuthService _authService = AuthService();

  // ================= STATE =================
  var tickets = <TicketModel>[].obs;
  var isLoading = false.obs;
  var selectedTicket = Rx<TicketModel?>(null);
  var commentText = ''.obs;

  var selectedStatus = 'all'.obs;

  // 🔥 FIX UTAMA (HARUS .obs)
  var availableStatuses =
      ['all', 'open', 'in_progress', 'resolved', 'closed'].obs;

  var stats = <String, int>{}.obs;

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    fetchTickets();
    fetchStats();
  }

  // ================= FETCH TICKETS =================
  Future<void> fetchTickets() async {
    isLoading.value = true;
    try {
      final user = await _authService.getCurrentUser();
      final role = user?.role ?? 'user';
      final userId = user?.id;

      List<TicketModel> fetched;

      if (selectedStatus.value == 'all') {
        fetched = await _ticketService.getTickets(
          role: role,
          userId: userId,
        );
      } else {
        fetched = await _ticketService.getTickets(
          status: selectedStatus.value,
          role: role,
          userId: userId,
        );
      }

      // 🔥 FIX (pakai assignAll, bukan =)
      tickets.assignAll(fetched);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat tiket: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FETCH STATS =================
  Future<void> fetchStats() async {
    try {
      final user = await _authService.getCurrentUser();
      final role = user?.role ?? 'user';
      final userId = user?.id;

      final result = await _ticketService.getTicketStats(role, userId);

      // 🔥 FIX (pakai assignAll)
      stats.assignAll(result);
    } catch (e) {
      print('Error fetch stats: $e');
    }
  }

  // ================= CREATE =================
  Future<void> createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
    String? attachmentUrl,
  }) async {
    isLoading.value = true;
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      final newTicket = await _ticketService.createTicket(
        title: title,
        description: description,
        category: category,
        priority: priority,
        createdBy: user.id,
        createdByName: user.name,
        attachmentUrl: attachmentUrl,
      );

      tickets.insert(0, newTicket);
      await fetchStats();

      Get.back();
      Get.snackbar(
        'Sukses',
        'Tiket berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat tiket: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPDATE STATUS =================
  Future<void> updateStatus(int ticketId, String newStatus) async {
    try {
      await _ticketService.updateTicketStatus(ticketId, newStatus);

      await fetchTickets();

      if (selectedTicket.value?.id == ticketId) {
        selectedTicket.value =
            await _ticketService.getTicketById(ticketId);
      }

      await fetchStats();

      await NotificationService.showTicketNotification(
        'Status Tiket Berubah',
        'Tiket #$ticketId status menjadi $newStatus',
        ticketId: ticketId,
      );

      Get.snackbar('Sukses', 'Status tiket diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal update status: $e');
    }
  }

  // ================= ASSIGN =================
  Future<void> assignTicket(
      int ticketId, int userId, String userName) async {
    try {
      await _ticketService.assignTicket(
          ticketId, userId, userName);

      await fetchTickets();

      if (selectedTicket.value?.id == ticketId) {
        selectedTicket.value =
            await _ticketService.getTicketById(ticketId);
      }

      await fetchStats();

      Get.snackbar('Sukses', 'Tiket diassign ke $userName');
    } catch (e) {
      Get.snackbar('Error', 'Gagal assign tiket: $e');
    }
  }

  // ================= COMMENT =================
  Future<void> addComment(int ticketId, String message) async {
    if (message.trim().isEmpty) return;

    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      await _ticketService.addComment(
        ticketId,
        user.id,
        user.name,
        user.role,
        message,
      );

      commentText.value = '';
      selectedTicket.value =
          await _ticketService.getTicketById(ticketId);

      await fetchTickets();

      await NotificationService.showTicketNotification(
        'Komentar Baru',
        '${user.name} memberikan komentar pada tiket #$ticketId',
        ticketId: ticketId,
      );

      Get.snackbar('Sukses', 'Komentar ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah komentar: $e');
    }
  }

  // ================= DETAIL =================
  Future<void> loadTicketDetail(int id) async {
    isLoading.value = true;
    try {
      selectedTicket.value =
          await _ticketService.getTicketById(id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail tiket');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER =================
  void changeFilter(String status) {
    selectedStatus.value = status;
    fetchTickets();
  }
}