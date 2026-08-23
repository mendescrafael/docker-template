# Docker Template

## Sobre o projeto

Este repositório fornece um starter reutilizável para conteinerizar aplicações com Docker, Docker Compose, arquivos de ambiente, templates, `ENTRYPOINT` e Makefile.

O Docker Template deve ser usado como **ponto de partida** para um projeto derivado. O projeto criado a partir dele deve possuir seu próprio histórico Git e pode especializar livremente a infraestrutura conforme a aplicação de destino.

## Motivação e objetivo

Projetos conteinerizados frequentemente repetem a mesma estrutura para construção de imagens, separação de ambientes, persistência, configuração e automação. Essa repetição aumenta o custo de manutenção e favorece divergências entre aplicações.

O objetivo é fornecer uma base modular e parametrizável que possa ser copiada/instanciada para um novo projeto, preservando uma separação clara entre desenvolvimento e produção sem manter o projeto derivado acoplado ao histórico Git do template.

## Principais recursos

### Infraestrutura reutilizável

- Dockerfile baseado em Multi-stage builds;
- Estágios separados para PHP-FPM, aplicação, desenvolvimento, produção e Nginx;
- Containers independentes para runtime PHP-FPM e web server Nginx;
- Estrutura preparada para diferentes imagens base e tipos de aplicação;
- Metadados OCI e processo de inicialização centralizado;
- Código incorporado com propriedade e permissões restritas ao usuário e ao grupo de runtime da aplicação;
- Organização reutilizável para dados persistentes e arquivos auxiliares;

### Configuração e automação

- Configuração orientada por arquivos de ambiente;
- Docker Compose para definição dos serviços, volumes e redes;
- Templates processados durante a inicialização;
- Makefile para validação, construção e operação dos ambientes;
- Função reutilizável para comandos específicos executados como o usuário de runtime da aplicação;
- Convenções para imagens, containers, hosts, volumes, redes e bancos de dados;

### Desenvolvimento e produção

- Aplicação PHP-FPM, Nginx e banco de dados conteinerizados no desenvolvimento;
- Aplicação PHP-FPM e Nginx conteinerizados com banco de dados externo em produção;
- Arquivo Compose complementar para o ambiente local;
- Estágios de imagem especializados para cada ambiente;
- Persistência separada do ciclo de vida dos containers;

### Criando um projeto a partir do template

Fluxo recomendado:

1. Use **Use this template** no GitHub, quando disponível; ou
2. Clone/copiei o repositório para o diretório do novo projeto;
3. Remova o histórico Git do Docker Template;
4. Inicialize um novo repositório na raiz do projeto derivado;
5. Especialize infraestrutura e `app/` no mesmo histórico.

Exemplo por CLI:

```bash
git clone https://github.com/mendescrafael/docker-template.git meu-projeto
cd meu-projeto
rm -rf .git
git init -b main
```

O `app/` não é ignorado pelo repositório raiz; arquivos gerados e dependências devem ser controlados pelo `.gitignore` único da raiz.

## Arquitetura e organização

### Visão geral

A infraestrutura separa o runtime PHP, o web server e a persistência. O código adicionado em `app/` é incorporado nos targets PHP-FPM; os targets `DEV` e `PRD` especializam a aplicação; e os targets `WEB-DEV` e `WEB-PRD` usam Nginx e recebem somente o conteúdo público gerado pelo target correspondente.

Os procedimentos de adaptação e primeira implantação estão no [INSTALL.md](INSTALL.md). Os comandos cotidianos e as operações de manutenção estão no [USAGE.md](USAGE.md).

### Ambientes suportados

- Desenvolvimento: Executa PHP-FPM, Nginx e banco de dados em containers;
- Produção: Executa PHP-FPM e Nginx em containers e utiliza um banco de dados provisionado externamente;

### Componentes principais

#### Dockerfile e estágios

O Dockerfile utiliza os estágios `BASE`, `APP`, `DEV` e `PRD` para PHP-FPM e `WEB-BASE`, `WEB-DEV` e `WEB-PRD` para Nginx. O serviço `app` usa o target indicado por `APP_BUILD_ENV`, enquanto o serviço `web` usa `web-${APP_BUILD_ENV}`. Dessa forma, o mesmo arquivo mantém os dois runtimes e copia para o Nginx somente o diretório público da aplicação.

#### Docker Compose

O arquivo `docker-compose.yml` define os serviços `app` (PHP-FPM) e `web` (Nginx), além da rede comum. O serviço `app` recebe `APP_NAME`, `APP_ENV`, `APP_DEBUG`, `APP_URL` e `APP_KEY` como configurações da aplicação consumidora. O arquivo `docker-compose.dev.yml` complementa essa configuração com o banco de dados e os bind mounts necessários ao desenvolvimento local.

#### Arquivos de ambiente

Os arquivos `.env` e `.env.dev` armazenam configurações locais e não devem ser versionados. Os arquivos `.env.example` e `.env.dev.example` documentam as variáveis aceitas usando valores genéricos. `PROJECT_LABEL` define o nome legível apresentado nos metadados das imagens, enquanto `PROJECT_NAME` identifica tecnicamente os recursos Docker.

#### `ENTRYPOINT` e templates


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
