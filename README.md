# eticketing_app

Aplikasi E-Ticketing System berbasis mobile yang dirancang menggunakan framework Flutter untuk antarmuka dan Supabase sebagai platform backend-as-a-service (BaaS)[cite: 2]. Proyek ini merupakan Laporan Proyek Akhir UAS untuk mata kuliah Praktikum Aplikasi Mobile[cite: 2].

## Informasi Pengembang
* **Nama**: MOHAMMAD ANHAZ ABDILAH[cite: 2]
* **NIM**: 434241102[cite: 2]
* **Kelas**: B4[cite: 2]
* **Program Studi**: Teknik Informatika, Fakultas Vokasi, Universitas Airlangga (2026)[cite: 2]

## Arsitektur Sistem
Aplikasi ini menerapkan arsitektur Client-Server modern berbasis cloud BaaS[cite: 2].
* **Frontend (Flutter)**: Berfungsi sebagai antarmuka interaksi pengguna yang menangani state management dan rendering komponen UI[cite: 2]. Client berkomunikasi dengan backend melalui RESTful API dan WebSocket yang disediakan oleh Supabase SDK[cite: 2].
* **Backend Cloud (Supabase)**: Mengelola infrastruktur serverless, mencakup sistem autentikasi pengguna, penyimpanan data relasional (PostgreSQL), dan mekanisme pemicu otomatis (triggers) di sisi server[cite: 2].

## Perancangan Basis Data (PostgreSQL)
Seluruh relasi database diimplementasikan pada skema public PostgreSQL di dalam instance Supabase, yang terdiri dari 4 tabel utama[cite: 2]:
* **`profiles`**: Berfungsi untuk menyimpan data personal pengguna yang terintegrasi langsung dengan tabel bawaan autentikasi Supabase (`auth.users`)[cite: 2].
* **`tickets`**: Tabel inti yang mencatat seluruh entitas tiket (memuat id, user_id, title, description, dan status) yang diajukan atau diterbitkan di dalam aplikasi[cite: 2].
* **`comments`**: Menyimpan data interaksi komentar percakapan (log dialog) di dalam sebuah tiket antara customer dan pihak admin[cite: 2].
* **`histories`**: Berfungsi sebagai rekam jejak (*audit trail*) otomatis untuk mencatat setiap perubahan status pada tiket[cite: 2].

## Implementasi & Otomasi Build (CI/CD)
* **Integrasi SDK**: Logika konektivitas aplikasi dibangun menggunakan paket resmi `supabase_flutter` yang diinisialisasi pada berkas utama `main.dart`[cite: 2].
* **GitHub Actions**: Untuk mengatasi keterbatasan spesifikasi perangkat keras lokal, proyek ini menerapkan pipa CI/CD otomasi cloud build menggunakan GitHub Actions[cite: 2].
* **Output Rilis**: Alur kerja CI/CD berhasil melakukan kompilasi otomatis menjadi berkas executables Android (`app-release.apk`) berukuran 54,4 MB[cite: 2]. Berkas APK ini siap dipasang pada perangkat Android minimal versi SDK 21 (Android 5.0)[cite: 2].

## Hasil Pengujian
Sistem telah diuji secara menyeluruh dan sukses menjalankan berbagai skenario, meliputi registrasi akun pengguna baru, autentikasi login (pengarahan sesuai Role), pembuatan dan pembaruan manajemen tiket, serta pencatatan log riwayat (audit trail) yang berjalan secara otomatis[cite: 2].

---

## Getting Started (Flutter Boilerplate)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.