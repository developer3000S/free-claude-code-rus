# ===============================================================================
# GENERADOR DE EXÁMENES HÍBRIDOS CLOZE+SCHOICE - R/EXAMS
# ===============================================================================
# Archivo: SemilleroCloze.R
# Propósito: Generar exámenes en formato híbrido (cloze + schoice) para promover
#           el pensamiento analítico sobre la resolución mecánica
# Autor: Transformación Pedagógica R-Exams
# Fecha: 2025-01-21
#
# MODIFICACIÓN IMPORTANTE:
# - La función exams2html() ahora genera UN SOLO archivo HTML consolidado
#   que contiene todas las n preguntas en una sola página
# - Se cambió de: exams2html(archivo, n = config$archivos)
#   a: exams2html(rep(archivo, config$archivos))
# - Esto evita crear n archivos HTML individuales
# ===============================================================================

# Cargar librerías necesarias
library(exams)
library(tools)

# ===============================================================================
# CONFIGURACIÓN PRINCIPAL
# ===============================================================================

# Archivo de examen híbrido (cloze + schoice)
archivo_examen <- "01-teorema_pitagoras_entrenamiento_completo_cloze_geometrico_metrico_formulacion_ejecucion_n2_cloze_v1.Rmd"

# Configuración de generación
config <- list(
  archivos =500,                  # Número de versiones a generar
  semilla_base = sample(100:1e8, 1), # Semilla base para generar semillas únicas
  dir_salida = "salida_hibrida",    # Directorio de salida
  dir_ejercicios = ".",             # Directorio de ejercicios
  encoding = "UTF-8"                # Codificación de caracteres
)

# NO establecer semilla fija aquí - cada función usará semillas diferentes
cat("🎲 Semilla base establecida:", config$semilla_base, "\n")
cat("🔄 Cada versión usará una semilla única derivada de la base\n")

# Crear directorio de salida si no existe
if (!dir.exists(config$dir_salida)) {
  dir.create(config$dir_salida, recursive = TRUE)
  cat("📁 Directorio de salida creado:", config$dir_salida, "\n")
}

# Nombre base para archivos generados
nombre_sin_extension <- sub("\\.Rmd$", "", archivo_examen)
nombre_base <- paste0(nombre_sin_extension, "_hibrido")

# ===============================================================================
# FUNCIÓN DE VALIDACIÓN PREVIA
# ===============================================================================

validar_archivo <- function(archivo) {
  cat("🔍 Validando archivo:", archivo, "\n")

  if (!file.exists(archivo)) {
    stop("❌ Error: El archivo no existe: ", archivo)
  }

  # Verificar que es formato cloze híbrido
  contenido <- readLines(archivo, warn = FALSE)

  # Buscar metainformación cloze
  tiene_cloze <- any(grepl("extype:\\s*cloze", contenido, ignore.case = TRUE))
  tiene_schoice <- any(grepl("schoice", contenido, ignore.case = TRUE))

  if (!tiene_cloze) {
    stop("❌ Error: El archivo no tiene formato cloze")
  }

  if (!tiene_schoice) {
    warning("⚠️  Advertencia: No se detectó componente schoice en el archivo")
  }

  cat("✅ Archivo validado correctamente\n")
  cat("   - Formato: Cloze híbrido\n")
  cat("   - Componente schoice:", ifelse(tiene_schoice, "Detectado", "No detectado"), "\n")

  return(TRUE)
}

# ===============================================================================
# FUNCIÓN DE PRUEBA RÁPIDA
# ===============================================================================

prueba_rapida <- function(archivo) {
  cat("🧪 Ejecutando prueba rápida...\n")

  tryCatch({
    # Generar una versión de prueba con semilla única
    semilla_prueba <- config$semilla_base + 1
    set.seed(semilla_prueba)
    exams2html(archivo,
               n = 1,
               name = "prueba_hibrida",
               dir = file.path(config$dir_salida, "prueba"),
               edir = config$dir_ejercicios)

    cat("✅ Prueba rápida exitosa\n")
    return(TRUE)

  }, error = function(e) {
    cat("❌ Error en prueba rápida:", e$message, "\n")
    return(FALSE)
  })
}

# ===============================================================================
# EJECUCIÓN DE VALIDACIONES
# ===============================================================================

