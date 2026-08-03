# Instalação

Este documento descreve como adaptar, configurar e executar o Docker Template em ambientes de desenvolvimento e produção.

O projeto fornece uma infraestrutura reutilizável baseada em Docker Multi-stage builds, Docker Compose, arquivos de ambiente, templates, `ENTRYPOINT` e Makefile. Antes da primeira execução, a estrutura deve ser personalizada para a aplicação que utilizará o template.

## Pré-requisitos

### Sistema operacional

O projeto foi desenvolvido para sistemas GNU/Linux.

Para desenvolvimento em Windows, utilize preferencialmente o WSL e mantenha o repositório em um sistema de arquivos Linux.

### Ferramentas necessárias

Instale e configure:

- Docker Engine;
- Docker Compose Plugin;
- Git;
- GNU Make;
- `awk`;
- `getent`;
- `grep`;
- `id`;
- `usermod`;
- `sudo`, quando necessário para grupos e permissões;
- cliente e utilitário de dump do banco de dados, quando forem utilizados os alvos de backup e restauração.

Confirme as ferramentas principais:

```bash
docker --version
docker compose version
git --version
make --version
```

O usuário atual deve possuir permissão para executar o Docker.

## Visão geral dos ambientes

A arquitetura contempla dois ambientes:

- **Desenvolvimento:** a aplicação e o banco de dados são executados em containers.
- **Produção:** a aplicação é executada em container e o banco de dados é provisionado externamente, em infraestrutura dedicada ou gerenciada.

Os comandos do Makefile com o sufixo `-dev` operam no ambiente de desenvolvimento. Os comandos equivalentes sem esse sufixo operam no ambiente de produção.

```text
make deploy-dev    # Desenvolvimento
make deploy        # Produção
```

## Obtendo o projeto

Clone o repositório e acesse sua raiz:

```bash
git clone https://github.com/mendescrafael/docker-template.git && cd docker-template
```

A raiz deve conter, no mínimo:

```text
app/
data/
.env.example
.env.dev.example
docker-compose.yml
docker-compose.dev.yml
Dockerfile
Makefile
README.md
```

## Estrutura principal

A estrutura base do projeto é:

```text
./
├── app/
├── data/
│   ├── app/
│   │   ├── config/
│   │   └── files/
│   ├── db/
│   │   └── dumps/
│   ├── misc/
│   └── utils/
│       ├── ssl/
│       │   ├── cert-file.crt.example
│       │   └── cert-file.key.example
│       ├── templates/
│       │   ├── app-site-cfg.conf.template
│       │   ├── app-site-vhost.conf.template
│       │   └── app-cron.template
│       └── app-entrypoint
├── .env
├── .env.dev
├── .env.dev.example
├── .env.example
├── docker-compose.dev.yml
├── docker-compose.yml
├── Dockerfile
├── Makefile
└── README.md
```

Os diretórios possuem as seguintes responsabilidades:

- `app/`: código-fonte ou artefatos da aplicação hospedada;
- `data/app/config/`: arquivos persistentes de configuração da aplicação;
- `data/app/files/`: arquivos persistentes produzidos ou consumidos pela aplicação;
- `data/db/dumps/`: dumps do banco de dados no ambiente de desenvolvimento;
- `data/misc/`: arquivos auxiliares;
- `data/utils/ssl/`: certificados SSL;
- `data/utils/templates/`: templates processados pelo `ENTRYPOINT`;
- `data/utils/app-entrypoint`: script de inicialização da aplicação.

## Personalização do projeto

Antes da primeira execução, substitua as referências genéricas, os placeholders e os valores de exemplo pela identidade da aplicação que utilizará o template.

### Identidade do projeto

Revise:

- `{Nome do projeto}`;
- nome e descrição do projeto;
- autores e licença;
- nome da aplicação;
- identificação do cliente ou ambiente;
- nomes de imagens, containers, volumes e redes;
- domínio, portas e certificados;
- metadados OCI da imagem.

Não mantenha valores de exemplo em ambientes reais.

### Código da aplicação

Adicione o código-fonte ou os artefatos da aplicação em:

```text
app/
```

A forma como esse conteúdo é copiado, instalado ou compilado depende das instruções definidas no estágio `APP` do Dockerfile.

### Imagens base e estágios

Revise o Dockerfile para garantir que ele:

- utilize as imagens base adequadas;
- instale as dependências necessárias;
- copie a aplicação para o caminho correto;
- preserve os estágios `BASE`, `APP`, `DEV` e `PRD`;
- defina corretamente `WORKDIR`, `ENTRYPOINT` e `CMD`;
- aplique configurações de desenvolvimento somente no estágio `DEV`;
- aplique configurações de desempenho e segurança no estágio `PRD`.

## Arquivos de ambiente

Crie os arquivos locais a partir dos modelos:

```bash
cp .env.example .env
cp .env.dev.example .env.dev
```

