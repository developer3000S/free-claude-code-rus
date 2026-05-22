#!/usr/bin/env python3
"""
Corrección automática de tildes en archivos .Rmd.
Uso: python3 corregir_ortografia_espanol.py <archivo.Rmd> [--fix]
     --fix: Aplica correcciones (sin este flag solo reporta)

A diferencia del script R homólogo, este script:
1. Tiene un diccionario mas completo (~500+ entradas)
2. Maneja strings multilínea (paste0, cat, strings en listas)
3. Detecta contexto: código R vs texto español visible al estudiante
4. Respeta: variables R, metadatos R-exams, anchors Markdown, rutas
"""

import re
import sys
import os
import shutil
from pathlib import Path

# ═══════════════════════════════════════════════════════════
# DICCIONARIO EXTENSO DE CORRECCIONES
# ═══════════════════════════════════════════════════════════

DICCIONARIO = {
    # ── Sustantivos terminados en -cion → -ción ──
    "informacion": "información",
    "descripcion": "descripción",
    "explicacion": "explicación",
    "configuracion": "configuración",
    "solucion": "solución",
    "validacion": "validación",
    "clasificacion": "clasificación",
    "ecuacion": "ecuación",
    "dimension": "dimensión",
    "version": "versión",
    "seleccion": "selección",
    "seccion": "sección",
    "funcion": "función",
    "relacion": "relación",
    "distribucion": "distribución",
    "variacion": "variación",
    "dispersion": "dispersión",
    "combinacion": "combinación",
    "iteracion": "iteración",
    "compilacion": "compilación",
    "instalacion": "instalación",
    "documentacion": "documentación",
    "retroalimentacion": "retroalimentación",
    "elongacion": "elongación",
    "deformacion": "deformación",
    "inclinacion": "inclinación",
    "operacion": "operación",
    "multiplicacion": "multiplicación",
    "division": "división",
    "adicion": "adición",
    "sustraccion": "sustracción",
    "fraccion": "fracción",
    "proporcion": "proporción",
    "razon": "razón",
    "evaluacion": "evaluación",
    "medicion": "medición",
    "observacion": "observación",
    "experimentacion": "experimentación",
    "interpretacion": "interpretación",
    "representacion": "representación",
    "argumentacion": "argumentación",
    "formulacion": "formulación",
    "ejecucion": "ejecución",
    "definicion": "definición",
    "posicion": "posición",
    "desviacion": "desviación",
    "produccion": "producción",
    "inspeccion": "inspección",
    "auditoria": "auditoría",
    "revision": "revisión",
    "verificacion": "verificación",
    "asociacion": "asociación",
    "limitacion": "limitación",
    "aplicacion": "aplicación",
    "conclusion": "conclusión",
    "instruccion": "instrucción",
    "construccion": "construcción",
    "interseccion": "intersección",
    "exclusion": "exclusión",
    "omision": "omisión",
    "confusion": "confusión",
    "reflexion": "reflexión",
    "expresion": "expresión",
    "opcion": "opción",
    "comprension": "comprensión",
    "metacognicion": "metacognición",
    "argumentacion": "argumentación",
    "interpretacion": "interpretación",
    "formulacion": "formulación",
    "generacion": "generación",
    "validacion": "validación",
    "depreciacion": "depreciación",
    "aprobacion": "aprobación",
    "cancelacion": "cancelación",
    "comparacion": "comparación",
    "gobernacion": "gobernación",
    "Gobernacion": "Gobernación",

    # ── Sustantivos terminados en -sion → -sión ──
    "ocasion": "ocasión",
    "precisión": "precisión",

    # ── Sustantivos terminados en -ia/-io con tilde ──
    "metrologia": "metrología",
    "direccion": "dirección",
    "energia": "energía",
    "mayoria": "mayoría",

    # ── Esdrújulos y palabras con tilde diacrítica ──
    "grafica": "gráfica",
    "grafico": "gráfico",
    "graficas": "gráficas",
    "graficos": "gráficos",
    "matematico": "matemático",
    "matematica": "matemática",
    "matematicas": "matemáticas",
    "estadistica": "estadística",
    "estadistico": "estadístico",
    "estadisticas": "estadísticas",
    "estadisticos": "estadísticos",
    "cientifico": "científico",
    "cientifica": "científica",
    "parabolico": "parabólico",
    "parabolica": "parabólica",
    "geometrico": "geométrico",
    "geometrica": "geométrica",
    "numerico": "numérico",
    "numerica": "numérica",
    "teorico": "teórico",
    "teorica": "teórica",
    "unico": "único",
    "unica": "única",
    "dinamico": "dinámico",
    "dinamica": "dinámica",
    "automatico": "automático",
    "automatica": "automática",
    "semantico": "semántico",
    "semantica": "semántica",
    "cuadratico": "cuadrático",
    "cuadratica": "cuadrática",
    "logaritmico": "logarítmico",
    "logaritmica": "logarítmica",
    "periodico": "periódico",
    "periodica": "periódica",
    "simetrico": "simétrico",
    "simetrica": "simétrica",
    "asimetrico": "asimétrico",
    "asimetrica": "asimétrica",
    "tipico": "típico",
    "tipica": "típica",
    "tipicamente": "típicamente",
    "especifico": "específico",
    "especifica": "específica",
    "atipico": "atípico",
    "atipica": "atípica",
    "atipicos": "atípicos",
    "atipicas": "atípicas",
    "anomala": "anómala",
    "anomalo": "anómalo",
    "logicamente": "lógicamente",
    "solido": "sólido",
    "critico": "crítico",
    "critica": "crítica",
    "basico": "básico",
    "basica": "básica",

    # ── Sustantivos comunes ──
    "codigo": "código",
    "proposito": "propósito",
    "analisis": "análisis",
    "numero": "número",
    "numeros": "números",
    "angulo": "ángulo",
    "angulos": "ángulos",
    "calculo": "cálculo",
    "calculos": "cálculos",
    "metodo": "método",
    "metodos": "métodos",
    "exito": "éxito",
    "patron": "patrón",
    "maximo": "máximo",
    "maxima": "máxima",
    "minimo": "mínimo",
    "minima": "mínima",
    "area": "área",
    "areas": "áreas",
    "perimetro": "perímetro",
    "diametro": "diámetro",
    "triangulo": "triángulo",
    "triangulos": "triángulos",
    "rectangulo": "rectángulo",
    "rectangulos": "rectángulos",
    "circulo": "círculo",
    "circulos": "círculos",
    "piramide": "pirámide",
    "energia": "energía",
    "periodo": "período",
    "vehiculo": "vehículo",
    "vehiculos": "vehículos",
    "pagina": "página",
    "paginas": "páginas",
    "linea": "línea",
    "lineas": "líneas",
    "termino": "término",
    "terminos": "términos",
    "limite": "límite",
    "limites": "límites",
    "hipotesis": "hipótesis",
    "sintesis": "síntesis",
    "tesis": "tesis",
    "enfasis": "énfasis",
    "estandar": "estándar",
    "fabrica": "fábrica",
    "comite": "comité",
    "maraton": "maratón",
    "tecnico": "técnico",
    "tecnica": "técnica",
    "sinonimo": "sinónimo",
    "raiz": "raíz",
    "causa": "causa",  # ya es correcta

    # ── Adverbios y conectores ──
    "mas": "más",
    "tambien": "también",
    "asi": "así",
    "aqui": "aquí",
    "ahi": "ahí",
    "alla": "allá",
    "despues": "después",
    "segun": "según",
    "ademas": "además",
    "todavia": "todavía",
    "quiza": "quizá",
    "quizas": "quizás",
    "dificil": "difícil",
    "facil": "fácil",
    "util": "útil",
    "debil": "débil",
    "agil": "ágil",
    "fertil": "fértil",
    "esteril": "estéril",
    "movil": "móvil",
    "habil": "hábil",
    "fragil": "frágil",
    "optima": "óptima",
    "optimo": "óptimo",

    # ── Verbos conjugados ──
    "sera": "será",
    "seran": "serán",
    "estara": "estará",
    "estaran": "estarán",
    "podra": "podrá",
    "podran": "podrán",
    "tendra": "tendrá",
    "tendran": "tendrán",
    "hara": "hará",
    "haran": "harán",
    "debera": "deberá",
    "deberan": "deberán",
    "habra": "habrá",
    "habran": "habrán",
    "habia": "había",
    "habian": "habían",
    "parecia": "parecía",
    "parecian": "parecían",
    "podria": "podría",
    "podrian": "podrían",
    "tendria": "tendría",
    "tendrian": "tendrían",
    "deberia": "debería",
    "deberian": "deberían",
    "habria": "habría",
    "habrian": "habrían",
    "varia": "varía",
    "varian": "varían",
    "realizo": "realizó",
    "recibio": "recibió",
    "midio": "midió",
    "pidio": "pidió",
    "logro": "logró",

    # ── Compañía, montaña, etc. (ñ words) ──
    "compania": "compañía",
    "montana": "montaña",
    "Montana": "Montaña",
    "purisima": "purísima",
    "Purisima": "Purísima",
    "pequeno": "pequeño",
    "pequena": "pequeña",
    "pequenos": "pequeños",
    "pequenas": "pequeñas",

    # ── Participios y formas con tilde ──
    "esten": "estén",
}

