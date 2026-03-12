#!/usr/bin/env bash
# scaffold-role.sh — create a new app role skeleton
# Usage: ./scaffold-role.sh <role_name>

set -e

ROLE=$1
if [ -z "$ROLE" ]; then
  echo "Usage: $0 <role_name>"
  exit 1
fi

DIR="$(dirname "$0")/$ROLE"

if [ -d "$DIR" ]; then
  echo "Role '$ROLE' already exists at $DIR"
  exit 1
fi

mkdir -p "$DIR"/{defaults,tasks,templates,handlers,meta}

cat > "$DIR/defaults/main.yml" <<EOF
---
# Default values for $ROLE
# Override in group_vars or host_vars

${ROLE}_image_version: latest
${ROLE}_data_dir: "{{ docker_root }}/$ROLE"
EOF

cat > "$DIR/tasks/main.yml" <<EOF
---
- name: Create $ROLE directory structure
  ansible.builtin.file:
    path: "{{ item }}"
    state: directory
    owner: "{{ ansible_user }}"
    mode: "0750"
  loop:
    - "{{ ${ROLE}_data_dir }}"

- name: Deploy $ROLE compose file
  ansible.builtin.template:
    src: docker-compose.yml.j2
    dest: "{{ ${ROLE}_data_dir }}/docker-compose.yml"
    owner: "{{ ansible_user }}"
    mode: "0640"
  notify: restart $ROLE

- name: Start $ROLE stack
  community.docker.docker_compose_v2:
    project_src: "{{ ${ROLE}_data_dir }}"
    state: present
EOF

cat > "$DIR/handlers/main.yml" <<EOF
---
- name: restart $ROLE
  community.docker.docker_compose_v2:
    project_src: "{{ ${ROLE}_data_dir }}"
    state: present
    recreate: always
EOF

cat > "$DIR/meta/main.yml" <<EOF
---
galaxy_info:
  role_name: $ROLE
  description: Deploy $ROLE Docker stack
  min_ansible_version: "2.14"
dependencies:
  - role: common
EOF

cat > "$DIR/templates/docker-compose.yml.j2" <<'EOF'
{# TODO: import macros as needed #}
{# {% from 'macros/postgres.j2' import postgres %} #}
{# {% from 'macros/redis.j2'    import redis    %} #}
{# {% from 'macros/traefik.j2'  import labels   %} #}

networks:
  # TODO: define networks

services:
  # TODO: define services
EOF

echo "Created role: $DIR"
