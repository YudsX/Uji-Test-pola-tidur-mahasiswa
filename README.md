# Analisis Pola Tidur Mahasiswa

Project ini menganalisis durasi tidur mahasiswa menggunakan uji parametrik dan non-parametrik, lalu membuat visualisasi distribusi serta perbandingan kelompok. Analisis mencakup tiga skenario: durasi tidur harian dibandingkan dengan anjuran 8 jam, perbandingan kelompok konsumsi kafein dan non-kafein, serta perbandingan tidur pada malam biasa dan malam ujian.

## Daftar Isi

- [Tujuan](#tujuan)
- [Analisis yang Dilakukan](#analisis-yang-dilakukan)
- [Struktur Data](#struktur-data)
- [Persyaratan](#persyaratan)
- [Cara Menjalankan](#cara-menjalankan)
- [Hasil](#hasil)
- [Catatan Metodologis](#catatan-metodologis)
- [Struktur Repository](#struktur-repository)

## Tujuan

Project ini bertujuan untuk:

1. Menguji apakah rata-rata durasi tidur harian berbeda dari 8 jam.
2. Membandingkan durasi tidur mahasiswa yang mengonsumsi kafein dengan yang tidak.
3. Membandingkan durasi tidur mahasiswa pada malam biasa dan malam ujian.
4. Menampilkan ringkasan statistik, hasil uji, keputusan, kesimpulan, dan grafik.

## Analisis yang Dilakukan

| Bagian | Perbandingan | Uji parametrik | Uji non-parametrik |
|---|---|---|---|
| Sheet1 — One sample | Tidur harian vs 8 jam | One-sample t-test | Wilcoxon signed-rank satu sampel |
| Sheet2 — Independent | Kelompok kafein vs non-kafein | Independent t-test (Welch atau varians sama berdasarkan Levene) | Wilcoxon rank-sum / Mann–Whitney |
| Sheet3 — Paired | Malam biasa vs malam ujian | Paired t-test | Paired Wilcoxon signed-rank |

Script memeriksa normalitas dengan Shapiro–Wilk. Untuk Sheet2, script juga menggunakan uji Levene untuk memilih asumsi varians pada t-test.

## Struktur Data

Simpan file Excel bernama **`uji_test_tema_6.xlsx`** di direktori kerja R yang aktif. File harus memiliki tiga sheet berikut:

### Sheet1

Kolom yang diperlukan:

- `Tidur Harian` — durasi tidur harian dalam jam.

### Sheet2

Kolom yang diperlukan:

- `kafein` — durasi tidur kelompok yang mengonsumsi kafein.
- `non_kafein` — durasi tidur kelompok yang tidak mengonsumsi kafein.

### Sheet3

Kolom yang diperlukan:

- `Malam_Biasa` — durasi tidur pada malam biasa.
- `Malam_Ujian` — durasi tidur pada malam ujian.
- `Selisih` — selisih berpasangan yang digunakan untuk uji normalitas. Pastikan kolom ini dihitung dengan arah selisih yang konsisten dengan definisi analisis Anda.

Gunakan nilai numerik dalam jam dan pastikan nama kolom serta nama sheet sama persis, termasuk spasi, huruf besar/kecil, dan garis bawah. Hindari nilai kosong atau teks pada kolom yang dianalisis.

## Persyaratan

- R
- Paket R: `readxl`, `dplyr`, `ggplot2`, dan `car`

Pasang paket yang diperlukan dari konsol R:

```r
install.packages(c("readxl", "dplyr", "ggplot2", "car"))
```

## Cara Menjalankan

1. Unduh atau clone repository ini.
2. Letakkan `uji_test_tema_6.xlsx` di direktori kerja R, atau sesuaikan lokasi file pada perintah `read_excel()` di script.
3. Jika perlu, atur direktori kerja dengan menghapus komentar dan mengubah path pada baris `setwd()` di `R_uji_test_tema6.R`.
4. Jalankan script di RStudio atau dari terminal:

```bash
Rscript R_uji_test_tema6.R
```

Script akan mencetak hasil analisis ke konsol dan menyimpan grafik PNG pada direktori kerja saat ini.

## Hasil

Script menghasilkan ringkasan statistik dan pengujian untuk masing-masing sheet, antara lain ukuran sampel, rata-rata, median, simpangan baku, hasil Shapiro–Wilk, hasil Levene (Sheet2), hasil uji pembanding, metode yang dipilih, keputusan pada ambang signifikansi 0,05, dan kesimpulan.

Tiga file grafik yang dibuat:

- `grafik1_one_sample.png` — histogram durasi tidur harian dengan garis acuan 8 jam dan rata-rata.
- `grafik2_independent.png` — boxplot kelompok kafein dan non-kafein.
- `grafik3_paired.png` — boxplot malam biasa dan malam ujian.

## Catatan Metodologis

- Script memakai hasil Shapiro–Wilk dengan ambang `p > 0.05` untuk memilih uji parametrik; jika tidak, script memilih alternatif non-parametrik. Keputusan ini merupakan aturan praktis dalam script dan sebaiknya dipertimbangkan bersama ukuran sampel, grafik, pencilan, serta asumsi desain penelitian.
- Untuk kelompok independen, Mann–Whitney/Wilcoxon rank-sum tidak otomatis menguji perbedaan median kecuali asumsi bentuk distribusi yang sesuai terpenuhi.
- Uji t independen memakai `var.equal = TRUE` jika uji Levene tidak signifikan, dan Welch t-test jika varians dinilai tidak sama.
- Pada data berpasangan, pastikan setiap nilai malam biasa dan malam ujian berasal dari responden yang sama dan urutannya sejajar.
- Pastikan definisi dan arah kolom `Selisih` konsisten. Script menggunakan kolom ini untuk uji normalitas, sedangkan pengujian berpasangan dilakukan dari `Malam_Biasa` dan `Malam_Ujian`.
- Script ini ditujukan untuk analisis pembelajaran dan tidak menggantikan pertimbangan statistik dalam penelitian formal.

## Struktur Repository

```text
.
├── README.md
├── R_uji_test_tema6.R
└── uji_test_tema_6.xlsx  # data input; sediakan secara terpisah
```
