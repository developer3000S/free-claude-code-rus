#!/usr/bin/env Rscript
# Uso: Rscript diagnosticar-error.R <archivo.Rmd> [mensaje_error]
# Diagnostica errores en un archivo .Rmd

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] == "--help") {
  cat("Uso: Rscript diagnosticar-error.R <archivo.Rmd> [mensaje_error]\n")
  cat("\n")
  cat("Diagnostica errores en un ejercicio .Rmd.\n")
  cat("\n")
  cat("Argumentos:\n")
  cat("  archivo.Rmd    Archivo del ejercicio a diagnosticar\n")
  cat("  mensaje_error  Opcional: mensaje de error a analizar\n")
  cat("\n")
  cat("Categorias de error:\n")
  cat("  ERR_G* = Graficos\n")
  cat("  ERR_T* = Texto/LaTeX\n")
  cat("  ERR_S* = Estructura\n")
  cat("  ERR_C* = Coherencia\n")
  quit(status = 0)
}

archivo <- args[1]
mensaje_error <- if (length(args) >= 2) args[2] else ""

diagnosticar_error <- function(mensaje, archivo_rmd = NULL) {

  # Graficos
  if (grepl("File.*\\.png.*not found|include_tikz.*failed", mensaje, ignore.case = TRUE)) {
    return(list(codigo = "ERR_G1", categoria = "GRAFICOS", prioridad = "ALTA",
                descripcion = "Graficas no visualizadas",
                solucion = "Usar renderizado condicional con is_latex_output()"))
  }

  # LaTeX
  if (grepl("LaTeX Error|! Undefined control sequence|! Missing", mensaje)) {
    return(list(codigo = "ERR_T1", categoria = "TEXTO", prioridad = "CRITICA",
                descripcion = "LaTeX no compila",
                solucion = "Revisar header-includes y sintaxis LaTeX"))
  }

  # Encoding
  if (grepl("invalid multibyte|UTF-8|encoding", mensaje, ignore.case = TRUE)) {
    return(list(codigo = "ERR_T2", categoria = "TEXTO", prioridad = "MEDIA",
                descripcion = "Encoding incorrecto",
                solucion = "Agregar encoding = 'UTF-8' en exams2*()"))
  }

  # Variables R
  if (grepl("object.*not found|Error in eval", mensaje)) {
    variable <- sub(".*object '(.*)' not found.*", "\\1", mensaje)
    return(list(codigo = "ERR_C3", categoria = "COHERENCIA", prioridad = "CRITICA",
                descripcion = sprintf("Variable '%s' no definida", variable),
                solucion = "Verificar que variable esta en generar_datos() y se retorna"))
  }

  # CLOZE NOPS
  if (grepl("exercise type 'cloze'.*not supported", mensaje, ignore.case = TRUE)) {
    return(list(codigo = "ERR_S5", categoria = "ESTRUCTURA", prioridad = "BAJA",
                descripcion = "CLOZE incompatible con NOPS",
                solucion = "Esperado - NOPS no soporta CLOZE con num/string"))
  }

  # Non-numeric
  if (grepl("non-numeric argument|NaN produced", mensaje)) {
    return(list(codigo = "ERR_C3", categoria = "COHERENCIA", prioridad = "ALTA",
                descripcion = "Operacion con valores no numericos",
                solucion = "Usar variable numerica original, no formateada"))
  }

  # Analisis de archivo si existe
  if (!is.null(archivo_rmd) && file.exists(archivo_rmd)) {
    contenido <- readLines(archivo_rmd, warn = FALSE)

    if (!any(grepl("^exname:", contenido))) {
      return(list(codigo = "ERR_T3", categoria = "TEXTO", prioridad = "CRITICA",
                  descripcion = "Metadatos faltantes (exname)",
                  solucion = "Agregar seccion Meta-information completa"))
    }

    answerlist_lines <- grep("^\\* ", contenido, value = TRUE)
    if (length(answerlist_lines) < 4) {
      return(list(codigo = "ERR_S1", categoria = "ESTRUCTURA", prioridad = "ALTA",
                  descripcion = sprintf("Solo %d opciones (minimo 4)", length(answerlist_lines)),
                  solucion = "Agregar opciones hasta tener minimo 4"))
    }
  }

  # No clasificado
  return(list(codigo = "ERR_X", categoria = "DESCONOCIDO", prioridad = "MEDIA",
              descripcion = "Error no clasificado",
              solucion = "Revisar log completo y patrones-errores-conocidos.md"))
}

# Ejecutar diagnostico
if (file.exists(archivo) || nchar(mensaje_error) > 0) {
  diag <- diagnosticar_error(mensaje_error, archivo)

  cat("\n")
  cat("=== DIAGNOSTICO ===\n")
  cat(sprintf("Codigo: %s\n", diag$codigo))
  cat(sprintf("Categoria: %s\n", diag$categoria))
  cat(sprintf("Prioridad: %s\n", diag$prioridad))
  cat(sprintf("Descripcion: %s\n", diag$descripcion))
  cat(sprintf("Solucion: %s\n", diag$solucion))
  cat("\n")

  if (diag$prioridad == "CRITICA") {
    quit(status = 2)
  } else if (diag$prioridad == "ALTA") {
    quit(status = 1)
  } else {
    quit(status = 0)
  }
} else {
  cat("ERROR: Archivo no encontrado:", archivo, "\n")
  quit(status = 1)
}