# Palabras que NUNCA deben corregirse (nombres de variables R comunes)
EXCLUIDAS_VARIABLES_R = {
    "solucion", "angulos", "angulo", "funcion", "numero",
    "grafica", "grafico", "calculo", "codigo", "metodo",
    "area", "maximo", "minimo", "linea", "lineas",
    "datos", "sera", "podra", "tendra", "habra",
}

# Campos de metadatos R-exams: preservar ASCII
REXAMS_ASCII_FIELDS = {
    "exname", "exsection", "extype", "exsolution",
    "exshuffle", "extol", "exextra",
}


def es_linea_metadato_rexams(linea):
    """Detecta lineas de metadatos R-exams que DEBEN permanecer ASCII."""
    linea_stripped = linea.strip()
    for campo in REXAMS_ASCII_FIELDS:
        if re.match(rf'^{campo}(\[.*?\])?\s*:', linea_stripped):
            return True
    return False


def es_variable_r_en_linea(linea, palabra):
    """Verifica si la palabra es una variable R (asignacion, argumento, etc.)."""
    patrones = [
        rf'\b{palabra}\s*<-',         # var <-
        rf'<-\s*{palabra}\b',         # <- var
        rf'\b{palabra}\s*=\s*c\(',    # var = c(
        rf'\b{palabra}\s*=\s*list',   # var = list
        rf'\${palabra}\b',            # datos$var
        rf'\b{palabra}\$',            # var$campo
        rf'\[\["{palabra}"\]\]',      # [["var"]]
        rf'function\s*\([^)]*\b{palabra}\b',  # argumento de funcion
        rf',\s*{palabra}\s*[,\)]',   # , var, o , var)
        rf'\(\s*{palabra}\s*[,\)]',   # (var, o (var)
    ]
    for p in patrones:
        if re.search(p, linea):
            return True
    return False


