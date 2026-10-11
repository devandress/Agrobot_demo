# Guía: del STEP de GrabCAD a URDF con FreeCAD + Cross

Pensada para quien nunca ha usado FreeCAD. Robot: UGV de 4 ruedas.

## Vocabulario mínimo

- **Vista de árbol:** panel izquierdo, lista de todos los objetos del documento.
- **Vista 3D:** panel central, donde se ve el modelo.
- **Vista de combo:** panel izquierdo con dos pestañas: `Modelo` (árbol) y `Tareas`.
- **Propiedades:** panel bajo el árbol. Muestra los datos del objeto seleccionado.
- **Selector de workbench:** lista desplegable en la barra superior. Cambia las herramientas disponibles (Part, Cross, etc.).
- **Placement:** posición y rotación de un objeto (propiedad en el panel Propiedades).

Mover la vista 3D: rueda del ratón = zoom, botón central = rotar, Ctrl + botón central = desplazar.

## 1. Abrir el STEP

1. `Archivo` > `Abrir` y elige `UGV-AIR-AGRO_es.STEP` (copia con nombres en español).
2. En el diálogo de importación:
   - Enable STEP compound merge: **desmarcado**
   - Usar LinkGroup: **desmarcado**
   - Reducir el número de objetos: **desmarcado**
   - Expandir forma compuesta: **desmarcado**
   - Ignorar nombres de instancias: **desmarcado**
   - Modo: `Documento único`
3. Pulsa OK y espera. El archivo es de 47 MB; puede tardar varios minutos. FreeCAD parece bloqueado pero sigue trabajando.
4. `Archivo` > `Guardar como` > `~/Agrobot_demo/cad/ugv.FCStd`. Guarda a menudo.

## 2. Revisar el modelo

1. En el árbol, despliega los nodos con la flecha.
2. Haz clic en una pieza: se resalta en la vista 3D. Así identificas qué es cada una.
3. Para ocultar una pieza: selecciónala y pulsa la barra espaciadora. Vuelve a pulsarla para mostrarla.
4. Orientación necesaria: **X al frente, Y a la izquierda, Z arriba**. Si el robot está girado, selecciona todas las piezas y cambia `Placement` > `Angle` y `Axis` en el panel Propiedades.

## 3. Agrupar piezas (un grupo por link)

Un URDF necesita pocos cuerpos grandes, no 99 piezas sueltas.

Grupos para el UGV:

| Grupo (nombre) | Qué contiene |
|---|---|
| `base_link` | Chasis, tapas, paneles, perfiles 40x40, chapas, motores, soportes, amortiguadores (todo lo fijo) |
| `wheel_fl` | Llanta, neumático y acople de la rueda delantera izquierda |
| `wheel_fr` | Ídem, delantera derecha |
| `wheel_rl` | Ídem, trasera izquierda |
| `wheel_rr` | Ídem, trasera derecha |

Para crear cada grupo:

1. En el árbol, haz clic en la primera pieza, mantén `Ctrl` y haz clic en las demás del grupo.
2. Cambia a `Part` en el selector de workbench.
3. Menú `Part` > `Compound` > `Make compound`.
4. Selecciona el `Compound` nuevo, pulsa `F2` y ponle el nombre del grupo.

Consejo: empieza por las 4 ruedas (pocas piezas cada una). Después selecciona todo lo que sobra y haz `base_link`. Para seleccionar "todo lo que sobra", selecciona todo con `Ctrl+A` y quita con `Ctrl+clic` los 4 compounds de ruedas.

No uses `Fusion` booleana (`Part` > `Boolean`): es lento y falla con modelos tan detallados.

## 4. Centro de cada rueda

Cada joint de rueda necesita su origen en el centro del eje.

1. Haz clic en el borde circular del eje o del buje de la rueda, en la vista 3D.
2. Abajo, la barra de estado muestra las coordenadas del punto seleccionado.
3. Anota X, Y, Z (en mm) del centro de cada rueda. Se usan en el paso 6.

## 5. Crear el robot en Cross

1. Selector de workbench > **Cross**. Si no aparece, reinicia FreeCAD (se instaló en `~/snap/freecad/common/Mod/freecad.cross`).
2. Barra de Cross > **Create robot**. Aparece un objeto `Robot` en el árbol.
3. Selecciona el compound `base_link`. Con el robot seleccionado, pulsa **Add link**. Marca este link como raíz.
4. Repite **Add link** para cada compound de rueda.

## 6. Crear los joints (uniones)

Un joint por rueda, 4 en total. Para cada uno, **Add joint** y rellena en Propiedades:

| Propiedad | Valor |
|---|---|
| Parent | `base_link` |
| Child | la rueda (`wheel_fl`, etc.) |
| Type | `continuous` |
| Axis | `0 1 0` |
| Origin | centro de la rueda (paso 4) |

Los límites no aplican a `continuous`. Si una rueda gira al revés en la simulación, se arregla en el control, no cambiando el eje.

## 7. Exportar el URDF

1. Selecciona el objeto `Robot` en el árbol.
2. Menú `Cross` > **Export URDF** (o en las propiedades del Robot, elige la carpeta de salida).
3. Destino: `~/Agrobot_demo/urdf/`.
4. Revisa el resultado abriendo el `.urdf` en un editor de texto: deben aparecer 5 `<link>` y 4 `<joint>`.

## 8. Verificar

Con ROS 2 instalado: `ros2 launch urdf_tutorial display.launch.py model:=urdf/ugv.urdf`. Gira las ruedas con los sliders.

## Pendiente para simular en Gazebo

Cross no genera masa, inercia, colisión simple ni el plugin `diff_drive`/`ros2_control`. Se añaden después, a mano, en un xacro.
