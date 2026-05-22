#!/usr/bin/env Rscript
# Uso: Rscript test-diversidad.R <archivo.Rmd> [n_intentos]
# Valida que el ejercicio genere 250+ versiones unicas de n_intentos

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] == "--help") {
  cat("Uso: Rscript test-diversidad.R <archivo.Rmd> [n_intentos]\n")
  cat("\n")
  cat("Valida diversidad de versiones de un ejercicio SCHOICE.\n")
  cat("\n")
  cat("Argumentos:\n")
  cat("  archivo.Rmd   Archivo del ejercicio a validar\n")
  cat("  n_intentos    Numero de versiones a generar (default: 300)\n")
  cat("\n")
  cat("Requisitos:\n")
  cat("  - El archivo debe tener una funcion generar_datos()\n")
  cat("  - Minimo 250 versiones unicas de 300 intentos (83%)\n")
  cat("\n")
  cat("Retorna codigo de salida:\n")
  cat("  0 = Diversidad suficiente (>= 250)\n")
  cat("  1 = Diversidad insuficiente (< 250)\n")
  quit(status = 0)
}

archivo <- args[1]
n_intentos <- if (length(args) >= 2) as.integer(args[2]) else 300

if (!file.exists(archivo)) {
  cat("ERROR: Archivo no encontrado:", archivo, "\n")
  quit(status = 1)
}

# Extraer y ejecutar solo el chunk data_generation
contenido <- readLines(archivo, warn = FALSE)

# Buscar inicio y fin del chunk data_generation
inicio <- grep("```\\{r.*data_generation", contenido)
if (length(inicio) == 0) {
  cat("ERROR: No se encontro chunk 'data_generation' en el archivo\n")
  quit(status = 1)
}

# Encontrar el cierre del chunk
fin <- inicio[1]
for (i in (inicio[1] + 1):length(contenido)) {
  if (grepl("^```$", contenido[i])) {
    fin <- i
    break
  }
}

# Extraer codigo R
codigo_r <- contenido[(inicio[1] + 1):(fin - 1)]
codigo_r <- paste(codigo_r, collapse = "\n")

# Ejecutar en entorno aislado
env <- new.env()
tryCatch({
  eval(parse(text = codigo_r), envir = env)
}, error = function(e) {
  cat("ERROR al ejecutar data_generation:", e$message, "\n")
  quit(status = 1)
})

if (!exists("generar_datos", envir = env)) {
  cat("ERROR: No se encontro funcion generar_datos() en el chunk\n")
  quit(status = 1)
}

generar_datos <- get("generar_datos", envir = env)

# Generar versiones
cat("Generando", n_intentos, "versiones...\n")

versiones <- replicate(n_intentos, {
  datos <- generar_datos()
  # Crear hash de todos los valores
  paste(unlist(datos), collapse = "_")
}, simplify = TRUE)

n_unicas <- length(unique(versiones))
porcentaje <- round(100 * n_unicas / n_intentos, 1)

cat("\n")
cat("=== RESULTADO TEST DIVERSIDAD ===\n")
cat("Archivo:", archivo, "\n")
cat("Intentos:", n_intentos, "\n")
cat("Versiones unicas:", n_unicas, "\n")
cat("Porcentaje:", porcentaje, "%\n")
cat("\n")

if (n_unicas >= 250) {
  cat("APROBADO: Diversidad suficiente\n")
  quit(status = 0)
} else {
  cat("RECHAZADO: Menos de 250 versiones unicas\n")
  cat("Sugerencia: Ampliar rangos en sample() dentro de generar_datos()\n")
  quit(status = 1)
}
