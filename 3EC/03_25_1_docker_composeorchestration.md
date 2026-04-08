## What is Docker Compose?

Docker Compose is a tool that lets you define and run multiple containers together as one app.

Think of it like:
Instead of manually running:
a WordPress container
a MySQL container
maybe phpMyAdmin

…you describe everything in one file (docker-compose.yml) and start it all with one command.

🧠 Simple analogy
Docker = individual Lego blocks
Docker Compose = instructions for assembling a full Lego set
🔧 What it actually does

With Compose, you define:

services (containers)
networks (how they talk)
volumes (data storage)