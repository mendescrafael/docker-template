# Diretrizes para agentes

## Como reutilizar este arquivo

Este arquivo separa as orientações em dois grupos:

- **Diretrizes reutilizáveis:** regras gerais de atuação, preservação, qualidade, segurança, validação e entrega que devem permanecer iguais entre projetos;
- **Especificidades deste projeto:** identidade, escopo, arquitetura, domínio, compatibilidade, documentação e comandos que pertencem somente ao projeto atual.

Ao copiar este arquivo para outro projeto, mantenha as **Diretrizes reutilizáveis** e altere somente o bloco **Especificidades deste projeto**. Revise também, de forma independente, as permissões declaradas no arquivo `.codex/config.toml` do workspace.

Quando uma especificidade do projeto complementar ou restringir uma diretriz reutilizável, prevalece a regra mais específica.

## Diretrizes reutilizáveis

### Objetivo

- Realizar análises;
- Sugerir e implementar melhorias de boas práticas;
- Realizar correções;
- Atender a outros tópicos solicitados pelo usuário;

### Contexto

- Ler somente as seções da documentação indicadas em **Especificidades deste projeto** que sejam relevantes à solicitação, salvo quando houver pedido explícito de leitura integral;
- Inspecionar somente os arquivos necessários à solicitação;
- Não presumir versões, caminhos, dependências ou comportamentos que possam ser verificados no projeto;

### Política de autonomia

Para solicitações de análise, explicação, revisão, diagnóstico ou planejamento:

- Inspecionar os arquivos relevantes;
- Apresentar as conclusões;
- Não modificar arquivos, salvo quando a solicitação também pedir implementação;

Para solicitações de alteração, correção, refatoração ou implementação:

- Realizar as mudanças locais solicitadas dentro do escopo autorizado;
- Executar validações locais não destrutivas;
- Não pedir confirmação para leituras, edições ou validações seguras;
- Pedir confirmação antes de operações externas, destrutivas, persistentes ou que ampliem materialmente o escopo;

Para políticas de escrita, leitura e de acesso negado a arquivos e diretórios, consultar também o arquivo `.codex/config.toml` aplicável ao workspace.

### Escopo e preservação do trabalho

- Manter todas as alterações no escopo definido para o projeto;
- Não modificar componentes externos, projetos vizinhos ou arquivos não relacionados à tarefa;
- Não sobrescrever alterações não commitadas;
- Quando uma limitação depender de mudança fora do escopo, explicar o impedimento e propor uma alternativa restrita ao projeto;
- Não adicionar integrações, compatibilidade genérica ou dependências obrigatórias sem solicitação explícita;
- Preferir APIs públicas e mecanismos nativos da plataforma a detalhes internos frágeis;

### Compatibilidade e dependências

- Ler as versões atuais nos arquivos do projeto antes de alterá-las;
- Preservar a faixa de versões suportadas, salvo solicitação explícita;
- Usar APIs, componentes, classes, funções e convenções nativas sempre que disponíveis;
- Não adicionar dependências externas desnecessárias;
- Avaliar o impacto em todos os fluxos que compartilhem uma mesma classe-base ou regra de domínio;

### Git

- Não executar comandos Git, salvo quando solicitado pelo usuário;
- Não remover o diretório `.git/`;
- Não executar `commit`, `add`, `reset`, `clean`, `checkout`, `merge`, `rebase` ou `push`, salvo se solicitado;
- Quando um commit for solicitado, seguir o padrão Conventional Commits;
- Inspecionar `git status` e `git diff` antes de editar quando o uso de Git estiver autorizado;

### Arquitetura e organização do código

- Respeitar a estrutura de diretórios, as responsabilidades e as convenções descritas nas especificidades do projeto;
- Evitar duplicação de regras entre interfaces ou fluxos equivalentes;
- Concentrar regras de domínio, persistência e apresentação nas camadas apropriadas;
- Manter arquivos públicos nos diretórios adotados pelo projeto;
- Não inserir grandes blocos de marcação ou scripts em componentes cuja responsabilidade seja apenas coordenar requisições;

### Interface e acessibilidade

- Usar componentes e padrões visuais nativos da plataforma;
- Garantir contraste e legibilidade nos temas suportados;
- Usar variáveis de tema, evitando cores fixas quando houver equivalente nativo;
- Manter acessibilidade por teclado e atributos ARIA;
- Escapar conteúdo fornecido pelo usuário e não tratá-lo como HTML confiável;
- Carregar dados sob demanda e evitar processamento desnecessário;
- Evitar requisições concorrentes em rotinas de monitoramento;
- Pausar monitoramentos quando a interface não estiver visível, quando aplicável;

### Internacionalização

- Seguir idioma, fuso e formato regional escolhidos pelo usuário;
- Usar os mecanismos nativos da plataforma para datas e traduções;
- Não inserir textos traduzíveis em código cliente sem internacionalização ou sem dados já traduzidos pelo backend;
- Ao alterar textos traduzíveis, atualizar, compilar e validar os catálogos definidos nas especificidades do projeto;

