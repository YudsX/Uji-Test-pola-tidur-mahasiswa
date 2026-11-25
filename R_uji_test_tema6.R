# ============================================================
# ANALISIS UJI T-TEST, NON-PARAMETRIK, & VISUALISASI
# Sheet1: One Sample (Durasi Tidur Harian vs 8 Jam)
# Sheet2: Independent (Konsumsi Kafein vs Tidak)
# Sheet3: Paired (Malam Biasa vs Malam Ujian)
# Kelompok 6, Tema 6
# ============================================================

library(readxl)
library(dplyr)
library(ggplot2)
library(car)

# ---- Set working directory (hapus tanda # dan sesuaikan foldermu) ----
# setwd("C:/Users/NamaAnda/Documents/FolderAnda")

# ---- Baca data ----
data1 <- read_excel("uji_test_tema_6.xlsx", sheet = "Sheet1")
data2 <- read_excel("uji_test_tema_6.xlsx", sheet = "Sheet2")
data3 <- read_excel("uji_test_tema_6.xlsx", sheet = "Sheet3")

# ============================================================
# 1. ONE SAMPLE (Sheet1)
# ============================================================
tidur_harian <- as.numeric(data1$`Tidur Harian`)
mu0 <- 8

n1    <- length(tidur_harian)
mean1 <- mean(tidur_harian)
sd1   <- sd(tidur_harian)
med1  <- median(tidur_harian)

norm1   <- shapiro.test(tidur_harian)
hasil1  <- t.test(tidur_harian, mu = mu0, alternative = "two.sided", conf.level = 0.95)
wilcox1 <- wilcox.test(tidur_harian, mu = mu0, alternative = "two.sided",
                       conf.int = TRUE, exact = FALSE)

# Tentukan p-value utama berdasarkan hasil normalitas
is_norm1 <- norm1$p.value > 0.05
p_utama1 <- ifelse(is_norm1, hasil1$p.value, wilcox1$p.value)

# ============================================================
# 2. INDEPENDENT (Sheet2)
# ============================================================
kafein     <- as.numeric(data2$kafein)
non_kafein <- as.numeric(data2$non_kafein)

nA    <- length(kafein);     nB    <- length(non_kafein)
meanA <- mean(kafein);       meanB <- mean(non_kafein)
sdA   <- sd(kafein);         sdB   <- sd(non_kafein)
varA  <- var(kafein);        varB  <- var(non_kafein)
medA  <- median(kafein);     medB  <- median(non_kafein)

norm2A <- shapiro.test(kafein)
norm2B <- shapiro.test(non_kafein)

df_lev <- data.frame(
  durasi   = c(kafein, non_kafein),
  kelompok = factor(c(rep("Kafein", nA), rep("Non-Kafein", nB)))
)
lev2     <- leveneTest(durasi ~ kelompok, data = df_lev)
var_sama <- lev2$`Pr(>F)`[1] > 0.05

hasil2  <- t.test(kafein, non_kafein, var.equal = var_sama,
                  alternative = "two.sided", conf.level = 0.95)
wilcox2 <- wilcox.test(kafein, non_kafein, alternative = "two.sided",
                       conf.int = TRUE, exact = FALSE)

# Tentukan p-value utama berdasarkan hasil normalitas kedua kelompok
is_norm2 <- (norm2A$p.value > 0.05) & (norm2B$p.value > 0.05)
p_utama2 <- ifelse(is_norm2, hasil2$p.value, wilcox2$p.value)

# ============================================================
# 3. PAIRED (Sheet3)
# ============================================================
malam_biasa <- as.numeric(data3$Malam_Biasa)
malam_ujian <- as.numeric(data3$Malam_Ujian)
selisih     <- as.numeric(data3$Selisih)

nP    <- length(malam_biasa)
meanS <- mean(malam_biasa); sdS <- sd(malam_biasa); medS <- median(malam_biasa)
meanT <- mean(malam_ujian); sdT <- sd(malam_ujian); medT <- median(malam_ujian)
meanD <- mean(selisih);     sdD <- sd(selisih);     medD <- median(selisih)

norm3   <- shapiro.test(selisih)
hasil3  <- t.test(malam_biasa, malam_ujian, paired = TRUE,
                  alternative = "two.sided", conf.level = 0.95)
wilcox3 <- wilcox.test(malam_biasa, malam_ujian, paired = TRUE,
                       alternative = "two.sided", conf.int = TRUE, exact = FALSE)

# Tentukan p-value utama berdasarkan hasil normalitas selisih
is_norm3 <- norm3$p.value > 0.05
p_utama3 <- ifelse(is_norm3, hasil3$p.value, wilcox3$p.value)

# ============================================================
# 4. LAPORAN HASIL AKHIR (RINGKASAN & KESIMPULAN)
# ============================================================

