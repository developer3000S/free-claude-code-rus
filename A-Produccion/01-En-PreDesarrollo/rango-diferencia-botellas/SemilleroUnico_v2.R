# Carga de la librería r-exams
library(exams)

# Configurar modo generación de exámenes para evitar pruebas test_that
.exams_generation_mode <- TRUE

# Definición del archivo de examen y configuración inicial
archivo_examen <- "rango_diferencia_botellas_metacognitivo_argumentacion_n3_schoice_v1.Rmd"
copias <- 1  # Número de versiones a generar
numpreg <- 5
semilla_base <- sample(100:1e8, 1)
# NO establecer semilla fija - cada versión usará semilla diferente
dir_salida <- "salida"
dir_ejercicios <- "."


# Nombre del archivo sin la extensión .Rmd
nombre_sin_extension <- sub("\\.Rmd$", "", archivo_examen)
nombre_arch <- paste0(nombre_sin_extension, "_")

################################################################################
# Generación de copias individuales para PDF, sólo 'copias', no importa 'numpreg'

# for(i in 1:copias) {
#   nombre_archivo <- sprintf("%s_copia%d_", nombre_sin_extension, i)
#   exams2pdf(archivo_examen,
#             n = 1,
#             name = nombre_archivo,
#             encoding = "UTF-8",
#             template = "solpcielo",
#             dir = dir_salida,
#             edir = dir_ejercicios,
#             verbose = TRUE)
# }

################################################################################
# Generación de copias individuales para Pandoc (docx), sólo 'copias',
# no importa 'numpreg

# for(i in 1:copias) {
#   nombre_archivo <- sprintf("%s_copia%d_", nombre_sin_extension, i)
#   exams2pandoc(archivo_examen,
#                n = 1,
#                name = nombre_archivo,
#                encoding = "UTF-8",
#                template = "plain.tex",
#                dir = dir_salida,
#                edir = dir_ejercicios,
#                format = "docx",
#                verbose = TRUE)
# }

################################################################################
# Creación del examen en formato HTML, sólo 'numpreg', 'copias' = 1

# exams2html(rep(archivo_examen, numpreg),
#            svg = FALSE,
#            verbose = TRUE,
#            template = "plain",
#            name = paste0(nombre_sin_extension, "_semillero"))

#################################################################################
# Generación de n copias en un solo archivo de salida para PDF

# NO establecer semilla fija - cada versión usará semilla diferente
exams2pdf(rep(archivo_examen, numpreg),
          n = copias,
          name = nombre_arch,
          encoding = "UTF-8",
          template = "solpcielo",
          dir = dir_salida,
          edir = dir_ejercicios,
          verbose = TRUE)

################################################################################
# Generación de n copias en un solo archivo .docx

# NO establecer semilla fija - cada versión usará semilla diferente
exams2pandoc(rep(archivo_examen, numpreg),
             n = copias,
             name = nombre_arch,
             encoding = "UTF-8",
             template = "pcielo.tex",
             header = list(Date = Sys.Date()),
             inputs = NULL,
             options = NULL,
             quiet = TRUE, # Consider removing or setting to FALSE if verbose is TRUE
             resolution = 100,
             width = 4,
             height = 4,
             svg = TRUE,
             dir = dir_salida,
             edir = dir_ejercicios,
             tdir = NULL,
             sdir = NULL,
             verbose = TRUE, # Added verbose
             points = NULL,
             exshuffle = NULL,
             type = "docx")

################################################################################
# Generación para Moodle, solo configura manualmente 'copias'
# no importa 'numpreg'

# set.seed(semilla)
exams2moodle(archivo_examen,
             n = copias,
             svg = TRUE,
             name = nombre_arch,
             encoding = "UTF-8",
             dir = "salida",
             edir = dir_ejercicios,
             mchoice = list(shuffle = TRUE,
                            answernumbering = "ABCD",
                            eval = list(partial = TRUE,
                                        rule = "none")),
             verbose = TRUE)

################################################################################
# Generación para NOPS (exámenes escaneables)

# NO establecer semilla fija - cada versión usará semilla diferente
exams2nops(rep(archivo_examen, numpreg),
           n = copias,
           name = paste0(nombre_sin_extension, "_nops_"),
           encoding = "UTF-8",
           dir = dir_salida,
           edir = dir_ejercicios,
           language = "es",                      # Idioma español
           title = "Evaluación de Matemáticas",  # Título del examen
           institution = "I. E. Pedacito de Cielo", # Nombre de la institución
           logo = NULL,                         # Sin logo (opcional)
           date = Sys.Date(),                   # Fecha actual
           replacement = FALSE,                 # Sin preguntas de reemplazo
           blank = 0,                           # Sin páginas adicionales
           duplex = TRUE,                       # Impresión a doble cara
           pages = NULL,                        # Número de páginas automático
           points = NULL,                       # Puntos por pregunta automático
           showpoints = FALSE,                  # No mostrar puntos en el examen
           verbose = TRUE)

################################################################################
# Generación para exams2forms (formularios HTML interactivos)
# NOTA: Requiere instalar el paquete exams2forms (ejecutar solo una vez)
# install.packages("exams2forms")

library(exams2forms)

# Generar archivos HTML standalone con exams2webquiz
# Esta función genera automáticamente los archivos CSS y JS necesarios
# Configuración: 1 pregunta por página, múltiples versiones
exams2webquiz(archivo_examen,  # Una pregunta por archivo HTML
              n = copias * numpreg,  # Total de versiones = copias × preguntas
              dir = dir_salida,
              name = paste0(nombre_sin_extension, "_interactivo"),
              edir = dir_ejercicios,
              encoding = "UTF-8",
              title = "Evaluación Interactiva de Matemáticas ICFES",
              solution = TRUE,        # Mostrar botón de solución
              shuffle = TRUE,         # Mezclar opciones de respuesta
              mathjax = TRUE,         # Habilitar MathJax para fórmulas
              browse = TRUE)          # Abrir navegador automáticamente

# # Opción 2: Generar archivos HTML en subdirectorio para embeber
# # Útil para integrar en documentos Rmd/Quarto o sitios web
# dir_forms_embed <- file.path(dir_salida, "forms_embed")
# dir.create(dir_forms_embed, recursive = TRUE, showWarnings = FALSE)
#
# exams2forms(archivo_examen,
#             n = 3,  # Generar 3 variaciones
#             dir = dir_forms_embed,
#             edir = dir_ejercicios,
#             encoding = "UTF-8",
#             title = "Ejercicio Interactivo",
#             verbose = TRUE,
#             solution = TRUE,
#             shuffle = TRUE,
#             mathjax = TRUE)
#
# # Copiar archivos CSS y JS al subdirectorio
# file.copy(system.file("webex.css", package = "exams2forms"),
#           file.path(dir_forms_embed, "webex.css"), overwrite = TRUE)
# file.copy(system.file("webex.js", package = "exams2forms"),
#           file.path(dir_forms_embed, "webex.js"), overwrite = TRUE)

################################################################################