> **Importante:** o alvo `check` verifica a existência de `.env`, `.env.dev`, `docker-compose.yml`, `docker-compose.dev.yml` e `Dockerfile`. Portanto, os dois arquivos de ambiente devem existir mesmo quando a operação pretendida utilizar apenas a configuração de produção.

### `.env`

O arquivo `.env` reúne as definições gerais e de produção.

O Makefile lê diretamente estas variáveis:

```text
APP_BASE_IMG
APP_NAME
APP_VERSION
CLIENT_ID
DB_BASE_IMG
DOCKER_GROUP
LICENSE
PROJECT_NAME
PROJECT_DESCRIPTION
PROJECT_AUTHORS
WEBSERVER_GROUP
```

Preencha também todas as demais variáveis utilizadas pelo Dockerfile, pelo Docker Compose, pelos templates e pelo `ENTRYPOINT`.

### `.env.dev`

O arquivo `.env.dev` complementa as definições para o ambiente de desenvolvimento, incluindo as configurações do banco de dados executado em container.

Preencha todas as variáveis documentadas em `.env.dev.example`.

### Segurança dos arquivos de ambiente

Os arquivos `.env` e `.env.dev` podem conter credenciais, tokens, chaves e senhas.

- Não versione esses arquivos.
- Não utilize valores reais nos arquivos `.example`.
- Não compartilhe seus conteúdos em logs ou documentação pública.
- Restrinja o acesso conforme as políticas do ambiente.

## Identificação e versionamento da imagem

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

## Docker Compose

Revise os arquivos Docker Compose para refletir os serviços e recursos da aplicação.

### Produção

O arquivo `docker-compose.yml` deve definir a aplicação e os recursos necessários à execução em produção. O banco de dados deve permanecer externo ao Compose, salvo quando a arquitetura for deliberadamente modificada.

### Desenvolvimento

O arquivo `docker-compose.dev.yml` deve complementar o Compose principal e pode incluir:

- serviço de banco de dados;
- volumes de desenvolvimento;
- portas locais;
- bind mounts;
- ferramentas de diagnóstico;
- configurações de depuração;
- políticas de reinicialização adequadas ao ambiente local.

### Serviços

Mantenha os nomes dos serviços compatíveis com as variáveis do Makefile:

```make
SERVICE_APP ?= app
SERVICE_DB ?= db
```

Caso os serviços recebam outros nomes, altere essas variáveis no Makefile ou forneça os valores na execução.

## Templates

Os arquivos em:

```text
data/utils/templates/
```

devem conter a estrutura das configurações do servidor web e do agendador.

Defina os valores nos arquivos `.env` e `.env.dev`, e não diretamente nos templates.

Adapte os templates quando a aplicação exigir mudanças estruturais, como diretório público, domínio, proxy reverso, certificados, cabeçalhos, regras de reescrita, agendamento de tarefas e caminhos internos.

## ENTRYPOINT

O arquivo:

```text
data/utils/app-entrypoint
```

deve ser adaptado à aplicação hospedada.

A rotina pode processar variáveis nos templates, preparar diretórios, ajustar permissões, gerar configurações, executar comandos de inicialização e iniciar o processo principal do container.

O script deve terminar executando o processo principal de forma compatível com o gerenciamento de sinais do Docker.

Evite operações destrutivas, migrações irreversíveis ou rotinas que não possam ser executadas novamente com segurança.

## Certificados SSL

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

## Grupos do usuário

Depois de preencher `.env`, confira os valores de `DOCKER_GROUP` e `WEBSERVER_GROUP`.

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

- diretórios: `775`;
- arquivos: `664`;
- proprietário: usuário atual;
- grupo: valor de `DOCKER_GROUP`.

> **Atenção:** o alvo utiliza `sudo chown` e `sudo chmod` em toda a raiz do projeto. Revise o conteúdo do diretório antes de executá-lo.

## Verificação inicial

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

## Validação da configuração

Antes de construir as imagens, valide o Docker Compose.

### Desenvolvimento

```bash
make config-dev
make validate-dev
```

### Produção

```bash
make config
make validate
```

`config` exibe a configuração resultante. `validate` executa a validação silenciosa.

Corrija todos os erros antes de prosseguir.

## Implantação em desenvolvimento

O ambiente de desenvolvimento combina `docker-compose.yml`, `docker-compose.dev.yml`, `.env` e `.env.dev`.

### Construção e inicialização

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

### Verificação

```bash
make status-dev
make status-all-dev
make logs-dev
```

### Acesso ao container

```bash
make app-shell-dev
```

Depois que os containers estiverem ativos, conclua os procedimentos específicos da aplicação.

## Implantação em produção

O ambiente de produção utiliza `docker-compose.yml` e `.env`.

### Preparação

Antes da implantação:

- provisione o banco de dados externo;
- crie o banco e o usuário;
- conceda somente as permissões necessárias;
- configure a conectividade entre a aplicação e o banco;
- valide DNS, domínio, portas, certificados e firewall;
- confirme os volumes persistentes;
- revise limites de recursos e políticas de reinicialização;
- realize backup dos dados existentes.

