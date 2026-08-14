# Instalação

Este documento descreve como adaptar, configurar e executar o Docker Template em ambientes de desenvolvimento e produção.

O projeto fornece uma infraestrutura reutilizável baseada em Docker Multi-stage builds, Docker Compose, arquivos de ambiente, templates, `ENTRYPOINT` e Makefile. Antes da primeira execução, a estrutura deve ser personalizada para a aplicação que utilizará o template.

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
git clone https://github.com/mendescrafael/docker-template.git && cd docker-template
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

- `{Nome do projeto}`;
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
- Copie a aplicação para `APP_DIR` no estágio `BASE`, com proprietário e grupo do servidor web;
- Preserve o estágio `BASE` para o código, o `ENTRYPOINT`, os templates, os certificados e os pacotes comuns;
- Utilize o estágio `APP` para dependências e configurações comuns da aplicação;
- Preserve o estágio `DEV` para as ferramentas e configurações de desenvolvimento;
- Preserve o estágio `PRD` para as configurações de desempenho e segurança e para a limpeza da imagem;
- Defina corretamente `WORKDIR`, `ENTRYPOINT` e `CMD`;
- Utilize em `APP_ENV` somente um target final existente, atualmente `dev` ou `prd`;

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
APP_NAME
APP_VERSION
CLIENT_ID
DB_BASE_IMG
DOCKER_GROUP
LICENSE
PROJECT_NAME
PROJECT_DESCRIPTION
PROJECT_AUTHORS
WEBSERVER_USER
WEBSERVER_GROUP
```

Preencha também todas as demais variáveis utilizadas pelo Dockerfile, pelo Docker Compose, pelos templates e pelo `ENTRYPOINT`.

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

O arquivo `docker-compose.yml` define o serviço da aplicação, a rede, os bind mounts persistentes de configuração e arquivos, as portas HTTP e HTTPS e os demais recursos necessários à execução em produção. O banco de dados deve permanecer externo ao Compose, salvo quando a arquitetura for deliberadamente modificada.

O serviço utiliza `restart: always`, verifica a aplicação por HTTP em `http://localhost` a cada 60 segundos, com timeout de 10 segundos, três tentativas e período inicial de 90 segundos. Os logs usam o driver `json-file`, limitado a cinco arquivos de 10 MB. O target de build é obtido de `APP_ENV`.

O VirtualHost HTTP redireciona as requisições para HTTPS. O estágio `DEV` declara as duas portas com `EXPOSE`, enquanto o estágio `PRD` declara somente a porta HTTPS; o Compose ainda publica os dois mapeamentos porque `EXPOSE` funciona apenas como metadado da imagem.

#### Desenvolvimento

O arquivo `docker-compose.dev.yml` complementa o Compose principal com:

- Serviço de banco de dados MySQL;
- Volume persistente do banco de dados;
- Diretório de dumps;
- Bind mount `./app:${APP_DIR}:rw`, que substitui no container o código incorporado à imagem;
- Portas locais;
- Política `restart: no` para os serviços locais;
- Verificação do MySQL a cada 30 segundos, com timeout de 10 segundos, três tentativas e período inicial de 20 segundos;
- Rotação dos logs do MySQL em cinco arquivos de 10 MB;

#### Serviços

Mantenha os nomes dos serviços compatíveis com as variáveis do Makefile:

```make
SERVICE_APP ?= app
SERVICE_DB ?= db
```

Caso os serviços recebam outros nomes, altere essas variáveis no Makefile ou forneça os valores na execução.

### Templates

Os arquivos em:

```text
data/utils/templates/
```

devem conter a estrutura das configurações do servidor web e do agendador.

Defina os valores nos arquivos `.env` e `.env.dev`, e não diretamente nos templates.

Adapte os templates quando a aplicação exigir mudanças estruturais, como diretório público, domínio, proxy reverso, certificados, cabeçalhos, regras de reescrita, agendamento de tarefas e caminhos internos.

### ENTRYPOINT

O arquivo:

```text
data/utils/app-entrypoint
```

deve ser adaptado à aplicação hospedada.

A rotina valida variáveis e caminhos obrigatórios, processa os templates, prepara os diretórios persistentes, configura o Cron e o Apache e, por fim, substitui o processo do script por `apache2-foreground`.

O Dockerfile não define `USER`, portanto o `ENTRYPOINT` inicia como `root`. Esse privilégio é necessário para ajustar propriedades e modos, escrever configurações em `/etc`, iniciar o Cron e preparar o Apache. O template do Cron e os alvos que reutilizarem `run_app_command` executam a aplicação com o usuário definido em `WEBSERVER_USER`; a imagem base do servidor web deve manter seus processos de atendimento compatíveis com esse mesmo usuário e grupo.

