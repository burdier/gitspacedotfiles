# Devcontainer

Este devcontainer sirve para trabajar en este repo de dotfiles con un entorno reproducible.

- Las **Features** instalan lo que conviene resolver al construir el contenedor: utilidades base, Git, Node LTS y Docker outside-of-Docker.
- `postCreateCommand` ejecuta `bash install.sh` para aplicar la configuración personal: AstroNvim, Nerd Font, `ctop`, aliases y scripts del repo.
- La fuente de VS Code queda configurada como `JetBrainsMono Nerd Font, monospace` para que los iconos de AstroNvim/devicons funcionen cuando la terminal soporte esa fuente.

Nota: para que estos dotfiles apliquen en **todos** tus Codespaces, `install.sh` sigue siendo necesario porque un `.devcontainer` solo afecta al repo donde vive.
