# Agrobot_demo

Diseño CAD del robot en FreeCAD y exportación a URDF con el workbench [CROSS](https://github.com/galou/freecad.cross).

## Setup
```bash
./scripts/setup_freecad.sh
```
Instala FreeCAD (snap) y CROSS en `~/snap/freecad/common/Mod/freecad.cross`, y fija FreeCAD en favoritos.

## Flujo
1. Modelar piezas en `cad/` (archivos `.FCStd`).
2. Workbench **Cross**: crear Robot, Links y Joints.
3. Exportar URDF a `urdf/`.

## Notas
- Sin ROS instalado, algunas funciones de Cross no están disponibles.
- Importar xacro requiere el módulo Python `xacro` dentro de FreeCAD.
