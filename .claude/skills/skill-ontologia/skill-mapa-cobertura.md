---
name: skill-mapa-cobertura
description: Genera un reporte HTML interactivo de cobertura del banco de ejercicios ICFES usando la ontología. Muestra brechas por competencia, nivel DOK y conceptos sin cobertura.
model_recommendation: sonnet
---

# Skill: Mapa de Cobertura del Banco de Ejercicios

## Cuándo usar este skill

Cuando el usuario pregunta:
- "¿Qué temas faltan en el banco de ejercicios?"
- "¿Cuál es la cobertura por competencia?"
- "Muéstrame las brechas"
- `/mapa-cobertura`

## Pasos

### 1. Verificar ontología disponible

```bash
curl -s --max-time 3 http://localhost:3030/$/ping > /dev/null 2>&1 || {
  echo "Fuseki no activo. Iniciar con: systemctl --user start fuseki.service"
  echo "Luego cargar: Rscript -e \"source('core/poblar_ontologia.R'); poblar_ontologia()\""
  exit 1
}
```

### 2. Ejecutar consultas de cobertura

```bash
cd /home/elpuente/R/proyecto-r-exams-icfes-matematicas-optimizado
Rscript -e "
source('core/consultar_cobertura.R')
cat('=== COBERTURA POR COMPETENCIA ===\n')
print(cobertura_por_competencia())
cat('\n=== COBERTURA POR NIVEL DOK ===\n')
print(cobertura_por_nivel())
cat('\n=== BRECHAS (conceptos sin ejercicios) ===\n')
df <- brechas_conceptos()
if (nrow(df) > 0) print(df) else cat('Sin brechas detectadas\n')
"
```

### 3. Presentar resultados al usuario

Mostrar los resultados en formato legible:

```
📊 Mapa de Cobertura — Banco ICFES Matemáticas

Ejercicios por competencia:
  InterpretacionRepresentacion: [N]
  FormulacionEjecucion: [N]
  Argumentacion: [N]
  ResolucionProblemas: [N]
  (sin competencia): [N]

Ejercicios por nivel DOK:
  DOK1 (Básico): [N]
  DOK2 (Medio): [N]
  DOK3 (Alto): [N]
  DOK4 (Avanzado): [N]

⚠️ Conceptos sin cobertura ([M] brechas):
  - [concepto1]
  - [concepto2]
  ...

💡 Recomendaciones:
  - [Si DOK3/DOK4 son bajos]: Generar más ejercicios de nivel alto
  - [Si hay brechas en prerequisitos]: Cubrir conceptos base primero
```

### 4. Generar visualización interactiva (opcional)

Si el usuario quiere el grafo interactivo:

```bash
cd /home/elpuente/R/proyecto-r-exams-icfes-matematicas-optimizado
Rscript -e "source('core/visualizar_grafo.R'); visualizar_grafo()"
```

Esto abre el grafo en el navegador con color coding:
- 🔴 Rojo: sin ejercicios
- 🟡 Amarillo: 1-2 ejercicios
- 🟢 Verde: 3+ ejercicios