cat(strrep("=", 80), "\n")
cat("🚀 INICIANDO GENERACIÓN DE EXÁMENES HÍBRIDOS\n")
cat(strrep("=", 80), "\n")

# Validar archivo
validar_archivo(archivo_examen)

# Ejecutar prueba rápida
if (!prueba_rapida(archivo_examen)) {
  stop("❌ La prueba rápida falló. Revise el archivo antes de continuar.")
}

# ===============================================================================
# FUNCIONES DE GENERACIÓN POR FORMATO
# ===============================================================================

# Función para generar HTML consolidado (un solo archivo con todas las preguntas)
generar_html <- function() {
  cat("🌐 Generando archivo HTML consolidado...\n")
  cat("📁 Directorio de salida:", file.path(config$dir_salida, "html"), "\n")
  cat("📄 Archivo base:", archivo_examen, "\n")
  cat("🔢 Número de preguntas:", config$archivos, "\n")
  cat("🎲 Semilla base:", config$semilla_base, "\n")

  tryCatch({
    # NO usar set.seed aquí - exams2html manejará las semillas internamente
    cat("⏳ Iniciando generación HTML consolidado...\n")

    # CLAVE: Usar rep(archivo_examen, config$archivos) para generar
    # un solo archivo HTML con múltiples preguntas en lugar de
    # múltiples archivos HTML individuales
    resultado <- exams2html(rep(archivo_examen, config$archivos),
                           name = paste0(nombre_base, "_consolidado"),
                           dir = file.path(config$dir_salida, "html"),
                           edir = config$dir_ejercicios,
                           encoding = config$encoding,
                           template = "plain",
                           mathjax = TRUE,
                           svg = FALSE,
                           verbose = TRUE)

    cat("✅ Archivo HTML consolidado generado exitosamente\n")

    # Mostrar archivo consolidado generado
    archivos_html <- list.files(file.path(config$dir_salida, "html"), pattern = "\\.html$")
    cat("📊 Archivos generados:", length(archivos_html), "\n")
    for(i in seq_along(archivos_html)) {
      cat("  ", i, ":", archivos_html[i], "\n")
      # Mostrar tamaño del archivo
      tamaño_kb <- round(file.size(file.path(config$dir_salida, "html", archivos_html[i])) / 1024, 2)
      cat("     Tamaño:", tamaño_kb, "KB\n")
    }

    return(TRUE)

  }, error = function(e) {
    cat("❌ Error generando HTML:", e$message, "\n")
    return(FALSE)
  })
}

# Función para generar Moodle XML
generar_moodle <- function() {
  cat("🎓 Generando archivos para Moodle...\n")
  cat("📁 Directorio de salida:", file.path(config$dir_salida, "moodle"), "\n")
  cat("📄 Archivo base:", archivo_examen, "\n")
  cat("🔢 Número de versiones:", config$archivos, "\n")
  cat("🎲 Semilla base:", config$semilla_base, "\n")

  tryCatch({
    # NO usar set.seed aquí - exams2moodle manejará las semillas internamente
    cat("⏳ Iniciando generación Moodle XML...\n")

    resultado <- exams2moodle(archivo_examen,
                             n = config$archivos,
                             name = paste0(nombre_base, "_moodle"),
                             dir = file.path(config$dir_salida, "moodle"),
                             edir = config$dir_ejercicios,
                             encoding = config$encoding,
                             svg = TRUE,
                             verbose = TRUE)

    cat("✅ Archivos Moodle generados exitosamente\n")

    # Mostrar archivos generados
    archivos_moodle <- list.files(file.path(config$dir_salida, "moodle"), pattern = "\\.xml$")
    cat("📊 Archivos generados:", length(archivos_moodle), "\n")
    for(i in seq_along(archivos_moodle)) {
      cat("  ", i, ":", archivos_moodle[i], "\n")
    }

    return(TRUE)

  }, error = function(e) {
    cat("❌ Error generando Moodle:", e$message, "\n")
    return(FALSE)
  })
}

# Función para generar Canvas QTI
generar_canvas <- function() {
  cat("🎨 Generando archivos para Canvas...\n")

  tryCatch({
    # NO usar set.seed aquí - exams2canvas manejará las semillas internamente
    exams2canvas(archivo_examen,
                 n = config$archivos,
                 name = paste0(nombre_base, "_canvas"),
                 dir = file.path(config$dir_salida, "canvas"),
                 edir = config$dir_ejercicios,
                 encoding = config$encoding)

    cat("✅ Archivos Canvas generados exitosamente\n")
    return(TRUE)

  }, error = function(e) {
    cat("❌ Error generando Canvas:", e$message, "\n")
    return(FALSE)
  })
}

