# {Nome do projeto}

## Sobre o projeto

Este repositório fornece um template reutilizável para conteinerizar aplicações com Docker, Docker Compose, arquivos de ambiente, templates, `ENTRYPOINT` e Makefile.

Antes de utilizar o projeto, substitua os nomes, descrições, imagens, caminhos e valores de exemplo pela identidade e pelos requisitos da aplicação que utilizará o template.

## Motivação e objetivo

Projetos conteinerizados frequentemente repetem a mesma estrutura para construção de imagens, separação de ambientes, persistência, configuração e automação. Essa repetição aumenta o custo de manutenção e favorece divergências entre aplicações.

O objetivo deste template é fornecer uma base modular e parametrizável que possa ser adaptada sem reescrever toda a infraestrutura, preservando uma separação clara entre desenvolvimento e produção.

## Principais recursos

### Infraestrutura reutilizável

- Dockerfile baseado em Multi-stage builds;
- Estágios separados para recursos comuns, aplicação, desenvolvimento e produção;
- Estrutura preparada para diferentes imagens base e tipos de aplicação;
- Metadados OCI e processo de inicialização centralizado;
- Código incorporado com propriedade e permissões restritas ao usuário e ao grupo do servidor web;
- Organização reutilizável para dados persistentes e arquivos auxiliares;

### Configuração e automação

- Configuração orientada por arquivos de ambiente;
- Docker Compose para definição dos serviços, volumes e redes;
- Templates processados durante a inicialização;
- Makefile para validação, construção e operação dos ambientes;
- Função reutilizável para comandos específicos executados como o usuário do servidor web;
- Convenções para imagens, containers, hosts, volumes, redes e bancos de dados;

### Desenvolvimento e produção

- Aplicação e banco de dados conteinerizados no desenvolvimento;
- Aplicação conteinerizada e banco de dados externo em produção;
- Arquivo Compose complementar para o ambiente local;
- Estágios de imagem especializados para cada ambiente;
- Persistência separada do ciclo de vida dos containers;

## Arquitetura e organização

### Visão geral

A infraestrutura separa a construção da imagem, a configuração da aplicação e a execução dos serviços. O código adicionado em `app/` é incorporado no estágio `BASE`, o estágio `APP` recebe dependências e configurações comuns e os estágios finais aplicam as especializações de desenvolvimento e produção.

Os procedimentos de adaptação e primeira implantação estão no [INSTALL.md](INSTALL.md). Os comandos cotidianos e as operações de manutenção estão no [USAGE.md](USAGE.md).

### Ambientes suportados

- Desenvolvimento: Executa a aplicação e o banco de dados em containers;
- Produção: Executa a aplicação em container e utiliza um banco de dados provisionado externamente;

### Componentes principais

#### Dockerfile e estágios

O Dockerfile utiliza os estágios `BASE`, `APP`, `DEV` e `PRD`. O estágio base incorpora o código com suas permissões iniciais e reúne os recursos compartilhados; o estágio da aplicação serve como ponto de extensão para dependências e configurações comuns; e os estágios finais aplicam as configurações específicas de cada ambiente.

#### Docker Compose

O arquivo `docker-compose.yml` define a base do ambiente de produção. O arquivo `docker-compose.dev.yml` complementa essa configuração com o banco de dados e os recursos necessários ao desenvolvimento local.

#### Arquivos de ambiente

Os arquivos `.env` e `.env.dev` armazenam configurações locais e não devem ser versionados. Os arquivos `.env.example` e `.env.dev.example` documentam as variáveis aceitas usando valores genéricos.

#### `ENTRYPOINT` e templates

O `ENTRYPOINT` valida a configuração, processa os templates e inicializa somente `APP_CONFIG_DIR` e `APP_FILES_DIR` como diretórios graváveis antes de iniciar o processo principal. Os templates permitem gerar configurações a partir das variáveis sem manter arquivos diferentes para cada ambiente, inclusive o usuário definido em `WEBSERVER_USER` para as tarefas do Cron.

### Padrões e convenções

#### Recursos Docker Compose

Imagens, containers, hosts, volumes e redes seguem uma nomenclatura que identifica aplicação, cliente, serviço e ambiente. As regras completas estão em [Padrões de nomenclatura](CONTRIBUTING.md#padrões-de-nomenclatura).

#### Banco de dados

O nome do banco identifica a aplicação, o cliente e o ambiente. A convenção detalhada também está em [Padrões de nomenclatura](CONTRIBUTING.md#padrões-de-nomenclatura).

## Estrutura de arquivos e diretórios

A árvore e a finalidade dos arquivos e diretórios relevantes estão documentadas em [Estrutura de arquivos e diretórios](CONTRIBUTING.md#estrutura-de-arquivos-e-diretórios).

## Compatibilidade

O projeto requer:

- Docker Engine 29.7 ou superior;
- Docker Compose;
- Uma aplicação e imagens base compatíveis com os estágios configurados;
- Um banco de dados externo compatível em produção, quando exigido pela aplicação;

## Documentação

- [INSTALL.md](INSTALL.md): Preparação, configuração e primeira implantação do projeto;
- [USAGE.md](USAGE.md): Operação, manutenção, atualização e diagnóstico dos ambientes;
- [CONTRIBUTING.md](CONTRIBUTING.md): Preparação e diretrizes para contribuições;
- [SUPPORT.md](SUPPORT.md): Orientações para solicitar suporte;
- [SECURITY.md](SECURITY.md): Política e processo de relato de vulnerabilidades;
- [CHANGELOG.md](CHANGELOG.md): Histórico das alterações relevantes do projeto;

## Licença

Distribuído sob a licença [LICENSE](LICENSE).
