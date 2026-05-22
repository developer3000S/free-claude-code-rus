#!/usr/bin/env python3
"""
Script para agregar línea vacía antes de todos los listados en archivos Markdown.
Procesa todos los archivos .md dentro del directorio .claude
"""

import os
import re
from pathlib import Path

def is_list_item(line):
    """Detecta si una línea es un elemento de lista."""
    stripped = line.lstrip()
    # Lista con viñetas: -, *, +
    if re.match(r'^[-*+]\s', stripped):
        return True
    # Lista numerada: 1., 2., etc.
    if re.match(r'^\d+\.\s', stripped):
        return True
    return False

def is_empty_line(line):
    """Detecta si una línea está vacía o solo tiene espacios."""
    return line.strip() == ''

def fix_markdown_lists(file_path):
    """Agrega línea vacía antes de listados si no existe."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        if not lines:
            return False
        
        new_lines = []
        modified = False
        
        for i, line in enumerate(lines):
            # Si es un elemento de lista
            if is_list_item(line):
                # Verificar si la línea anterior existe y no está vacía
                if i > 0:
                    prev_line = lines[i-1]
                    # Si la línea anterior no está vacía y no es otro elemento de lista
                    if not is_empty_line(prev_line) and not is_list_item(prev_line):
                        # Agregar línea vacía antes del listado
                        new_lines.append('\n')
                        modified = True
            
            new_lines.append(line)
        
        # Solo escribir si hubo modificaciones
        if modified:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(new_lines)
            return True
        
        return False
    
    except Exception as e:
        print(f"Error procesando {file_path}: {e}")
        return False

def main():
    """Procesa todos los archivos .md en .claude"""
    base_dir = Path('.claude')
    
    if not base_dir.exists():
        print("Error: Directorio .claude no encontrado")
        return
    
    # Encontrar todos los archivos .md
    md_files = list(base_dir.rglob('*.md'))
    
    print(f"Encontrados {len(md_files)} archivos .md")
    print("Procesando...\n")
    
    modified_count = 0
    
    for md_file in sorted(md_files):
        if fix_markdown_lists(md_file):
            print(f"✅ Modificado: {md_file}")
            modified_count += 1
        else:
            print(f"⏭️  Sin cambios: {md_file}")
    
    print(f"\n{'='*60}")
    print(f"Resumen:")
    print(f"  Total archivos: {len(md_files)}")
    print(f"  Modificados: {modified_count}")
    print(f"  Sin cambios: {len(md_files) - modified_count}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()

