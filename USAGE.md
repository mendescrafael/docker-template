# Uso

Este documento descreve a operação cotidiana dos ambientes de desenvolvimento e produção do Docker Template.

Para preparar o projeto e realizar a primeira implantação, consulte o [guia de instalação](INSTALL.md).

## Antes de começar

Confirme que o projeto já foi adaptado e instalado conforme o [guia de instalação](INSTALL.md). Em especial:

- Mantenha os arquivos `.env` e `.env.dev` preenchidos;
- Adicione o código ou os artefatos da aplicação em `app/`;
- Configure os certificados esperados em `data/utils/ssl/`;
- Confirme que `WEBSERVER_USER` e `WEBSERVER_GROUP` existem na imagem base e correspondem ao processo web;
- Garanta que o usuário atual possa executar o Docker;
- Execute os comandos na raiz do projeto;

O alvo `check`, utilizado pela maioria dos comandos, exige a presença de `.env` e `.env.dev`, inclusive nas operações de produção.

Consulte os comandos disponíveis e as informações calculadas para a imagem:

```bash
make help
make info
make version
```

## Conceitos e configuração

### Ambientes

Os comandos com o sufixo `-dev` usam o ambiente de desenvolvimento. Os equivalentes sem o sufixo usam o ambiente de produção.

| Característica | Desenvolvimento | Produção |
| --- | --- | --- |
| Comandos | `make <comando>-dev` | `make <comando>` |
| Arquivos Compose | `docker-compose.yml` e `docker-compose.dev.yml` | `docker-compose.yml` |
| Arquivos de ambiente | `.env` e `.env.dev` | `.env` |
| Aplicação | Container com `app/` montado no diretório da aplicação | Container com o código incorporado à imagem |
| Banco de dados | Serviço `db` em container | Serviço externo à stack |
| Reinício automático | Desativado | Ativado |

Antes de executar um comando, confirme o ambiente pelo sufixo. Os dois ambientes podem criar recursos com nomes semelhantes, definidos por `APP_NAME`, `CLIENT_ID` e `APP_ENV`.

## Operações

### Início rápido

#### Desenvolvimento

Valide a configuração resultante, implante os serviços e confira o estado dos containers:

```bash
make validate-dev
make deploy-dev
make status-dev
```

Se algum serviço não ficar disponível, inspecione todos os containers e acompanhe os logs:

```bash
make status-all-dev
make logs-dev
```

#### Produção

Confirme primeiro que o banco de dados externo, o DNS, os certificados, as portas e os volumes persistentes estão preparados. Em seguida:

```bash
make validate
make deploy
make status
```

Para acompanhar a inicialização:

```bash
make logs
```

O endereço da aplicação depende de `WEBSERVER_DOMAIN_NAME`, `WEBSERVER_PORT` e `WEBSERVER_PORT_SSL`. Use o protocolo correspondente ao virtual host e aos certificados configurados para o ambiente.

### Ciclo de vida dos serviços

| Operação | Desenvolvimento | Produção | Comportamento |
| --- | --- | --- | --- |
| Construir imagens | `make build-dev` | `make build` | Constrói as imagens sem iniciar os containers |
| Iniciar serviços | `make up-dev` | `make up` | Cria ou atualiza os containers e inicia em segundo plano |
| Implantar | `make deploy-dev` | `make deploy` | Executa a construção e depois inicia os serviços |
| Interromper | `make stop-dev` | `make stop` | Para os containers sem removê-los |
| Reiniciar | `make restart-dev` | `make restart` | Para e inicia novamente os containers existentes |
| Encerrar | `make down-dev` | `make down` | Para e remove containers e redes da stack |
| Reconstruir | `make rebuild-dev` | `make rebuild` | Encerra, reconstrói e inicia novamente a stack |

O comando `down` não remove os volumes nomeados por padrão. Ainda assim, faça backup antes de operações de manutenção, atualização ou recuperação.

Use `restart` para executar a sequência `stop` e `up` sem reconstruir a imagem. Use `up` para criar ou atualizar os containers sem uma interrupção explícita. Use `rebuild` quando houver alterações no Dockerfile ou em conteúdo incorporado à imagem.

### Estado, configuração e logs

Liste somente os containers em execução:

```bash
make status-dev
make status
```

Inclua também os containers parados:

```bash
make status-all-dev
make status-all
```

Exiba a configuração interpolada ou valide-a silenciosamente:

```bash
make config-dev
make validate-dev

make config
make validate
```

O resultado de `config` pode conter valores interpolados dos arquivos de ambiente. Não publique nem compartilhe essa saída sem remover credenciais e outros dados sensíveis.

Acompanhe os logs em tempo real:

```bash
make logs-dev
make logs
```

Use `Ctrl+C` para encerrar o acompanhamento. Isso não interrompe os containers executados em segundo plano. Antes de compartilhar logs, remova senhas, tokens, endereços internos, dados pessoais e demais informações sensíveis.