### Construção e inicialização

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

### Verificação

```bash
make status
make status-all
make logs
```

### Acesso ao container

```bash
make app-shell
```

Depois, execute os procedimentos específicos de instalação ou atualização da aplicação.

## Comandos operacionais

### Parar os containers

```bash
make stop-dev
make stop
```

### Parar e remover os containers

```bash
make down-dev
make down
```

### Reiniciar os serviços

```bash
make restart-dev
make restart
```

### Reconstruir o ambiente

```bash
make rebuild-dev
make rebuild
```

### Acompanhar os logs

```bash
make logs-dev
make logs
```

## Banco de dados no ambiente de desenvolvimento

O Makefile disponibiliza operações genéricas para o serviço de banco de dados do ambiente de desenvolvimento.

### Acesso ao cliente

```bash
make db-cli-dev
```

Quando necessário:

```bash
make db-cli-dev DATABASE_USER=<USUARIO>
```

### Gerar dump

Os alvos utilizam os executáveis definidos por:

```make
EXECUTABLE_DB ?= mysql
EXECUTABLE_DB_DUMP ?= mysqldump
```

Execute:

```bash
make db-dump-dev DATABASE_USER=<USUARIO> DATABASE_NAME=<BANCO>
```

Quando os valores não forem fornecidos, o Makefile os solicita interativamente.

### Restaurar dump

```bash
make db-restore-dev DATABASE_USER=<USUARIO> DATABASE_NAME=<BANCO> DATABASE_DUMP_SQL=<ARQUIVO_SQL>
```

> **Atenção:** os comandos genéricos assumem ferramentas e sintaxe compatíveis com MySQL. Para outro banco de dados, adapte o Makefile.

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

Revise também `DOCKER_GROUP` e `WEBSERVER_GROUP`.

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

## Listagem de recursos Docker

```bash
make list-images
make list-volumes
make list-networks
make list-all
```

## Limpeza

O projeto disponibiliza:

```bash
make prune-cache
make prune-volumes
make prune-networks
make clean
```

`clean` executa a limpeza de cache de build, volumes não utilizados e redes não utilizadas.

> **Cuidado:** esses comandos atuam sobre recursos não utilizados do hospedeiro e podem afetar outros projetos Docker. Liste os recursos e realize backups antes da execução.

## Atualização

Antes de atualizar o template ou a aplicação:

- gere backup do banco de dados;
- preserve os diretórios persistentes;
- revise alterações em `.env.example` e `.env.dev.example`;
- compare o Dockerfile, os arquivos Compose, o `ENTRYPOINT` e os templates;
- verifique se personalizações locais serão sobrescritas;
- valide primeiro em desenvolvimento ou homologação.

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

## Recomendações

- Utilize Linux em produção.
- Utilize WSL para desenvolvimento em Windows.
- Mantenha o template genérico separado das customizações específicas sempre que possível.
- Não armazene credenciais no repositório.
- Não versione chaves privadas.
- Use os arquivos `.env` para valores e os templates para estrutura.
- Valide primeiro em desenvolvimento ou homologação.
- Mantenha backups do banco e dos diretórios persistentes.
- Documente todas as adaptações feitas para a aplicação.
- Use o Makefile para padronizar as operações.

## Detalhes específicos do Docker Template

### Comandos específicos da aplicação

O Makefile contém uma área reservada para alvos próprios da aplicação:

```make
# TODO: Adicione aqui alvos para comandos específicos da aplicação.
```

Adicione os novos alvos imediatamente antes de `help` e inclua suas descrições no próprio alvo `help`.

Exemplos de operações específicas:

- limpeza de cache;
- migração de banco;
- criação de usuário;
- instalação de dependências;
- execução de testes;
- tarefas agendadas;
- atualização da aplicação;
- geração de arquivos estáticos.

Use nomes no padrão:

```text
nomeaplicacao-comando
```

Exemplo:

```text
minhaapp-clear-cache
```

### Checklist de adaptação

Antes de considerar o projeto adaptado, confirme:

- o placeholder `{Nome do projeto}` foi substituído;
- o código da aplicação foi incluído em `app/`;
- as imagens base foram definidas;
- `.env.example` e `.env.dev.example` foram adaptados;
- `.env` e `.env.dev` foram criados;
- os arquivos Compose foram ajustados;
- os serviços usam os nomes esperados pelo Makefile;
- o Dockerfile foi adaptado;
- o `ENTRYPOINT` foi adaptado;
- os templates foram adaptados;
- os certificados foram configurados;
- os volumes persistentes foram definidos;
- o banco externo de produção foi provisionado;
- os comandos específicos da aplicação foram documentados;
- `make validate-dev` foi executado;
- `make validate` foi executado;
- a implantação foi testada em desenvolvimento;
- backups e procedimentos de recuperação foram definidos.
