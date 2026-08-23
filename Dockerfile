# -----------------------------------------------------------------------------
# SPDX-License-Identifier: GPL-3.0-or-later
#
# @copyright Copyright (c) 2026 Rafael Mendes
# @license   GPLv3+ <https://www.gnu.org/licenses/gpl-3.0.html>
# @link      GitHub <https://github.com/mendescrafael>
#
# This file is part of Docker Template.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Este Dockerfile utiliza Multi-stage builds com duas famílias de imagens:
#
#   Aplicação PHP-FPM:
#     - BASE: Dependências e configuração comuns;
#     - APP:  Especialização da aplicação;
#     - DEV:  Runtime de desenvolvimento;
#     - PRD:  Runtime de produção;
#
#   Web server Nginx:
#     - WEB-BASE: Configuração comum do Nginx;
#     - WEB-DEV:  Arquivos públicos gerados pelo target DEV;
#     - WEB-PRD:  Arquivos públicos gerados pelo target PRD;
#
# O Compose constrói `app` usando `${APP_BUILD_ENV}` e `web` usando
# `web-${APP_BUILD_ENV}`, preservando um único Dockerfile e a reutilização entre
# ambientes.
# -----------------------------------------------------------------------------

# Imagens base. Os valores podem ser sobrescritos por argumentos de build.
ARG APP_BASE_IMG=php:8.5.9-fpm-trixie
ARG WEBSERVER_BASE_IMG=nginx:1.30.4-alpine3.24

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: BASE
# -----------------------------------------------------------------------------
FROM ${APP_BASE_IMG} AS base

ARG APP_DIR
ARG APP_RUNTIME_GROUP
ARG APP_RUNTIME_USER
ARG BUILD_DATE
ARG LICENSE
ARG PHP_FPM_PORT
ARG PROJECT_AUTHORS
ARG PROJECT_DESCRIPTION
ARG PROJECT_LABEL
ARG REVISION
ARG TAG_IMAGE
ARG TZ
ARG VENDOR_LABEL

ENV DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="${PROJECT_LABEL}"
LABEL org.opencontainers.image.description="${PROJECT_DESCRIPTION}"
LABEL org.opencontainers.image.authors="${PROJECT_AUTHORS}"
LABEL org.opencontainers.image.licenses="${LICENSE}"
LABEL org.opencontainers.image.vendor="${VENDOR_LABEL}"
LABEL org.opencontainers.image.version="${TAG_IMAGE}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${REVISION}"

WORKDIR ${APP_DIR}

# Conteúdo da aplicação.
COPY --chown=${APP_RUNTIME_USER}:${APP_RUNTIME_GROUP} app/ .
RUN chown "${APP_RUNTIME_USER}:${APP_RUNTIME_GROUP}" "${APP_DIR}" \
    && find "${APP_DIR}" -type d -exec chmod 750 {} + \
    && find "${APP_DIR}" -type f -exec chmod 640 {} +

# ENTRYPOINT da aplicação.
COPY data/utils/app-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/app-entrypoint

# Pacotes comuns aos ambientes.
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    logrotate \
    && rm -rf /var/lib/apt/lists/*

# Timezone.
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# Rotacionamento de logs.
RUN test -f /etc/logrotate.conf \
    && sed -i 's/weekly/daily/g' /etc/logrotate.conf \
    || echo "'/etc/logrotate.conf' não encontrado, ignorando..."

ENTRYPOINT ["app-entrypoint"]
CMD ["php-fpm"]
# -----------------------------------------------------------------------------
# [END] Multi-stage: BASE
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: APP
# -----------------------------------------------------------------------------
FROM base AS app

# TODO: Adicione aqui as instruções comuns do build da aplicação para os
# ambientes de produção e desenvolvimento.
# -----------------------------------------------------------------------------
# [END] Multi-stage: APP
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: DEV
# -----------------------------------------------------------------------------
FROM app AS dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    libarchive-tools \
    unzip \
    gnupg \
    vim \
    iproute2 \
    iputils-ping \
    dnsutils \
    git \
    && rm -rf /var/lib/apt/lists/*

# TODO: Adicione aqui as instruções específicas de desenvolvimento.

EXPOSE ${PHP_FPM_PORT}
# -----------------------------------------------------------------------------
# [END] Multi-stage: DEV
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: PRD
# -----------------------------------------------------------------------------
FROM app AS prd

# TODO: Adicione aqui as instruções específicas de produção.

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE ${PHP_FPM_PORT}
# -----------------------------------------------------------------------------
# [END] Multi-stage: PRD
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: WEB-BASE
#
# O Nginx é executado em um container separado e encaminha requisições PHP ao
# serviço `app` por FastCGI. A imagem oficial processa automaticamente os
# templates presentes em `/etc/nginx/templates/` durante a inicialização.
# -----------------------------------------------------------------------------
FROM ${WEBSERVER_BASE_IMG} AS web-base

ARG BUILD_DATE
ARG LICENSE
ARG PROJECT_AUTHORS
ARG PROJECT_DESCRIPTION
ARG PROJECT_LABEL
ARG REVISION
ARG TAG_IMAGE
ARG VENDOR_LABEL

LABEL org.opencontainers.image.title="${PROJECT_LABEL} Web"
LABEL org.opencontainers.image.description="${PROJECT_DESCRIPTION} - Nginx web server"
LABEL org.opencontainers.image.authors="${PROJECT_AUTHORS}"
LABEL org.opencontainers.image.licenses="${LICENSE}"
LABEL org.opencontainers.image.vendor="${VENDOR_LABEL}"
LABEL org.opencontainers.image.version="${TAG_IMAGE}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${REVISION}"

# Remove o site padrão e instala os templates do projeto. O ENTRYPOINT oficial
# do Nginx executará envsubst e gerará os arquivos em `/etc/nginx/conf.d/`.
RUN rm -f /etc/nginx/conf.d/default.conf
COPY data/utils/templates/app-site-cfg.conf.template /etc/nginx/templates/
COPY data/utils/templates/app-site-vhost.conf.template /etc/nginx/templates/
# -----------------------------------------------------------------------------
# [END] Multi-stage: WEB-BASE
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: WEB-DEV
# -----------------------------------------------------------------------------
FROM web-base AS web-dev

ARG APP_DIR
ARG WEBSERVER_SITE_ROOT_DIR
ARG WEBSERVER_PORT
ARG WEBSERVER_PORT_SSL

RUN mkdir -p "${WEBSERVER_SITE_ROOT_DIR}"
COPY --from=dev --chown=nginx:nginx ${APP_DIR}/public/ ${WEBSERVER_SITE_ROOT_DIR}/

EXPOSE ${WEBSERVER_PORT} ${WEBSERVER_PORT_SSL}
# -----------------------------------------------------------------------------
# [END] Multi-stage: WEB-DEV
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# [BEGIN] Multi-stage: WEB-PRD
# -----------------------------------------------------------------------------
FROM web-base AS web-prd

ARG APP_DIR
ARG WEBSERVER_SITE_ROOT_DIR
ARG WEBSERVER_PORT
ARG WEBSERVER_PORT_SSL

RUN mkdir -p "${WEBSERVER_SITE_ROOT_DIR}"
COPY --from=prd --chown=nginx:nginx ${APP_DIR}/public/ ${WEBSERVER_SITE_ROOT_DIR}/

EXPOSE ${WEBSERVER_PORT} ${WEBSERVER_PORT_SSL}
# -----------------------------------------------------------------------------
# [END] Multi-stage: WEB-PRD
# -----------------------------------------------------------------------------