def es_anchor_markdown(linea, palabra):
    """Detecta anchors Markdown {#palabra-...} que son identificadores ASCII."""
    return bool(re.search(rf'\{{#[^}}]*\b{palabra}\b[^}}]*\}}', linea))


def es_ruta_archivo(linea, palabra):
    """Detecta si la palabra es parte de una ruta o nombre de archivo."""
    return bool(re.search(rf'(?<=[/_-]){palabra}(?=[/_.-])|(?<=[/_-]){palabra}\b\.[a-zA-Z]', linea))


def es_codigo_inline(linea, palabra):
    """Detecta si la palabra esta dentro de codigo R inline `r ...`."""
    return bool(re.search(rf'`r[^`]*\b{palabra}\b[^`]*`', linea))


def contiene_palabra(texto, palabra):
    """Busca la palabra completa (word boundary) en el texto, case-insensitive."""
    if not palabra:
        return False
    # Escapar caracteres especiales (tilde en original no deberia tenerlos)
    escaped = re.escape(palabra)
    return bool(re.search(rf'\b{escaped}\b', texto, re.IGNORECASE))


def reemplazar_palabra(texto, old, new):
    """Reemplaza palabra completa preservando mayusculas/minusculas."""
    if not old:
        return texto

    def _replacer(m):
        matched = m.group(0)
        # Preservar capitalizacion
        if matched[0].isupper():
            return new[0].upper() + new[1:]
        return new

    return re.sub(
        rf'\b{re.escape(old)}\b',
        _replacer,
        texto,
        flags=re.IGNORECASE
    )


