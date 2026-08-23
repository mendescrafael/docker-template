# Referência de estruturas para documentação Markdown

> Documento auxiliar do `AGENTS.md` do AtacaHub.
>
> Consultar somente em tarefas que criem, reestruturem ou padronizem `README.md`, `INSTALL.md`, `USAGE.md`, `CONTRIBUTING.md`, `SUPPORT.md` ou `SECURITY.md`.
>
> As regras permanentes de documentação continuam definidas no `AGENTS.md`; este arquivo mantém apenas os modelos detalhados para evitar carregar esse conteúdo em tarefas não relacionadas.

## Estruturas modelos para arquivos de documentação Markdown

### Modelo para arquivo `CONTRIBUTING.md`:

Abaixo está um modelo-base que reúne a estrutura comum para o arquivo `CONTRIBUTING.md`.

> **Importante:** Quando forem aplicáveis, subtópicos adicionais podem ser criados dentro dos tópicos e subtópicos existentes, mas preservando a estrutura macro e ordem dos tópicos conforme abaixo.

> **Importante:** O conteúdo dos tópicos e subtópicos inserido no modelo abaixo deve ser preservado, salvo quando se tratarem de texto genérico que deve ser substituído.

```markdown
# Contribuindo

Este documento descreve o ambiente de desenvolvimento, a finalidade dos arquivos auxiliares presentes na raiz do projeto e os comandos usados para validar uma contribuição.

Antes de começar, leia o [README.md](README.md) para conhecer o projeto, o [INSTALL.md](INSTALL.md) para preparar o ambiente, o [USAGE.md](USAGE.md) para conhecer os procedimentos operacionais e o [SECURITY.md](SECURITY.md) para comunicar vulnerabilidades de forma responsável.

## Formas de contribuir

<!-- Listagem das formas de contribuições possíveis -->

## Pré-requisitos e preparação do ambiente

<!-- Instruções sobre pré-requisitos e preparação do ambiente -->

## Estrutura de arquivos e diretórios

> **Nota:** a árvore deve listar os arquivos e diretórios da raiz; em `app/`, listar somente os itens diretos, incluindo arquivos; em `data/`, mostrar somente a hierarquia de diretórios até 6 níveis, sem arquivos internos; qualquer outro diretório da raiz deve aparecer somente pelo nome. Em cada nível, ordenar diretórios ocultos, diretórios comuns, arquivos ocultos e arquivos comuns quando aplicável, sempre alfabeticamente dentro de cada grupo.

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

<!-- Descrição do uso do Makefile -->

### Variáveis configuráveis

<!-- Descrição da finalidade das variáveis -->

### Verificações de pré-requisitos

<!-- Instruções sobre comandos de checagem de pré-requisitos -->

### Permissionamento do ambiente de desenvolvimento

<!-- Instruções sobre comandos de permissionamento -->

### Validações de qualidade

<!-- Instruções sobre comandos de qualidade do projeto e/ou código -->

### Operações específicas do projeto

<!-- Listagem de operações específicas do projeto -->

### Convenções para novos alvos

<!-- Instruções sobre nomenclatura para novos alvos no Makefile -->

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
```

### Modelo para arquivo `INSTALL.md`:

Abaixo está um modelo-base que reúne a estrutura comum para o arquivo `INSTALL.md`.

> **Importante:** Quando forem aplicáveis, subtópicos adicionais podem ser criados dentro dos tópicos e subtópicos existentes, mas preservando a estrutura macro e ordem dos tópicos conforme abaixo.

> **Importante:** O conteúdo dos tópicos e subtópicos inserido no modelo abaixo deve ser preservado, salvo quando se tratarem de texto genérico que deve ser substituído.

```markdown
# Instalação

## Pré-requisitos

<!-- Listagem dos pré-requisitos do projeto -->

## Obtendo o projeto

<!-- Instruções de como obter o projeto -->

## Preparação

<!-- Instruções de prepação do projeto -->

## Permissões

<!-- Instruções sobre permissionamento de arquivos e diretórios do projeto -->

## Verificação

<!-- Instruções sobre verificações dos artefatos usados pelo projeto -->

## Atualização

<!-- Instruções de atualização do projeto  -->

## Próximos passos

<!-- Instruções para próximos passos após implantação do projeto -->

## Diagnóstico

<!-- Instruções sobre diagnósticos aplicáveis -->

## Segurança

<!-- Instruções relacionadas a segurança no projeto -->
```

### Modelo para arquivo `README.md`:

Abaixo está um modelo-base que reúne a estrutura comum para o arquivo `README.md`.

> **Importante:** Quando forem aplicáveis, subtópicos adicionais podem ser criados dentro dos tópicos e subtópicos existentes, mas preservando a estrutura macro e ordem dos tópicos conforme abaixo.

> **Importante:** O conteúdo dos tópicos e subtópicos inserido no modelo abaixo deve ser preservado, salvo quando se tratarem de texto genérico que deve ser substituído.

```markdown
# {Nome do projeto}

## Sobre o projeto

<!-- Descrição do projeto -->

## Motivação e objetivo

<!-- Descrição sobre motivo e objetivo do projeto -->

## Principais recursos

<!-- Listagem dos principais recursos do projeto -->

## Arquitetura e organização

### Visão geral

<!-- Uma visão geral da arquitetura e organização do projeto  -->

### Componentes principais

<!-- Listagem dos componentes principais do projeto -->

## Estrutura de arquivos e diretórios

A árvore e a finalidade dos arquivos e diretórios relevantes estão documentadas em [Estrutura de arquivos e diretórios](CONTRIBUTING.md#estrutura-de-arquivos-e-diretórios).

## Compatibilidade

O projeto requer:

- Descreva artefato e versão;
- Outro artefato e versão;

## Documentação

- [INSTALL.md](INSTALL.md): Preparação, configuração e primeira implantação do projeto;
- [USAGE.md](USAGE.md): Operação, manutenção, atualização e diagnóstico do projeto;
- [CONTRIBUTING.md](CONTRIBUTING.md): Preparação e diretrizes para contribuições;
- [SUPPORT.md](SUPPORT.md): Orientações para solicitar suporte;
- [SECURITY.md](SECURITY.md): Política e processo de relato de vulnerabilidades;
- [CHANGELOG.md](CHANGELOG.md): Histórico das alterações relevantes do projeto;

## Licença

Distribuído sob a licença [LICENSE](LICENSE).
```

