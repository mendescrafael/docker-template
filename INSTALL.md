# Instalação

Este documento descreve como criar um novo projeto a partir do Docker Template, adaptar sua infraestrutura e executar os ambientes de desenvolvimento e produção.

O projeto fornece uma infraestrutura reutilizável baseada em Docker Multi-stage builds, Docker Compose, arquivos de ambiente, templates, `ENTRYPOINT` e Makefile. O template é um ponto de partida: depois da criação, o projeto derivado deve possuir histórico Git próprio e pode especializar a infraestrutura conforme sua aplicação.

Depois de concluir a primeira implantação, consulte o [guia de uso](USAGE.md) para operar, inspecionar, manter e diagnosticar os ambientes.

## Pré-requisitos

### Sistema operacional

O projeto foi desenvolvido para sistemas GNU/Linux.

Para desenvolvimento em Windows, utilize preferencialmente o WSL e mantenha o repositório em um sistema de arquivos Linux.

Para instalar o WSL, consulte a [documentação oficial da Microsoft](https://learn.microsoft.com/pt-br/windows/wsl/install). No VS Code, o diretório mantido no WSL pode ser acessado com o fluxo descrito no guia de [desenvolvimento remoto no WSL](https://code.visualstudio.com/docs/remote/wsl-tutorial).

### Ferramentas necessárias

Instale e configure:

- Docker Engine 29.7 ou superior;
- Docker Compose;
- Git;
- GNU Make;
- `awk`;
- `getent`;
- `grep`;
- `id`;
- `usermod`;
- `sudo` e os utilitários de gerenciamento de usuários, grupos e permissões do sistema, para usar os alvos de permissionamento;
- `mysql` e `mysqldump`, quando forem utilizados os alvos de backup e restauração;

Confirme as ferramentas principais:

```bash
docker --version
docker compose version
git --version
make --version
```

O usuário atual deve possuir permissão para executar o Docker.

## Obtendo o projeto

Clone o repositório e acesse sua raiz:

```bash
git clone https://github.com/mendescrafael/docker-template.git meu-projeto
cd meu-projeto
rm -rf .git
git init -b main
```

## Preparação

### Visão geral dos ambientes

A arquitetura contempla dois ambientes:

- **Desenvolvimento:** a aplicação e o banco de dados são executados em containers;
- **Produção:** a aplicação é executada em container e o banco de dados é provisionado externamente, em infraestrutura dedicada ou gerenciada;

Os comandos do Makefile com o sufixo `-dev` operam no ambiente de desenvolvimento. Os comandos equivalentes sem esse sufixo operam no ambiente de produção.

```text
make deploy-dev    # Desenvolvimento
make deploy        # Produção
```

### Personalização do projeto

Antes da primeira execução, substitua as referências genéricas, os placeholders e os valores de exemplo pela identidade da aplicação que utilizará o template.

#### Identidade do projeto

Revise:

- Título `Docker Template` usado como identidade inicial;
- Nome e descrição do projeto;
- Autores e licença;
- Nome da aplicação;
- Identificação do cliente ou ambiente;
- Nomes de imagens, containers, volumes e redes;
- Domínio, portas e certificados;
- Metadados OCI da imagem;

Não mantenha valores de exemplo em ambientes reais.

#### Código da aplicação

Adicione o código-fonte ou os artefatos da aplicação em:

```text
app/
```

O estágio `BASE` copia esse conteúdo para `APP_DIR` e aplica as permissões iniciais. Use o estágio `APP` para instalar ou compilar dependências comuns antes das especializações de desenvolvimento e produção.

#### Imagens base e estágios

Revise o Dockerfile para garantir que ele:

- Utilize as imagens base adequadas;
- Instale as dependências necessárias;
- Copie a aplicação para `APP_DIR` no estágio `BASE`, com proprietário e grupo definidos por `APP_RUNTIME_USER` e `APP_RUNTIME_GROUP`;
- Preserve o estágio `BASE` para o código, o `ENTRYPOINT` e os pacotes comuns; adicione processos auxiliares somente quando a aplicação derivada realmente precisar deles;
- Utilize o estágio `APP` para dependências e configurações comuns da aplicação;
- Preserve os estágios `DEV` e `PRD` para especializações do runtime PHP-FPM;
- Preserve `WEB-BASE`, `WEB-DEV` e `WEB-PRD` para o Nginx e copie para eles somente o diretório público da aplicação;
- Mantenha certificados fora das camadas das imagens e monte-os no serviço `web`;
- Defina corretamente `WORKDIR`, `ENTRYPOINT` e `CMD`;
- Utilize em `APP_BUILD_ENV` somente um target final existente, atualmente `dev` ou `prd`;

### Arquivos de ambiente

Crie os arquivos locais a partir dos modelos:

```bash
cp .env.example .env
cp .env.dev.example .env.dev
```

> **Importante:** o alvo `check` verifica a existência de `.env`, `.env.dev`, `docker-compose.yml`, `docker-compose.dev.yml` e `Dockerfile`. Portanto, os dois arquivos de ambiente devem existir mesmo quando a operação pretendida utilizar apenas a configuração de produção.

#### `.env`

O arquivo `.env` reúne as definições gerais e de produção.

O Makefile lê diretamente estas variáveis:

```text
APP_BASE_IMG
APP_BUILD_ENV
APP_VERSION
APP_RUNTIME_USER
APP_RUNTIME_GROUP
CLIENT_ID
DB_BASE_IMG
DOCKER_GROUP
LICENSE
PROJECT_LABEL
PROJECT_NAME
PROJECT_DESCRIPTION
PROJECT_AUTHORS
WEBSERVER_BASE_IMG
```

Preencha também todas as demais variáveis utilizadas pelo Dockerfile, pelo Docker Compose, pelos templates e pelo `ENTRYPOINT`.

As variáveis `APP_NAME`, `APP_ENV`, `APP_DEBUG`, `APP_URL` e `APP_KEY` pertencem à aplicação consumidora e são encaminhadas pelo Docker Compose ao container `app`. Defina os valores conforme o ambiente e mantenha `APP_KEY` vazio no exemplo até que o projeto derivado utilize o mecanismo próprio da aplicação para gerar a chave. `APP_ENV` configura a aplicação; a seleção dos targets Docker permanece sob responsabilidade de `APP_BUILD_ENV`.

#### `.env.dev`

O arquivo `.env.dev` complementa as definições para o ambiente de desenvolvimento, incluindo as configurações do banco de dados executado em container.

Preencha todas as variáveis documentadas em `.env.dev.example`.

#### Segurança dos arquivos de ambiente

Os arquivos `.env` e `.env.dev` podem conter credenciais, tokens, chaves e senhas.

- Não versione esses arquivos;
- Não utilize valores reais nos arquivos `.example`;
- Não compartilhe seus conteúdos em logs ou documentação pública;
- Restrinja o acesso conforme as políticas do ambiente;

### Identificação e versionamento da imagem

O Makefile forma a tag da imagem a partir de `APP_VERSION` e da revisão atual do Git.

Quando o diretório pertence a um repositório Git:

```text
<versao-da-aplicacao>-<git-hash>
```

Quando existem alterações não commitadas:

```text
<versao-da-aplicacao>-<git-hash>-dirty
```

Quando o diretório não pertence a um repositório Git, a tag contém apenas a versão da aplicação.

Consulte a tag calculada:

```bash
make version
```

Exiba as informações técnicas detectadas:

```bash
make info
```

### Docker Compose

Revise os arquivos Docker Compose para refletir os serviços e recursos da aplicação.

#### Produção

O arquivo `docker-compose.yml` define dois serviços de runtime: `app`, baseado em PHP-FPM, e `web`, baseado em Nginx. O serviço `web` publica HTTP/HTTPS, monta os certificados somente leitura e encaminha requisições PHP para `app` via FastCGI. O banco de dados permanece externo ao Compose em produção, salvo quando a arquitetura for deliberadamente modificada.

Os serviços `app` e `web` utilizam `restart: always`. O healthcheck de `app` verifica a porta FastCGI do PHP-FPM; o healthcheck de `web` consulta `http://127.0.0.1:${WEBSERVER_PORT}/health`. Os logs usam o driver `json-file`, limitado a cinco arquivos de 10 MB. O target de `app` é obtido de `APP_BUILD_ENV`, enquanto o target do Nginx é `web-${APP_BUILD_ENV}`.

O server block HTTP do Nginx mantém `/health` disponível localmente e redireciona as demais requisições para HTTPS. O Nginx publica as portas definidas em `WEBSERVER_PORT` e `WEBSERVER_PORT_SSL`; o PHP-FPM permanece acessível somente pela rede interna do Compose na porta `PHP_FPM_PORT`.

Em produção, os targets `WEB-PRD` recebem uma cópia do diretório público gerado pelo target PHP `PRD`. Se a aplicação criar arquivos públicos em runtime, não dependa dessa cópia imutável: configure um volume compartilhado específico entre `app` e `web` ou, preferencialmente, um storage externo/objeto apropriado à aplicação.

#### Desenvolvimento

O arquivo `docker-compose.dev.yml` complementa o Compose principal com:

- Serviço de banco de dados MySQL;
- Volume persistente do banco de dados;
- Diretório de dumps;
- Bind mount `./app:${APP_DIR}:rw` no serviço `app`, que substitui o código incorporado à imagem;
- Bind mount `./app/public:${WEBSERVER_SITE_ROOT_DIR}:ro` no serviço `web`, permitindo servir os arquivos públicos em desenvolvimento;
- Portas HTTP/HTTPS publicadas somente pelo Nginx;
- Política `restart: no` para os serviços locais;
- Verificação do MySQL a cada 30 segundos, com timeout de 10 segundos, três tentativas e período inicial de 20 segundos;
- Rotação dos logs do MySQL em cinco arquivos de 10 MB;

#### Serviços

Mantenha os nomes dos serviços compatíveis com as variáveis do Makefile:

```make
SERVICE_APP ?= app
SERVICE_WEB ?= web
SERVICE_DB ?= db
```

Caso os serviços recebam outros nomes, altere essas variáveis no Makefile ou forneça os valores na execução.

### Templates

Os arquivos em:

```text
data/utils/templates/
```

devem conter a estrutura das configurações do Nginx. `app-site-cfg.conf.template` e `app-site-vhost.conf.template` são copiados para `/etc/nginx/templates/` e processados pelo `ENTRYPOINT` oficial do Nginx.

Defina os valores nos arquivos `.env` e `.env.dev`, e não diretamente nos templates.

Adapte os templates quando a aplicação exigir mudanças estruturais, como diretório público, domínio, proxy reverso, certificados, cabeçalhos, regras de reescrita e caminhos internos.

### ENTRYPOINT

O arquivo:

```text
data/utils/app-entrypoint
```

deve ser adaptado à aplicação hospedada.

A rotina valida as variáveis e o diretório da aplicação e executa o comando principal recebido do Dockerfile. Por padrão, o `CMD` é `php-fpm`. A configuração do Nginx é processada separadamente pelo `ENTRYPOINT` oficial da imagem `nginx`.

O Dockerfile da aplicação não define `USER`, portanto o `ENTRYPOINT` inicia como `root` e entrega o processo principal ao PHP-FPM. Os workers do PHP-FPM e os alvos que reutilizarem `run_app_command` utilizam o usuário definido em `APP_RUNTIME_USER`; o Nginx executa em container independente com o usuário próprio da imagem oficial.

As permissões do código incorporado à imagem PHP são normalizadas durante o build: proprietário e grupo definidos por `APP_RUNTIME_USER` e `APP_RUNTIME_GROUP`, diretórios `750` e arquivos `640`. Os targets Nginx recebem somente o conteúdo de `${APP_DIR}/public`, copiado para a imagem web com propriedade `nginx:nginx`.

O template não define diretórios persistentes genéricos para a aplicação. Quando um projeto derivado precisar deles, declare caminhos, mounts, permissões e rotinas de inicialização conforme a responsabilidade concreta da aplicação.

No desenvolvimento, o bind mount de `./app` substitui o conteúdo e as permissões incorporados à imagem PHP. Preserve no hospedeiro a leitura e a travessia necessárias ao usuário de runtime da aplicação. O Nginx recebe `./app/public` em modo somente leitura.


> **Segurança:** a validação registra somente o nome das variáveis obrigatórias, nunca seus valores. Continue tratando logs como dados operacionais e sanitize qualquer conteúdo específico da aplicação antes de compartilhá-lo.

Evite operações destrutivas, migrações irreversíveis ou rotinas que não possam ser executadas novamente com segurança.

### Certificados SSL

Quando forem utilizados certificados próprios, copie-os para:

```text
data/utils/ssl/
```

Mantenha os nomes esperados:

```text
cert-file.crt
cert-file.key
```

Os arquivos com sufixo `.example` servem somente como referência.

Nunca versione chaves privadas reais.

### Grupos do usuário

Depois de preencher `.env`, confira os valores de `DOCKER_GROUP` e `APP_RUNTIME_GROUP`.

Adicione o usuário atual aos grupos configurados:

```bash
make add-user-groups
```

Depois, encerre e inicie novamente a sessão, ou reinicie o WSL.

Confirme:

```bash
id
docker ps
```

## Permissões

Quando necessário, aplique o padrão de permissões:

```bash
make apply-permissions
```

O comando aplica recursivamente:

- Diretórios: `2775`, com o bit `setgid`;
- Arquivos regulares: `664`;
- Arquivos executáveis: `775`;
- Proprietário: usuário atual;
- Grupo: valor de `DOCKER_GROUP`;

> **Atenção:** o alvo utiliza `sudo chown` e `sudo chmod` em toda a raiz do projeto. Revise o conteúdo do diretório antes de executá-lo.

Esse alvo corrige as permissões do workspace no hospedeiro. O padrão `750` e `640` aplicado durante o build não é reaplicado pelo `ENTRYPOINT` a todo o bind mount de código do ambiente de desenvolvimento.

## Verificação

Liste os comandos disponíveis:

```bash
make help
```

Exiba os dados do projeto:

```bash
make info
```

Consulte a versão calculada da imagem:

```bash
make version
```

### Validação da configuração

Antes de construir as imagens, valide o Docker Compose.

#### Desenvolvimento

```bash
make config-dev
make validate-dev
```

#### Produção

```bash
make config
make validate
```

`config` exibe a configuração resultante. `validate` executa a validação silenciosa.

Corrija todos os erros antes de prosseguir.

### Implantação em desenvolvimento

O ambiente de desenvolvimento combina `docker-compose.yml`, `docker-compose.dev.yml`, `.env` e `.env.dev`.

#### Construção e inicialização

Execute:

```bash
make deploy-dev
```

Esse alvo executa `build-dev` e `up-dev`.

As etapas também podem ser executadas separadamente:

```bash
make build-dev
make up-dev
```

#### Verificação

```bash
make status-dev
make status-all-dev
make logs-dev
```

#### Acesso ao container

```bash
make app-shell-dev
```

Depois que os containers estiverem ativos, conclua os procedimentos específicos da aplicação.

### Implantação em produção

O ambiente de produção utiliza `docker-compose.yml` e `.env`.

#### Preparação

Antes da implantação:

- Provisione o banco de dados externo;
- Crie o banco e o usuário;
- Conceda somente as permissões necessárias;
- Configure a conectividade entre a aplicação e o banco;
- Valide DNS, domínio, portas, certificados e firewall;
- Confirme os volumes persistentes;
- Revise limites de recursos e políticas de reinicialização;
- Realize backup dos dados existentes;

#### Construção e inicialização

Execute:

```bash
make deploy
```

Esse alvo executa `build` e `up`.

As etapas também podem ser executadas separadamente:

```bash
make build
make up
```

#### Verificação

```bash
make status
make status-all
make logs
```

#### Acesso ao container

```bash
make app-shell
```

Depois, execute os procedimentos específicos de instalação ou atualização da aplicação.

### Detalhes específicos do Docker Template

#### Comandos específicos da aplicação

O Makefile contém uma área reservada para alvos próprios da aplicação:

```make
# TODO: Adicione aqui alvos para comandos específicos da aplicação.
```

Adicione os novos alvos imediatamente antes de `help` e inclua suas descrições no próprio alvo `help`.

Quando o comando não exigir privilégios administrativos, reutilize `run_app_command` para executá-lo no container como `APP_RUNTIME_USER`. Por exemplo:

```make
minhaapp-tarefa: check
	@$(call run_app_command,$(COMPOSE),/usr/local/bin/minhaapp tarefa)

minhaapp-tarefa-dev: check
	@$(call run_app_command,$(COMPOSE_DEV),/usr/local/bin/minhaapp tarefa)
```

Exemplos de operações específicas:

- Limpeza de cache;
- Migração de banco;
- Criação de usuário;
- Instalação de dependências;
- Execução de testes;
- Tarefas agendadas;
- Atualização da aplicação;
- Geração de arquivos estáticos;

Use nomes no padrão:

```text
nomeaplicacao-comando
```

Exemplo:

```text
minhaapp-clear-cache
```

### Verificação final

Antes de considerar o projeto adaptado, confirme:

- O título `Docker Template` foi substituído pela identidade do projeto derivado;
- O código da aplicação foi incluído em `app/`;
- As imagens base foram definidas;
- `.env.example` e `.env.dev.example` foram adaptados;
- `.env` e `.env.dev` foram criados;
- Os arquivos Compose foram ajustados;
- Os serviços usam os nomes esperados pelo Makefile;
- O Dockerfile foi adaptado;
- O `ENTRYPOINT` foi adaptado;
- `APP_RUNTIME_USER` e `APP_RUNTIME_GROUP` correspondem ao usuário e ao grupo disponíveis na imagem PHP-FPM;
- `PHP_FPM_HOST` e `PHP_FPM_PORT` correspondem ao serviço e à porta internos usados pelo Nginx;
- `WEBSERVER_BASE_IMG` corresponde a uma imagem Nginx compatível;
- Os templates foram adaptados;
- Os certificados foram configurados;
- Os volumes persistentes foram definidos;
- O banco externo de produção foi provisionado;
- Os comandos específicos da aplicação foram documentados;
- `make validate-dev` foi executado;
- `make validate` foi executado;
- A implantação foi testada em desenvolvimento;
- Backups e procedimentos de recuperação foram definidos;

## Atualização

Antes de atualizar o template ou a aplicação:

- Gere backup do banco de dados;
- Preserve os diretórios persistentes;
- Revise alterações em `.env.example` e `.env.dev.example`;
- Compare o Dockerfile, os arquivos Compose, o `ENTRYPOINT` e os templates;
- Verifique se personalizações locais serão sobrescritas;
- Valide primeiro em desenvolvimento ou homologação;

### Desenvolvimento

```bash
make validate-dev
make rebuild-dev
make status-dev
make logs-dev
```

### Produção

```bash
make validate
make rebuild
make status
make logs
```

## Próximos passos

Depois de adaptar, implantar e verificar o projeto, consulte o [USAGE.md](USAGE.md) para operar, manter, atualizar e diagnosticar os ambientes.

## Diagnóstico

### Arquivos obrigatórios

O alvo `check` exige:

```text
.env
.env.dev
docker-compose.yml
docker-compose.dev.yml
Dockerfile
```

### Docker sem `sudo`

Execute:

```bash
make add-user-groups
```

Depois, reabra a sessão e confirme:

```bash
docker ps
```

### Erros de permissão

Execute:

```bash
make apply-permissions
```

Revise também `DOCKER_GROUP`, `APP_RUNTIME_USER` e `APP_RUNTIME_GROUP`. Depois do ajuste no hospedeiro, reinicie o ambiente com `make restart-dev` no desenvolvimento ou `make restart` na produção.

Se a falha ocorrer somente no desenvolvimento, lembre-se de que `./app:${APP_DIR}:rw` substitui as permissões definidas no build. Confirme que `APP_RUNTIME_USER` consegue atravessar `APP_DIR`, ler os arquivos da aplicação e gravar somente nos caminhos persistentes exigidos pela implementação.

### Erros do Docker Compose

Desenvolvimento:

```bash
make config-dev
make validate-dev
```

Produção:

```bash
make config
make validate
```

### Container não inicia

Desenvolvimento:

```bash
make status-all-dev
make logs-dev
```

Produção:

```bash
make status-all
make logs
```

Analise os logs antes de reconstruir ou remover recursos.

### Certificados não encontrados

Confirme que `data/utils/ssl/` contém os certificados ativos com os nomes esperados pela configuração do Nginx. Os arquivos `.example` servem apenas como modelos. O diretório é montado no serviço `web` em modo somente leitura e não é incorporado às imagens.

## Segurança

Proteja os arquivos de ambiente, certificados, dumps e diretórios persistentes. Para comunicar vulnerabilidades de forma responsável, siga o processo privado descrito no [SECURITY.md](SECURITY.md).
