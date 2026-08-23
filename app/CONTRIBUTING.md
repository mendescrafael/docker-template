# Contribuindo

Este documento descreve o ambiente de desenvolvimento, a finalidade dos arquivos auxiliares presentes na raiz do projeto e os comandos usados para validar uma contribuição.

Antes de começar, leia o [README.md](README.md) para conhecer o projeto, o [INSTALL.md](INSTALL.md) para preparar o ambiente, o [USAGE.md](USAGE.md) para conhecer os procedimentos operacionais e o [SECURITY.md](SECURITY.md) para comunicar vulnerabilidades de forma responsável.

## Formas de contribuir

<!-- Listagem das formas de contribuições possíveis -->

## Pré-requisitos e preparação do ambiente

<!-- Instruções sobre pré-requisitos e preparação do ambiente -->

## Estrutura de arquivos e diretórios

> **Nota:** esta árvore destaca apenas os arquivos e diretórios mais relevantes.

<!-- A estrutura hierárquica dos arquivos e diretórios do projeto -->

## Ambiente de desenvolvimento

<!-- Descrição sobre a estruturação do ambiente de desenvolvimento -->

### Artefatos de desenvolvimento na raiz do projeto

<!-- Descrição dos artefatos de desenvolvimentos -->

### Controle do repositório e colaboração

<!-- Listagem de arquivos e diretórios de controle de versão -->

### Dependências e artefatos específicos

<!-- Listagem de artefatos de dependência -->

### Diretrizes para as alterações

<!-- Breve descrição das diretrizes de desenvolvimento que devem ser seguidas -->

#### Diretrizes específicas do projeto

<!-- Descrição detalhada das diretrizes de desenvolvimento  -->

## Uso do Makefile

O `Makefile` fornece uma interface opcional para projetos PHP, Node.js ou híbridos. Ele detecta `composer.json` e `package.json`, exige somente as ferramentas correspondentes aos manifests presentes e delega operações específicas aos scripts declarados pelo projeto.

Consulte os alvos e as variáveis disponíveis:

```bash
make help
```

### Variáveis configuráveis

- `COMPOSER`, `PHP`, `NODE` e `NPM`: Executáveis utilizados pelas toolchains;
- `COMPOSER_PROJECT_DIR` e `NODE_PROJECT_DIR`: Diretórios que contêm os manifests das toolchains;
- `COMPOSER_INSTALL_FLAGS`, `COMPOSER_UPDATE_FLAGS`, `NPM_INSTALL_FLAGS` e `NPM_UPDATE_FLAGS`: Opções adicionais encaminhadas aos gerenciadores;
- `PHP_SOURCE_PATHS`: Caminhos pesquisados por `lint-php`;
- `LINT_SCRIPT`, `ANALYSE_SCRIPT`, `TEST_SCRIPT`, `FORMAT_SCRIPT` e `BUILD_SCRIPT`: Nomes dos scripts delegados aos manifests;

### Verificações de pré-requisitos

Use `make check` para verificar somente os executáveis exigidos pelos manifests existentes. Use `make validate` para validar os manifests sem instalar dependências.

### Permissionamento do ambiente de desenvolvimento

O `Makefile` não altera proprietário, grupo ou permissões do workspace. O permissionamento deve ser definido pela infraestrutura ou pelo ambiente de desenvolvimento responsável pela aplicação.

### Validações de qualidade

- `make lint-php`: Valida a sintaxe dos arquivos PHP encontrados;
- `make lint`: Valida manifests, sintaxe PHP e scripts de lint declarados;
- `make analyse`: Executa os scripts de análise estática declarados;
- `make test`: Executa os scripts de teste declarados;
- `make qa`: Executa lint, análise e testes;

### Operações específicas do projeto

- `make install`: Instala somente as dependências dos manifests presentes;
- `make update`: Atualiza somente as dependências dos manifests presentes;
- `make list-scripts`: Lista os scripts disponibilizados por Composer e npm;
- `make run SCRIPT=<nome>`: Executa um script específico nos manifests que o declararem;
- `make format`: Executa os scripts de formatação declarados;
- `make build`: Executa os scripts de build declarados;

### Convenções para novos alvos

Prefira scripts nos manifests para operações próprias de frameworks ou ferramentas. Adicione um alvo ao `Makefile` somente quando ele coordenar um fluxo reutilizável entre projetos, mantenha executáveis e caminhos configuráveis e não torne uma toolchain obrigatória quando seu manifest estiver ausente.

## Padrões de código e documentação

### Linguagens e formatos utilizados

<!-- Descrição sobre liguagens e padrões de formato usados -->

### Cabeçalho e documentação do código

<!-- Instruções e exemplo de cabeçalho header para arquivos -->

### Documentação do projeto

<!-- Instruções para regras de documentação do projeto -->

## Segurança e dados locais

<!-- Instruções relacionadas a segurança -->

## Validação das mudanças

<!-- Instruções sobre uso de comandos ou procedimentos para validar as mudanças -->

## Commits e pull requests

<!-- Instruções sobre padrões adotados para commits -->

### PRs

<!-- Instruções sobre PRs -->

## Relatos de erros

Um bom relato deve conter:

- Descrição aqui;
- Outra descrição aqui;

Antes de relatar o problema, consulte a seção de diagnóstico do [USAGE.md](USAGE.md) e as orientações do [SUPPORT.md](SUPPORT.md) e procure por uma issue equivalente.

## Licença

Ao enviar uma contribuição, você concorda que ela seja distribuída sob os termos da licença [LICENSE](LICENSE), adotada pelo projeto.