### Banco de dados

- Não apagar tabelas ou dados durante a implementação de uma funcionalidade;
- Manter a criação e a atualização do esquema idempotentes;
- Alterar o esquema somente quando necessário;
- Documentar novas colunas e índices;
- Não criar compatibilidade retroativa desnecessária;
- Não alterar silenciosamente o significado de colunas existentes;
- Usar as APIs de banco da plataforma e consultas seguras;

### Segurança e resiliência

- Validar o usuário autenticado nos endpoints;
- Respeitar o modelo de autorização, os escopos e as permissões da plataforma;
- Confirmar a permissão de visualização antes de gerar links para recursos protegidos;
- Não permitir que um registro, evento ou ação conceda acesso ao objeto de origem;
- Usar os mecanismos nativos de proteção contra CSRF;
- Sanitizar entradas, saídas e parâmetros de filtros;
- Não registrar ou expor senhas, tokens, chaves, credenciais, stack traces, consultas, caminhos internos ou outros dados sensíveis;
- Manter fallback seguro quando um valor não puder ser resolvido;
- Impedir que falhas de recursos acessórios interrompam a operação principal da plataforma;

### Cabeçalhos e documentação de código

- Usar o cabeçalho definido nas especificidades do projeto nos arquivos em que ele já for adotado e nos novos arquivos de código;
- Escrever comentários e documentação no idioma definido pelo projeto;
- Preservar PHPDoc, JSDoc, comentários e mecanismos equivalentes de documentação nas demais linguagens;
- Adicionar documentação em novas classes, funções e métodos;
- Documentar parâmetros, retorno, exceções e efeitos colaterais relevantes;
- Não remover documentação apenas para reduzir o tamanho do arquivo;
- Fazer com que comentários expliquem intenção e decisões, sem repetir o código;
- Texto de listas em arquivos Markdown (e outros arquivos equivalentes) devem iniciar com palavras em maiúsculo e finalizar com `;`, conforme o padrão:

```markdown
- Primeiro item de lista;
- Segundo item de lista;
- Terceiro item de lista:
  - Subitem;
  - Outro subitem;
```

### Padronização de arquivos de configuração

- Manter a mesma ordem das seções comuns em arquivos equivalentes entre projetos;
- Preservar seções, variáveis, alvos e padrões específicos de cada projeto;
- Usar como referência o arquivo equivalente mais completo, incorporando somente elementos aplicáveis ao projeto atual;
- Organizar variáveis, padrões e alvos relacionados dentro da mesma seção;
- Manter nomes e descrições idênticos para seções que tratem do mesmo assunto;
- Omitir seções vazias ou recursos que não sejam aplicáveis ao projeto;
- Manter os blocos comuns de arquivos binários do `.gitattributes` sincronizados;
- Preservar no `.gitignore` e em `app/.gitattributes` regras genéricas herdadas ou compartilhadas com o projeto-base quando elas forem úteis para manter consistência estrutural, mesmo que alguns padrões façam referência a componentes que ainda não estejam em uso ou que possam não ser utilizados pelo projeto;
- Não interpretar a presença de uma regra no `.gitignore` ou em `app/.gitattributes` como indicação de que o respectivo componente, linguagem, ferramenta ou artefato já esteja em uso, nem como proibição de introduzi-lo, substituí-lo ou removê-lo quando uma necessidade real do projeto exigir;
- Não sanitizar preventivamente o `.gitignore` ou `app/.gitattributes` apenas por existirem padrões atualmente sem uso; realizar essa limpeza somente quando houver solicitação explícita ou em etapa destinada à sanitização final;
- Manter as exceções do `.gitignore` coerentes com os arquivos de exemplo realmente existentes;
- Usar `.env*` no `.dockerignore` para impedir o envio de arquivos locais de ambiente ao contexto de construção;
- Comparar nomes e organização das variáveis entre `.env.example` e `.env`, sem copiar valores sensíveis para os exemplos;
- Comparar `.env.dev.example` e `.env.dev` seguindo a mesma regra;
- Preservar nos arquivos `.env*.example` uma organização lógica e legível por seções, dependências e finalidade; não reordenar variáveis exclusivamente para obter ordem alfabética quando a ordem atual melhorar a leitura, refletir dependências de interpolação ou mantiver variáveis relacionadas próximas;
- Ao adicionar ou alterar variáveis em `.env*.example`, posicioná-las na seção funcional apropriada e preservar a ordem deliberadamente estabelecida, salvo quando houver motivo técnico ou solicitação explícita para reorganizá-las;
- Não criar arquivos locais `.env` ou `.env.dev` quando eles não existirem;
- Validar a sintaxe dos `Makefile`, arquivos de ambiente e demais formatos alterados;
- Não alterar documentação Markdown durante padronizações quando sua atualização tiver sido explicitamente adiada;

