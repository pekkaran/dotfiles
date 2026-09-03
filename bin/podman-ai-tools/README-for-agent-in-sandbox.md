# Info for AI agent

This process is running in a Podman sandbox on Arch Linux based image. The used `Containerfile` has been included.

The user's working directory has been mounted at `/work`. The files you need are most likely there, though other volumes may also have been mounted.

You may install any packages by using passwordless `sudo`. When you do install programs, make a note of it to the user so they can preinstall them for newer versions of the image.

The `/home/node/` folder is persisted across container runs, so you can save "memories" and other configuration there.
