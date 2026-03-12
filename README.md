# [Nombre del proyecto]

> Breve descripción en una línea: qué hace el proyecto y para quién.

---

## Contexto

Describe aquí el origen del proyecto, el problema que aborda y por qué existe. Incluye:

- **Antecedentes**: de dónde surge la necesidad o el encargo.
- **Alcance**: qué está dentro y fuera del proyecto.
- **Stakeholders**: quién pide los resultados y quién los usa.

---

## Objetivos y entregables

Lista clara de qué se espera obtener al final del proyecto:

- [ ] Entregable 1 (ej.: informe ejecutivo, dashboard, modelo).
- [ ] Entregable 2 (ej.: notebooks de exploración, scripts de procesamiento).
- [ ] Criterios de éxito (ej.: métricas, plazos, formato de entrega).

---

## Productos finales y enlaces

Enlaces directos a los artefactos publicados (reports, dashboards, documentos):

| Producto | Descripción | Enlace |
|----------|-------------|--------|
| Ej.: Reporte principal | Resumen ejecutivo en HTML/PDF | [link] |
| Ej.: Notebook exploratorio | Análisis inicial de datos | [link] |

*(Actualiza esta tabla cuando tengas URLs reales.)*

---

## Problemas conocidos y limitaciones

- **Problema 1**: descripción breve y, si aplica, workaround o issue asociado.
- **Problema 2**: idem.

*(Elimina esta sección si no hay problemas conocidos; si los hay, manténla actualizada.)*

---

## Cómo empezar

### Requisitos

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/) (para Dev Containers)
- [VS Code](https://code.visualstudio.com/) con la extensión [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Ejecución con Dev Containers (integración con VS Code y pasos mínimos)

1. Crea un nuevo repositorio en Github usando el template de este proyecto.
2. En VS Code, luego de vincular tu cuenta de github, usa CTRL+SHIFT+P y elige **Remote-Containers: Clone Repository in Container Volume...**
3. Sigue los pasos y escoge el directorio donde quieres clonar el repositorio.
4. Espera a que se construya el contenedor. Además del archivo de configuración del devcontainer, también se ejecuta el script `install-dev-tools.sh` para instalar las dependencias necesarias; luego tendrás R, Python y Quarto listos en el mismo entorno.
5. Puedes hacer commits y pushes directamente desde VS Code o la terminal del contenedor.


### Ejecución manual y alternativa

1. Clona el repositorio localmente en tu máquina.
2. Abre la carpeta del proyecto en VS Code.
3. Cuando te lo pida, elige **Reopen in Container**.
4. Espera a que se construya el contenedor. Además del archivo de configuración del devcontainer, también se ejecuta el script `install-dev-tools.sh` para instalar las dependencias necesarias; luego tendrás R, Python y Quarto listos en el mismo entorno.
5. Debe haber una configuración previa de git y github para poder hacer commits y pushes directamente desde VS Code o la terminal del contenedor.

### Estructura del proyecto

Basada en [cookiecutter-data-science](https://drivendata.github.io/cookiecutter-data-science/):

```
├── data/                 # Datos 
├── notebooks/            # Cuadernos Quarto (.qmd)
├── notebooks-rendered/   # HTML/otros generados desde los notebooks
├── scripts/              # Scripts reutilizables (R, Python; ver scripts/scripts.md)
├── _quarto.yml           # Configuración de Quarto
├── changelog.md          # Historial de cambios del proyecto
└── README.md             # Este archivo
```

### Stack tecnológico

- **R** y **Python** para análisis y scripting.
- **Quarto** para notebooks y reportes reproducibles (HTML, PDF, etc.).
- **Dev Containers** para un entorno reproducible y aislado.

---

## Changelog

Los cambios relevantes del proyecto se documentan en [changelog.md](changelog.md).

---