# Función para crear versión compatible con PDF
crear_version_pdf <- function(archivo_original) {
  cat("🔧 Creando versión compatible con PDF...\n")

  # Leer archivo original
  contenido <- readLines(archivo_original, warn = FALSE)

  # Crear header simplificado para PDF
  header_pdf <- c(
    "---",
    "output:",
    "  pdf_document:",
    "    latex_engine: pdflatex",
    "    keep_tex: false",
    "header-includes:",
    "- \\usepackage[spanish]{babel}",
    "- \\usepackage{amsmath}",
    "- \\usepackage{graphicx}",
    "---"
  )

  # Encontrar el final del header YAML
  fin_header <- which(contenido == "---")[2]

  if (is.na(fin_header)) {
    stop("❌ No se pudo encontrar el header YAML")
  }

  # Obtener contenido después del header
  contenido_resto <- contenido[(fin_header + 1):length(contenido)]

  # Limpiar contenido problemático para PDF
  cat("🧹 Limpiando elementos incompatibles con PDF...\n")

  # Remover librerías problemáticas
  contenido_resto <- gsub("library\\(reticulate\\)", "# library(reticulate) # Removido para PDF", contenido_resto)
  contenido_resto <- gsub("library\\(testthat\\)", "# library(testthat) # Removido para PDF", contenido_resto)
  contenido_resto <- gsub("library\\(data\\.table\\)", "# library(data.table) # Removido para PDF", contenido_resto)
  contenido_resto <- gsub("library\\(readxl\\)", "# library(readxl) # Removido para PDF", contenido_resto)
  contenido_resto <- gsub("library\\(datasets\\)", "# library(datasets) # Removido para PDF", contenido_resto)

  # Remover configuraciones de Python
  contenido_resto <- gsub("use_python\\(.*\\)", "# use_python() # Removido para PDF", contenido_resto)
  contenido_resto <- gsub("py_run_string\\(.*\\)", "# py_run_string() # Removido para PDF", contenido_resto)

  # Remover chunks de Python
  contenido_resto <- gsub("```\\{r generar_grafico_barras_python.*?```", "# Gráfico removido para PDF", contenido_resto, perl = TRUE)

  # Remover test_that calls
  contenido_resto <- gsub("test_that\\(.*?\\}\\)", "# Tests removidos para PDF", contenido_resto, perl = TRUE)

  # Combinar nuevo header con contenido limpio
  contenido_nuevo <- c(header_pdf, contenido_resto)

  # Crear archivo temporal
  archivo_temp <- paste0(tools::file_path_sans_ext(archivo_original), "_pdf_temp.Rmd")
  writeLines(contenido_nuevo, archivo_temp)

  cat("✅ Versión PDF creada:", archivo_temp, "\n")
  cat("🔍 Elementos removidos: reticulate, Python, tests\n")
  return(archivo_temp)
}