# ---------- SHEET1 ----------
cat("\n>>> SHEET1 — ONE SAMPLE (Durasi Tidur Harian vs 8 Jam) <<<\n")
cat(sprintf("  n                 : %d\n", n1))
cat(sprintf("  Rata-rata (x̄)     : %.4f jam (Median = %.2f jam)\n", mean1, med1))
cat(sprintf("  Standar deviasi(s): %.4f jam\n", sd1))
cat(sprintf("  Nilai acuan (μ₀)  : %d jam\n", mu0))
cat(sprintf("  Uji normalitas    : W = %.4f, p = %.4g -> %s\n",
            norm1$statistic, norm1$p.value,
            ifelse(is_norm1, "Normal ✓", "Tidak Normal ✗")))
cat(sprintf("  Uji varians       : (tidak diperlukan untuk one-sample)\n"))
cat(sprintf("  t-test (pembanding): t = %.4f, df = %.0f, p = %.4g, 95%% CI [%.4f ; %.4f]\n",
            hasil1$statistic, hasil1$parameter, hasil1$p.value,
            hasil1$conf.int[1], hasil1$conf.int[2]))
cat(sprintf("  Wilcoxon (utama)  : V = %.4f, p = %.4g\n",
            wilcox1$statistic, wilcox1$p.value))
cat(sprintf("  Metode digunakan  : %s\n",
            ifelse(is_norm1, "One Sample t-test (Parametrik)", "One Sample Wilcoxon Signed-Rank (Non-Parametrik)")))
cat(sprintf("  Keputusan         : %s\n",
            ifelse(p_utama1 < 0.05, "TOLAK H₀", "GAGAL TOLAK H₀")))
cat(sprintf("  Kesimpulan        : Durasi tidur harian mahasiswa %s signifikan dari anjuran 8 jam per hari.\n",
            ifelse(p_utama1 < 0.05, "BERBEDA", "TIDAK BERBEDA")))

# ---------- SHEET2 ----------
cat("\n>>> SHEET2 — INDEPENDENT (Konsumsi Kafein vs Non-Kafein) <<<\n")
cat(sprintf("  Kafein     : n = %d | x̄ = %.4f | Median = %.2f | s = %.4f | s² = %.4f\n",
            nA, meanA, medA, sdA, varA))
cat(sprintf("  Non-Kafein : n = %d | x̄ = %.4f | Median = %.2f | s = %.4f | s² = %.4f\n",
            nB, meanB, medB, sdB, varB))
cat(sprintf("  Selisih rata-rata (x̄A - x̄B) : %.4f jam\n", meanA - meanB))
cat(sprintf("  Uji normalitas A  : W = %.4f, p = %.4g -> %s\n",
            norm2A$statistic, norm2A$p.value,
            ifelse(norm2A$p.value > 0.05, "Normal ✓", "Tidak Normal ✗")))
cat(sprintf("  Uji normalitas B  : W = %.4f, p = %.4g -> %s\n",
            norm2B$statistic, norm2B$p.value,
            ifelse(norm2B$p.value > 0.05, "Normal ✓", "Tidak Normal ✗")))
cat(sprintf("  Uji Levene (varians): F = %.4f, p = %.4f -> %s\n",
            lev2$`F value`[1], lev2$`Pr(>F)`[1],
            ifelse(var_sama, "Varians HOMOGEN ✓", "Varians TIDAK HOMOGEN ✗")))
cat(sprintf("  t-test (pembanding): t = %.4f, df = %.2f, p = %.4g, 95%% CI [%.4f ; %.4f]\n",
            hasil2$statistic, hasil2$parameter, hasil2$p.value,
            hasil2$conf.int[1], hasil2$conf.int[2]))
cat(sprintf("  Mann-Whitney (utama): W = %.4f, p = %.4g\n",
            wilcox2$statistic, wilcox2$p.value))
cat(sprintf("  Metode digunakan  : %s\n",
            ifelse(is_norm2, "Independent t-test (Parametrik)", "Mann-Whitney U (Non-Parametrik)")))
cat(sprintf("  Keputusan         : %s\n",
            ifelse(p_utama2 < 0.05, "TOLAK H₀", "GAGAL TOLAK H₀")))
cat(sprintf("  Kesimpulan        : Durasi tidur mahasiswa kelompok kafein dan non-kafein %s signifikan.\n",
            ifelse(p_utama2 < 0.05, "BERBEDA", "TIDAK BERBEDA")))

# ---------- SHEET3 ----------
cat("\n>>> SHEET3 — PAIRED (Malam Biasa vs Malam Ujian) <<<\n")
cat(sprintf("  Malam Biasa : n = %d | x̄ = %.4f jam | Median = %.2f jam | s = %.4f jam\n",
            nP, meanS, medS, sdS))
