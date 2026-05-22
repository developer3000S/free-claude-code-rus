# Estilos y Personalizacion matplotlib

## Configuracion Inicial

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import rcParams

rcParams['font.family'] = 'serif'
rcParams['font.size'] = 10
rcParams['figure.figsize'] = (8, 6)
rcParams['figure.dpi'] = 100
rcParams['savefig.dpi'] = 300
rcParams['axes.grid'] = True
rcParams['grid.alpha'] = 0.3
```

## Colores

```python
# Por nombre
'red', 'blue', 'green', 'yellow', 'cyan', 'magenta', 'black', 'white'

# Codigos hexadecimales
'#FF0000', '#00FF00', '#0000FF', '#4CAF50'

# RGB (valores entre 0 y 1)
(0.5, 0.2, 0.8)

# Transparencia
alpha=0.5  # 50% transparente
```

## Estilos de Linea

```python
'-'   # Solida
'--'  # Discontinua
':'   # Punteada
'-.'  # Raya-punto

# Grosor
linewidth=0.5  # Delgada
linewidth=2    # Media
linewidth=3    # Gruesa
```

## Marcadores

```python
'o'   # Circulo
's'   # Cuadrado
'^'   # Triangulo arriba
'v'   # Triangulo abajo
'*'   # Estrella
'+'   # Cruz
'x'   # X
'D'   # Diamante
```

## Texto Matematico (LaTeX)

```python
r'$x^2$'                    # Potencia
r'$\frac{a}{b}$'           # Fraccion
r'$\sqrt{x}$'              # Raiz cuadrada
r'$\sin(x)$'               # Seno
r'$\alpha, \beta, \gamma$' # Griegas
r'$\int_0^1 f(x)dx$'       # Integral
```

## Guardar con Alta Resolucion

```python
plt.savefig('outputs/output_python.png', dpi=300, bbox_inches='tight')
```

## Librerias Esenciales

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import rcParams
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, Circle, Rectangle, Polygon
from matplotlib.collections import PatchCollection
from matplotlib.patches import Arc  # Para angulos
```