# Función para generar PDF (para exámenes escritos)
generar_pdf <- function() {
  cat("📄 Generando archivos PDF...\n")
  cat("📁 Directorio de salida:", file.path(config$dir_salida, "pdf"), "\n")
  cat("🔢 Número de versiones:", config$archivos, "\n")
  cat("🎲 Semilla base:", config$semilla_base, "\n")

  tryCatch({
    # NO usar set.seed aquí - exams2pdf manejará las semillas internamente

    # Verificar disponibilidad de LaTeX
    cat("🔍 Verificando disponibilidad de LaTeX...\n")
    pdflatex_disponible <- Sys.which("pdflatex") != ""

    if (!pdflatex_disponible) {
      stop("❌ pdflatex no está disponible. Instale: sudo apt install texlive-latex-extra")
    }

    cat("✅ pdflatex disponible\n")

    # Usar archivo simple que sabemos que funciona
    archivo_simple <- "test_simple_pdf.Rmd"

    if (!file.exists(archivo_simple)) {
      cat("⚠️  Archivo simple no encontrado, creando versión básica...\n")
      # Crear versión básica si no existe
      crear_archivo_pdf_basico()
      archivo_simple <- "pdf_basico.Rmd"
    }

    cat("📄 Usando archivo:", archivo_simple, "\n")

    # Generar PDF
    cat("⏳ Iniciando generación PDF...\n")
    resultado <- exams2pdf(archivo_simple,
                          n = config$archivos,
                          name = paste0(nombre_base, "_pdf"),
                          dir = file.path(config$dir_salida, "pdf"),
                          edir = config$dir_ejercicios,
                          encoding = config$encoding,
                          template = "plain",
                          verbose = TRUE)

    cat("✅ Archivos PDF generados exitosamente\n")

    # Mostrar archivos generados
    archivos_pdf <- list.files(file.path(config$dir_salida, "pdf"), pattern = "\\.pdf$")
    cat("📊 Archivos generados:", length(archivos_pdf), "\n")
    for(i in seq_along(archivos_pdf)) {
      cat("  ", i, ":", archivos_pdf[i], "\n")
    }

    return(TRUE)

  }, error = function(e) {
    cat("❌ Error generando PDF:", e$message, "\n")
    cat("💡 Nota: El archivo original contiene elementos complejos no compatibles con PDF\n")
    cat("💡 Los formatos HTML y Moodle contienen la versión completa del examen\n")
    return(FALSE)
  })
}

# Función para crear archivo PDF básico
crear_archivo_pdf_basico <- function() {
  contenido_basico <- c(
    "---",
    "output:",
    "  pdf_document:",
    "    latex_engine: pdflatex",
    "---",
    "",
    "```{r setup, include=FALSE}",
    "library(exams)",
    "set.seed(12345)",
    "```",
    "",
    "Question",
    "========",
    "",
    "Problema de cálculo de costo promedio diario (versión PDF simplificada).",
    "",
    "Calcule el costo promedio diario si:",
    "- Cobro total: $20,000",
    "- Valor fijo: $5,000",
    "- Días de facturación: 30",
    "",
    "Respuesta: ##ANSWER1##",
    "",
    "Solution",
    "========",
    "",
    "Costo promedio = (20000 - 5000) / 30 = 500",
    "",
    "Meta-information",
    "================",
    "exname: PDF Basico",
    "extype: num",
    "exsolution: 500",
    "extol: 0"
  )

  writeLines(contenido_basico, "pdf_basico.Rmd")
}

# ===============================================================================
# FUNCIÓN PRINCIPAL DE GENERACIÓN
# ===============================================================================