As permissões do código incorporado à imagem são normalizadas durante o build: proprietário e grupo definidos por `WEBSERVER_USER` e `WEBSERVER_GROUP`, diretórios `750` e arquivos `640`. Dessa forma, o processo web pode acessar a aplicação sem conceder acesso aos demais usuários do sistema.

Depois da montagem dos volumes, o `ENTRYPOINT` inicializa `APP_CONFIG_DIR` e `APP_FILES_DIR` com o mesmo proprietário e grupo, diretórios `2770` e arquivos `660`. Ambos integram a validação de diretórios obrigatórios e são criados quando não existem.

O ajuste é recursivo somente quando o proprietário, o grupo ou o modo do diretório raiz não corresponde ao padrão. Nas inicializações seguintes, o processamento é ignorado. O bit `setgid` mantém o grupo definido por `WEBSERVER_GROUP` nos novos arquivos e diretórios criados nesses caminhos.

No desenvolvimento, o bind mount de `./app` substitui o conteúdo e as permissões incorporados à imagem. O `ENTRYPOINT` não normaliza todo o código montado; ele ajusta somente `APP_CONFIG_DIR` e `APP_FILES_DIR`. Preserve no hospedeiro a leitura e a travessia necessárias ao usuário do servidor web.

Os diretórios de certificados recebem modo `710` e seus arquivos, modo `640`. O arquivo gerado para o Cron recebe modo `644` antes da inicialização do serviço. O usuário do agendamento é obtido de `WEBSERVER_USER`; substitua o comando genérico `date` no template pela rotina exigida pela aplicação.

> **Atenção:** a validação atual registra nos logs o nome e o valor das variáveis obrigatórias, inclusive as variáveis de conexão com o banco de dados. Restrinja o acesso aos logs do container e não os compartilhe sem sanitização.

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

- Diretórios: `2775`, com o bit `setgid`;
- Arquivos regulares: `664`;
- Arquivos executáveis: `775`;
- Proprietário: usuário atual;
- Grupo: valor de `DOCKER_GROUP`;

> **Atenção:** o alvo utiliza `sudo chown` e `sudo chmod` em toda a raiz do projeto. Revise o conteúdo do diretório antes de executá-lo.

Esse alvo corrige as permissões do workspace no hospedeiro. Ao iniciar ou reiniciar o container, o `ENTRYPOINT` aplica o padrão específico da aplicação somente a `APP_CONFIG_DIR` e `APP_FILES_DIR`; ele não reaplica `750` e `640` a todo o bind mount de código do ambiente de desenvolvimento.

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

Quando o comando não exigir privilégios administrativos, reutilize `run_app_command` para executá-lo no container como `WEBSERVER_USER`. Por exemplo:

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

- O placeholder `{Nome do projeto}` foi substituído;
- O código da aplicação foi incluído em `app/`;
- As imagens base foram definidas;
- `.env.example` e `.env.dev.example` foram adaptados;
- `.env` e `.env.dev` foram criados;
- Os arquivos Compose foram ajustados;
- Os serviços usam os nomes esperados pelo Makefile;
- O Dockerfile foi adaptado;
- O `ENTRYPOINT` foi adaptado;
- `WEBSERVER_USER` e `WEBSERVER_GROUP` correspondem ao usuário e ao grupo disponíveis na imagem base;
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

Revise também `DOCKER_GROUP`, `WEBSERVER_USER` e `WEBSERVER_GROUP`. Depois do ajuste no hospedeiro, reinicie o ambiente com `make restart-dev` no desenvolvimento ou `make restart` na produção para que o `ENTRYPOINT` inicialize os diretórios graváveis.

Se a falha ocorrer somente no desenvolvimento, lembre-se de que `./app:${APP_DIR}:rw` substitui as permissões definidas no build. Confirme que o usuário do servidor web consegue atravessar `APP_DIR`, ler os arquivos da aplicação e gravar somente nos caminhos persistentes exigidos pela implementação.

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

Confirme que `data/utils/ssl/` contém os certificados ativos com os nomes esperados pela configuração da aplicação. Os arquivos `.example` servem apenas como modelos e não são utilizados como certificados ativos pelo `ENTRYPOINT`.

## Segurança

Proteja os arquivos de ambiente, certificados, dumps e diretórios persistentes. Para comunicar vulnerabilidades de forma responsável, siga o processo privado descrito no [SECURITY.md](SECURITY.md).
