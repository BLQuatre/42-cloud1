# cloud-1: Automated WordPress Infrastructure Deployment

An Ansible-based infrastructure automation project that deploys a complete WordPress stack using Docker containers. This project automatically provisions and configures a production-ready WordPress environment with MariaDB, Caddy web server (with automatic HTTPS via Cloudflare DNS), and phpMyAdmin.

## 🏗️ Architecture

The deployment consists of four containerized services orchestrated via Docker Compose:

- **Caddy**: Reverse proxy and web server with automatic HTTPS via Cloudflare DNS
- **WordPress**: PHP-FPM WordPress installation
- **MariaDB**: MySQL-compatible database server
- **phpMyAdmin**: Web-based database management interface

All services communicate through a dedicated Docker bridge network (`cloud1`), with persistent data stored in Docker volumes.

## 📋 Prerequisites

- Python 3.x
- Docker (will be installed automatically by Ansible if not present)
- A target server (Ubuntu-based) accessible via SSH
- Cloudflare API token (for automatic HTTPS certificate provisioning)
- Domain name configured with Cloudflare DNS

## 🚀 Quick Start

### 1. Setup Python Virtual Environment

```bash
make setup
```

This creates a Python virtual environment, installs Ansible and create inventory.ini and vault.yml.

### 2. Configure Inventory

Edit `inventory.ini` with your server details:

```ini
[servers]
srv1 ansible_host=YOUR_SERVER_IP ansible_user=YOUR_USER ansible_password=YOUR_PASSWORD ansible_become_password=YOUR_SUDO_PASSWORD ansible_ssh_port=22
```

### 3. Configure Secrets

Edit `vault.yml` with your configuration:

```yaml
DOMAIN_NAME: "yourdomain.com"

WP_SQL_HOST: "mariadb"
WP_SQL_PORT: "3306"
WP_SQL_DATABASE: "wordpress"
WP_SQL_USER: "wordpress_user"
WP_SQL_PASSWORD: "your_secure_password"

WP_ADMIN_USER: "admin"
WP_ADMIN_EMAIL: "admin@yourdomain.com"
WP_ADMIN_PASSWORD: "your_secure_admin_password"

MARIADB_ROOT_PASSWORD: "your_secure_root_password"

CF_API_TOKEN: "your_cloudflare_api_token"

PMA_HOST: "mariadb"
PMA_PORT: "3306"
PMA_ABSOLUTE_URI: "/pma"
```

**Security Note**: For production, encrypt `vault.yml` using Ansible Vault:

```bash
make encrypt
```

### 4. Test Connectivity

```bash
make ping
```

### 5. Deploy Infrastructure

```bash
make playbook
```

This will:
1. Install Docker and Docker Compose on the target server
2. Deploy all configuration files and Dockerfiles
3. Build custom Docker images
4. Start all services
5. Verify deployment status

## 🛠️ Project Structure

```
.
├── ansible.cfg                    # Ansible configuration
├── inventory.ini                  # Server inventory (not in repo)
├── vault.yml                      # Secret variables (not in repo)
├── playbook.yml                   # Main Ansible playbook
├── Makefile                       # Convenience commands
├── requirements.txt               # Python dependencies
├── local/                         # Local testing environment
│   └── Dockerfile                 # Ubuntu SSH server for testing
└── roles/                         # Ansible roles
    ├── docker/                    # Docker installation & compose setup
    │   ├── files/
    │   │   └── docker-compose.yml
    │   ├── tasks/
    │   │   └── main.yml
    │   └── templates/
    │       └── .env.j2
    ├── mariadb/                   # MariaDB database configuration
    │   ├── files/
    │   │   ├── Dockerfile
    │   │   └── conf/
    │   └── tasks/
    ├── wordpress/                 # WordPress configuration
    │   ├── files/
    │   │   ├── Dockerfile
    │   │   ├── conf/
    │   │   └── tools/
    │   └── tasks/
    └── caddy/                     # Caddy reverse proxy
        ├── files/
        │   ├── Dockerfile
        │   └── conf/
        │       └── Caddyfile
        └── tasks/
```

## 📦 What Gets Deployed

The Ansible playbook deploys everything to `/opt/cloud1/` on the target server:

```
/opt/cloud1/
├── docker-compose.yml
├── .env
├── mariadb/
│   ├── Dockerfile
│   └── conf/
├── wordpress/
│   ├── Dockerfile
│   ├── conf/
│   └── tools/
└── caddy/
    ├── Dockerfile
    └── conf/
```

## 🔍 Available Commands

| Command | Description |
|---------|-------------|
| `make setup` | Create Python venv, install dependencies and create files |
| `make encrypt` | Encrypt vault.yml with Ansible Vault |
| `make view-vault` | View encrypted vault.yml contents |
| `make ping` | Test Ansible connectivity to servers |
| `make inventory` | Display parsed inventory |
| `make playbook` | Execute the main deployment playbook |

## 🌐 Accessing Services

After deployment, services are available at:

- **WordPress**: `https://yourdomain.com`
- **phpMyAdmin**: `https://yourdomain.com/pma`

HTTPS certificates are automatically provisioned and renewed via Caddy using Cloudflare DNS challenge.

## 🔧 Customization

### Changing the Deployment Path

Edit the `app_path` variable in `playbook.yml`:

```yaml
vars:
  app_path: "/opt/cloud1"  # Change to your preferred path
```

## 📊 Monitoring Deployment

The playbook displays status information during execution:

- Docker version verification
- Docker Compose version verification
- Container build progress
- Container health status
- Individual container states

## 📝 License

This project is part of the 42 School curriculum.

## 🤝 Contributing

This is an educational project. Feel free to fork and adapt for your own learning purposes.

---

**Built with ❤️ for the 42 School cloud-1 project**