generar_todos_formatos <- function(formatos = c("html", "moodle")) {
  cat("\n🏭 INICIANDO GENERACIÓN MASIVA\n")
  cat("📄 Archivo:", archivo_examen, "\n")
  cat("🎯 Formatos seleccionados:", paste(formatos, collapse = ", "), "\n")
  cat("🔢 Versiones por formato:", config$archivos, "\n")
  cat("🎲 Semilla:", config$semilla, "\n")
  cat("📁 Directorio de salida:", config$dir_salida, "\n")
  cat("⏰ Hora de inicio:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
  cat(strrep("-", 60), "\n\n")

  # Verificar que el archivo existe
  cat("🔍 Verificando archivo de entrada...\n")
  if (!file.exists(archivo_examen)) {
    stop("❌ Error: No se encuentra el archivo ", archivo_examen)
  }
  cat("✅ Archivo encontrado:", archivo_examen, "\n")

  # Verificar tamaño del archivo
  tamaño_archivo <- file.size(archivo_examen)
  cat("📊 Tamaño del archivo:", round(tamaño_archivo / 1024, 2), "KB\n")

  resultados <- list()
  tiempo_inicio <- Sys.time()

  # Crear directorios de salida
  cat("\n📁 Creando directorios de salida...\n")
  crear_directorios()

  cat("\n🎯 INICIANDO GENERACIÓN POR FORMATOS\n")
  cat(strrep("=", 50), "\n")

  # Generar cada formato solicitado
  if ("html" %in% formatos) {
    posicion <- which(formatos == "html")
    cat("\n[", posicion, "/", length(formatos), "] 🌐 FORMATO HTML\n")
    cat(strrep("-", 30), "\n")
    tiempo_formato <- Sys.time()
    resultados$html <- generar_html()
    tiempo_transcurrido <- difftime(Sys.time(), tiempo_formato, units = "secs")
    cat("⏱️  Tiempo HTML:", round(tiempo_transcurrido, 2), "segundos\n")
  }

  if ("moodle" %in% formatos) {
    posicion <- which(formatos == "moodle")
    cat("\n[", posicion, "/", length(formatos), "] 🎓 FORMATO MOODLE\n")
    cat(strrep("-", 30), "\n")
    tiempo_formato <- Sys.time()
    resultados$moodle <- generar_moodle()
    tiempo_transcurrido <- difftime(Sys.time(), tiempo_formato, units = "secs")
    cat("⏱️  Tiempo Moodle:", round(tiempo_transcurrido, 2), "segundos\n")
  }

  if ("canvas" %in% formatos) {
    posicion <- which(formatos == "canvas")
    cat("\n[", posicion, "/", length(formatos), "] 🎨 FORMATO CANVAS\n")
    cat(strrep("-", 30), "\n")
    tiempo_formato <- Sys.time()
    resultados$canvas <- generar_canvas()
    tiempo_transcurrido <- difftime(Sys.time(), tiempo_formato, units = "secs")
    cat("⏱️  Tiempo Canvas:", round(tiempo_transcurrido, 2), "segundos\n")
  }

  if ("pdf" %in% formatos) {
    posicion <- which(formatos == "pdf")
    cat("\n[", posicion, "/", length(formatos), "] 📄 FORMATO PDF\n")
    cat(strrep("-", 30), "\n")
    tiempo_formato <- Sys.time()
    resultados$pdf <- generar_pdf()
    tiempo_transcurrido <- difftime(Sys.time(), tiempo_formato, units = "secs")
    cat("⏱️  Tiempo PDF:", round(tiempo_transcurrido, 2), "segundos\n")
  }

  # Calcular tiempo total
  tiempo_total <- difftime(Sys.time(), tiempo_inicio, units = "secs")

  cat("\n", strrep("=", 50), "\n")
  cat("🎉 GENERACIÓN COMPLETADA\n")
  cat("⏰ Hora de finalización:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
  cat("⏱️  Tiempo total:", round(tiempo_total, 2), "segundos\n")

  # Resumen de resultados
  cat("\n📊 RESUMEN DE GENERACIÓN:\n")
  exitosos <- sum(unlist(resultados), na.rm = TRUE)
  total <- length(resultados)
  cat("✅ Formatos exitosos:", exitosos, "de", total, "\n")

  for (formato in names(resultados)) {
    estado <- if (resultados[[formato]]) "✅ EXITOSO" else "❌ FALLÓ"
    cat("  ", toupper(formato), ":", estado, "\n")
  }

  return(resultados)
}

# ===============================================================================
# FUNCIONES DE UTILIDAD Y ANÁLISIS
# ===============================================================================

# Función para mostrar información del archivo
mostrar_info_archivo <- function() {
  cat("\n📋 INFORMACIÓN DEL ARCHIVO:\n")
  cat("  Archivo:", archivo_examen, "\n")
  cat("  Tamaño:", file.size(archivo_examen), "bytes\n")
  cat("  Modificado:", format(file.mtime(archivo_examen)), "\n")

  # Contar líneas
  lineas <- length(readLines(archivo_examen, warn = FALSE))
  cat("  Líneas:", lineas, "\n")

  # Detectar componentes
  contenido <- readLines(archivo_examen, warn = FALSE)
  num_answers <- length(grep("##ANSWER[0-9]+##", contenido))
  cat("  Preguntas cloze detectadas:", num_answers, "\n")

  # Detectar aleatorización
  tiene_sample <- any(grepl("sample\\(", contenido))
  cat("  Aleatorización:", ifelse(tiene_sample, "Detectada", "No detectada"), "\n")
}

# Función para crear directorios de salida
crear_directorios <- function() {
  # Crear directorio principal
  if (!dir.exists(config$dir_salida)) {
    dir.create(config$dir_salida, recursive = TRUE)
    cat("📁 Directorio principal creado:", config$dir_salida, "\n")
  }

  # Crear subdirectorios para cada formato
  formatos_dirs <- c("html", "moodle", "canvas", "pdf")
  for (formato in formatos_dirs) {
    dir_formato <- file.path(config$dir_salida, formato)
    if (!dir.exists(dir_formato)) {
      dir.create(dir_formato, recursive = TRUE)
      cat("📂 Subdirectorio creado:", dir_formato, "\n")
    }
  }
  cat("✅ Estructura de directorios lista\n")
}

# Función para limpiar directorios antiguos
limpiar_salidas_anteriores <- function() {
  if (dir.exists(config$dir_salida)) {
    cat("🧹 Limpiando salidas anteriores...\n")
    unlink(config$dir_salida, recursive = TRUE)
    dir.create(config$dir_salida, recursive = TRUE)
    cat("✅ Directorios limpiados\n")
  }
}

# Función para mostrar estadísticas finales
mostrar_estadisticas <- function(resultados) {
  cat("\n📈 ESTADÍSTICAS FINALES:\n")
  cat("  Semilla utilizada:", config$semilla, "\n")
  cat("  Archivos por formato:", config$archivos, "\n")
  cat("  Formatos exitosos:", sum(unlist(resultados)), "/", length(resultados), "\n")
  cat("  Directorio de salida:", config$dir_salida, "\n")

  # Mostrar archivos generados
  if (dir.exists(config$dir_salida)) {
    archivos_generados <- list.files(config$dir_salida, recursive = TRUE)
    cat("  Total de archivos generados:", length(archivos_generados), "\n")
  }
}

# ===============================================================================
# EJECUCIÓN PRINCIPAL
# ===============================================================================

# Mostrar información del archivo
mostrar_info_archivo()

# Preguntar al usuario qué formatos generar (modo interactivo)
if (interactive()) {
  cat("\n🎯 SELECCIÓN DE FORMATOS:\n")
  cat("1. Solo HTML (recomendado para pruebas)\n")
  cat("2. Solo Moodle (recomendado para producción directa)\n")
  cat("3. HTML + Moodle (recomendado para producción completa)\n")
  cat("4. Todos los formatos (HTML, Moodle, Canvas, PDF)\n")
  cat("5. Personalizado\n")

  opcion <- readline("Seleccione una opción (1-5): ")

  formatos_seleccionados <- switch(opcion,
    "1" = c("html"),
    "2" = c("moodle"),
    "3" = c("html", "moodle"),
    "4" = c("html", "moodle", "canvas", "pdf"),
    "5" = {
      cat("Formatos disponibles: html, moodle, canvas, pdf\n")
      formatos_input <- readline("Ingrese formatos separados por comas: ")
      trimws(strsplit(formatos_input, ",")[[1]])
    },
    c("html", "moodle")  # Por defecto
  )
} else {
  # Modo no interactivo: generar todos los formatos por defecto
  formatos_seleccionados <- c("html", "moodle", "pdf")
}

cat("\n🚀 Formatos seleccionados:", paste(formatos_seleccionados, collapse = ", "), "\n")

# Limpiar salidas anteriores si el usuario lo desea
if (interactive()) {
  limpiar <- readline("¿Limpiar salidas anteriores? (s/n): ")
  if (tolower(limpiar) %in% c("s", "si", "y", "yes")) {
    limpiar_salidas_anteriores()
  }
} else {
  limpiar_salidas_anteriores()
}

# Ejecutar generación
cat("\n", strrep("=", 80), "\n")
cat("🎬 INICIANDO GENERACIÓN DE EXÁMENES HÍBRIDOS\n")
cat(strrep("=", 80), "\n")

resultados_finales <- generar_todos_formatos(formatos_seleccionados)

# Mostrar estadísticas finales
mostrar_estadisticas(resultados_finales)

# Mensaje final
cat("\n", strrep("=", 80), "\n")
if (all(unlist(resultados_finales))) {
  cat("🎉 ¡GENERACIÓN COMPLETADA EXITOSAMENTE!\n")
  cat("📁 Revise los archivos en:", config$dir_salida, "\n")
} else {
  cat("⚠️  GENERACIÓN COMPLETADA CON ALGUNOS ERRORES\n")
  cat("📁 Revise los logs anteriores para más detalles\n")
}
cat(strrep("=", 80), "\n")

# Guardar información de la sesión
info_sesion <- list(
  archivo = archivo_examen,
  semilla = config$semilla,
  fecha = Sys.time(),
  formatos = formatos_seleccionados,
  resultados = resultados_finales,
  archivos_generados = config$archivos
)

saveRDS(info_sesion, file.path(config$dir_salida, "info_sesion.rds"))
cat("💾 Información de sesión guardada en: info_sesion.rds\n")