### Padronização da documentação Markdown

- Manter a mesma ordem dos tópicos comuns em documentos equivalentes entre projetos;
- Usar o documento equivalente mais completo como referência, incorporando somente conteúdo aplicável ao projeto atual;
- Preservar requisitos, comandos, caminhos, versões, procedimentos e seções específicas de cada projeto;
- Omitir tópicos vazios ou que não sejam aplicáveis ao projeto;
- Manter o `README.md` concentrado na visão geral, nos principais recursos, na compatibilidade e no índice da documentação;
- Manter procedimentos de preparação e primeira implantação no `INSTALL.md`;
- Manter procedimentos operacionais, comandos cotidianos, manutenção e diagnóstico no `USAGE.md`;
- Manter preparação do ambiente de desenvolvimento, diretrizes, validações, commits e pull requests no `CONTRIBUTING.md`;
- Manter orientações para solicitar ajuda no `SUPPORT.md`;
- Manter versões suportadas e relato privado de vulnerabilidades no `SECURITY.md`;
- Usar, quando aplicável, a ordem `Verificação`, `Atualização`, `Próximos passos`, `Diagnóstico` e `Segurança` no final do `INSTALL.md`;
- Usar, quando aplicável, os tópicos `Antes de começar`, `Diagnóstico` e `Ajuda e segurança` no `USAGE.md`;
- Usar a ordem `Formas de contribuir`, `Pré-requisitos e preparação do ambiente`, diretrizes específicas, `Segurança e dados locais`, `Validação das mudanças`, `Commits e pull requests`, `Relatos de erros` e `Licença` no `CONTRIBUTING.md`;
- Manter uma seção `Documentação` no `README.md` com links para `INSTALL.md`, `USAGE.md`, `CONTRIBUTING.md`, `SUPPORT.md`, `SECURITY.md` e `CHANGELOG.md`;
- Transformar menções a outros arquivos Markdown em links relativos;
- Nas árvores que representam a estrutura do projeto, exibir todos os arquivos e diretórios da raiz;
- Para `app/`, exibir somente seus arquivos e diretórios diretamente contidos, sem expandir níveis internos;
- Não expandir nenhum diretório da raiz além de `app/` e `data/`;
- Para `data/`, exibir somente diretórios internos, omitindo arquivos, com profundidade máxima de 6 níveis de diretórios a partir de `data/`;
- Não exibir arquivos internos de `data/`;
- Ordenar cada nível da árvore como na IDE: diretórios iniciados por `.` primeiro, diretórios comuns em seguida, arquivos iniciados por `.` depois e arquivos comuns por último;
- Manter ordem alfabética, sem distinção entre maiúsculas e minúsculas, dentro de cada um desses quatro grupos;
- Manter as árvores sincronizadas com a estrutura real, salvo árvores explicitamente identificadas como estrutura planejada;
- Iniciar itens de listas com palavras em maiúscula e terminá-los com ponto e vírgula, exceto itens introdutórios que terminem com dois-pontos;
- Preservar exemplos de comandos e saídas em blocos literais;
- Validar espaçamento de títulos, pontuação de listas, espaços residuais, links relativos e referências a títulos renomeados;
- Não duplicar instruções detalhadas entre `README.md`, `INSTALL.md` e `USAGE.md`; manter uma descrição resumida e um link para o documento responsável;

#### Referência de estruturas para documentação Markdown

Os modelos completos de `README.md`, `INSTALL.md`, `USAGE.md`, `CONTRIBUTING.md`, `SUPPORT.md` e `SECURITY.md` ficam em [.codex/REFERENCIA_DOCUMENTACAO.md](.codex/REFERENCIA_DOCUMENTACAO.md).

Regras:

- Consultar essa referência somente quando a tarefa criar, reestruturar ou padronizar um desses documentos;
- Não carregar a referência em tarefas de código, infraestrutura ou domínio que não alterem documentação;
- As regras de ordem, responsabilidade e formatação desta seção continuam prevalecendo;
- Preservar conteúdo específico do projeto e usar os modelos apenas como estrutura-base;

### Versão e documentação