### Modelo para arquivo `SECURITY.md`:

Abaixo está um modelo-base que reúne a estrutura comum para o arquivo `SECURITY.md`.

> **Importante:** Nenhum tópico ou subtópico adicional deve ser criado, mas caso necessário pode ser incluído novo conteúdo em algum tópico existente.

> **Importante:** O conteúdo dos tópicos e subtópicos inserido no modelo abaixo deve ser preservado.

```markdown
# Política de segurança

## Versões suportadas

Correções de segurança são fornecidas para a versão estável mais recente do projeto. Antes de relatar um problema, confirme se ele também ocorre na versão atual e em uma versão suportada conforme [Compatibilidade](README.md#compatibilidade).

## Relato de vulnerabilidades

Não publique vulnerabilidades, provas de conceito ou dados sensíveis em issues abertas.

Envie o relato de forma privada pelo recurso **Report a vulnerability** da aba **Security** do repositório [{usuário GitHub}/{repositório}](https://github.com/{usuário GitHub}/{repositório}/security). Inclua, quando possível:

- Versões do projeto e outros artefados;
- Pré-condições e passos mínimos para reproduzir;
- Impacto observado e comportamento esperado;
- Logs sanitizados, sem credenciais, tokens ou dados pessoais;
- Uma sugestão de correção, caso exista;

O recebimento será confirmado assim que possível. A análise, a correção e a divulgação serão coordenadas de acordo com a gravidade e a possibilidade de reprodução. Não há programa de recompensa financeira.

## Escopo

São relevantes falhas introduzidas pelo código do projeto, incluindo bypass de autorização, exposição de ações ou dados e operações indevidas. Problemas pertencentes ao core dos artefatos usados devem ser comunicados ao respectivo mantenedor.
```

### Modelo para arquivo `SUPPORT.md`:

Abaixo está um modelo-base que reúne a estrutura comum para o arquivo `SUPPORT.md`.

> **Importante:** Nenhum tópico ou subtópico adicional deve ser criado, mas caso necessário pode ser incluído novo conteúdo em algum tópico existente.

> **Importante:** O conteúdo dos tópicos e subtópicos inserido no modelo abaixo deve ser preservado.

```markdown
# Suporte

## Antes de solicitar ajuda

Consulte [README.md](README.md), [INSTALL.md](INSTALL.md) e [USAGE.md](USAGE.md), confirme a compatibilidade das versões conforme [Compatibilidade](README.md#compatibilidade). Reproduza o problema com a versão estável mais recente do projeto e verifique os logs dos artefatos.

## Abrindo uma issue

Use as [issues do projeto](https://github.com/{usuário GitHub}/{repositório}/issues) para relatar defeitos reproduzíveis ou propor melhorias. Informe:

- Versões do projeto e outros artefados;
- Forma de instalação e ambiente utilizado;
- Passos para reproduzir, resultado atual e resultado esperado;
- Capturas de tela ou logs sanitizados, quando úteis;
- Configurações adicionais necessárias para reproduzir, se houver;

**Não publique** senhas, tokens, endereços internos, dados pessoais ou dumps de banco. Vulnerabilidades devem seguir exclusivamente o processo privado descrito em [SECURITY.md](SECURITY.md).

## Limites do suporte

O projeto não oferece SLA ou suporte comercial. Dúvidas gerais de administração dos artefatos, infraestrutura, ferramentas de terceiros e problemas não introduzidos pelo projeto estão fora de escopo.
```

### Modelo para arquivo `USAGE.md`:

Abaixo está um modelo-base que reúne a estrutura comum para o arquivo `USAGE.md`.

> **Importante:** Quando forem aplicáveis, subtópicos adicionais podem ser criados dentro dos tópicos e subtópicos existentes, mas preservando a estrutura macro e ordem dos tópicos conforme abaixo.

> **Importante:** O conteúdo dos tópicos e subtópicos inserido no modelo abaixo deve ser preservado, salvo quando se tratarem de texto genérico que deve ser substituído.

```markdown
# Uso

<!-- Descrição gerais de uso -->

Para preparar o projeto e realizar a primeira implantação, consulte o [guia de instalação](INSTALL.md).

## Antes de começar

<!-- Instruções iniciais -->

## Conceitos e configuração

<!-- Instruções sobre conceitos e configuração do projeto -->

## Operações

<!-- Instruções sobre operações realizdas pelo projeto -->

## Manutenção e cuidados

<!-- Instruções sobre manutenção e cuidados do projeto -->

## Diagnóstico

<!-- Instruções sobre diagnósticos aplicáveis -->

## Ajuda e segurança

Para preparar o projeto, consulte o [INSTALL.md](INSTALL.md). Para conhecer a visão geral e os recursos do projeto, consulte o [README.md](README.md).

Problemas de uso devem seguir as orientações do [SUPPORT.md](SUPPORT.md). Vulnerabilidades ou suspeitas de falha de segurança devem ser relatadas pelo processo privado descrito no [SECURITY.md](SECURITY.md).
```