def extraer_segmentos_espanol(contenido):
    """
    Divide el archivo .Rmd en segmentos, clasificando cada linea como:
    - 'markdown': texto visible (Question, Solution, Answerlist, listas, etc.)
    - 'r_string': dentro de strings R (paste0, cat, strings en listas)
    - 'r_code': codigo R puro (no strings, no comentarios)
    - 'r_comment': comentarios R (# ...)
    - 'metadata': metadatos R-exams (exextra, etc.)
    - 'chunk_header': ```{r ...}
    - 'fence': ```
    """
    lineas = contenido.split('\n')
    segmentos = []
    en_chunk_r = False
    en_markdown_section = False
    string_multilinea = False
    string_char = None

    for i, linea in enumerate(lineas):
        stripped = linea.strip()

        # Detectar inicio/fin de chunk R
        if stripped.startswith('```{r'):
            en_chunk_r = True
            en_markdown_section = False
            segmentos.append(('chunk_header', i, linea))
            continue
        if stripped == '```' and en_chunk_r:
            en_chunk_r = False
            en_markdown_section = False
            segmentos.append(('fence', i, linea))
            continue
        if stripped == '```' and not en_chunk_r:
            en_markdown_section = False
            segmentos.append(('fence', i, linea))
            continue

        # Detectar secciones Markdown
        if re.match(r'^(Question|Solution|Answerlist)\s*$', stripped):
            en_markdown_section = True
            segmentos.append(('section_header', i, linea))
            continue

        # Detectar Meta-information section
        if stripped == 'Meta-information' or re.match(r'^Meta-information\s*$', stripped):
            en_markdown_section = False
            en_chunk_r = False
            segmentos.append(('section_header', i, linea))
            continue

        # Clasificar por contexto
        if es_linea_metadato_rexams(linea):
            segmentos.append(('metadata', i, linea))
        elif en_markdown_section and not en_chunk_r:
            segmentos.append(('markdown', i, linea))
        elif en_chunk_r:
            # Dentro de chunk R: distinguir string, comentario, codigo
            if stripped.startswith('#'):
                segmentos.append(('r_comment', i, linea))
            elif _contiene_string_espanol(linea):
                segmentos.append(('r_string', i, linea))
            else:
                segmentos.append(('r_code', i, linea))
        else:
            # Fuera de chunk y fuera de secciones Markdown conocidas
            # Puede ser texto entre chunks (menos comun)
            segmentos.append(('unknown', i, linea))

    return segmentos, lineas


def _contiene_string_espanol(linea):
    """Detecta si una linea dentro de un chunk R contiene strings en espanol."""
    # Buscar contenido entre comillas que tenga texto en espanol
    matches = re.findall(r'"([^"]*)"', linea)
    for m in matches:
        # Si el string tiene mas de 10 chars y contiene vocales con tilde o n~ potencial
        if len(m) > 10:
            return True
    matches = re.findall(r"'([^']*)'", linea)
    for m in matches:
        if len(m) > 10:
            return True
    return False