cat(sprintf("  Malam Ujian : n = %d | x̄ = %.4f jam | Median = %.2f jam | s = %.4f jam\n",
            nP, meanT, medT, sdT))
cat(sprintf("  Selisih (d) : n = %d | x̄d = %.4f jam | Median = %.2f jam | sd = %.4f jam\n",
            nP, meanD, medD, sdD))
cat(sprintf("  Uji normalitas selisih : W = %.4f, p = %.4g -> %s\n",
            norm3$statistic, norm3$p.value,
            ifelse(is_norm3, "Normal ✓", "Tidak Normal ✗")))
cat(sprintf("  Uji varians       : (tidak diperlukan untuk paired; fokus pada varians selisih)\n"))
cat(sprintf("  Varians selisih (sd²) : %.4f\n", sdD^2))
cat(sprintf("  t-test (pembanding): t = %.4f, df = %.0f, p = %.4g, 95%% CI [%.4f ; %.4f]\n",
            hasil3$statistic, hasil3$parameter, hasil3$p.value,
            hasil3$conf.int[1], hasil3$conf.int[2]))
cat(sprintf("  Wilcoxon (utama)  : V = %.4f, p = %.4g\n",
            wilcox3$statistic, wilcox3$p.value))
cat(sprintf("  Metode digunakan  : %s\n",
            ifelse(is_norm3, "Paired t-test (Parametrik)", "Paired Wilcoxon Signed-Rank (Non-Parametrik)")))
cat(sprintf("  Keputusan         : %s\n",
            ifelse(p_utama3 < 0.05, "TOLAK H₀", "GAGAL TOLAK H₀")))
cat(sprintf("  Kesimpulan        : Durasi tidur mahasiswa pada malam biasa vs malam ujian %s signifikan.\n",
            ifelse(p_utama3 < 0.05, "BERBEDA", "TIDAK BERBEDA")))

# ============================================================
# 5. VISUALISASI GRAFIK (GGPLOT2) & SIMPAN KE PNG
# ============================================================

# Grafik 1: Histogram One Sample
p1 <- ggplot(data.frame(tidur = tidur_harian), aes(x = tidur)) +
  geom_histogram(binwidth = 1, fill = "#4E79A7", color = "white", alpha = 0.85) +
  geom_vline(xintercept = mu0, color = "#E15759", linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = mean1, color = "#59A14F", linetype = "solid", linewidth = 1) +
  annotate("text", x = mu0 + 0.2, y = 16, label = "Anjuran (8 jam)", color = "#E15759", hjust = 0, fontface = "bold") +
  annotate("text", x = mean1 - 0.2, y = 14, label = sprintf("Mean (%.2f jam)", mean1), color = "#59A14F", hjust = 1, fontface = "bold") +
  labs(title = "Distribusi Durasi Tidur Harian Mahasiswa (n = 60)",
       x = "Durasi Tidur (Jam)", y = "Jumlah Responden") +
  theme_minimal()
print(p1)
ggsave("grafik1_one_sample.png", plot = p1, width = 7, height = 4.5, dpi = 300)

# Grafik 2: Boxplot Independent
p2 <- ggplot(df_lev, aes(x = kelompok, y = durasi, fill = kelompok)) +
  geom_boxplot(alpha = 0.8, width = 0.5, show.legend = FALSE) +
  scale_fill_manual(values = c("#F28E2B", "#4E79A7")) +
  labs(title = "Perbandingan Durasi Tidur: Kafein vs Non-Kafein",
       x = "Kelompok Responden", y = "Durasi Tidur (Jam)") +
  theme_minimal()
print(p2)
ggsave("grafik2_independent.png", plot = p2, width = 6.5, height = 4.5, dpi = 300)

# Grafik 3: Boxplot Paired
df_paired <- data.frame(
  kondisi = factor(c(rep("Malam Biasa", nP), rep("Malam Ujian", nP)),
                   levels = c("Malam Biasa", "Malam Ujian")),
  durasi  = c(malam_biasa, malam_ujian)
)
p3 <- ggplot(df_paired, aes(x = kondisi, y = durasi, fill = kondisi)) +
  geom_boxplot(alpha = 0.8, width = 0.5, show.legend = FALSE) +
  scale_fill_manual(values = c("#59A14F", "#E15759")) +
  labs(title = "Perbandingan Durasi Tidur: Malam Biasa vs Malam Ujian (n = 60)",
       x = "Kondisi", y = "Durasi Tidur (Jam)") +
  theme_minimal()
print(p3)
ggsave("grafik3_paired.png", plot = p3, width = 6.5, height = 4.5, dpi = 300)

### SELESAI ###