- Atualizar a versão somente quando solicitado;
- Não presumir a versão: ler os arquivos atuais;
- Atualizar documentação e changelog imediatamente somente quando a solicitação exigir, quando fizerem parte do critério de aceite da tarefa, quando uma obrigação legal/licença exigir sincronização imediata ou quando não houver etapa posterior de consolidação documental;
- Quando o projeto possuir etapa explícita de consolidação documental, adiar para ela as atualizações rotineiras de documentação geradas por implementações incrementais, registrando o delta nos relatórios da execução;
- Manter sincronizadas as árvores de arquivos presentes na documentação quando a documentação for efetivamente atualizada, respeitando a regra de profundidade e ordenação definida neste `AGENTS.md`;
- Usar como referência base para árvores do projeto o tópico [Estrutura de arquivos e diretórios](#estrutura-de-arquivos-e-diretórios), salvo árvores explicitamente conceituais ou identificadas como estrutura planejada;
- Em árvores do projeto, detalhar a raiz, os itens diretos de `app/` e a hierarquia de diretórios de `data/` até 6 níveis; qualquer outro diretório da raiz deve aparecer somente pelo nome;
- Menções a outros arquivos Markdown devem ser links para o arquivo;
- Exemplos de saídas de comandos devem ser preservados em texto literal;
- Não criar commit ou tag, salvo quando solicitado;

### Validação

- Executar o conjunto aplicável de comandos definido nas especificidades do projeto;
- Executar testes automatizados relevantes, quando houver;
- Adaptar comandos a arquivos opcionais que realmente existam;
- Não iniciar serviços, modificar bancos de dados ou instalar ferramentas sem autorização;
- Executar validações Git somente quando o usuário tiver autorizado o uso de Git;
- Informar claramente qualquer validação não executada;

### Entrega

Ao finalizar:

- Resumir as mudanças;
- Listar os arquivos modificados;
- Informar as validações executadas;
- Informar limitações e testes não executados;
- Destacar decisões que dependam de validação funcional na plataforma;

## Especificidades deste projeto

> **Bloco de personalização:** ao reutilizar este arquivo, substituir ou remover somente os tópicos desta seção conforme a identidade, a arquitetura, o domínio e as ferramentas do novo projeto.

### Identificação e contexto

- Nome: Docker Template;
- Diretório e identificador: `docker-template`;
- Plataforma: Docker;
- Tipo de projeto: template reutilizável de conteinerização para aplicações PHP;
- Diretório de atuação: raiz deste arquivo e seus descendentes;
- Documentação principal: [README.md](README.md) na raiz deste diretório;
- Arquivo de permissões do workspace: `.codex/config.toml`, quando existente na raiz do projeto;

### Objetivo e escopo do projeto

- Fornecer uma base reutilizável, modular e parametrizável para conteinerização de aplicações PHP;
- Preservar a arquitetura baseada em Docker Multi-stage builds;
- Preservar ambientes distintos de desenvolvimento e produção;
- Manter o runtime PHP desacoplado do servidor web;
- Usar PHP-FPM como runtime da aplicação;
- Usar Nginx como servidor web em container independente;
- Manter o banco de dados conteinerizado no ambiente de desenvolvimento;
- Manter o banco de dados externo à composição principal de produção;
- Permitir que projetos consumidores especializem a aplicação e a infraestrutura sem reescrever toda a base;
- Não acoplar o template a Laravel, Symfony ou outro framework/aplicação específica;
- Não adicionar Redis, queue worker, scheduler, Node.js, Composer ou outro serviço/recurso adicional como requisito padrão do template;
- Manter somente recursos que façam parte da arquitetura base deliberadamente definida;

### Compatibilidade

- Manter compatibilidade com Docker `29.7` ou superior;
- Usar Docker Compose pelo subcomando `docker compose`;
- Não alterar essa faixa de compatibilidade sem solicitação;
- Tratar as imagens declaradas nos arquivos `.env*` como baseline configurável, e não como dependências rígidas do código do template;
- Ler `APP_BASE_IMG`, `WEBSERVER_BASE_IMG` e `DB_BASE_IMG` nos arquivos do projeto antes de presumir suas versões;
- A baseline atual dos arquivos de exemplo utiliza:
  - PHP-FPM: `php:8.5.9-fpm-trixie`;
  - Nginx: `nginx:1.30.4-alpine3.24`;
  - MySQL de desenvolvimento: `mysql:9.7`;

### Estrutura de arquivos e diretórios

> **Nota:** esta árvore destaca apenas os arquivos e diretórios mais relevantes.

```text
.
├── app/
├── data/
│   ├── db/
│   │   └── dumps/
│   ├── misc/
│   └── utils/
│       ├── ssl/
│       ├── templates/
│       │   ├── app-site-cfg.conf.template
│       │   └── app-site-vhost.conf.template
│       └── app-entrypoint
├── .git/
├── .dockerignore
├── .env.dev.example
├── .env.example
├── .gitattributes
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── docker-compose.dev.yml
├── docker-compose.yml
├── Dockerfile
├── INSTALL.md
├── LICENSE
├── Makefile
├── README.md
├── SECURITY.md
├── SUPPORT.md
└── USAGE.md
```

- `app/`: Diretório base para o código-fonte da aplicação consumidora;
- `data/`: Diretório de dados e artefatos auxiliares da infraestrutura;
- `data/db/dumps/`: Dumps do banco de dados de desenvolvimento, montados em `DB_DUMPS_DIR`;
- `data/misc/`: Arquivos diversos úteis ao desenvolvimento e não pertencentes à imagem;
- `data/utils/ssl/`: Certificados SSL/TLS locais, montados somente no serviço `web`;
- `data/utils/templates/app-site-cfg.conf.template`: Configurações gerais do Nginx;
- `data/utils/templates/app-site-vhost.conf.template`: Virtual host Nginx, TLS, healthcheck e FastCGI;
- `data/utils/app-entrypoint`: Inicialização do container `app`;
- `docker-compose.yml`: Serviços e recursos comuns, incluindo `app` e `web`;
- `docker-compose.dev.yml`: Override de desenvolvimento, incluindo banco de dados e bind mounts;
- `Dockerfile`: Multi-stage build das imagens PHP-FPM e Nginx;
- `Makefile`: Interface operacional do template;

### Arquitetura e separação de responsabilidades

Preservar a arquitetura:

```text
Cliente HTTP/HTTPS
       ↓
      web
     Nginx
       ↓ FastCGI
      app
   PHP-FPM
       ↓
   Aplicação PHP
```

No ambiente de desenvolvimento:

```text
web ─────► app ─────► db
Nginx      PHP-FPM     MySQL
```

No ambiente de produção:

```text
web ─────► app ─────► banco externo
Nginx      PHP-FPM
```

Regras:

- O serviço `web` é responsável por HTTP, HTTPS, TLS, arquivos públicos, healthcheck HTTP e encaminhamento FastCGI;
- O serviço `app` é responsável pelo runtime PHP-FPM e pela aplicação;
- O serviço `db` existe somente no ambiente de desenvolvimento, salvo mudança explicitamente solicitada;
- Não voltar a concentrar Nginx/Apache e PHP no mesmo container sem decisão arquitetural explícita;
- Não reintroduzir Apache como dependência implícita;
- Não expor PHP-FPM diretamente ao host; utilizar a rede interna do Compose e `expose`;
- O Nginx deve alcançar PHP-FPM por `PHP_FPM_HOST` e `PHP_FPM_PORT`;
- A aplicação deve continuar independente da implementação concreta do web server sempre que possível;

### Dockerfile e Multi-stage builds

Preservar as duas famílias de stages.

Aplicação PHP-FPM:

```text
BASE
 ↓
APP
 ├── DEV
 └── PRD
```

Web server Nginx:

```text
WEB-BASE
├── WEB-DEV
└── WEB-PRD
```

Regras:

- `BASE`: dependências e configuração comuns ao runtime PHP;
- `APP`: especialização comum da aplicação;
- `DEV`: ferramentas e instruções exclusivas de desenvolvimento;
- `PRD`: runtime de produção;
- `WEB-BASE`: configuração comum do Nginx;
- `WEB-DEV`: imagem Nginx associada ao conteúdo público do target `DEV`;
- `WEB-PRD`: imagem Nginx associada ao conteúdo público do target `PRD`;
- O serviço `app` deve construir o target indicado por `APP_BUILD_ENV`;
- O serviço `web` deve construir o target `web-${APP_BUILD_ENV}`;
- Manter um único `Dockerfile`, salvo necessidade comprovada de separação;
- Projetos derivados podem adicionar stages auxiliares, como Composer ou Node, quando necessários;
- Copiar para o Nginx somente o conteúdo público necessário à aplicação;
- Não copiar código PHP privado, arquivos de configuração ou secrets para a imagem Nginx;
- Manter `APP_BASE_IMG` e `WEBSERVER_BASE_IMG` configuráveis por argumento de build;
- Preservar labels OCI e metadados de build quando existentes;

### Runtime PHP-FPM

- Usar `APP_RUNTIME_USER` e `APP_RUNTIME_GROUP` para o usuário e grupo do runtime da aplicação;
- Manter `APP_DIR` como diretório de trabalho da aplicação;
- Manter o código incorporado à imagem com permissões restritivas;
- Não tornar toda a árvore da aplicação gravável apenas para contornar problemas de permissão;
- Manter PHP-FPM como processo principal padrão do container `app`;
- Usar `APP_SERVICE=php-fpm` como identidade padrão do processo de aplicação enquanto aplicável;
- Preservar o healthcheck interno do PHP-FPM ou substituí-lo somente por mecanismo equivalente e mais confiável;
- Não instalar Nginx, Apache ou outro servidor web dentro da imagem PHP-FPM sem solicitação explícita;

### ENTRYPOINT da aplicação

O `data/utils/app-entrypoint` deve permanecer genérico e independente do framework.

Preservar as responsabilidades:

- Validar variáveis obrigatórias;
- Validar/criar diretórios obrigatórios realmente utilizados;
- Validar arquivos obrigatórios quando aplicável;
- Executar o processo principal com `exec`;

Regras de segurança e comportamento:

- Nunca registrar valores de variáveis obrigatórias durante `validate_envs`;
- Registrar somente o nome da variável validada;
- Não remover a primeira variável da lista de validação;
- Não imprimir `DB_PASS`, tokens, chaves ou outros secrets;
- Manter `set -e` ou comportamento equivalente de fail-fast;
- Preservar o uso de `exec` para o processo principal;
- Não instalar dependências automaticamente no entrypoint;
- Não executar migrations automaticamente;
- Não adicionar lógica específica de Laravel, Symfony ou outra aplicação ao template genérico;
- Evitar `chmod 777` ou permissões equivalentes excessivas;

### Nginx

Usar os templates:

```text
app-site-cfg.conf.template
app-site-vhost.conf.template
```

Preservar os seguintes comportamentos enquanto aplicáveis:

- Remover o site padrão da imagem oficial;
- Usar o `ENTRYPOINT` oficial do Nginx;
- Usar o mecanismo oficial de `envsubst` para processar `/etc/nginx/templates/`;
- Desabilitar `server_tokens`;
- Aplicar `WEBSERVER_CLIENT_MAX_BODY_SIZE`;
- Expor healthcheck em `/health`;
- Redirecionar tráfego HTTP normal para HTTPS;
- Manter TLS `1.2` e `1.3`;
- Servir arquivos a partir de `WEBSERVER_SITE_ROOT_DIR`;
- Encaminhar arquivos PHP ao serviço `app` via FastCGI;
- Definir corretamente `SCRIPT_FILENAME`;
- Encaminhar `HTTP_AUTHORIZATION`;
- Bloquear acesso a arquivos ocultos, preservando `.well-known` quando necessário;
- Não armazenar certificados TLS dentro da imagem;
- Não adicionar regras específicas de framework ao virtual host sem necessidade do projeto consumidor;

### Certificados SSL/TLS

- Manter certificados locais em `data/utils/ssl/`;
- Excluir certificados reais do contexto de build por `.dockerignore`;
- Preservar somente arquivos de exemplo e `.gitkeep` quando aplicável;
- Montar `data/utils/ssl` no serviço `web` como `read-only`;
- Não montar certificados no serviço `app` sem necessidade explícita;
- Não copiar certificados para a imagem durante o build;
- Tratar `SSL_CERT_FILE` e `SSL_KEY_FILE` como caminhos internos do container Nginx;
- Não registrar conteúdo de certificados ou chaves privadas;

### Ambientes de desenvolvimento e produção

#### Desenvolvimento

Preservar:

- `docker-compose.yml` combinado com `docker-compose.dev.yml`;
- `.env` combinado com `.env.dev`;
- Serviço `app` com bind mount `./app:${APP_DIR}:rw`;
- Serviço `web` com bind mount `./app/public:${WEBSERVER_SITE_ROOT_DIR}:ro`;
- Serviço `db` conteinerizado;
- Dumps em `data/db/dumps`;
- Porta interna do banco definida por `DB_PORT` e porta publicada no host definida por `DB_PUBLISHED_PORT`;
- `restart: no` para serviços de desenvolvimento quando definido;

#### Produção

Preservar:

- `docker-compose.yml` como composição principal;
- Código incorporado à imagem PHP-FPM;
- Conteúdo público incorporado à imagem Nginx;
- Ausência de bind mount do código-fonte da aplicação;
- Banco de dados provisionado externamente;
- Certificados montados no Nginx como somente leitura;
- Políticas de restart e healthcheck definidas na composição principal;

Não adicionar banco de dados ao ambiente de produção do template sem solicitação explícita.

### Persistência e arquivos públicos

- Não definir diretórios persistentes genéricos para a aplicação sem uma responsabilidade concreta;
- Projetos derivados devem declarar seus próprios diretórios, variáveis, mounts e validações quando necessários;
- O diretório público no container `web` deve ser somente leitura quando montado por bind mount;
- Em produção, o conteúdo público deve vir do build correspondente;
- Se uma aplicação gerar arquivos públicos dinamicamente em runtime, não compartilhar toda a árvore da aplicação por conveniência;
- Para conteúdo público mutável, criar volume específico ou usar armazenamento externo quando o projeto consumidor exigir;
- Não usar bind mounts de código em produção apenas para simplificar deploy;

### Variáveis de ambiente

Preservar a separação conceitual das variáveis.

Infraestrutura do projeto:

```text
PROJECT_LABEL
PROJECT_NAME
APP_BUILD_ENV
CLIENT_ID
VENDOR_*
```

Aplicação/runtime PHP:

```text
APP_*
PHP_FPM_*
```

Web server:

```text
WEBSERVER_*
SSL_*
```

Banco:

```text
DB_*
MYSQL_*
```

Infraestrutura auxiliar:

```text
DOCKER_*
TZ
```

Regras:

- Usar `PROJECT_LABEL` como nome legível do projeto nos metadados OCI;
- Usar `PROJECT_NAME` como identificador técnico dos recursos Docker;
- Usar `APP_BUILD_ENV=dev|prd` para selecionar targets e variantes da infraestrutura;
- Tratar `APP_BUILD_ENV` como seletor da infraestrutura, apesar do prefixo `APP_`;
- Não usar `APP_NAME` nem `APP_ENV` como seletor Docker do template, evitando colisão com aplicações consumidoras;
- Encaminhar `APP_NAME`, `APP_ENV`, `APP_DEBUG`, `APP_URL` e `APP_KEY` somente ao serviço `app`, sem expor `APP_KEY` em metadados, logs ou no serviço `web`;
- Manter `DB_PORT` como porta interna do serviço de banco na rede Docker;
- Manter `DB_PUBLISHED_PORT` como porta opcional publicada no host no ambiente de desenvolvimento;
- Não reutilizar `DB_PORT` com duas semânticas;
- Manter `.env.example` e `.env.dev.example` sincronizados em nomes e ordem quando as mesmas seções forem compartilhadas;
- Usar `.env` para valores comuns/produção e `.env.dev` para especialização de desenvolvimento;
- Não versionar `.env` nem `.env.dev`;
- Não inserir secrets nos arquivos de exemplo;
- Não renomear variáveis sem atualizar Dockerfile, Compose, Makefile, templates, entrypoint e documentação afetados;
- Não reutilizar `WEBSERVER_*` para configurações próprias do PHP-FPM;
- Manter `APP_RUNTIME_USER` e `APP_RUNTIME_GROUP` separados do usuário interno do Nginx;

### Docker Compose

- Preservar os serviços `app` e `web` na composição principal;
- Preservar o serviço `db` no override de desenvolvimento;
- Manter a rede interna compartilhada entre os serviços;
- Usar `PROJECT_NAME` e `APP_BUILD_ENV` nos nomes/targets de infraestrutura quando aplicável;
- Manter `depends_on` com healthcheck quando a dependência real exigir disponibilidade;
- Usar `expose` para PHP-FPM e `ports` para as portas HTTP/HTTPS publicadas pelo Nginx;
- Mapear `DB_PUBLISHED_PORT:DB_PORT` somente no ambiente de desenvolvimento;
- Manter volumes de certificados como `read-only`;
- Evitar `privileged: true`;
- Evitar montar `/var/run/docker.sock` dentro dos containers;
- Manter limites de logs definidos pelo driver `json-file`, salvo decisão explícita;
- Não criar dependência circular entre serviços;

### Makefile

Preservar os nomes padrão:

```text
SERVICE_APP ?= app
SERVICE_WEB ?= web
SERVICE_DB ?= db
```

Preservar, quando aplicáveis, os alvos:

```text
build / build-dev
up / up-dev
down / down-dev
deploy / deploy-dev
rebuild / rebuild-dev
restart / restart-dev
status / status-dev
config / config-dev
validate / validate-dev
logs / logs-dev
app-shell / app-shell-dev
web-shell / web-shell-dev
db-cli-dev
db-dump-dev
db-restore-dev
```

Regras:

- Usar `app-shell*` para o container PHP-FPM;
- Usar `web-shell*` para o container Nginx;
- Usar `/bin/sh` no container Nginx Alpine;
- Usar a função `run_app_command` para comandos de aplicação executados com `APP_RUNTIME_USER`, quando aplicável;
- Não codificar comandos específicos de framework nos alvos genéricos do template;
- Novos alvos específicos de uma aplicação devem ser adicionados no projeto derivado, salvo se forem genericamente reutilizáveis;
- Documentar o `app/Makefile` somente nos arquivos de documentação da aplicação hospedada em `app/` e documentar o `Makefile` da raiz somente nos arquivos de documentação da infraestrutura, sem misturar ou duplicar instruções entre os dois escopos;
- Usar `PROJECT_LABEL` na identidade legível e `PROJECT_NAME` na identidade técnica de imagens/recursos;
- Exibir `APP_BUILD_ENV` nas informações do projeto quando útil;
- Manter `COMPOSE` e `COMPOSE_DEV` como fontes centrais dos comandos Docker Compose;

### Segurança

Além das diretrizes reutilizáveis:

- Nunca registrar valores de credenciais durante a validação do entrypoint;
- Excluir `.env*` do contexto de build;
- Excluir certificados reais do contexto de build;
- Montar certificados como somente leitura;
- Não incorporar secrets em `ARG`, `ENV`, layers ou labels da imagem;
- Não copiar `.git/` para as imagens;
- Não tornar diretórios graváveis sem necessidade;
- Não usar permissões `777`;
- Não expor PHP-FPM diretamente ao host;
- Não expor diretórios privados da aplicação pelo Nginx;
- Manter o document root restrito ao diretório público;
- Revisar qualquer mudança em `try_files`, FastCGI, TLS ou caminhos públicos por impacto de segurança;
- Preservar a ocultação da versão do Nginx com `server_tokens off`;

### Reutilização por projetos consumidores

O Docker Template é um **ponto de partida para um novo projeto**, não uma dependência Git que precise permanecer acoplada ao consumidor.

Fluxo recomendado:

```text
Docker Template
      ↓
criar novo projeto a partir do template
      ↓
histórico Git próprio
      ↓
especializar infraestrutura + aplicação
```

Regras:

- Preferir o recurso **Use this template** do GitHub quando disponível;
- Em fluxo por CLI, é aceitável clonar/copiar o template, remover o `.git/` do template e executar `git init` no projeto derivado;
- O projeto derivado deve versionar, em um único repositório, a infraestrutura e o código da aplicação, salvo decisão arquitetural explícita em contrário;
- Não manter `.git/` aninhado em `app/` por padrão;
- O diretório `app/` deve ser versionável pelo repositório raiz;
- Centralizar regras de ignore no `.gitignore` da raiz e acrescentar novos padrões à medida que a aplicação exigir;
- Projetos consumidores podem substituir o conteúdo de `app/`;
- Projetos consumidores podem estender stages `APP`, `DEV` e `PRD`;
- Projetos consumidores podem adicionar extensões PHP, Composer, Node.js, Redis, queue, scheduler e outros recursos conforme sua própria arquitetura;
- Essas especializações não devem ser automaticamente incorporadas ao Docker Template upstream apenas porque um consumidor as utiliza;
- Melhorias genericamente úteis podem ser portadas deliberadamente ao template após avaliação;

### Cabeçalho e idioma da documentação de código

Preservar este cabeçalho nos arquivos em que ele já for adotado e adicioná-lo aos novos arquivos de código, respeitando o tipo de comentário da linguagem:

```text
/**
 * -----------------------------------------------------------------------------
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @copyright Copyright (c) 2026 Rafael Mendes
 * @license   GPLv3+ <https://www.gnu.org/licenses/gpl-3.0.html>
 * @link      GitHub <https://github.com/mendescrafael>
 *
 * This file is part of Docker Template.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 * -----------------------------------------------------------------------------
 */
```

- Escrever comentários e documentação de código em Português do Brasil;

### Versão, changelog e documentos

Quando houver mudança de versão, revisar:

- [CONTRIBUTING.md](CONTRIBUTING.md);
- [CHANGELOG.md](CHANGELOG.md);
- A estrutura de árvore presente na documentação, desconsiderando arquivos administrativos do Codex/agentes;

Além disso:

- Adicionar as últimas alterações no [CHANGELOG.md](CHANGELOG.md) sempre abaixo do bloco `[Unreleased]`, criando uma nova seção quando necessário;
- Manter [README.md](README.md), [INSTALL.md](INSTALL.md), [USAGE.md](USAGE.md), [SUPPORT.md](SUPPORT.md) e [SECURITY.md](SECURITY.md) genéricos quanto à versão corrente do projeto;
- Manter a documentação genérica quanto à aplicação consumidora;
- Usar `Docker Template` como nome do projeto nos modelos próprios do repositório, evitando placeholders desnecessários;
- Preservar referências históricas ao Apache no [CHANGELOG.md] quando documentarem versões anteriores;
- Ao alterar arquitetura, serviços, variáveis, targets, volumes ou fluxos de ambiente, atualizar todos os documentos afetados;

### Comandos de validação

Executar o conjunto aplicável após mudanças:

```bash
# Estado e integridade do diff, somente quando o uso de Git estiver autorizado
git status --short
git diff --check

# Shell
bash -n data/utils/app-entrypoint

# Docker Compose - produção
docker compose \
  --env-file .env \
  -f docker-compose.yml \
  config --quiet

# Docker Compose - desenvolvimento
docker compose \
  --env-file .env \
  --env-file .env.dev \
  -f docker-compose.yml \
  -f docker-compose.dev.yml \
  config --quiet

# Makefile
make -n help
```

Quando Docker estiver disponível e a solicitação autorizar validação funcional, executar conforme aplicável:

```bash
make build
make build-dev
make up
make up-dev
make status
make status-dev
make logs
make logs-dev
```

Validar funcionalmente, quando aplicável:

- Healthcheck do PHP-FPM;
- Healthcheck HTTP `/health` do Nginx;
- Redirecionamento HTTP para HTTPS;
- Handshake TLS;
- Encaminhamento Nginx → PHP-FPM via FastCGI;
- Leitura de arquivos públicos;
- Bind mounts de desenvolvimento;
- Banco de dados de desenvolvimento;
- `DB_PORT` e `DB_PUBLISHED_PORT`;
- Diretórios graváveis realmente existentes;
- Ausência de valores sensíveis nos logs do entrypoint;

Além disso:

- Não iniciar containers, alterar banco ou executar builds destrutivos sem autorização quando a tarefa for apenas análise;
- Informar claramente quando Docker CLI, certificados ou dependências externas impedirem alguma validação;
- Destacar decisões que dependam de teste end-to-end no ambiente Docker;