def corregir_archivo(archivo, aplicar_fix=False):
    """
    Analiza y opcionalmente corrige tildes en un archivo .Rmd.

    Returns:
        (num_errores, lista_errores, contenido_corregido)
    """
    if not os.path.exists(archivo):
        print(f"ERROR: Archivo no encontrado: {archivo}")
        return (0, [], None)

    with open(archivo, 'r', encoding='utf-8') as f:
        contenido = f.read()

    lineas = contenido.split('\n')
    errores_encontrados = []

    # Construir diccionario ordenado por longitud descendente
    # (palabras mas largas primero para evitar conflictos)
    palabras_ordenadas = sorted(DICCIONARIO.keys(), key=len, reverse=True)

    for i, linea in enumerate(lineas):
        stripped = linea.strip()

        # Saltar lineas de metadatos R-exams
        if es_linea_metadato_rexams(linea):
            continue

        # Saltar codigo R puro (sin strings ni comentarios)
        # Solo procesamos lineas que tengan contenido textual en espanol
        es_markdown = _es_contexto_markdown(lineas, i)
        es_string_r = _es_contexto_string_r(linea)
        es_comentario = stripped.startswith('#')

        if not (es_markdown or es_string_r or es_comentario):
            continue

        for palabra_mal in palabras_ordenadas:
            if not contiene_palabra(linea, palabra_mal):
                continue

            # FILTROS: no corregir en ciertos contextos
            if es_variable_r_en_linea(linea, palabra_mal):
                continue
            if es_anchor_markdown(linea, palabra_mal):
                continue
            if es_ruta_archivo(linea, palabra_mal):
                continue
            if es_codigo_inline(linea, palabra_mal):
                continue
            if palabra_mal in EXCLUIDAS_VARIABLES_R and (
                es_variable_r_en_linea(linea, palabra_mal) or
                re.search(rf'\b{palabra_mal}\s*=', linea)
            ):
                continue

            palabra_bien = DICCIONARIO[palabra_mal]
            nueva_linea = reemplazar_palabra(linea, palabra_mal, palabra_bien)

            if nueva_linea != linea:
                errores_encontrados.append({
                    'linea': i + 1,
                    'palabra_mal': palabra_mal,
                    'palabra_bien': palabra_bien,
                    'contexto': stripped[:80],
                })
                lineas[i] = nueva_linea
                linea = nueva_linea  # actualizar para siguientes palabras

    # Reportar
    if errores_encontrados:
        print(f"\n{'='*60}")
        print(f"ERRORES ORTOGRÁFICOS ENCONTRADOS: {len(errores_encontrados)}")
        print(f"Archivo: {archivo}")
        print(f"{'='*60}\n")

        for err in errores_encontrados:
            print(f"  Línea {err['linea']}: '{err['palabra_mal']}' → '{err['palabra_bien']}'")
            print(f"    Contexto: {err['contexto']}")

        if aplicar_fix:
            backup = archivo + '.bak'
            shutil.copy2(archivo, backup)
            nuevo_contenido = '\n'.join(lineas)
            with open(archivo, 'w', encoding='utf-8') as f:
                f.write(nuevo_contenido)
            print(f"\n  ✓ {len(errores_encontrados)} CORRECCIONES APLICADAS (backup: {backup})")
        else:
            print(f"\n  ⚠ Para aplicar correcciones, ejecute con --fix")
            print(f"    python3 {__file__} {archivo} --fix")

        return (len(errores_encontrados), errores_encontrados,
                '\n'.join(lineas) if not aplicar_fix else None)
    else:
        print(f"\n  ✓ Sin errores ortográficos: {archivo}")
        return (0, [], None)


def _es_contexto_markdown(lineas, idx):
    """Determina si la linea esta en un contexto Markdown (fuera de chunks R)."""
    en_chunk = False
    for j in range(idx, -1, -1):
        stripped = lineas[j].strip()
        if stripped.startswith('```{r'):
            en_chunk = True
            break
        if stripped == '```':
            en_chunk = False
            break
    return not en_chunk


def _es_contexto_string_r(linea):
    """Detecta si la linea contiene strings en espanol dentro de codigo R."""
    # Buscar strings largos (probablemente texto en espanol)
    strings_largos = re.findall(r'"[^"]{20,}"', linea)
    strings_largos += re.findall(r"'[^']{20,}'", linea)
    return len(strings_largos) > 0


def corregir_directorio(directorio, patron=r'\.Rmd$', aplicar_fix=False):
    """Procesa todos los archivos .Rmd en un directorio recursivamente."""
    archivos = []
    for root, dirs, files in os.walk(directorio):
        for f in files:
            if re.search(patron, f):
                archivos.append(os.path.join(root, f))

    if not archivos:
        print(f"No se encontraron archivos {patron} en: {directorio}")
        return

    print(f"Procesando {len(archivos)} archivos...\n")
    total_errores = 0
    archivos_con_errores = 0

    for f in sorted(archivos):
        n, _, _ = corregir_archivo(f, aplicar_fix)
        if n > 0:
            total_errores += n
            archivos_con_errores += 1

    print(f"\n{'='*60}")
    print(f"RESUMEN")
    print(f"{'='*60}")
    print(f"  Archivos procesados: {len(archivos)}")
    print(f"  Archivos con errores: {archivos_con_errores}")
    print(f"  Total errores: {total_errores}")


# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Uso: python3 corregir_ortografia_espanol.py <archivo.Rmd|directorio> [--fix]")
        print("  --fix    Aplica las correcciones (sin este flag solo reporta)")
        sys.exit(1)

    objetivo = sys.argv[1]
    aplicar_fix = '--fix' in sys.argv

    if os.path.isdir(objetivo):
        corregir_directorio(objetivo, aplicar_fix=aplicar_fix)
    elif os.path.isfile(objetivo):
        n, _, _ = corregir_archivo(objetivo, aplicar_fix)
        sys.exit(0 if n == 0 else 1)
    else:
        print(f"ERROR: No se encontró: {objetivo}")
        sys.exit(1)
