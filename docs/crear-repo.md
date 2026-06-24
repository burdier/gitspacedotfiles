# Crear el repo en GitHub

Opción con GitHub CLI:

```bash
git init
git add .
git commit -m "Initial dotfiles for Codespaces"
gh repo create dotfiles --private --source=. --remote=origin --push
```

Opción manual:

1. Crea un repo vacío llamado `dotfiles` en GitHub.
2. Ejecuta:

```bash
git init
git add .
git commit -m "Initial dotfiles for Codespaces"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/dotfiles.git
git push -u origin main
```

Después activa el repo en GitHub → Settings → Codespaces → Dotfiles.
