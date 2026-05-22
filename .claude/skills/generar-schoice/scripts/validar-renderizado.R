#!/usr/bin/env Rscript
# Uso: Rscript validar-renderizado.R <archivo.Rmd>
# Renderiza en 4 formatos: HTML, PDF, DOCX, NOPS

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] == "--help") {
  cat("Uso: Rscript validar-renderizado.R <archivo.Rmd>\n")
  cat("\n")
  cat("Renderiza un ejercicio .Rmd en los 4 formatos obligatorios:\n")
  cat("  - HTML (exams2html)\n")
  cat("  - PDF (exams2pdf)\n")
  cat("  - DOCX (exams2pandoc)\n")
  cat("  - NOPS (exams2nops)\n")
  cat("\n")
  cat("Retorna codigo de salida:\n")
  cat("  0 = Todos los formatos OK\n")
  cat("  1 = Uno o mas formatos fallaron\n")
  quit(status = 0)
}

archivo <- args[1]

if (!file.exists(archivo)) {
  cat("ERROR: Archivo no encontrado:", archivo, "\n")
  quit(status = 1)
}

suppressPackageStartupMessages(library(exams))

resultados <- list()
formatos <- list(
  html = function(f) exams2html(f, n = 1, encoding = "UTF-8"),
  pdf = function(f) exams2pdf(f, n = 1, encoding = "UTF-8"),
  pandoc = function(f) exams2pandoc(f, n = 1, type = "docx", encoding = "UTF-8"),
  nops = function(f) exams2nops(f, n = 1, encoding = "UTF-8")
)

for (fmt in names(formatos)) {
  tryCatch({
    formatos[[fmt]](archivo)
    resultados[[fmt]] <- "OK"
  }, error = function(e) {
    resultados[[fmt]] <<- paste("ERROR:", e$message)
  })
}

# Reporte
cat("\n")
cat("=== RESULTADOS DE VALIDACION ===\n")
cat("Archivo:", archivo, "\n")
cat("\n")

todos_ok <- TRUE
for (fmt in names(resultados)) {
  status <- if (resultados[[fmt]] == "OK") "OK" else "FALLO"
  if (status == "FALLO") todos_ok <- FALSE
  cat(sprintf("[%s] %s: %s\n", toupper(fmt), status, resultados[[fmt]]))
}

cat("\n")
if (todos_ok) {
  cat("RESULTADO: Todos los formatos compilaron correctamente\n")
  quit(status = 0)
} else {
  cat("RESULTADO: Uno o mas formatos fallaron\n")
  quit(status = 1)
}