O Docker Compose limita os logs de cada serviço a cinco arquivos de 10 MB pelo driver `json-file`. Encaminhe os logs para uma solução externa quando o histórico exigido exceder essa retenção local.

O healthcheck da aplicação consulta `http://localhost` a cada 60 segundos, após um período inicial de 90 segundos. No desenvolvimento, o MySQL é verificado a cada 30 segundos, após um período inicial de 20 segundos. Ambos usam timeout de 10 segundos e três tentativas.

### Acesso ao container da aplicação

Com o serviço `app` em execução, abra um shell Bash no container:

```bash
make app-shell-dev
make app-shell
```

Como o Dockerfile não define `USER`, esse terminal utiliza atualmente `root`. Use-o para diagnósticos pontuais e para tarefas de sistema que realmente exijam esse privilégio. Alterações manuais dentro do sistema de arquivos do container podem ser perdidas quando ele for recriado; mantenha dados permanentes nos volumes e diretórios persistentes definidos pelo projeto.

Se o nome do serviço da aplicação for diferente de `app`, informe-o na execução:

```bash
make app-shell-dev SERVICE_APP=<SERVICO>
```

### Comandos específicos da aplicação

O template não define comandos administrativos para uma aplicação específica. Ao adaptar o Makefile, crie alvos com e sem o sufixo `-dev` e reutilize `run_app_command` quando a operação deva ocorrer como `WEBSERVER_USER`:

```make
minhaapp-tarefa: check
	@$(call run_app_command,$(COMPOSE),/usr/local/bin/minhaapp tarefa)

minhaapp-tarefa-dev: check
	@$(call run_app_command,$(COMPOSE_DEV),/usr/local/bin/minhaapp tarefa)
```

A função executa o comando por meio de `su`, dentro do serviço definido em `SERVICE_APP`. Use comandos absolutos ou caminhos relativos ao `WORKDIR` configurado como `APP_DIR`. Não use essa função para operações que realmente dependam de privilégios de `root`.

### Banco de dados no ambiente de desenvolvimento

As operações deste tópico destinam-se ao ambiente de desenvolvimento e assumem ferramentas compatíveis com MySQL.

#### Acessar o cliente

```bash
make db-cli-dev
```

Informe o usuário diretamente, se necessário:

```bash
make db-cli-dev DATABASE_USER=<USUARIO>
```

Se o nome do serviço de banco for diferente de `db`, use `SERVICE_DB=<SERVICO>`.

#### Gerar um dump

O comando usa `mysqldump` no hospedeiro e cria o arquivo no diretório atual com o padrão `dump_<data-hora>_<banco>.sql`:

```bash
make db-dump-dev DATABASE_USER=<USUARIO> DATABASE_NAME=<BANCO>
```

Quando o usuário ou o banco não forem fornecidos, o Makefile solicita os valores interativamente. A senha é solicitada pelo cliente do banco.

Depois da geração, mova o arquivo para o local protegido definido pela política de backups do projeto. O diretório `data/db/dumps/` está montado no container de banco apenas como uma área de intercâmbio no ambiente de desenvolvimento.

#### Restaurar um dump

A restauração altera os dados do banco selecionado. Confirme o ambiente, o banco e o arquivo antes de executar:

```bash
make db-restore-dev \
  DATABASE_USER=<USUARIO> \
  DATABASE_NAME=<BANCO> \
  DATABASE_DUMP_SQL=<ARQUIVO_SQL>
```

O comando usa o cliente `mysql` instalado no hospedeiro. Faça um backup do estado atual e valide a restauração em desenvolvimento antes de aplicar o mesmo procedimento a dados importantes.

### Aplicação de alterações

Use a operação correspondente ao tipo de alteração:

| Alteração | Desenvolvimento | Produção |
| --- | --- | --- |
| Código em `app/` | Refletido pelo bind mount; reinicie somente se a aplicação exigir | Execute `make rebuild` |
| Dockerfile ou dependências da imagem | Execute `make rebuild-dev` | Execute `make rebuild` |
| `.env`, `.env.dev` ou arquivo Compose | Valide e execute `make up-dev` | Valide e execute `make up` |
| `ENTRYPOINT`, templates ou certificados incorporados à imagem | Execute `make rebuild-dev` | Execute `make rebuild` |
| Conteúdo persistente da aplicação | Siga o procedimento próprio da aplicação | Siga o procedimento próprio da aplicação |

Após qualquer alteração, confira o estado e os logs do ambiente correspondente.

## Manutenção e cuidados

### Persistência e backup

| Recurso | Desenvolvimento | Produção |
| --- | --- | --- |
| Configuração da aplicação | `data/app/config/` | `data/app/config/` |
| Arquivos da aplicação | `data/app/files/` | `data/app/files/` |
| Código-fonte da aplicação | Bind mount de `app/` | Conteúdo incorporado à imagem |
| Dados do banco | Volume nomeado `db_vol` | Banco externo à stack |
| Dumps do banco | `data/db/dumps/` disponível no container | Definido pela infraestrutura externa |

Antes de reconstruir ou atualizar:

- Faça backup do banco de dados;
- Preserve `data/app/config/` e `data/app/files/`;
- Confirme o destino e a retenção dos backups;
- Teste a restauração em um ambiente não produtivo;

O código incorporado à imagem pertence a `WEBSERVER_USER:WEBSERVER_GROUP`, com diretórios `750` e arquivos `640`. Em runtime, `APP_CONFIG_DIR` e `APP_FILES_DIR` usam diretórios `2770`, arquivos `660` e o bit `setgid` para preservar o grupo do servidor web.

### Atualização

Antes de atualizar, preserve os dados persistentes, gere um backup do banco de dados e consulte o [CHANGELOG.md](CHANGELOG.md). Valide primeiro em desenvolvimento ou homologação.

Desenvolvimento:

```bash
make validate-dev
make rebuild-dev
make status-all-dev
make logs-dev
```

Produção:

```bash
make validate
make rebuild
make status-all
make logs
```

Depois, valide os procedimentos específicos da aplicação.

### Recursos do hospedeiro

Liste os recursos Docker disponíveis:

```bash
make list-images
make list-volumes
make list-networks
make list-all
```

Esses comandos listam recursos do hospedeiro inteiro, não apenas os criados por este projeto.

### Limpeza

Os alvos de limpeza também atuam sobre recursos não utilizados de todo o hospedeiro Docker:

```bash
make prune-cache
make prune-volumes
make prune-networks
make clean
```

Antes de executar qualquer um deles:

- Liste os recursos existentes;
- Confirme que nenhum outro projeto depende deles;
- Faça backup dos dados persistentes;
- Prefira o alvo específico ao `clean`;

`prune-volumes` pode remover volumes não associados a containers, e `clean` combina a limpeza do cache de construção, dos volumes e das redes não utilizadas.

## Diagnóstico

### Falha na validação inicial

Confirme a presença dos arquivos obrigatórios e a disponibilidade das ferramentas listadas no [guia de instalação](INSTALL.md). O alvo `check` exige os dois arquivos de ambiente, mesmo para produção.

### Erro de configuração do Compose

Exiba primeiro a configuração resultante e depois execute a validação:

```bash
make config-dev
make validate-dev
```

Ou, em produção:

```bash
make config
make validate
```

Revise variáveis vazias, caminhos, portas em uso, nomes de serviços e o valor de `APP_ENV`.

### Container parado ou não saudável

```bash
make status-all-dev
make logs-dev
```

Em produção, use os comandos sem `-dev`. Verifique especialmente variáveis obrigatórias, certificados, templates, permissões, acesso aos diretórios persistentes e conectividade com o banco de dados.

### Erro de permissão

Consulte os procedimentos de grupos e permissões no [guia de instalação](INSTALL.md#permissões). O alvo `make apply-permissions` altera recursivamente a propriedade e as permissões da raiz do projeto e deve ser usado somente depois de revisar seu escopo.

Em seguida, use `make restart-dev` no desenvolvimento ou `make restart` na produção. O `ENTRYPOINT` não altera o código completo da aplicação: ele inicializa somente `APP_CONFIG_DIR` e `APP_FILES_DIR` quando o diretório raiz ainda não possui o padrão esperado.

No desenvolvimento, o bind mount `./app:${APP_DIR}:rw` substitui o código e as permissões gravados na imagem. Se um comando falhar, confirme que `WEBSERVER_USER` consegue atravessar `APP_DIR`, ler o executável ou script da aplicação e gravar apenas no diretório exigido pela operação.

Os diretórios graváveis usam proprietário e grupo do servidor web, diretórios `2770`, arquivos `660` e o bit `setgid`. O código incorporado à imagem usa diretórios `750` e arquivos `640`, mas esse padrão de build não é reaplicado a todo o bind mount de desenvolvimento.

### Alteração não aplicada

Confirme onde o arquivo é consumido:

- Arquivos montados por bind mount ficam disponíveis diretamente no container;
- Arquivos copiados pelo Dockerfile exigem uma nova construção da imagem;
- Variáveis e definições do Compose exigem a recriação do container por `up`;
- O alvo `restart` executa `stop` e `up`, portanto pode recriar o container quando a configuração mudou, mas não reconstrói a imagem;

### Logs da inicialização

O `ENTRYPOINT` atual registra o nome e o valor das variáveis obrigatórias durante a validação, inclusive variáveis de conexão com o banco de dados. Trate os logs do container como conteúdo sensível, restrinja seu acesso e sanitize qualquer trecho antes de armazená-lo ou compartilhá-lo.

## Ajuda e segurança

Para preparar o projeto, consulte o [INSTALL.md](INSTALL.md). Para conhecer a visão geral e os recursos do projeto, consulte o [README.md](README.md).

Problemas de uso devem seguir as orientações do [SUPPORT.md](SUPPORT.md). Vulnerabilidades ou suspeitas de falha de segurança devem ser relatadas pelo processo privado descrito no [SECURITY.md](SECURITY.md).
