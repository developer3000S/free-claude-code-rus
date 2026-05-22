#!/usr/bin/env Rscript
# Uso: Rscript validar-coherencia.R <archivo.Rmd>
# Valida los 4 tipos de coherencia: matematica, imagen-texto, codigo, metadatos

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] == "--help") {
  cat("Uso: Rscript validar-coherencia.R <archivo.Rmd>\n")
  cat("\n")
  cat("Valida los 4 tipos de coherencia de un ejercicio:\n")
  cat("  1. Coherencia Matematica (ERR_C1)\n")
  cat("  2. Coherencia Imagen-Texto (ERR_C2)\n")
  cat("  3. Coherencia de Codigo (ERR_C3)\n")
  cat("  4. Coherencia de Metadatos (ERR_C4)\n")
  cat("\n")
  cat("Retorna codigo de salida:\n")
  cat("  0 = Todas las coherencias OK\n")
  cat("  1 = Una o mas coherencias fallaron\n")
  quit(status = 0)
}

archivo <- args[1]

if (!file.exists(archivo)) {
  cat("ERROR: Archivo no encontrado:", archivo, "\n")
  quit(status = 1)
}

contenido <- readLines(archivo, warn = FALSE, encoding = "UTF-8")

errores <- list(
  matematica = c(),
  imagen_texto = c(),
  codigo = c(),
  metadatos = c()
)

# 1. Validar metadatos
obligatorios <- c("exname", "extype", "exsolution", "exshuffle")
for (campo in obligatorios) {
  if (!any(grepl(paste0("^", campo, ":"), contenido))) {
    errores$metadatos <- c(errores$metadatos, paste("Falta", campo))
  }
}

icfes <- c("Type", "Competencia", "Componente", "Afirmacion", "Evidencia", "Nivel")
for (campo in icfes) {
  if (!any(grepl(paste0("^exextra\\[", campo, "\\]:"), contenido))) {
    errores$metadatos <- c(errores$metadatos, paste("Falta exextra[", campo, "]", sep = ""))
  }
}

# Verificar exsolution vs Answerlist
exsolution_linea <- contenido[grep("^exsolution:", contenido)]
answerlist_items <- grep("^\\* ", contenido, value = TRUE)

if (length(exsolution_linea) > 0 && length(answerlist_items) > 0) {
  exsolution <- sub("^exsolution:\\s*", "", exsolution_linea[1])
  if (grepl("^[01]+$", exsolution)) {
    if (nchar(exsolution) != length(answerlist_items)) {
      errores$metadatos <- c(errores$metadatos,
        sprintf("exsolution (%d) != Answerlist (%d)",
                nchar(exsolution), length(answerlist_items)))
    }
  }
}

# 2. Validar coherencia de codigo
patron_func_format <- "(abs|sqrt|round|floor|ceiling)\\([^)]*formateado"
lineas_func_format <- grep(patron_func_format, contenido, value = TRUE)
if (length(lineas_func_format) > 0) {
  errores$codigo <- c(errores$codigo, "Funcion matematica sobre variable formateada")
}

# Detectar variables TikZ hardcodeadas
patron_tikz_hard <- "\\\\def\\\\[a-zA-Z]+\\{[0-9.-]+\\}"
lineas_tikz_hard <- grep(patron_tikz_hard, contenido, value = TRUE)
if (length(lineas_tikz_hard) > 0) {
  errores$imagen_texto <- c(errores$imagen_texto, "Variables TikZ hardcodeadas (usar paste0)")
}

# 3. Validar exshuffle
if (any(grepl("^exshuffle:\\s*FALSE", contenido, ignore.case = TRUE))) {
  errores$metadatos <- c(errores$metadatos, "exshuffle debe ser TRUE")
}

# Generar reporte
cat("\n")
cat("=== VALIDACION DE COHERENCIA - FASE 2 ===\n")
cat("Archivo:", archivo, "\n")
cat("\n")

tipos <- c("matematica", "imagen_texto", "codigo", "metadatos")
nombres <- c("Matematica (ERR_C1)", "Imagen-Texto (ERR_C2)",
             "Codigo (ERR_C3)", "Metadatos (ERR_C4)")

todos_ok <- TRUE
for (i in seq_along(tipos)) {
  n_err <- length(errores[[tipos[i]]])
  status <- if (n_err == 0) "OK" else sprintf("ERRORES (%d)", n_err)
  cat(sprintf("[%s] %s\n", nombres[i], status))

  if (n_err > 0) {
    todos_ok <- FALSE
    for (err in errores[[tipos[i]]]) {
      cat(sprintf("  -> %s\n", err))
    }
  }
}

cat("\n")
total_errores <- sum(sapply(errores, length))

if (todos_ok) {
  cat("RESULTADO: APROBADO - Sin errores de coherencia\n")
  cat("Siguiente: Aprobar para produccion si FASE 1 tambien paso\n")
  quit(status = 0)
} else {
  cat(sprintf("RESULTADO: REQUIERE CORRECCION - %d errores\n", total_errores))
  cat("Siguiente: FASE 3 (diagnosticar-errores)\n")
  quit(status = 1)
}
